
-- TeleportCloak by Jordon

local TeleportCloak = CreateFrame("Frame")
TeleportCloak:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
TeleportCloak.button = CreateFrame("Button", "TeleportCloak", UIParent, "SecureActionButtonTemplate")
TeleportCloak.button:SetAttribute("type", "macro");

local TeleportCloaks = {
	65274, -- Cloak of Coordination (Horde)
	65360, -- Cloak of Coordination (Alliance)
	63206, -- Wrap of Unity (Alliance)
	63207, -- Wrap of Unity (Horde)
	63352, -- Shroud of Cooperation (Alliance)
	63353, -- Shroud of Cooperation (Horde)
}

local function IsTeleportCloak(cloak)
	for i=1, #TeleportCloaks do
		if TeleportCloaks[i] == cloak then return true end
	end
	return false
end

function TeleportCloak:SaveCloak()
	local cloak = GetInventoryItemID("player", INVSLOT_BACK)
	if not cloak then return end
	if not IsTeleportCloak(cloak) then
		self.cloak = cloak
	end
end
TeleportCloak:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
TeleportCloak.PLAYER_EQUIPMENT_CHANGED = TeleportCloak.SaveCloak
TeleportCloak:RegisterEvent("PLAYER_ENTERING_WORLD")
TeleportCloak.PLAYER_ENTERING_WORLD = TeleportCloak.SaveCloak

function TeleportCloak:RestoreCloak()
	local cloak = GetInventoryItemID("player", INVSLOT_BACK)
	if not cloak then return end
	if IsTeleportCloak(cloak) then
		if self.cloak and not InCombatLockdown() then
			--DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportCloak|r: " .. self.cloak)
			EquipItemByName(self.cloak)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99TeleportCloak|r: |cffff0000WARNING|r: " .. GetItemInfo(cloak))
		end
	end
end
TeleportCloak:RegisterEvent("ZONE_CHANGED")
TeleportCloak.ZONE_CHANGED = TeleportCloak.RestoreCloak
TeleportCloak:RegisterEvent("ZONE_CHANGED_INDOORS")
TeleportCloak.ZONE_CHANGED_INDOORS = TeleportCloak.RestoreCloak
TeleportCloak:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TeleportCloak.ZONE_CHANGED_NEW_AREA = TeleportCloak.RestoreCloak

TeleportCloak:RegisterEvent("BAG_UPDATE")
function TeleportCloak:BAG_UPDATE()
	if InCombatLockdown() then return end
	for i=1, #TeleportCloaks do
		local startTime, _, enable = GetItemCooldown(TeleportCloaks[i])
		if startTime == 0 and enable == 1 then
			TeleportCloak.button:SetAttribute("macrotext", "/equip item:" .. TeleportCloaks[i] .. "\n/use 15");
			return
		end
	end
	TeleportCloak.button:SetAttribute("macrotext", "")
end
