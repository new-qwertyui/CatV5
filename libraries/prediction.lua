local module = {}
local eps = 1e-9

local function isZero(d)
	return (d > -eps and d < eps)
end

local function cuberoot(x)
	return (x > 0) and math.pow(x, (1 / 3)) or -math.pow(math.abs(x), (1 / 3))
end

local function solveQuadric(c0, c1, c2)
	local s0, s1

	local p, q, D

	p = c1 / (2 * c0)
	q = c2 / c0
	D = p * p - q

	if isZero(D) then
		s0 = -p
		return s0
	elseif (D < 0) then
		return
	else -- if (D > 0)
		local sqrt_D = math.sqrt(D)

		s0 = sqrt_D - p
		s1 = -sqrt_D - p
		return s0, s1
	end
end

local function solveCubic(c0, c1, c2, c3)
	local s0, s1, s2

	local num, sub
	local A, B, C
	local sq_A, p, q
	local cb_p, D

	A = c1 / c0
	B = c2 / c0
	C = c3 / c0

	sq_A = A * A
	p = (1 / 3) * (-(1 / 3) * sq_A + B)
	q = 0.5 * ((2 / 27) * A * sq_A - (1 / 3) * A * B + C)

	cb_p = p * p * p
	D = q * q + cb_p

	if isZero(D) then
		if isZero(q) then -- one triple solution
			s0 = 0
			num = 1
		else -- one single and one double solution
			local u = cuberoot(-q)
			s0 = 2 * u
			s1 = -u
			num = 2
		end
	elseif (D < 0) then -- Casus irreducibilis: three real solutions
		local phi = (1 / 3) * math.acos(-q / math.sqrt(-cb_p))
		local t = 2 * math.sqrt(-p)

		s0 = t * math.cos(phi)
		s1 = -t * math.cos(phi + math.pi / 3)
		s2 = -t * math.cos(phi - math.pi / 3)
		num = 3
	else -- one real solution
		local sqrt_D = math.sqrt(D)
		local u = cuberoot(sqrt_D - q)
		local v = -cuberoot(sqrt_D + q)

		s0 = u + v
		num = 1
	end

	sub = (1 / 3) * A

	if (num > 0) then s0 = s0 - sub end
	if (num > 1) then s1 = s1 - sub end
	if (num > 2) then s2 = s2 - sub end

	return s0, s1, s2
end

function module.solveQuartic(c0, c1, c2, c3, c4)
    local s0, s1, s2, s3

    local coeffs = {}
    local z, u, v, sub
    local A, B, C, D
    local sq_A, p, q, r
    local num

    if isZero(c0) then
        local s = {solveCubic(c1, c2, c3, c4)}
        return s
    end

    A = c1 / c0
    B = c2 / c0
    C = c3 / c0
    D = c4 / c0

    sq_A = A * A
    p = -0.375 * sq_A + B
    q = 0.125 * sq_A * A - 0.5 * A * B + C
    r = -(3 / 256) * sq_A * sq_A + 0.0625 * sq_A * B - 0.25 * A * C + D

    if isZero(r) then
        local results = {solveCubic(1, 0, p, q)}
        num = #results
        s0, s1, s2 = results[1], results[2], results[3]
    else
        coeffs[3] = 0.5 * r * p - 0.125 * q * q
        coeffs[2] = -r
        coeffs[1] = -0.5 * p
        coeffs[0] = 1

        local cubic_results = {solveCubic(coeffs[0], coeffs[1], coeffs[2], coeffs[3])}
        z = cubic_results[1]

        u = z * z - r
        v = 2 * z - p

        if isZero(u) then
            u = 0
        elseif (u > 0) then
            u = math.sqrt(u)
        else
            return {}
        end
        if isZero(v) then
            v = 0
        elseif (v > 0) then
            v = math.sqrt(v)
        else
            return {}
        end

        local solutions = {}
        
        coeffs[2] = z - u
        coeffs[1] = q < 0 and -v or v
        coeffs[0] = 1
        local r1 = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
        for _, s in ipairs(r1) do table.insert(solutions, s) end
        
        coeffs[2] = z + u
        coeffs[1] = q < 0 and v or -v
        coeffs[0] = 1
        local r2 = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
        for _, s in ipairs(r2) do table.insert(solutions, s) end

        num = #solutions
        s0, s1, s2, s3 = solutions[1], solutions[2], solutions[3], solutions[4]
    end

    sub = 0.25 * A

    if (num and num > 0) then
        if (num > 0 and s0) then s0 = s0 - sub end
        if (num > 1 and s1) then s1 = s1 - sub end
        if (num > 2 and s2) then s2 = s2 - sub end
        if (num > 3 and s3) then s3 = s3 - sub end

        local final_solutions = {}
        if s0 then table.insert(final_solutions, s0) end
        if s1 then table.insert(final_solutions, s1) end
        if s2 then table.insert(final_solutions, s2) end
        if s3 then table.insert(final_solutions, s3) end
        return final_solutions
    else
        return {}
    end
