-- Lua Library inline imports
local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end

local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local __TS__Symbol, Symbol
do
    local symbolMetatable = {__tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end}
    function __TS__Symbol(description)
        return setmetatable({description = description}, symbolMetatable)
    end
    Symbol = {
        asyncDispose = __TS__Symbol("Symbol.asyncDispose"),
        dispose = __TS__Symbol("Symbol.dispose"),
        iterator = __TS__Symbol("Symbol.iterator"),
        hasInstance = __TS__Symbol("Symbol.hasInstance"),
        species = __TS__Symbol("Symbol.species"),
        toStringTag = __TS__Symbol("Symbol.toStringTag")
    }
end

local __TS__Iterator
do
    local function iteratorGeneratorStep(self)
        local co = self.____coroutine
        local status, value = coroutine.resume(co)
        if not status then
            error(value, 0)
        end
        if coroutine.status(co) == "dead" then
            return
        end
        return true, value
    end
    local function iteratorIteratorStep(self)
        local result = self:next()
        if result.done then
            return
        end
        return true, result.value
    end
    local function iteratorStringStep(self, index)
        index = index + 1
        if index > #self then
            return
        end
        return index, string.sub(self, index, index)
    end
    function __TS__Iterator(iterable)
        if type(iterable) == "string" then
            return iteratorStringStep, iterable, 0
        elseif iterable.____coroutine ~= nil then
            return iteratorGeneratorStep, iterable
        elseif iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            return iteratorIteratorStep, iterator
        else
            return ipairs(iterable)
        end
    end
end

local Set
do
    Set = __TS__Class()
    Set.name = "Set"
    function Set.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "Set"
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self:add(result.value)
            end
        else
            local array = values
            for ____, value in ipairs(array) do
                self:add(value)
            end
        end
    end
    function Set.prototype.add(self, value)
        local isNewValue = not self:has(value)
        if isNewValue then
            self.size = self.size + 1
        end
        if self.firstKey == nil then
            self.firstKey = value
            self.lastKey = value
        elseif isNewValue then
            self.nextKey[self.lastKey] = value
            self.previousKey[value] = self.lastKey
            self.lastKey = value
        end
        return self
    end
    function Set.prototype.clear(self)
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Set.prototype.delete(self, value)
        local contains = self:has(value)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[value]
            local previous = self.previousKey[value]
            if next ~= nil and previous ~= nil then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next ~= nil then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous ~= nil then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[value] = nil
            self.previousKey[value] = nil
        end
        return contains
    end
    function Set.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(self:keys()) do
            callback(nil, key, key, self)
        end
    end
    function Set.prototype.has(self, value)
        return self.nextKey[value] ~= nil or self.lastKey == value
    end
    Set.prototype[Symbol.iterator] = function(self)
        return self:values()
    end
    function Set.prototype.entries(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, key}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.values(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    Set[Symbol.species] = Set
end

local Map
do
    Map = __TS__Class()
    Map.name = "Map"
    function Map.prototype.____constructor(self, entries)
        self[Symbol.toStringTag] = "Map"
        self.items = {}
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if entries == nil then
            return
        end
        local iterable = entries
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                local value = result.value
                self:set(value[1], value[2])
            end
        else
            local array = entries
            for ____, kvp in ipairs(array) do
                self:set(kvp[1], kvp[2])
            end
        end
    end
    function Map.prototype.clear(self)
        self.items = {}
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Map.prototype.delete(self, key)
        local contains = self:has(key)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[key]
            local previous = self.previousKey[key]
            if next ~= nil and previous ~= nil then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next ~= nil then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous ~= nil then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[key] = nil
            self.previousKey[key] = nil
        end
        self.items[key] = nil
        return contains
    end
    function Map.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(self:keys()) do
            callback(nil, self.items[key], key, self)
        end
    end
    function Map.prototype.get(self, key)
        return self.items[key]
    end
    function Map.prototype.has(self, key)
        return self.nextKey[key] ~= nil or self.lastKey == key
    end
    function Map.prototype.set(self, key, value)
        local isNewValue = not self:has(key)
        if isNewValue then
            self.size = self.size + 1
        end
        self.items[key] = value
        if self.firstKey == nil then
            self.firstKey = key
            self.lastKey = key
        elseif isNewValue then
            self.nextKey[self.lastKey] = key
            self.previousKey[key] = self.lastKey
            self.lastKey = key
        end
        return self
    end
    Map.prototype[Symbol.iterator] = function(self)
        return self:entries()
    end
    function Map.prototype.entries(self)
        local items = self.items
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, items[key]}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.values(self)
        local items = self.items
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = items[key]}
                key = nextKey[key]
                return result
            end
        }
    end
    Map[Symbol.species] = Map
