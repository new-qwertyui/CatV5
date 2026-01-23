type GenericFunction<T..., U...> = (U...) -> T...
type GenericScript = LocalScript | ModuleScript
type AnyFunction = GenericFunction<...any, ...any>
type AnyTable = { [any]: any }
type Table = {any}

type tool = {
    tool: Instance,
    itemType: string?,
    toolType: string?,
    amount: number,
    addedToBackpackTime: number,
    itemSkin: string?
}

type VapeModule = {
    Enabled: boolean,
    Options: {[any]: AnyTable}
}

declare Reach: VapeModule
declare Backtrack: VapeModule

declare store: AnyTable
declare bedwars: AnyTable
declare lobbybedwars: AnyTable
declare remotes: AnyTable
declare damagedata: AnyTable
declare speedBoosts: AnyTable
declare sortmethods: AnyTable
declare vapeEvents: AnyTable

declare canDebug: boolean
declare swapping: number
declare CancelSwitch: number

--[=[
    Retrieves the specified item.

    @param item string -- Item name
    @return tool? -- Matching item, if found
]=]
declare function getItem(item: string): tool?

--[=[
    Returns the best armor for the given slot (0–2).

    @param slot number -- Armor slot index
    @return string? -- Armor name
]=]
declare function getBestArmor(slot: number): string?

--[=[
    Returns all instances with the specified CollectionService tag
    and automatically updates on changes.

    @param tag string -- Collection tag
    @return Table, AnyFunction -- Instances and cleanup callback
]=]
declare function collection(tag: string, clean: VapeModule?): (Table, AnyFunction)

--[=[
    Returns the best sword and its inventory slot.

    @return tool?, number? -- Sword and slot index
]=]
declare function getSword(): (tool?, number?)

--[=[
    Returns the wool item and its amount in the inventory.

    @return string?, number? -- Wool item and count
]=]
declare function getWool(): (string?, number?)

--[=[
    Returns the placed block at the given position,
    automatically rounding the position.

    @param position Vector3 -- World position
    @return Instance?, Vector3 -- Block and rounded position
]=]
declare function getPlacedBlock(position: Vector3): (Instance?, Vector3)

--[=[
    Returns all block positions between two points,
    automatically rounding coordinates.

    @param posa Vector3 -- Start position
    @param posb Vector3 -- End position
    @return {Vector3} -- Block positions
]=]
declare function getBlocksInPoints(posa: Vector3, posb: Vector3): {Vector3}
    
--[=[
    Rounds a world position to aligned coordinates.

    @param position Vector3 -- Target position
    @return Vector3 -- Rounded position
]=]
declare function roundPos(position: Vector3): Vector3

--[=[
    Switches the currently held item to the specified tool.

    @param tool tool -- Target tool
    @return boolean -- True if successfully equipped
]=]
declare function switchItem(tool: tool, delay: number?): boolean

--[=[
    Returns the point on a bounded region around a reference position
    in the direction of the target position.

    @param poscheck Vector3 -- Reference position
    @param position Vector3 -- Target position
    @return Vector3 -- Clamped direction point
]=]
declare function nearCorner(poscheck: Vector3, position: Vector3): Vector3

--[=[
    Returns a valid nearby position if the given position is not walkable.

    @param position Vector3 -- Target position
    @return Vector3 -- Adjusted position
]=]
declare function blockProximity(position: Vector3): Vector3

--[=[
    Checks for adjacent blocks at the given position.

    @param position Vector3 -- Target position
    @return boolean -- True if adjacent blocks exist
]=]
declare function checkAdjacent(position: Vector3): boolean

--[=[
    Returns the shield value of a character.

    @param char Model -- Character model
    @return number -- Shield amount
]=]
declare function getShieldAttribute(char: Model): number

--[=[
    Returns the current movement speed multiplier.

    @return number -- Speed multiplier
]=]
declare function getSpeed(): number

--[=[
    Returns the hotbar slot index for the specified tool.

    @param tool tool -- Target tool
    @return number? -- Hotbar slot index, if found
]=]
declare function getHotbar(tool: tool): number?

--[=[
    Switches to the specified hotbar slot.

    @param slot number -- Hotbar slot index
    @return boolean -- True if switch succeeded
]=]
declare function hotbarSwitch(slot: number): boolean