end

-- Enhanced jumping pattern detection
local function detectJumpingPattern(targetVelocity, previousVelocities)
	local verticalVel = targetVelocity.Y
	
	-- Check if player is in a jumping state
	local isJumping = math.abs(verticalVel) > 5
	
	-- If we have previous velocity data, look for oscillating patterns
	if previousVelocities and #previousVelocities >= 3 then
		local verticalChanges = 0
		for i = 2, #previousVelocities do
			if (previousVelocities[i].Y > 0) ~= (previousVelocities[i-1].Y > 0) then
				verticalChanges = verticalChanges + 1
			end
		end
		-- If velocity direction changes frequently, it's likely jumping
		return verticalChanges >= 2, verticalChanges
	end
	
	return isJumping, 0
end

-- Improved ground detection with better jumping handling
local function predictGroundCollision(startPos, velocity, gravity, playerHeight, params, maxTime, isJumping)
	local dt = 0.016 -- 60 FPS timestep
	local currentPos = startPos
	local currentVel = velocity
	local time = 0
	
	-- For jumping players, use a more conservative approach
	if isJumping then
		-- Predict where they'll be when they start falling
		local timeToApex = math.max(0, currentVel.Y / gravity)
		local apexHeight = currentPos.Y + (currentVel.Y * timeToApex) - (0.5 * gravity * timeToApex * timeToApex)
		
		-- If they're going up, predict the fall from apex
		if currentVel.Y > 0 then
			-- Calculate time to fall from apex to ground level
			local fallTime = math.sqrt(2 * (apexHeight - (startPos.Y - playerHeight)) / gravity)
			local totalTime = timeToApex + fallTime
			
			if totalTime < maxTime then
				local horizontalDistance = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude * totalTime
				local landingPos = startPos + Vector3.new(currentVel.X * totalTime, -playerHeight, currentVel.Z * totalTime)
				return landingPos, totalTime
			end
		end
	end
	
	-- Standard ground prediction for non-jumping or when jumping prediction fails
	while time < maxTime do
		-- Apply gravity to velocity
		currentVel = currentVel + Vector3.new(0, -gravity * dt, 0)
		
		-- Calculate next position
		local nextPos = currentPos + currentVel * dt
		
		-- Check if we have params and can raycast
		if params then
			local ray = workspace:Raycast(currentPos, nextPos - currentPos, params)
			if ray then
				-- Found collision, return adjusted position and time
				local collisionPos = ray.Position + Vector3.new(0, playerHeight, 0)
				return collisionPos, time
			end
		end
		
		-- Simple ground level check if no raycasting available
		if nextPos.Y <= (startPos.Y - playerHeight * 2) then
			local groundPos = Vector3.new(nextPos.X, startPos.Y - playerHeight, nextPos.Z)
			return groundPos, time
		end
		
		currentPos = nextPos
		time = time + dt
	end
	
	return nil, maxTime
end