end

local function __TS__StringIncludes(self, searchString, position)
    if not position then
        position = 1
    else
        position = position + 1
    end
    local index = string.find(self, searchString, position, true)
    return index ~= nil
end

local __TS__Match = string.match

local function __TS__SourceMapTraceBack(fileName, sourceMap)
    _G.__TS__sourcemap = _G.__TS__sourcemap or ({})
    _G.__TS__sourcemap[fileName] = sourceMap
    if _G.__TS__originalTraceback == nil then
        local originalTraceback = debug.traceback
        _G.__TS__originalTraceback = originalTraceback
        debug.traceback = function(thread, message, level)
            local trace
            if thread == nil and message == nil and level == nil then
                trace = originalTraceback()
            elseif __TS__StringIncludes(_VERSION, "Lua 5.0") then
                trace = originalTraceback((("[Level " .. tostring(level)) .. "] ") .. tostring(message))
            else
                trace = originalTraceback(thread, message, level)
            end
            if type(trace) ~= "string" then
                return trace
            end
            local function replacer(____, file, srcFile, line)
                local fileSourceMap = _G.__TS__sourcemap[file]
                if fileSourceMap ~= nil and fileSourceMap[line] ~= nil then
                    local data = fileSourceMap[line]
                    if type(data) == "number" then
                        return (srcFile .. ":") .. tostring(data)
                    end
                    return (data.file .. ":") .. tostring(data.line)
                end
                return (file .. ":") .. line
            end
            local result = string.gsub(
                trace,
                "(%S+)%.lua:(%d+)",
                function(file, line) return replacer(nil, file .. ".lua", file .. ".ts", line) end
            )
            local function stringReplacer(____, file, line)
                local fileSourceMap = _G.__TS__sourcemap[file]
                if fileSourceMap ~= nil and fileSourceMap[line] ~= nil then
                    local chunkName = (__TS__Match(file, "%[string \"([^\"]+)\"%]"))
                    local sourceName = string.gsub(chunkName, ".lua$", ".ts")
                    local data = fileSourceMap[line]
                    if type(data) == "number" then
                        return (sourceName .. ":") .. tostring(data)
                    end
                    return (data.file .. ":") .. tostring(data.line)
                end
                return (file .. ":") .. line
            end
            result = string.gsub(
                result,
                "(%[string \"[^\"]+\"%]):(%d+)",
                function(file, line) return stringReplacer(nil, file, line) end
            )
            return result
        end
    end
