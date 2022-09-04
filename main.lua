local debug = RegisterMod("Debug Tool", 1)
DebugTool = debug

--TODO:
--	Entity whitelist/blacklist
--	Support for mods to render arbitrary data for debugging
--	MCM support
--	DebugLevelState
--	DebugGameState

DebugTool.enums = {}
DebugTool.data = {
	sfxThisRoom = {}
}
DebugTool.save = {
	config = {}
}

local game = Game()
local sfx = SFXManager()

local cursor = Sprite()

cursor:Load("gfx/ui/cursor.anm2", true)
cursor:Play("Idle")
--cursor.Scale = Vector(0.5, 0.5)

local f = Font() -- init font object
f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object

include("scripts.the-everything-function-rev1") --provides "dump" function
include("scripts.enums")
include("scripts.data")
include("scripts.command")
--include("scripts.mcm")


if Isaac.GetFrameCount() <= 1 then
	DebugTool.data = {
		sfxThisRoom = {}
	}
end
DebugTool.LoadGame()

-- Helpers --------------------------------------------------------
function DebugTool.getStringWidth(value)
	return (string.len(tostring(value))) - .5
end

function DebugTool.UpdateSfxsPlaying()
	for i = 1, SoundEffect.NUM_SOUND_EFFECTS do
		if sfx:IsPlaying(i) then
			local shouldAddIt = true
			for j = 1, #DebugTool.data.sfxThisRoom do
				if DebugTool.data.sfxThisRoom[j] == i then
					shouldAddIt = false
					break
				end
			end
			if shouldAddIt then
				DebugTool.data.sfxThisRoom[#DebugTool.data.sfxThisRoom + 1] = i
			end
		end
	end
end

function DebugTool.StringList(number, stringTable) -- it's easier to iterate on bit values this way than doing bitwise comparisons
	local bitTab = DebugTool.ToBitTab(number)
	local returnString = ""

	for i = 1, #stringTable do
		if bitTab[i]==1 then
			if (returnString == "") then
				returnString = returnString .. stringTable[i]
			else
				returnString = returnString .. ", " .. stringTable[i]
			end
		end
	end
	if (returnString == "") then
		return "none"
	end
	return returnString
end

function DebugTool.ToBitTab(num)
	local t={}
	local rest = 0
	while num>0 do
		rest=math.fmod(num,2)
		t[#t+1]=rest
		num=(num-rest)/2
	end
	return t
end

local function GetDimension()
	local level = game:GetLevel()
	local curDec = level:GetCurrentRoomDesc()
	local curIndex = level:GetCurrentRoomIndex()
	if GetPtrHash(curDec) == GetPtrHash(level:GetRoomByIdx(curIndex, 0)) then
		return 0
	elseif GetPtrHash(curDec) == GetPtrHash(level:GetRoomByIdx(curIndex, 2)) then
		return 2
	else
		return 1
	end
end

local widthDefault = 30 -- i'll clean this later.
local function DrawText(text, x, y, sx, sy, r, g, b, a, w, c)
	f:DrawStringScaled(text, x-w/2, y, sx, sy, KColor(r, g, b, a), w, c)
end

-- Processors --------------------------------------------------------
local function DebugSFX()
	if DebugTool.config.debugSfxs then
		DebugTool.UpdateSfxsPlaying()
		if DebugTool.config.toggle then
			local buffer = ""
			local x = 400 - 23*Options.HUDOffset
			DrawText("SFXs this room:", x, 5, 0.5, 0.5, 255, 255, 255, 255, widthDefault, false)
			for i=1, #DebugTool.data.sfxThisRoom do
				buffer = DebugTool.enums.sfxList[DebugTool.data.sfxThisRoom[i]]
				if type(buffer) == "nil" then buffer = tostring(i) end
				DrawText(buffer, x, 5 + 7*i, 0.5, 0.5, 255, 255, 255, 255, widthDefault, false)
			end
		end
	end
end

local function DebugGameValues(player)
	if DebugTool.config.debugGameValues then
		local x = 35 + 20*Options.HUDOffset
		local y = 30 + 11.8*Options.HUDOffset
		DrawText("Character: " .. player:GetName(), x, y, 0.5, 0.5, 255, 255, 255, 255, 0, false)
		local source = player:GetLastDamageSource()
		if source ~= nil then
			DrawText("Last damage source: " .. source.Type .. "." .. source.Variant, x, y+7, 0.5, 0.5, 255, 255, 255, 255, 0, false)
		end
		local text = DebugTool.StringList(player:GetLastDamageFlags(), DebugTool.enums.damageFlagList)
		DrawText("Last damage flags: " .. text, x, y+14, 0.5, 0.5, 255, 255, 255, 255, 0, false)

		DrawText("Current room index: " .. game:GetLevel():GetCurrentRoomIndex() .. ", ".. GetDimension(), x, y+28, 0.5, 0.5, 255, 255, 255, 255, 0, false)
		text = DebugTool.StringList(game:GetLevel():GetCurses(), DebugTool.enums.curseList)
		DrawText("Curses: " .. text, x, y+35, 0.5, 0.5, 255, 255, 255, 255, 0, false)
	end
end

--[[
local function DebugLevelState()
	if debugLevelState then
	end
end

local function DebugGameState()
	if debugGameState then
	end
end
]]--

local function DebugAnything(entity, pos)
	if entity.Type ~= EntityType.ENTITY_TEXT then -- if it's neither a text nor an effect
		local text = "" .. entity.Type .. "." .. entity.Variant .. "." .. entity.SubType
		DrawText(text, pos.X, pos.Y-47, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
		text = "spawner: " .. entity.SpawnerType .. "." .. entity.SpawnerVariant
		if (text ~= "spawner: 0.0") then
			DrawText(text, pos.X, pos.Y-42, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
		end
	end
end

local function DebugEnemy(enemy, pos)
	local text = nil
	local buffer = nil
	local spawnertext = true
	local y = pos.Y - 57
	-- render health
	text = "" .. math.floor(enemy.HitPoints*10)/10 .. "/" .. math.floor(enemy.MaxHitPoints*10)/10
	DrawText(text, pos.X, y, 0.5, 0.5, 255, 255, 0, 255, widthDefault, true)
	y = y + 5
	-- render state
	buffer = DebugTool.enums.stateList[enemy:ToNPC().State+1]
	if type(buffer) == "nil" then buffer = tostring(enemy:ToNPC().State) end
	text = "" .. buffer
	DrawText(text, pos.X, y, 0.5, 0.5, 0, 255, 255, 255, widthDefault, true)
	y = y + 5
	-- render type.variant.subtype
	text = "" .. enemy.Type .. "." .. enemy.Variant .. "." .. enemy.SubType
	DrawText(text, pos.X, y, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
	y = y + 5
	-- render spawner
	text = "spawner: " .. enemy.SpawnerType .. "." .. enemy.SpawnerVariant
	if (text ~= "spawner: 0.0") then
		DrawText(text, pos.X, y, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
		y = y + 5
	end
	if DebugTool.config.testIVars then
		text = "I1: " .. dump(enemy.I1) .. "   I2: " .. dump(enemy.I2)
		DrawText(text, pos.X, y, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
		y = y + 5
	end
	if DebugTool.config.testVectors then
		text = "V1: " .. dump(enemy.V1)
		DrawText(text, pos.X, y, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
		if text ~= "V1: Vector(0.00, 0.00)" and text ~= "V1: Vector(0.00, -0.00)" and text ~= "V1: Vector(-0.00, 0.00)" and text ~= "V1: Vector(-0.00, -0.00)" then
			cursor.Color = Color(1, .5, 0, 1, 0, 0, 0)
			cursor:Render(enemy.V1)
		end
		y = y + 5
		text = "V2: " .. dump(enemy.V2)
		DrawText(text, pos.X, y, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
		if text ~= "V2: Vector(0.00, 0.00)" and text ~= "V2: Vector(0.00, -0.00)" and text ~= "V2: Vector(-0.00, 0.00)" and text ~= "V2: Vector(-0.00, -0.00)" then
			cursor.Color = Color(0, .5, 1, 1, 0, 0, 0)
			cursor:Render(enemy.V2)
		end
	end
end

local function DebugPickup(pickup, pos)
	-- render type.variant.subtype
	local text = "" .. pickup.Type .. "." .. pickup.Variant .. "." .. pickup.SubType
	DrawText(text, pos.X, pos.Y-27, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)

	-- render spawner
	text = "spawner: " .. pickup.SpawnerType .. "." .. pickup.SpawnerVariant
	if (text ~= "spawner: 0.0") then
		DrawText(text, pos.X, pos.Y-22, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
	end
end

local function DebugEffect(effect, pos)
	local sprite = effect:GetSprite()
	local buffer = ""
	local text = "" .. effect.Type .. "." .. effect.Variant .. "." .. effect.SubType
	DrawText(text, pos.X, pos.Y-47, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
	buffer = "" .. sprite:GetFilename()
	text = string.sub(buffer, 5, string.len(buffer)-5) 
	DrawText(text, pos.X, pos.Y-42, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
	text = "spawner: " .. effect.SpawnerType .. "." .. effect.SpawnerVariant
	if (text ~= "spawner: 0.0") then
		DrawText(text, pos.X, pos.Y-37, 0.5, 0.5, 255, 255, 255, 255, widthDefault, true)
	end
end

local function DebugEntities(entities, room)
	for i = 1, #entities do
		local pos = room:WorldToScreenPosition(entities[i].Position, false) -- get its position
		if entities[i]:ToNPC() ~= nil then
			if entities[i]:IsBoss() and DebugTool.config.debugBoss
			or DebugTool.config.debugEnemies and not entities[i]:IsBoss() then
				DebugEnemy(entities[i]:ToNPC(), pos)
			end
		elseif entities[i]:ToPickup() ~= nil then
			if entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE then
				if DebugTool.config.debugCollectibles then
					DebugPickup(entities[i]:ToPickup(), pos)
				end
			elseif DebugTool.config.debugPickups then
				DebugPickup(entities[i]:ToPickup(), pos)
			end
		elseif entities[i]:ToEffect() ~= nil then
			if DebugTool.config.debugEffects then
				DebugEffect(entities[i]:ToEffect(), pos)
			end
		elseif DebugTool.config.tryDebugAll then
			DebugAnything(entities[i], pos)
		end
	end
end

-- Callbacks --------------------------------------------------------
debug:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, fromsave)
	if not fromsave then
		if DebugTool.config.spawnModItems then
			local id = CollectibleType.NUM_COLLECTIBLES
			while Isaac.GetItemConfig():GetCollectible(id) ~= nil do
				Isaac.ExecuteCommand("spawn 5.100." .. id)
				id = id+1
			end
		end
		if DebugTool.config.spawnModTrinkets then
			local id = TrinketType.NUM_TRINKETS
			while Isaac.GetItemConfig():GetTrinket(id) ~= nil do
				Isaac.ExecuteCommand("spawn 5.350." .. id)
				id = id+1
			end
		end
	end
end)

debug:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() DebugTool.data.sfxThisRoom = {} end)

debug:AddCallback(ModCallbacks.MC_POST_RENDER, function()
--TODO move as needed once other functions are done
	local entities = Isaac.GetRoomEntities()
	local room = game:GetRoom()
	local player = Isaac.GetPlayer()

	DebugSFX()
	if DebugTool.config.toggle then
		DebugGameValues(player)
		--DebugLevelState()
		--DebugGameState()
		DebugEntities(entities, room)
	end
end)
