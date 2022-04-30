local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID----------
devices = {}
devices["ELECTRIC_SYSTEM"]      = counter()
devices["ELECTRIC_SYSTEM_EMERGENCY_BUS"]      = counter()
devices["ELECTRIC_SYSTEM_BATTERY_BUS"]      = counter()

devices["RADIO"]          = counter()
devices["RADIO_ARC_522"]          = counter()
devices["RADIO_TR_3"]          = counter()
devices["INTERCOM_AIC_18"]			=counter()

devices["HUD_SYSTEM"]			= counter()
devices["AVIONIC_SYSTEM"]		= counter()

devices["WEAPON_SYSTEM"]        = counter()
devices["WEAPON_PANEL"]			= counter()

devices["CANOPY"]			= counter()

devices["RADAR"]			= counter()
devices["RADAR_SCOPE"]			= counter()

