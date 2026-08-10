--!strict
-- DataService
-- Player data persistence for Sports Card Farm, built on ProfileStore.
-- The wrapper is reused from World Cup RNG's production-hardened DataService
-- (session locking, Reconcile, Studio mock, per-player mock override,
-- SyncMirror); the template is rebuilt from canon spec §14. Other services
-- read/mutate data through this module's public API.

local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileStore = require(ServerScriptService.Packages.ProfileStore)
local Signal       = require(ReplicatedStorage.Packages.Signal)

local STORE_NAME    = "SportsCardFarm_PlayerData_v1"
-- In Studio we use ProfileStore's mock store so the loop is testable without
-- published API access. Live servers always hit the real DataStore.
local USE_MOCK      = RunService:IsStudio()

-- Per-player mock override.
-- Each attribute ascribed to THIS script is keyed by a player's Name with a boolean value;
-- when that player joins it overrides USE_MOCK for them alone (true = ProfileStore mock,
-- false = live DataStore). Players with no matching attribute fall back to USE_MOCK
-- (Studio => mock). Attributes are read fresh on every join, so they can be flipped at runtime.
local function readMockOverrides(): { [string]: boolean }
	local overrides: { [string]: boolean } = {}
	for name, value in script:GetAttributes() do
		if type(value) == "boolean" then
			overrides[name] = value == true
		end
	end
	return overrides
end

local function useMockFor(player: Player): boolean
	local override = readMockOverrides()[player.Name]
	if type(override) == "boolean" then
		return override
	end
	return USE_MOCK
end

-- The default profile (canon spec §14, M1 trim). Keep flat and serializable.
export type CardRec = {
	uid: string,
	cardID: string,   -- id into CardConfig catalog
	foil: string,     -- FoilConfig id ("Base" in M1)
	level: number,    -- 1 in M1; 1–50 lands in M2
	grade: string?,   -- M3
	trait: string?,   -- M3
	valueCache: number, -- EconomyConfig.cardValue at grant time
}

export type PackRec = {
	packID: string,   -- PackConfig pack id
	foil: string,     -- FoilConfig id; rolled at pack SPAWN (PurchaseService)
	openAt: number,   -- unix ts when the pack becomes openable
	pedestal: number?, -- which pack pedestal it stands on (M1.1: player picks)
}

export type PlayerData = {
	schemaVersion: number,
	cash: number,
	luckMult: number,
	cashMult: number,
	plotSlots: number,
	conveyorTier: number,
	storage: { [string]: CardRec },
	displayed: { [string]: string }, -- slotKey -> uid
	packQueue: { [string]: PackRec }, -- placementId -> PackRec
	carried: { packID: string?, packFoil: string?, boxValue: number }, -- items in hand (flow spec v1.1)
	nextUid: number,
	nextPlacementId: number,
	packsOpened: number,
	index: { [string]: boolean },
	tokens: { grade: number, training: number },
	pity: { gradeRolls: number, traitRolls: number },
	potions: { any },
	passes: { [string]: boolean },
	upgrades: { [string]: number },
	dailyStreak: number,
	lastDailyClaim: number,
	lastOfflineTs: number,
	playtimeLadderState: number,
	purchaseHistory: { [string]: boolean },
	badges: { towerFloor: number, netWorth: number },
	settings: { Music: boolean, Sound: boolean, PackReveal: boolean, VFX: boolean },
	playtimeSeconds: number,
	lastSessionTimestamp: number,
	firstJoinAt: number?,
}

local PROFILE_TEMPLATE = require(script:WaitForChild("template")) :: PlayerData

type Profile = typeof(ProfileStore.New(STORE_NAME, PROFILE_TEMPLATE):StartSessionAsync(""))

local DataService = {}

-- Fired (player, data) once a player's profile is loaded and ready.
DataService.ProfileLoaded = Signal.new()
-- Fired (player) right before a player's profile is released.
DataService.ProfileReleasing = Signal.new()

local profileStore: any = nil
local profiles: { [Player]: Profile } = {}
local loading: { [Player]: boolean } = {} -- guards against double session-start
local lastLogout: { [Player]: number } = {} -- previous session's end timestamp, per join
local sessionStart: { [Player]: number } = {} -- os.time() this session began (playtime accrual)

--[[ Public API ]]--

-- Returns the live profile or nil. Prefer GetData for most reads.
function DataService.GetProfile(self: any, player: Player): Profile?
	return profiles[player]
end

-- Returns the player's mutable data table, or nil if not loaded.
function DataService.GetData(self: any, player: Player): PlayerData?
	local profile = profiles[player]
	if profile then
		return (profile :: any).Data :: PlayerData
	end
	return nil
