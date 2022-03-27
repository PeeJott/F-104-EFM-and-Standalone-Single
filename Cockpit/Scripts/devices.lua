local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID----------
devices = {}
devices["HUD_SYSTEM"]			= counter() --Nummer 1
devices["AVIONIC_SYSTEM"]		= counter() --Nummer 2
devices["ELECTRIC_SYSTEM"]      = counter() --Nummer 3
devices["WEAPON_SYSTEM"]        = counter() --Nummer 4

