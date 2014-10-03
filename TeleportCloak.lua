
-- TeleportCloak by Jordon

local TeleportCloak = CreateFrame("Frame")
TeleportCloak:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local List = {
	Cloak = {
		65274, -- Cloak of Coordination (Horde)
		65360, -- Cloak of Coordination (Alliance)
		63206, -- Wrap of Unity (Alliance)
		63207, -- Wrap of Unity (Horde)
		63352, -- Shroud of Cooperation (Alliance)
		63353, -- Shroud of Cooperation (Horde)
	},
	Trinket = {
		103678, -- Time-Lost Artifact
		17691, -- Stormpike Insignia Rank 1
		17900, -- Stormpike Insignia Rank 2
		17901, -- Stormpike Insignia Rank 3
		17902, -- Stormpike Insignia Rank 4
		17903, -- Stormpike Insignia Rank 5
		17904, -- Stormpike Insignia Rank 6
		17690, -- Frostwolf Insignia Rank 1
		17905, -- Frostwolf Insignia Rank 2
		17906, -- Frostwolf Insignia Rank 3
		17907, -- Frostwolf Insignia Rank 4
		17908, -- Frostwolf Insignia Rank 5
		17909, -- Frostwolf Insignia Rank 6
	},
	Ring = {
		40585, -- Signet of the Kirin Tor
		40586, -- Band of the Kirin Tor
		44934, -- Loop of the Kirin Tor
		44935, -- Ring of the Kirin Tor
		45688, -- Inscribed Band of the Kirin Tor
		45689, -- Inscribed Loop of the Kirin Tor
		45690, -- Inscribed Ring of the Kirin Tor
		45691, -- Inscribed Signet of the Kirin Tor
		48954, -- Etched Band of the Kirin Tor
		48955, -- Etched Loop of the Kirin Tor
		48956, -- Etched Ring of the Kirin Tor
		48957, -- Etched Signet of the Kirin Tor
		51557, -- Runed Signet of the Kirin Tor
		51558, -- Runed Loop of the Kirin Tor
		51559, -- Runed Ring of the Kirin Tor
		51560, -- Runed Band of the Kirin Tor
		95050, -- Brassiest Knuckle (Horde)
		95051, -- Brassiest Knuckle (Alliance)
	},
	Feet = {
		50287, -- Boots of the Bay
		28585, -- Ruby Slippers
	},
	Neck = {
		32757, -- Blessed Medallion of Karabor
	},
	Tabard = {
		46874, -- Argent Crusader's Tabard
		63378, -- Hellscream's Reach Tabard
		63379, -- Baradin's Wardens Tabard
	}
}

local InventoryType = {
	INVTYPE_NECK = INVSLOT_NECK,
	INVTYPE_FEET = INVSLOT_FEET,
	INVTYPE_FINGER = INVSLOT_FINGER1,
	INVTYPE_TRINKET = INVSLOT_TRINKET1,
	INVTYPE_CLOAK = INVSLOT_BACK,
	INVTYPE_TABARD = INVSLOT_TABARD,
}

local function IsTeleportItem(item)
	for slot,_ in pairs(List) do
		for j=1, #List[slot] do
			if List[slot][j] == item then return true end
		end
	end
	return false
end

local TeleportCloakList = {}

TeleportCloakWarnings = TeleportCloakWarnings or true

local CloakButton = CreateFrame("Button", "TeleportCloak", UIParent, "SecureActionButtonTemplate")
CloakButton:SetAttribute("type", "macro");

CloakButton:SetScript("PreClick", function(self)
	if InCombatLockdown() then return end

	local list
	if #TeleportCloakList == 0 then
		list = List.Cloak
	else
		list = TeleportCloakList
	end

	TeleportCloakList = {}

	for i=1, #list do
		local startTime, duration, enable = GetItemCooldown(list[i])
		if (startTime == 0 or duration - (GetTime() - startTime) <= 30) and enable == 1 then
			local slot = select(9, GetItemInfo(list[i]))
			self:SetAttribute("macrotext", string.format("/equipslot %i item:%i\n/use %i", InventoryType[slot], list[i], InventoryType[slot]))
			return
		end
	end
	self:SetAttribute("macrotext", "")
end)

