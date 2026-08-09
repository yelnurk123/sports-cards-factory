-- CmdrClientBootstrap
-- Enables the in-game Cmdr console. The server (MainServer) replicates CmdrClient
-- into ReplicatedStorage on boot; this requires it and binds the activation key.
-- Press F2 or ';' to open the console. (SetActivationKeys REPLACES Cmdr's default
-- F2 bind, so F2 must be listed here explicitly.) Command access is gated
-- server-side (admin-only via MainServer's BeforeRun hook).

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))
Cmdr:SetActivationKeys({ Enum.KeyCode.F2, Enum.KeyCode.Semicolon })
