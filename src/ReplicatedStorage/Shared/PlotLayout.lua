--!strict
-- PlotLayout — shared world geometry (environment canon v1, 2026-08-11):
-- one island world, Plaza hub at the center, and a RING of player bases
-- outside the arrowed road circuit. Server (WorldService) builds from this;
-- client (HudController teleports) reads the same constants so the two never
-- drift.

local PlotLayout = {}

PlotLayout.PLOT_COUNT = 8
PlotLayout.BASE_SIZE = 48

-- Ring geometry: road circuit half-size and base placement. Bases sit OUTSIDE
-- the road, front edge touching it; two bases per side (N/E/S/W).
PlotLayout.ROAD_HALF = 150 -- road strip centers are this far from world center
PlotLayout.ROAD_WIDTH = 10
PlotLayout.BASE_RING = 190 -- base platform centers are this far from center

local SIDE_OFFSET = 90 -- second base on a side sits this far along the side

-- Base frame: position at the platform's top center (platform top = world Y2,
-- one step above the road); rotation faces the FRONT of the base (-Z local)
-- toward the Plaza. All per-base modules are placed in this local frame.
function PlotLayout.baseFrame(index: number): CFrame
	local side = math.floor((index - 1) / 2) % 4 -- 0=N 1=E 2=S 3=W
	local slot = (index - 1) % 2
	local off = if slot == 0 then -SIDE_OFFSET else SIDE_OFFSET
	local ring = PlotLayout.BASE_RING
	local pos: Vector3
	if side == 0 then
		pos = Vector3.new(off, 0, -ring)
	elseif side == 1 then
		pos = Vector3.new(ring, 0, off)
	elseif side == 2 then
		pos = Vector3.new(-off, 0, ring)
	else
		pos = Vector3.new(-ring, 0, -off)
	end
	return CFrame.lookAt(pos + Vector3.new(0, 2, 0), Vector3.new(0, 2, 0))
end

-- Named spots for HUD teleports (mirror WorldService's plaza build).
PlotLayout.PlazaSpot = Vector3.new(0, 4, 0)
PlotLayout.SellSpot = Vector3.new(0, 4, 62) -- in front of the Sell zone pad

return PlotLayout