-- Calculate prediction time with jumping consideration and long-distance adjustments
local function calculatePredictionTime(distance, projectileSpeed, targetVelocity, isStrafing, isJumping)
	local baseTime = distance / projectileSpeed
	local velocityMagnitude = targetVelocity.Magnitude
	
	-- New: speed-aware long-distance factor
	local longDistanceFactor = 1.0
	if distance > 200 then
		local far = distance > 500 and 1 or distance > 350 and 2 or 3
		-- For slower projectiles, we need to lead MORE (factor > 1). For fast ones, slightly less.
		if projectileSpeed < 120 then
			-- Strongly increase time for very low speed
			longDistanceFactor = (far == 1 and 1.35) or (far == 2 and 1.25) or 1.15
		elseif projectileSpeed < 180 then
			longDistanceFactor = (far == 1 and 1.25) or (far == 2 and 1.15) or 1.1
		else
			-- High-speed projectiles can still reduce a little to avoid overlead
			longDistanceFactor = (far == 1 and 0.9) or (far == 2 and 0.95) or 1.0
		end
	end
	
	-- For jumping targets, keep conservative prediction but don't underlead slow projectiles
	if isJumping then
		local jumpingFactor = 0.6
		if projectileSpeed < 150 and distance > 150 then
			-- Ease up the reduction for slow shots at range
			jumpingFactor = 0.75
		end
		if isStrafing and distance > 150 then
			jumpingFactor = jumpingFactor * 0.9
		end
		return baseTime * jumpingFactor * longDistanceFactor
	end
	
	-- Strafing handling
	if isStrafing and distance > 150 then
		-- Previously this reduced aggressively; for slow projectiles, avoid underlead
		if projectileSpeed < 180 then
			local boost = math.min(distance / 400, 0.25) -- up to +25%
			return baseTime * (1.0 + boost) * longDistanceFactor
		else
			local distanceFactor = math.min(distance / 300, 1.0)
			local strafingReduction = 0.75 + (distanceFactor * 0.15) -- 75-90% of base time for faster projectiles
			return baseTime * strafingReduction * longDistanceFactor
		end
	end
	
	-- Non-strafing
	if distance > 200 and velocityMagnitude > 10 then
		return baseTime * longDistanceFactor
	end
	
	return baseTime
end

-- Compute required projectile speed to hit at time t given target kinematics and projectile gravity
local function requiredSpeedAtTime(t, origin, targetPos, relativeVelocity, gravity)
	-- Displacement the projectile must cover at time t:
	-- D(t) = (targetPos - origin) + relativeVelocity * t - 0.5 * g * t^2 (downward in Y)
	local drop = Vector3.new(0, 0.5 * gravity * t * t, 0)
	local D = (targetPos - origin) + relativeVelocity * t - drop
	local dist = D.Magnitude
	if t <= 0 then
		return math.huge
	end
	return dist / t
end

-- Validate if a solution is physically reasonable (enhanced for jumping and slow projectiles)
local function validateSolution(time, origin, targetPos, relativeVelocity, gravity, projectileSpeed, maxTime, isJumping)
	if not time or time ~= time or time <= 0 or time > maxTime then
		return false
	end
	
	local req = requiredSpeedAtTime(time, origin, targetPos, relativeVelocity, gravity)
	-- Allow more tolerance for jumping and for inherently harder long-range/slow shots
	local speedTolerance = isJumping and 1.35 or 1.18
	if projectileSpeed < 150 then
		speedTolerance = speedTolerance + 0.07
	end
	
	if req > projectileSpeed * speedTolerance then
		return false
	end
	
	return true
end

-- Enhanced strafe detection that considers jumping
local function isStrafing(targetVelocity, distance, isJumping)
	local velocityMagnitude = targetVelocity.Magnitude
	
	-- Lower threshold for strafe detection at longer distances or when jumping
	local minStrafingSpeed = (distance > 200 or isJumping) and 5 or 8
	
	if velocityMagnitude < minStrafingSpeed then
		return false
	end
	
	-- Calculate horizontal velocity (X and Z components)
	local horizontalVel = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
	local horizontalMagnitude = horizontalVel.Magnitude
	
	-- More sensitive strafe detection for longer distances or jumping
	local horizontalThreshold = (distance > 200 or isJumping) and 0.5 or 0.7
	local speedThreshold = (distance > 200 or isJumping) and 8 or 12
	
	if horizontalMagnitude / velocityMagnitude > horizontalThreshold and horizontalMagnitude > speedThreshold then
		return true
	end
	
	return false
