--!strict
-- PlotLayout — shared plot-grid geometry. Server (WorldService) builds plots
-- from this; client (HudController teleports) reads the same constants so the
-- two never drift.

local PlotLayout = {}

PlotLayout.PLOT_COUNT = 8
PlotLayout.PLOT_SIZE = 44

-- 2 rows of 4; plot index -> pad center CFrame (pad top surface is Y=1).
function PlotLayout.center(index: number): CFrame
	local col = (index - 1) % 4
	local row = math.floor((index - 1) / 4)
	return CFrame.new(-84 + col * 56, 1, 70 + row * 56)
end

-- Named spots for HUD teleports (mirror WorldService's plaza build).
PlotLayout.PlazaSpot = Vector3.new(0, 4, -30)
PlotLayout.SellSpot = Vector3.new(60, 4, -16)

return PlotLayout
