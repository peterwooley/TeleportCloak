
-- TeleportCloak by Jordon

local TeleportCloak = CreateFrame("Frame")
TeleportCloak:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
TeleportCloak.CloakButton = CreateFrame("Button", "TeleportCloak", UIParent, "SecureActionButtonTemplate")
TeleportCloak.CloakButton:SetAttribute("type", "macro");
TeleportCloak.RingButton = CreateFrame("Button", "TeleportRing", UIParent, "SecureActionButtonTemplate")
TeleportCloak.RingButton:SetAttribute("type", "macro");
TeleportCloak.TrinketButton = CreateFrame("Button", "TeleportTrinket", UIParent, "SecureActionButtonTemplate")
TeleportCloak.TrinketButton:SetAttribute("type", "macro");


local TeleportCloaks = {
	65274, -- Cloak of Coordination (Horde)
	65360, -- Cloak of Coordination (Alliance)
	63206, -- Wrap of Unity (Alliance)
	63207, -- Wrap of Unity (Horde)
	63352, -- Shroud of Cooperation (Alliance)
	63353, -- Shroud of Cooperation (Horde)
}

local TeleportTrinkets = {
	103678, -- Time-Lost Artifact
}

local TeleportRings = {
	44935, -- Ring of the Kirin Tor
}

local function IsTeleportCloak(item)
	for i=1, #TeleportCloaks do
		if TeleportCloaks[i] == item then return true end
	end
	return false
end

local function IsTeleportTrinket(item)
	for i=1, #TeleportTrinkets do
		if TeleportTrinkets[i] == item then return true end
	end
	return false
end

local function IsTeleportRing(item)
	for i=1, #TeleportRings do
		if TeleportRings[i] == item then return true end
	end
	return false
end

function TeleportCloak:SaveItems()
	local item
	item = GetInventoryItemID("player", INVSLOT_BACK)
	if item and not IsTeleportCloak(item) then
		self.INVSLOT_BACK = item
	end

	item = GetInventoryItemID("player", INVSLOT_FINGER1)
	if item and not IsTeleportRing(item) then
		self.INVSLOT_FINGER1 = item
	end

	item = GetInventoryItemID("player", INVSLOT_FINGER2)
	if item and not IsTeleportRing(item) then
		self.INVSLOT_FINGER2 = item
	end	

	item = GetInventoryItemID("player", INVSLOT_TRINKET1)
	if item and not IsTeleportTrinket(item) then
		self.INVSLOT_TRINKET1 = item
	end	

	item = GetInventoryItemID("player", INVSLOT_TRINKET2)
	if item and not IsTeleportTrinket(item) then
		self.INVSLOT_TRINKET2 = item
	end	
end
TeleportCloak:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
TeleportCloak.PLAYER_EQUIPMENT_CHANGED = TeleportCloak.SaveItems
TeleportCloak:RegisterEvent("PLAYER_ENTERING_WORLD")
TeleportCloak.PLAYER_ENTERING_WORLD = TeleportCloak.SaveItems

function TeleportCloak:RestoreItems()
	local item
	item = GetInventoryItemID("player", INVSLOT_BACK)
	if item and IsTeleportCloak(item) then
		if self.INVSLOT_BACK and not InCombatLockdown() then
			EquipItemByName(self.INVSLOT_BACK)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportCloak|r: |cffff0000WARNING|r: " .. GetItemInfo(item))
		end
	end

	item = GetInventoryItemID("player", INVSLOT_FINGER1)
	if item and IsTeleportRing(item) then
		if self.INVSLOT_FINGER1 and not InCombatLockdown() then
			EquipItemByName(self.INVSLOT_FINGER1)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportRing|r: |cffff0000WARNING|r: " .. GetItemInfo(item))
		end
	end

	item = GetInventoryItemID("player", INVSLOT_FINGER2)
	if item and IsTeleportRing(item) then
		if self.INVSLOT_FINGER2 and not InCombatLockdown() then
			EquipItemByName(self.INVSLOT_FINGER2)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportRing|r: |cffff0000WARNING|r: " .. GetItemInfo(item))
		end
	end

	item = GetInventoryItemID("player", INVSLOT_TRINKET1)
	if item and IsTeleportTrinket(item) then
		if self.INVSLOT_TRINKET1 and not InCombatLockdown() then
			EquipItemByName(self.INVSLOT_TRINKET1)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportTrinket|r: |cffff0000WARNING|r: " .. GetItemInfo(item))
		end
	end

	item = GetInventoryItemID("player", INVSLOT_TRINKET2)
	if item and IsTeleportTrinket(item) then
		if self.INVSLOT_TRINKET2 and not InCombatLockdown() then
			EquipItemByName(self.INVSLOT_TRINKET2)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportTrinket|r: |cffff0000WARNING|r: " .. GetItemInfo(item))
		end
	end
end
TeleportCloak:RegisterEvent("ZONE_CHANGED")
TeleportCloak.ZONE_CHANGED = TeleportCloak.RestoreItems
TeleportCloak:RegisterEvent("ZONE_CHANGED_INDOORS")
TeleportCloak.ZONE_CHANGED_INDOORS = TeleportCloak.RestoreItems
TeleportCloak:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TeleportCloak.ZONE_CHANGED_NEW_AREA = TeleportCloak.RestoreItems

function TeleportCloak:UpdateCloakButton()
	for i=1, #TeleportCloaks do
		local startTime, _, enable = GetItemCooldown(TeleportCloaks[i])
		if startTime == 0 and enable == 1 then
			self.CloakButton:SetAttribute("macrotext", "/equip item:" .. TeleportCloaks[i] .. "\n/use 15")
			return
		end
	end
	self.CloakButton:SetAttribute("macrotext", "")
end

function TeleportCloak:UpdateRingButton()
	for i=1, #TeleportRings do
		local startTime, _, enable = GetItemCooldown(TeleportRings[i])
		if startTime == 0 and enable == 1 then
			self.RingButton:SetAttribute("macrotext", "/equipslot 11 item:" .. TeleportRings[i] .. "\n/use 11")
			return
		end
	end
	self.RingButton:SetAttribute("macrotext", "")
end

function TeleportCloak:UpdateTrinketButton()
	for i=1, #TeleportTrinkets do
		local startTime, _, enable = GetItemCooldown(TeleportTrinkets[i])
		if startTime == 0 and enable == 1 then
			self.TrinketButton:SetAttribute("macrotext", "/equipslot 13 item:" .. TeleportTrinkets[i] .. "\n/use 13")
			return
		end
	end
	self.TrinketButton:SetAttribute("macrotext", "")
end

TeleportCloak:RegisterEvent("BAG_UPDATE")
function TeleportCloak:BAG_UPDATE()
	if InCombatLockdown() then return end
	self:UpdateCloakButton()
	self:UpdateRingButton()
	self:UpdateTrinketButton()
end