end

-- Live total playtime: persisted seconds + the current session's elapsed time.
function DataService.GetPlaytime(self: any, player: Player): number
	local data = DataService:GetData(player)
	if not data then
		return 0
	end
	local started = sessionStart[player]
	return (data.playtimeSeconds or 0) + (started and (os.time() - started) or 0)
end

-- Unix time the player's PREVIOUS session ended (0/nil = first session).
-- Captured on join before lastSessionTimestamp is refreshed (M5 offline hook).
function DataService.GetLastLogout(self: any, player: Player): number?
	return lastLogout[player]
end

-- Yields until the player's data is ready (or they leave). Safe for other
-- services whose OnStart may race ahead of DataService's.
function DataService.WaitForData(self: any, player: Player): PlayerData?
	local existing = DataService:GetData(player)
	if existing then
		return existing
	end
	while player:IsDescendantOf(Players) and not profiles[player] do
		task.wait()
	end
	return DataService:GetData(player)
end

function DataService.IsActive(self: any, player: Player): boolean
	local profile = profiles[player]
	return profile ~= nil and (profile :: any):IsActive()
end

-- Mirrors server-canonical scalars to read-only player Attributes so the client
-- HUD (and tooling) can observe them without trusting the client. Call after
-- any mutation to these fields.
function DataService.SyncMirror(self: any, player: Player)
	local data = DataService:GetData(player)
	if not data then
		return
	end
	player:SetAttribute("Cash", data.cash)
	local leaderstats = player:FindFirstChild("leaderstats")
	local cashStat = leaderstats and leaderstats:FindFirstChild("Cash")
	if cashStat and cashStat:IsA("IntValue") then
		cashStat.Value = math.floor(data.cash)
	end
	player:SetAttribute("PacksOpened", data.packsOpened)
	local cardCount = 0
	for _ in data.storage do
		cardCount += 1
	end
	player:SetAttribute("CardCount", cardCount)
	local displayedCount = 0
	for _ in data.displayed do
		displayedCount += 1
	end
	player:SetAttribute("DisplayedCount", displayedCount)
end

--[[ Lifecycle ]]--

local function onPlayerAdded(player: Player)
	if profiles[player] or loading[player] then
		return -- already loaded or loading (bootstrap vs PlayerAdded race)
	end
	loading[player] = true

	local useMock = useMockFor(player)
	local store = useMock and profileStore.Mock or profileStore
	local profile = store:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	loading[player] = nil

	if not profile then
		player:Kick("Your data failed to load. Please rejoin.")
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	profile.OnSessionEnd:Connect(function()
		profiles[player] = nil
		player:Kick("Your session ended. Please rejoin.")
	end)

	-- Player may have left during the async load.
	if player.Parent ~= Players then
		profile:EndSession()
		return
	end

	profiles[player] = profile
	sessionStart[player] = os.time()
	lastLogout[player] = profile.Data.lastSessionTimestamp -- before overwrite (M5 retention)
	-- Genuine first-ever session: stamp the join time so analytics can segment NEW players
	-- (joined after this shipped) from legacy ones, who never get the stamp.
	if (profile.Data.lastSessionTimestamp or 0) == 0 and not profile.Data.firstJoinAt then
		profile.Data.firstJoinAt = os.time()
	end
	profile.Data.lastSessionTimestamp = os.time()

	-- leaderstats folder for the Tab list
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = leaderstats

	DataService.SyncMirror(DataService, player)
	DataService.ProfileLoaded:Fire(player, profile.Data)
	print(("[DataService] loaded %s (mock=%s)"):format(player.Name, tostring(useMock)))
end

local function onPlayerRemoving(player: Player)
	loading[player] = nil
	lastLogout[player] = nil
	local profile = profiles[player]
	if profile then
		DataService.ProfileReleasing:Fire(player)
		local data = (profile :: any).Data
		local started = sessionStart[player]
		if started then
			data.playtimeSeconds = (data.playtimeSeconds or 0) + (os.time() - started)
		end
		profiles[player] = nil
		data.lastSessionTimestamp = os.time()
		profile:EndSession()
	end
	sessionStart[player] = nil
end

function DataService.OnStart(self: any)
	profileStore = ProfileStore.New(STORE_NAME, PROFILE_TEMPLATE)

	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

	-- Bootstrap players already present (PlayerAdded fires before this connects
	-- on a populated server).
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end

	print("[DataService] Ready (mock=" .. tostring(USE_MOCK) .. ")")
end

return DataService