end

-- Enhanced network lag compensation for jumping targets
local function calculateNetworkCompensation(ping, targetVelocity, distance, isStrafing, isJumping)
	local lagTime = ping / 1000 -- Convert to seconds
	local velocityMagnitude = targetVelocity.Magnitude
	
	-- Reduce network compensation for jumping and strafing targets
	local baseCompensation = lagTime
	
	if isJumping then
		-- Significantly reduce compensation for jumping targets
		baseCompensation = baseCompensation * 0.4
		
		-- Even less for jumping + strafing
		if isStrafing then
			baseCompensation = baseCompensation * 0.7
		end
	elseif isStrafing then
		-- Standard strafing reduction
		baseCompensation = baseCompensation * 0.5
		
		-- Further reduce for long distances
		if distance > 200 then
			baseCompensation = baseCompensation * 0.6
		end
	else
		-- Standard compensation for non-strafing, non-jumping targets
		if velocityMagnitude > 20 then
			baseCompensation = baseCompensation * (1 + velocityMagnitude / 200)
		end
	end
	
	return math.min(baseCompensation, lagTime * 0.8) -- Cap compensation
end

-- Enhanced prediction for jumping and strafing targets with low-speed compensation
local function predictComplexTarget(origin, targetPos, targetVelocity, projectileSpeed, gravity, distance, ping, isJumping, isStrafing)
	local velocityMagnitude = targetVelocity.Magnitude
	
	-- Use shorter prediction time for complex movement (now speed-aware)
	local predictionTime = calculatePredictionTime(distance, projectileSpeed, targetVelocity, isStrafing, isJumping)
	
	-- Low-speed projectile detection (slightly raised threshold)
	local isLowSpeed = projectileSpeed < 180
	local speedRatio = projectileSpeed / 200 -- Ratio for speed compensation
	
	-- For jumping targets, we need to consider the vertical component more carefully
	local predictions = {}
	
	if isJumping then
		-- Enhanced prediction weights for low-speed projectiles
		local currentWeight = isLowSpeed and 0.12 or 0.2
		local horizontalWeight = isLowSpeed and 0.58 or 0.4
		local reducedWeight = isLowSpeed and 0.3 or 0.4
		
		-- 1. Current trajectory (very low weight for jumping + low speed)
		local currentPred = targetPos + targetVelocity * predictionTime
		table.insert(predictions, {pos = currentPred, weight = currentWeight})
		
		-- 2. Horizontal-only prediction (higher weight for low speed)
		local horizontalVel = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
		local horizontalPred = targetPos + horizontalVel * predictionTime
		table.insert(predictions, {pos = horizontalPred, weight = horizontalWeight})
		
		-- 3. Reduced vertical velocity (adjusted for low speed)
		local verticalReduction = isLowSpeed and 0.1 or 0.3
		local reducedVertical = Vector3.new(targetVelocity.X, targetVelocity.Y * verticalReduction, targetVelocity.Z)
		local reducedPred = targetPos + reducedVertical * predictionTime
		table.insert(predictions, {pos = reducedPred, weight = reducedWeight})
		
		-- 4. For low-speed projectiles, add a conservative center-mass prediction
		if isLowSpeed then
			local conservativeTime = predictionTime * 0.55
			local conservativeVel = Vector3.new(targetVelocity.X * 0.7, 0, targetVelocity.Z * 0.7)
			local conservativePred = targetPos + conservativeVel * conservativeTime
			table.insert(predictions, {pos = conservativePred, weight = 0.28})
		end
		
	elseif isStrafing then
		-- Standard strafing predictions (slightly favor reduced velocity but not too much for slow projectiles)
		local currentPred = targetPos + targetVelocity * predictionTime
		table.insert(predictions, {pos = currentPred, weight = isLowSpeed and 0.4 or 0.3})
		
		local reducedVel = targetVelocity * (isLowSpeed and 0.8 or 0.6)
		local reducedPred = targetPos + reducedVel * predictionTime
		table.insert(predictions, {pos = reducedPred, weight = isLowSpeed and 0.6 or 0.7})
	else
		-- Simple linear prediction for normal movement
		return targetPos + targetVelocity * predictionTime, predictionTime
	end
	
	-- Calculate weighted average
	local finalPrediction = Vector3.new(0, 0, 0)
	for _, pred in pairs(predictions) do
		finalPrediction = finalPrediction + (pred.pos * pred.weight)
	end
	
	-- Apply gravity compensation (reduced for jumping targets)
	if gravity > 0 then
		local gravityFactor = isJumping and 0.6 or 1.0 -- Reduce gravity effect for jumping
		local gravityDrop = 0.5 * gravity * predictionTime * predictionTime * gravityFactor
		finalPrediction = finalPrediction + Vector3.new(0, gravityDrop, 0)
	end
	
	-- Apply network compensation
	if ping > 60 then
		local compensation = calculateNetworkCompensation(ping, targetVelocity, distance, isStrafing, isJumping)
		local compensationVector = targetVelocity * compensation
		finalPrediction = finalPrediction + compensationVector
	end
	
	return finalPrediction, predictionTime
