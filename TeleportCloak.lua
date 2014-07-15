
-- TeleportCloak by Jordon

local TeleportCloak = CreateFrame("Frame")
TeleportCloak:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local CloakButton = CreateFrame("Button", "TeleportCloak", UIParent, "SecureActionButtonTemplate")
CloakButton:SetAttribute("type", "macro");

local RingButton = CreateFrame("Button", "TeleportRing", UIParent, "SecureActionButtonTemplate")
RingButton:SetAttribute("type", "macro");

local TrinketButton = CreateFrame("Button", "TeleportTrinket", UIParent, "SecureActionButtonTemplate")
TrinketButton:SetAttribute("type", "macro");

local FeetButton = CreateFrame("Button", "TeleportFeet", UIParent, "SecureActionButtonTemplate")
FeetButton:SetAttribute("type", "macro");

local NeckButton = CreateFrame("Button", "TeleportNeck", UIParent, "SecureActionButtonTemplate")
NeckButton:SetAttribute("type", "macro");

local TabardButton = CreateFrame("Button", "TeleportTabard", UIParent, "SecureActionButtonTemplate")
TabardButton:SetAttribute("type", "macro");

local CloakList = {
	63206, -- Wrap of Unity (Alliance)
	63207, -- Wrap of Unity (Horde)
	63352, -- Shroud of Cooperation (Alliance)
	63353, -- Shroud of Cooperation (Horde)
	65274, -- Cloak of Coordination (Horde)
	65360, -- Cloak of Coordination (Alliance)
}

local TrinketList = {
	103678, -- Time-Lost Artifact
}

local RingList = {
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
}

local FeetList = {
	50287, -- Boots of the Bay
}

local NeckList = {
	32757, -- Blessed Medallion of Karabor
}

local TabardList = {
	46874, -- Argent Crusader's Tabard
}

local function IsTeleportItem(item)
	local list = {
		CloakList,
		TrinketList,
		RingList,
		FeetList,
		NeckList,
		TabardList,
	}

	for i=1, #list do
		for j=1, #list[i] do
			if list[i][j] == item then return true end
		end
	end
	
	return false
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
			else
				DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportCloak|r: |cffff0000WARNING|r: " .. GetItemInfo(item))
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

local function UpdateButton(button, list, slot)
	for i=1, #list do
		local startTime, _, enable = GetItemCooldown(list[i])
		if startTime == 0 and enable == 1 then
			button:SetAttribute("macrotext", string.format("/equipslot %s item:%s\n/use %s", slot, list[i], slot))
			return
		end
	end
	button:SetAttribute("macrotext", "")
end

TeleportCloak:RegisterEvent("BAG_UPDATE")
function TeleportCloak:BAG_UPDATE()
	if InCombatLockdown() then return end
	UpdateButton(CloakButton, CloakList, INVSLOT_BACK)
	UpdateButton(TrinketButton, TrinketList, INVSLOT_TRINKET1)
	UpdateButton(RingButton, RingList, INVSLOT_FINGER1)
	UpdateButton(FeetButton, FeetList, INVSLOT_FEET)
	UpdateButton(NeckButton, NeckList, INVSLOT_NECK)
	UpdateButton(TabardButton, TabardList, INVSLOT_TABARD)
end