end
-- End of Lua Library inline imports
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["416"] = 1,["418"] = 3,["419"] = 4,["420"] = 5,["421"] = 6,["422"] = 7,["423"] = 9,["425"] = 1,["427"] = 23,["428"] = 23,["430"] = 24,["431"] = 28,["432"] = 30,["433"] = 31,["435"] = 34,["436"] = 36,["437"] = 34,["438"] = 26,["441"] = 50,["442"] = 1,["443"] = 54,["444"] = 53,["445"] = 1,["446"] = 57,["447"] = 56,["454"] = 1,["455"] = 68,["456"] = 69,["457"] = 70,["458"] = 71,["459"] = 72,["460"] = 72,["461"] = 72,["462"] = 72,["463"] = 73,["465"] = 76,["466"] = 77,["467"] = 78,["469"] = 82,["470"] = 83,["472"] = 87,["473"] = 88,["474"] = 89,["475"] = 91,["476"] = 67,["484"] = 1,["485"] = 1,["486"] = 106,["487"] = 107,["489"] = 111,["490"] = 112,["491"] = 114,["492"] = 115,["493"] = 116,["494"] = 116,["495"] = 116,["496"] = 116,["497"] = 117,["499"] = 120,["500"] = 121,["501"] = 122,["503"] = 125,["504"] = 126,["505"] = 130,["506"] = 133,["507"] = 134,["509"] = 138,["510"] = 139,["511"] = 141,["512"] = 102,["519"] = 1,["520"] = 152,["521"] = 153,["522"] = 154,["523"] = 155,["524"] = 156,["525"] = 156,["526"] = 156,["527"] = 156,["530"] = 160,["531"] = 161,["532"] = 162,["534"] = 165,["535"] = 151,["536"] = 169,["537"] = 170,["538"] = 171,["539"] = 171,["540"] = 171,["541"] = 171,["542"] = 169,["543"] = 174,["544"] = 175,["545"] = 176,["546"] = 174,["547"] = 180,["548"] = 181,["549"] = 182,["550"] = 183,["551"] = 184,["552"] = 185,["553"] = 185,["554"] = 185,["555"] = 185,["558"] = 190,["559"] = 190,["560"] = 190,["561"] = 192,["562"] = 192,["563"] = 192,["564"] = 192,["565"] = 192,["566"] = 192,["567"] = 192,["568"] = 197,["569"] = 198,["570"] = 199,["571"] = 200,["572"] = 201,["575"] = 204,["576"] = 205,["577"] = 206,["578"] = 207,["582"] = 180,["583"] = 214,["584"] = 215,["585"] = 216,["587"] = 214,["590"] = 1,["591"] = 1,["592"] = 226,["594"] = 227,["595"] = 228,["596"] = 226});
animationStation = animationStation or ({})
do
    local warning = utility.warning
    local Quaternion = utility.Quaternion
    local create3d = vector.create3d
    local loadFiles = utility.loadFiles
    local fakeRef = utility.fakeRef
    loadFiles({"master_containers"})
    --- Holds all the model animation information.
    local repository = __TS__New(animationStation.ModelContainer)
    --- Holds all the bone states for players.
    local PlayerState = __TS__Class()
    PlayerState.name = "PlayerState"
    function PlayerState.prototype.____constructor(self)
        self.boneStates = __TS__New(Map)
        local characterBones = repository.bones:get("character.b3d")
        if characterBones == nil then
            error("Tried to create a player state without [character.b3d] bones registered!")
        end
        characterBones:forEach(function(____, bone)
            self.boneStates:set(bone, {animation = "", progress = 0, speed = 1, up = true})
        end)
    end
    --- Player Repository holds all the player bone states because:
    -- - the player is userdata, not an object. >:(
    local playerRepository = __TS__New(Map)
    function animationStation.registerAnimation(modelName, animationName, definition)
        repository:registerAnimation(modelName, animationName, definition)
    end
    function animationStation.registerBones(modelName, bones)
        repository:registerBones(modelName, bones)
    end
    --- Set a player's bone animation.
    -- 
    -- @param player The player.
    -- @param boneName The bone name.
    -- @param animationName The animation name.
    -- @returns If the animation was applied or it was simply ignored due to being the existing animation.
    function animationStation.setPlayerBoneAnimation(player, boneName, animationName)
        local name = player:get_player_name()
        local state = playerRepository:get(name)
        if state == nil then
            warning(("Player [" .. name) .. "] does not exist in database! Creating and aborting.")
            playerRepository:set(
                name,
                __TS__New(PlayerState)
            )
            return false
        end
        local boneState = state.boneStates:get(boneName)
        if boneState == nil then
            error(("Tried to set bone animation for bone [" .. boneName) .. "] in character.b3d, which does not exist.")
        end
        if boneState.animation == animationName then
            return false
        end
        boneState.animation = animationName
        boneState.up = true
        boneState.progress = 0
        return true
    end
    --- Set a bone animation which synchronizes with the current progress of another bone.
    -- 
    -- @param player The player.
    -- @param boneName The bone name.
    -- @param animationName The animation name.
    -- @param boneToSyncWith The bone in which we are trying to synchronize with.
    -- @returns If the animation was applied or ignored.
    function animationStation.setPlayerBoneAnimationWithSync(player, boneName, animationName, boneToSyncWith)
        local applied = animationStation.setPlayerBoneAnimation(player, boneName, animationName)
        if not applied then
            return false
        end
        local name = player:get_player_name()
        local state = playerRepository:get(name)
        if state == nil then
            warning(("Player [" .. name) .. "] does not exist in database! Creating and aborting.")
            playerRepository:set(
                name,
                __TS__New(PlayerState)
            )
            return false
        end
        local syncBoneState = state.boneStates:get(boneToSyncWith)
        if syncBoneState == nil then
            error(("Tried to set synchronization animation for bone [" .. boneToSyncWith) .. "] in character.b3d, which does not exist.")
        end
        local syncBoneProgress = syncBoneState.progress
        local syncBoneUp = syncBoneState.up
        local boneState = state.boneStates:get(boneName)
        if boneState == nil then
            error(("Tried to set synchronization animation for bone [" .. boneName) .. "] in character.b3d, which does not exist. [flag 2]")
        end
        boneState.progress = syncBoneProgress
        boneState.up = syncBoneUp
        return true
    end
    --- Set a player's bone animation speed.
    -- 
    -- @param player The player.
    -- @param boneName The bone.
    -- @param animationSpeed The new animation speed.
    -- @returns Nothing.
    function animationStation.setPlayerBoneAnimationSpeed(player, boneName, animationSpeed)
        local name = player:get_player_name()
        local state = playerRepository:get(name)
        if state == nil then
            warning(("Player [" .. name) .. "] does not exist in database! Creating and aborting.")
            playerRepository:set(
                name,
                __TS__New(PlayerState)
            )
            return
        end
        local boneState = state.boneStates:get(boneName)
        if boneState == nil then
            error(("Tried to set bone animation for bone [" .. boneName) .. "] in character.b3d, which does not exist.")
        end
        boneState.speed = animationSpeed
    end
    minetest.register_on_joinplayer(function(player)
        local name = player:get_player_name()
        playerRepository:set(
            name,
            __TS__New(PlayerState)
        )
    end)
    minetest.register_on_leaveplayer(function(player)
        local name = player:get_player_name()
        playerRepository:delete(name)
    end)
    local function processPlayerAnimations(player, delta)
        local name = player:get_player_name()
        local playerContainer = playerRepository:get(name)
        if playerContainer == nil then
            warning("Processing player animation failed! Nonexistent. Creating then aborting.")
            playerRepository:set(
                name,
                __TS__New(PlayerState)
            )
            return
        end
        for ____, ____value in __TS__Iterator(playerContainer.boneStates) do
            local boneName = ____value[1]
            local state = ____value[2]
            repository:applyBoneAnimation(
                player,
                state.progress,
                "character.b3d",
                state.animation,
                boneName
            )
            if state.up then
                state.progress = state.progress + delta * state.speed
                if state.progress >= 1 then
                    state.progress = 1
                    state.up = false
                end
            else
                state.progress = state.progress - delta * state.speed
                if state.progress <= 0 then
                    state.progress = 0
                    state.up = true
                end
            end
        end
    end
    utility.onStep(function(delta)
        for ____, player in ipairs(minetest.get_connected_players()) do
            processPlayerAnimations(player, delta)
        end
    end)
    --- AnimatedEntity class automatically gets animation handlers
    -- strapped into any child class for ease of use.
    animationStation.AnimatedEntity = __TS__Class()
    local AnimatedEntity = animationStation.AnimatedEntity
    AnimatedEntity.name = "AnimatedEntity"
    function AnimatedEntity.prototype.____constructor(self)
        self.name = "Nothing"
        self.object = fakeRef()
    end
end
