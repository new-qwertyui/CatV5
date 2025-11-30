--> made by selunar, tysm!

local PF = {}
PF.__index = PF

local runService = cloneref(game:GetService('RunService'))

local CELL = 3

local function mergeTables(t1, t2)
	local merged = {}

	for k, v in t1 do
		merged[k] = v
	end

	for k, v in t2 do
		if type(k) == 'number' then
			table.insert(merged, v)
		else
			merged[k] = v
		end
	end

	return merged
end

local function isVoid(pos)
	local ray = Ray.new(pos, Vector3.new(0, -200, 0))
	local part = workspace:FindPartOnRay(ray)
	return not part
end

local function isWall(from, to, settings)
	Ignore = (type(settings) == 'table' and settings.Ignore) or {}
	
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = mergeTables({workspace.Terrain}, Ignore)
	local result = workspace:Raycast(from, (to - from).Unit * (to - from).Magnitude, rayParams)
	return result ~= nil
end

local function heuristic(a, b)
	return (a - b).Magnitude
end

local function neighbors(node)
	local dirs = {
		Vector3.new(-CELL, 0, 0),
		Vector3.new(-CELL, 0, 0),
		Vector3.new(0, 0, CELL),
		Vector3.new(0, 0, -CELL),
		Vector3.new(0, CELL, 0),
		Vector3.new(0, -CELL, 0),
	}
	local n = {}
	for _, dir in dirs do
		table.insert(n, node + dir)
	end
	return n
end

function PF:FindPath(startPos, targetPos, settings)
	settings = settings or {}
	local ignoreVoid = settings.ignoreVoid or false
	local checkWalls = settings.wallCheck or false
	local MAX_STEPS = settings.MaxDistance or 10000

	local openSet = {startPos}
	local cameFrom = {}
	local gScore = {[startPos] = 0}
	local fScore = {[startPos] = heuristic(startPos, targetPos)}

	local function lowestF()
		local lowest, best = math.huge, nil
		for _, node in openSet do
			if fScore[node] and fScore[node] < lowest then
				lowest = fScore[node]
				best = node
			end
		end
		return best
	end

	while #openSet > 0 do
		local current = lowestF()
		if not current then break end
		if (current - targetPos).Magnitude < CELL then
			local path = {targetPos}
			while current do
				table.insert(path, 1, current)
				current = cameFrom[current]
				runService.Heartbeat:Wait()
			end
			return path
		end

		for i, n in openSet do
			if n == current then
				table.remove(openSet, i)
				break
			end
		end

		for _, neighbor in neighbors(current) do
			if not ignoreVoid and isVoid(neighbor) then
				continue
			end

			if checkWalls and isWall(current, neighbor) then
				continue
			end

			local tempG = gScore[current] + CELL
			if not gScore[neighbor] or tempG < gScore[neighbor] then
				cameFrom[neighbor] = current
				gScore[neighbor] = tempG
				fScore[neighbor] = tempG + heuristic(neighbor, targetPos)
				table.insert(openSet, neighbor)
			end
		end

		if #cameFrom > MAX_STEPS then
			warn('Path too long or blocked!')
			break
		end
		runService.Heartbeat:Wait()
	end

	return nil
end

return PF
