local DEBUG = DebugTool

DEBUG:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
	cmd = string.lower(cmd)
	params = string.lower(params)
	if (string.match(cmd,"moddebug")) then
		if (string.match(cmd, "_spawnitems")) or params == "spawnitems" then
			DebugTool.config.spawnModItems = not DebugTool.config.spawnModItems
			if DebugTool.config.spawnModItems then
				Isaac.ConsoleOutput("Mod item spawning enabled")
			else
				Isaac.ConsoleOutput("Mod item spawning disabled")
			end
		elseif (string.match(cmd, "_spawntrinkets")) or params == "spawntrinkets" then
			DebugTool.config.spawnModTrinkets = not DebugTool.configdata.spawnModTrinkets
			if DebugTool.config.spawnModTrinkets then
				Isaac.ConsoleOutput("Mod trinket spawning enabled")
			else
				Isaac.ConsoleOutput("Mod trinket spawning disabled")
			end
		elseif (string.match(cmd, "_gameinfo")) or params == "gameinfo" then
			DebugTool.config.debugGameValues = not DebugTool.config.debugGameValues
			if DebugTool.config.debugGameValues then
				Isaac.ConsoleOutput("Game info debugging enabled")
			else
				Isaac.ConsoleOutput("Game info debugging disabled")
			end
		elseif (string.match(cmd, "_sfx")) or params == "sfx" then
			DebugTool.config.debugSfxs = not DebugTool.config.debugSfxs
			if DebugTool.config.debugSfxs then
				Isaac.ConsoleOutput("Sfx debugging enabled")
			else
				Isaac.ConsoleOutput("Sfx debugging disabled")
			end
		elseif (string.match(cmd, "_enemies")) or params == "enemies" then
			DebugTool.config.debugEnemies = not DebugTool.config.debugEnemies
			if DebugTool.config.debugEnemies then
				Isaac.ConsoleOutput("Enemy debugging enabled")
			else
				Isaac.ConsoleOutput("Enemy debugging disabled")
			end
		elseif (string.match(cmd, "_bosses")) or params == "bosses" then
			DebugTool.config.debugBoss = not DebugTool.config.debugBoss
			if DebugTool.config.debugBoss then
				Isaac.ConsoleOutput("Boss debugging enabled")
			else
				Isaac.ConsoleOutput("Boss debugging disabled")
			end
		elseif (string.match(cmd, "_pickups")) or params == "pickups" then
			DebugTool.config.debugPickups = not DebugTool.config.debugPickups
			if DebugTool.config.debugPickups then
				Isaac.ConsoleOutput("Pickup debugging enabled")
			else
				Isaac.ConsoleOutput("Pickup debugging disabled")
			end
		elseif (string.match(cmd, "_items")) or params == "items" then
			DebugTool.config.debugCollectibles = not DebugTool.config.debugCollectibles
			if DebugTool.config.debugCollectibles then
				DebugTool.config.debugPickups = true
				Isaac.ConsoleOutput("Item debugging enabled")
			else
				Isaac.ConsoleOutput("Item debugging disabled")
			end
		elseif (string.match(cmd, "_effects")) or params == "effects" then
			DebugTool.config.debugEffects = not DebugTool.config.debugEffects
			if DebugTool.config.debugEffects then
				Isaac.ConsoleOutput("Effect debugging enabled")
			else
				Isaac.ConsoleOutput("Effect debugging disabled")
			end
		elseif (string.match(cmd, "_all")) or params == "all" then
			DebugTool.config.tryDebugAll = not DebugTool.config.tryDebugAll
			if DebugTool.config.tryDebugAll then
				Isaac.ConsoleOutput("All entities debugging enabled")
			else
				Isaac.ConsoleOutput("All entities debugging disabled")
			end
		elseif (string.match(cmd, "_ivalues")) or params == "ivalues" then
			DebugTool.config.testIVars = not DebugTool.config.testIVars
			if DebugTool.config.testIVars then
				Isaac.ConsoleOutput("IV debugging enabled")
			else
				Isaac.ConsoleOutput("IV debugging disabled")
			end
		elseif (string.match(cmd, "_vectors")) or params == "vectors" then
			DebugTool.config.testVectors = not DebugTool.config.testVectors
			if DebugTool.config.testVectors then
				Isaac.ConsoleOutput("Vector data debugging enabled")
			else
				Isaac.ConsoleOutput("Vector data debugging disabled")
			end
		elseif (string.match(cmd, "_toggle")) or params == "toggle" then
			DebugTool.config.toggle = not DebugTool.config.toggle
			if DebugTool.config.toggle then
				Isaac.ConsoleOutput("Debug display enabled")
			else
				Isaac.ConsoleOutput("Debug display disabled")
			end
		else
			Isaac.ConsoleOutput("spawnitems: Toggles modded items spawning\n")
			Isaac.ConsoleOutput("spawntrinkets: Toggles modded trinket spawning\n")
			Isaac.ConsoleOutput("gameinfo: Toggles game info debugging\n")
			Isaac.ConsoleOutput("sfx: Toggles sfx debugging\n")
			Isaac.ConsoleOutput("enemies: Toggles enemy debugging\n")
			Isaac.ConsoleOutput("bosses: Toggles boss debugging\n")
			Isaac.ConsoleOutput("pickups: Toggles pickup debugging\n")
			Isaac.ConsoleOutput("items: Toggles item debugging\n")
			Isaac.ConsoleOutput("effects: Toggles effect debugging\n")
			Isaac.ConsoleOutput("all: Toggles all entities debugging\n")
			Isaac.ConsoleOutput("ivalues: Toggles IV debugging\n")
			Isaac.ConsoleOutput("vectors: Toggles entity vector debugging\n")
			Isaac.ConsoleOutput("toggle: Toggles debug display\n")
		end
		DEBUG.Save()
	end
end)