end

function module.SolveTrajectory(origin, originVelocity, projectileSpeed, gravity, targetPos, targetVelocity, playerGravity, playerHeight, playerJump, params, bypass, previousVelocities)
    -- Enhanced input validation
    if not origin or not targetPos or not targetVelocity then
        return nil
    end
    
    originVelocity = originVelocity or Vector3.new(0, 0, 0)
    projectileSpeed = projectileSpeed or 100
    gravity = gravity or 196.2
    playerGravity = playerGravity or 196.2
    playerHeight = playerHeight or 5
    
	warn(typeof(targetVelocity), targetVelocity)

    local disp = targetPos - origin
    local distance = disp.Magnitude
    local velocityMagnitude = targetVelocity.Magnitude
    
    -- Early exit for very close targets
    if distance < 10 then
        return targetPos
    end
    
    -- Get ping for network compensation
    local ping = 0
    local success, stats = pcall(function()
        return game:GetService('Stats'):FindFirstChild('PerformanceStats')
    end)
    if success and stats or bypass then
        ping = bypass and 50 or tonumber(stats.Ping:GetValue())
    end
    
    -- Enhanced movement pattern detection
    local isJumping, jumpChanges = detectJumpingPattern(targetVelocity, previousVelocities)
    local isStrafingTarget = isStrafing(targetVelocity, distance, isJumping)
    
    -- Special handling for very low velocity targets
    if velocityMagnitude < 3 then
        local simpleTime = distance / projectileSpeed
        local simplePrediction = targetPos + targetVelocity * simpleTime
        
        if gravity > 0 then
            local gravityDrop = 0.5 * gravity * simpleTime * simpleTime
            simplePrediction = simplePrediction + Vector3.new(0, gravityDrop, 0)
        end
        
        return simplePrediction
    end
    
    -- Apply jump prediction adjustments and aim for middle of target
    local adjustedTargetPos = targetPos
    local adjustedVelocity = targetVelocity
    
    -- Aim for the middle of the target (half of player height up from feet)
    adjustedTargetPos = adjustedTargetPos + Vector3.new(0, playerHeight / 2, 0)
    
    if playerJump then
        adjustedTargetPos = adjustedTargetPos - Vector3.new(0, 1, 0) -- Slight adjustment for jumping
    end
    
    -- Enhanced ground collision prediction for jumping targets
    if playerGravity and playerGravity > 0 and (math.abs(targetVelocity.Y) > 0.01 or isJumping) and velocityMagnitude >= 5 then
        local maxTime = distance / projectileSpeed + 2 -- Add some buffer time
        local groundPos, groundTime = predictGroundCollision(
            adjustedTargetPos, 
            adjustedVelocity, 
            playerGravity, 
            playerHeight, 
            params, 
            maxTime,
            isJumping
        )
        
        if groundPos and groundTime < maxTime * 0.9 then -- Use if collision is reasonably soon
            -- For jumping targets, blend ground prediction with current position
            if isJumping then
                local blendFactor = math.min(groundTime / (maxTime * 0.5), 1.0)
                adjustedTargetPos = adjustedTargetPos:lerp(groundPos, blendFactor * 0.7)
                -- Keep some vertical velocity for jumping targets
                adjustedVelocity = Vector3.new(targetVelocity.X, targetVelocity.Y * 0.3, targetVelocity.Z)
            else
                adjustedTargetPos = groundPos
                adjustedVelocity = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
            end
        end
    end
    
    -- Use enhanced prediction method for complex movement patterns
    local predictedPosition, predictionTime = predictComplexTarget(
        origin, adjustedTargetPos, adjustedVelocity, projectileSpeed, gravity, distance, ping, isJumping, isStrafingTarget
    )
    
    -- Try quartic solver for precise calculation with enhanced validation
    local bestSolution = predictedPosition
    
    -- Use quartic solver less aggressively for jumping targets
    local useQuartic = not isJumping or (distance < 100 and not isStrafingTarget)
    
    if useQuartic then
        local relativeVelocity = adjustedVelocity - originVelocity
        local p, q, r = relativeVelocity.X, relativeVelocity.Y, relativeVelocity.Z
        local h, j, k = (adjustedTargetPos - origin).X, (adjustedTargetPos - origin).Y, (adjustedTargetPos - origin).Z
        local l = -0.5 * gravity
        
        local solutions = module.solveQuartic(
            l*l,
            -2*q*l,
            q*q - 2*j*l - projectileSpeed*projectileSpeed + p*p + r*r,
            2*(j*q + h*p + k*r),
            j*j + h*h + k*k
        )
        
        if solutions and #solutions > 0 then
            local maxTime = distance / projectileSpeed * (isJumping and 1.5 or 2) -- Shorter max time for jumping
            local bestTime = nil
            
            for _, time in ipairs(solutions) do
                if validateSolution(time, origin, adjustedTargetPos, relativeVelocity, gravity, projectileSpeed, maxTime, isJumping) then
                    if not bestTime or (time > 0 and time < bestTime) then
                        bestTime = time
                    end
                end
            end
            
            -- Use quartic solution if it's reasonable
            if bestTime and bestTime > 0 then
                local quarticSolution = adjustedTargetPos + adjustedVelocity * bestTime
                
                -- Enhanced validation for jumping targets
                local quarticDistance = (quarticSolution - origin).Magnitude
                local maxReasonableDistance = distance * (isJumping and 1.8 or 2.5)
                
                if quarticDistance <= maxReasonableDistance then
                    -- For jumping targets, blend quartic with predictive solution
                    if isJumping then
                        bestSolution = predictedPosition:lerp(quarticSolution, 0.6)
                    else
                        bestSolution = quarticSolution
                    end
                end
            end
        end
    end
    
    -- Final validation and bounds checking
    if bestSolution then
        local finalDistance = (bestSolution - origin).Magnitude
        
        -- If prediction is unreasonably far, fall back to conservative estimate
        local maxReasonableDistance = distance * (isJumping and 2.0 or 2.5)
        
        if finalDistance > maxReasonableDistance then
            local conservativeTime = distance / projectileSpeed * (isJumping and 0.6 or 0.85)
            bestSolution = targetPos + targetVelocity * conservativeTime
            
            if gravity > 0 then
                local gravityFactor = isJumping and 0.5 or 1.0
                local gravityDrop = 0.5 * gravity * conservativeTime * conservativeTime * gravityFactor
                bestSolution = bestSolution + Vector3.new(0, gravityDrop, 0)
            end
        end
    end
    
    return bestSolution
end

return module
