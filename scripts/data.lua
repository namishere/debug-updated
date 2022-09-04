local json = require("json")

DebugTool.config = {
	default = {}
}
local data = {
	config = {}
}

DebugTool.config.default = {
	spawnModItems = false,
	spawnModTrinkets = false,
	debugGameValues = true,
	debugSfxs = false,
	debugEnemies = true,
	debugBoss = true,
	debugPickups = false,
	debugCollectibles = false,
	debugEffects = false,
	tryDebugAll = false,
	debugLevelState = false,
	debugGameState = false,
	testIVars = true,
	testVec = false,
	toggle = true
}

function DebugTool.Save()
	DebugTool.save.config.spawnModItems = DebugTool.config.spawnModItems
	DebugTool.save.config.spawnModTrinkets = DebugTool.config.spawnModTrinkets
	DebugTool.save.config.debugGameValues = DebugTool.config.debugGameValues
	DebugTool.save.config.debugSfxs = DebugTool.config.debugSfxs
	DebugTool.save.config.debugEnemies = DebugTool.config.debugEnemies
	DebugTool.save.config.debugBoss = DebugTool.config.debugBoss
	DebugTool.save.config.debugPickups = DebugTool.config.debugPickups
	DebugTool.save.config.debugCollectibles = DebugTool.config.debugCollectibles
	DebugTool.save.config.debugEffects = DebugTool.config.debugEffects
	DebugTool.save.config.tryDebugAll = DebugTool.config.tryDebugAll
	DebugTool.save.config.debugLevelState = DebugTool.config.debugLevelState
	DebugTool.save.config.debugGameState = DebugTool.config.debugGameState
	DebugTool.save.config.testIVars = DebugTool.config.testIVars
	DebugTool.save.config.testVec = DebugTool.config.testVec
	DebugTool.save.config.toggle = DebugTool.config.toggle
	DebugTool:SaveData(json.encode(DebugTool.save))
end

function Validate(var, default)
	if var ~= nil then return var end
	return default
end

function DebugTool.LoadGame()
	if DebugTool:HasData() then
		data = json.decode(DebugTool:LoadData())
	else
		data = {
			config = {}
		}
	end
	DebugTool.config.spawnModItems = Validate(data.config.spawnModItems, DebugTool.config.default.spawnModItems)
	DebugTool.config.spawnModTrinkets = Validate(data.config.spawnModTrinkets, DebugTool.config.default.spawnModTrinkets)
	DebugTool.config.debugGameValues = Validate(data.config.debugGameValues, DebugTool.config.default.debugGameValues)
	DebugTool.config.debugSfxs = Validate(data.config.debugSfxs, DebugTool.config.default.debugSfxs)
	DebugTool.config.debugEnemies = Validate(data.config.debugEnemies, DebugTool.config.default.debugEnemies)
	DebugTool.config.debugBoss = Validate(data.config.debugBoss, DebugTool.config.default.debugBoss)
	DebugTool.config.debugPickups = Validate(data.config.debugPickups, DebugTool.config.default.debugPickups)
	DebugTool.config.debugCollectibles = Validate(data.config.debugCollectibles, DebugTool.config.default.debugCollectibles)
	DebugTool.config.debugEffects = Validate(data.config.debugEffects, DebugTool.config.default.debugEffects)
	DebugTool.config.tryDebugAll = Validate(data.config.tryDebugAll, DebugTool.config.default.tryDebugAll)
	DebugTool.config.debugLevelState = Validate(data.config.debugLevelState, DebugTool.config.default.debugLevelState)
	DebugTool.config.debugGameState = Validate(data.config.debugGameState, DebugTool.config.default.debugGameState)
	DebugTool.config.testIVars = Validate(data.config.testIVars, DebugTool.config.default.testIVars)
	DebugTool.config.testVec = Validate(data.config.testVectors, DebugTool.config.default.testVectors)
	DebugTool.config.toggle = Validate(data.config.toggle, DebugTool.config.default.toggle)
	DebugTool.Save()
end

DebugTool:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, DebugTool.Save)
DebugTool:AddCallback(ModCallbacks.MC_POST_GAME_END, DebugTool.Save)

DebugTool:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, DebugTool.LoadGame)
