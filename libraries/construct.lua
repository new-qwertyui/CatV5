
local storeevent = Instance.new('BindableEvent')
local inventoryplr 
local inventorytick = tick()
local bedwars
bedwars = {
    controllers = {
        AnimationType = setmetatable({}, {__index = function()
            return {}
        end}),
        AnimationUtil = setmetatable({}, {}),
        AppController = {},
        AbilityController = {},
        BedwarsKitMeta = {},
        BlockBreaker = {
            hitblock = function(...) return ... end,
            clientManager = {},
            getBlockPosition = function(...)
                return Vector3.zero
            end
        },
		BlockController = {
            isBlockBreakable = function(...)
                return true
            end,
            getBlockPosition = function(...)
                return Vector3.zero
            end
        },
		BlockPlacer = {
            new = function() 
                local a = {}
                a.blockType = 'real'
                function a:placeBlock() end
                function a:disable() end
                return a 
            end
        },
		BlockEngine = {},
		BowConstantsTable = {
            RelX = Vector3.zero,
            RelY = Vector3.zero,
            RelZ = Vector3.zero
        },
		ClickHold = {
            startClick = function(self) return self end,
            showProgress = function(...) return Instance.new('ScreenGui') end
        },
		Client = {},
		ClientDamageBlock = {},
		CombatConstant = {
            RAYCAST_SWORD_CHARACTER_DISTANCE = 17
        },
		getIcon = function()
			return ''
		end,
        BalloonController = {
            inflateBalloon = function() end,
            deflateBalloon = function() end
        },
		getInventory = function(plr)
			local suc, res = pcall(function()
                if plr == inventoryplr and (tick() - inventorytick) < 3 then
                    return inventoryplr
                end
                inventoryplr = plr.Character.InventoryFolder.Value:GetChildren()
                inventorytick = tick()
                return inventoryplr
			end)
			return {
                items = suc and res or {},
                armor = {}
            }
		end,
		ItemMeta = setmetatable({}, {
            __index = function()
                return {
                    block = {breakType = nil}
                }
            end
        }),
        SprintController = {},
		KillEffectMeta = {},
		KillFeedController = {
            addToKillFeed = function() end
        },
		Knit = {},
		KnockbackUtil = {
            applyKnockback = function(...)
                return (...)
            end
        },
		NametagController = {
            addGameNametag = function() end
        },
		ProjectileMeta = setmetatable({
            getProjectileMeta = function()
                return {
                    predictionLifetimeSec = 3,
                    lifetimeSec = 3
                }
            end
        }, {
            __index = function(self, index)
                self[index] = {
                    combat = {
                        damage = 0
                    }
                }
            end
        }),
        SwordController = {
            lastSwing = tick(),
            lastAttack = tick()
        },
        ProjectileController = {
            createLocalProjectile = function(...)
                return false
            end,
            calculateImportantLaunchValues = function(...) end
        },
		QueryUtil = {
            setQueryIgnored = function(...)
                return true
            end
        },
		QueueCard = {
            render = function() end
        },
		QueueMeta = {},
		Roact = {
            createElement = function() end,
            Ref = 'pro'
        },
		RuntimeLib = {},
		Shop = {
            getShopItem = function()
                return nil
            end,
            ShopItems = {}
        },
		ShopItems = {},
		SoundList = {},
		SoundManager = {},
		Store = {
            changed = {}
        },
		TeamUpgradeMeta = {},
		UILayers = {},
		VisualizerUtils = {},
		WeldTable = {}
    },
    events = {}
}

function bedwars.controllers.BlockController:getStore()
    return {
        getBlockAt = function()
            return nil
        end
    }
end

function bedwars.controllers.Store:getState()
    local tab = {}
    pcall(function()
        tab = {
            Game = {
                matchState = 1,
                queueType = 'bedwars_to4'
            },
            Bedwars = {
                kit = game.Players.LocalPlayer:GetAttribute('PlayingAsKit') or 'none'
            },
            Inventory = {
                observedInventory = {inventory = bedwars.controllers.getInventory(game.Players.LocalPlayer)},
                inventory = {
                    hand = game.Players.LocalPlayer.Character.HandInvItem.Value
                }
            }
        }
    end)
    print(tab.Game)
    return tab
end

function bedwars.controllers.SwordController:swingSwordAtMouse() end

function bedwars.controllers.SwordController.isClickingTooFast() 
    bedwars.controllers.SwordController.lastSwing = tick() 
    return true 
end

function bedwars.controllers.SwordController:getTargetInRegion() return true end

function bedwars.controllers.SoundManager:playSound(...)
    return (...)
end

function bedwars.controllers.QueryUtil:raycast(...)
    return workspace:Raycast(...)
end

function bedwars.controllers.Store:dispatch() end

function bedwars.controllers.Store.changed:connect(...)
    return storeevent.Event:Connect(...)
end

function bedwars.controllers.AppController:isAppOpen()
    return false
end

function bedwars.controllers.AppController:isLayerOpen()
    return false
end

function bedwars.controllers.AppController:getOpenApps()
    return {}
end

function bedwars.controllers.AbilityController:canUseAbility()
    return true
end

function bedwars.controllers.AbilityController:useAbility(...)
    return game:GetService('ReplicatedStorage')['events-@easy-games/game-core:shared/game-core-networking@getEvents.Events'].useAbility:FireServer(...)
end

function bedwars.controllers.BlockBreaker.clientManager:getBlockSelector()
    local tab = {}
    function tab:getMouseInfo()
        return 0
    end
    return tab
end


local issprinting = false;
function bedwars.controllers.SprintController:stopSprinting()
    issprinting = false
    workspace.CurrentCamera.FieldOfView -= 7
end

function bedwars.controllers.SprintController:startSprinting()
    issprinting = true
    pcall(function()
        repeat
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
            end)
            task.wait()
        until not issprinting
    end)
end

workspace.CurrentCamera:GetPropertyChangedSignal('FieldOfView'):Connect(function()
    if issprinting then
        workspace.CurrentCamera.FieldOfView += 7
    end
end)

function bedwars.controllers.SprintController:getMovementStatusModifier()
    return {
        getModifiers = function()
            return {}
        end
    }
end

local finishedremotes = {}
function bedwars.controllers.Client:Get(inst)
    if type(inst) == 'string' then
        if finishedremotes[inst] then
            return finishedremotes[inst]
        end
        for i,v in game:GetDescendants() do
            if tostring(v) == inst then
                local sendserver = function(...)
                    if v.ClassName == 'RemoteFunction' then
                        v:InvokeServer(...)
                    elseif v.ClassName == 'RemoteEvent' then
                        v:FireServer(...)
                    end
                end
                finishedremotes[inst] = {
                    SendToServer = sendserver,
                    FireServer = sendserver,
                    CallServer = sendserver,
                    CallServerAsync = sendserver
                }
                return finishedremotes[inst]
            end
        end
    end
end

function bedwars.controllers.Client:GetNamespace(a)
    local b = {}
    function b:Get(qweqwe)
        return bedwars.controllers.Client:Get(qweqwe)
    end
    return b 
end

return bedwars