local function Print(msg, subTitle, skipTitle)
	local title = "|cff33ff99TeleportCloak|r"
	if subTitle then
		if not skipTitle then DEFAULT_CHAT_FRAME:AddMessage(title) end
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99" .. subTitle .. "|r: " .. msg)
	else
		DEFAULT_CHAT_FRAME:AddMessage(title .. ": " .. msg)
	end
end

local Slots = {
	INVSLOT_NECK,
	INVSLOT_FEET,
	INVSLOT_FINGER1,
	INVSLOT_FINGER2,
	INVSLOT_TRINKET1,
	INVSLOT_TRINKET2,
	INVSLOT_BACK,
	INVSLOT_TABARD,
}

SLASH_TeleportCloak1 = "/tc"
SlashCmdList.TeleportCloak = function(msg)
	local cmd = string.match(msg or "", "(%a+)") or ""
	local arg = string.match(msg or "", "%a+ (.+)")

	cmd = string.lower(cmd)

	if cmd == "add" then
		if arg then
			local _, link, _,_,_,_,_,_, slot = GetItemInfo(arg)
			if link then
				-- Check inventory slots
				for i=1, #Slots do
					if GetInventoryItemLink("player", Slots[i]) == link then
						local id = GetInventoryItemID("player", Slots[i])
						if id and IsTeleportItem(id) then
							table.insert(TeleportCloakList, id)
							return
						end
					end
				end

				-- Find the item in our bags
				for i = 1, NUM_BAG_SLOTS do
					for j = 1, GetContainerNumSlots(i) do
						local id = GetContainerItemID(i, j)
						if id and IsTeleportItem(id) and (GetContainerItemLink(i, j) == link or GetInventoryItemLink("player", InventoryType[slot]) == link) then
							table.insert(TeleportCloakList, id)
							return
						end
					end
				end
			end
		else
			Print("/tc add <itemName>", "Usage")
		end

	elseif cmd == "warnings" then
		TeleportCloakWarnings = not TeleportCloakWarnings
		local status = TeleportCloakWarnings and "Enabled" or "Disabled"
		Print(status, "Warnings")

	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportCloak Usage|r")
		Print('/tc add <itemName>', "   Add Item", true)
		Print('/tc warnings', "   Toggle Warnings", true)

	end

end

local Saved = {}

local function SaveItems()
	for i=1, #Slots do
		local item = GetInventoryItemID("player", Slots[i])
		if item and not IsTeleportItem(item) then
			Saved[Slots[i]] = item
		end
	end
end
TeleportCloak:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
TeleportCloak.PLAYER_EQUIPMENT_CHANGED = SaveItems
TeleportCloak:RegisterEvent("PLAYER_ENTERING_WORLD")
TeleportCloak.PLAYER_ENTERING_WORLD = SaveItems

local function RestoreItems()
	for i=1, #Slots do
		local item = GetInventoryItemID("player", Slots[i])
		if item and IsTeleportItem(item) then
			if Saved[Slots[i]] and not InCombatLockdown() then
				EquipItemByName(Saved[Slots[i]])
			elseif TeleportCloakWarnings then
				if Slots[i] ~= INVSLOT_TABARD then
					Print("|cffff0000Warning|r: " .. GetItemInfo(item))
				end
			end
		end
	end
end

TeleportCloak:RegisterEvent("ZONE_CHANGED")
TeleportCloak.ZONE_CHANGED = RestoreItems
TeleportCloak:RegisterEvent("ZONE_CHANGED_INDOORS")
TeleportCloak.ZONE_CHANGED_INDOORS = RestoreItems
TeleportCloak:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TeleportCloak.ZONE_CHANGED_NEW_AREA = RestoreItems
