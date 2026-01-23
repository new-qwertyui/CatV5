local vape = shared.vape
local entitylib = vape.Libraries.entity

local run = function(func)
	func()
end

run(function()
    local function addEntity(ent)
        entitylib.addEntity(ent, nil, function()
            return true
        end)
    end

    local Zombies = workspace:WaitForChild('Baddies', 9e9)
    for _, v in Zombies:GetChildren() do
        addEntity(v)
    end
    vape:Clean(Zombies.ChildAdded:Connect(addEntity))
    vape:Clean(Zombies.ChildRemoved:Connect(function(ent)
        entitylib.removeEntity(ent)
    end))
end)    