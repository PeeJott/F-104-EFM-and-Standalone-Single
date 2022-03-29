dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")
dofile(LockOn_Options.script_path.."Radar/radar_device_init.lua")

-- set panel
layoutGeometry = {}

mount_vfs_texture_archives("Bazar/Textures/AvionicsCommon")

attributes = {
	"support_for_cws",--wird benötigt, damit man nicht die Avionic des FC3-Moduls verliert wenn man "Mainpanel.lua" definiert.
	-- "avNightVisionGoggles",
}
---------------------------------------------
MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua"}

creators = {}

creators[devices.HUD_SYSTEM] 			={"avLuaDevice", LockOn_Options.script_path.."HUD/HUD_System.lua"}
creators[devices.AVIONIC_SYSTEM]		={"avLuaDevice", LockOn_Options.script_path.."Systems/Avionic_System.lua"}

creators[devices.ELECTRIC_SYSTEM]		={"avSimpleElectricSystem",LockOn_Options.script_path.."Systems/electric_system.lua"}
creators[devices.WEAPON_SYSTEM]         ={"avSimpleWeaponSystem",LockOn_Options.script_path.."Systems/weapon_system.lua"}


indicators = {} --DAS HIER MUSS SEIN SONST CRASHT ES DCS
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."HUD/init.lua",	--init script
 nil, 
    {
		{"ILS-PLASHKA-CENTER", "ILS-PLASHKA-DOWN", "ILS-PLASHKA-RIGHT"},	-- initial geometry anchor , triple of connector names. Mal zunächst nur 3 statt 4 ILS-PLASHKE-UP mal ausgelassen
		{sx_l =  0,  -- center position correction in meters (+forward , -backward)
		 sy_l =  0,  -- center position correction in meters (+up , -down)
		 sz_l =  0,  -- center position correction in meters (-left , +right)
		 sh   =  0,  -- half height correction 
		 sw   =  0,  -- half width correction 
		 rz_l =  0,  -- rotation corrections  
		 rx_l =  0,
		 ry_l =  0}
	}	
}

indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."Radar/Indicator/init.lua",	--init script
 nil, 
    {
		{"RADAR-PLASHKA-CENTER", "RADAR-PLASHKA-DOWN", "RADAR-PLASHKA-RIGHT"},	-- initial geometry anchor , triple of connector names. Mal zunächst nur 3 statt 4 ILS-PLASHKE-UP mal ausgelassen
		{sx_l =  0,  -- center position correction in meters (+forward , -backward)
		 sy_l =  0,  -- center position correction in meters (+up , -down)
		 sz_l =  0,  -- center position correction in meters (-left , +right)
		 sh   =  0,  -- half height correction 
		 sw   =  0,  -- half width correction 
		 rz_l =  0,  -- rotation corrections  
		 rx_l =  0,
		 ry_l =  0}
	}	
}

---------------------------------------------
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")
---------------------------------------------
