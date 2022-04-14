dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")


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
creators[devices.ELECTRIC_SYSTEM]		={"avLuaDevice",LockOn_Options.script_path.."ElectricSystems/electric_system.lua"}
creators[devices.ELECTRIC_SYSTEM_EMERGENCY_BUS]		={"avSimpleElectricSystem",LockOn_Options.script_path.."ElectricSystems/electric_system_emergency_dc_bus.lua"}
creators[devices.ELECTRIC_SYSTEM_BATTERY_BUS]		={"avSimpleElectricSystem",LockOn_Options.script_path.."ElectricSystems/electric_system_battery_bus.lua"}

creators[devices.RADIO]           		= {"avLuaDevice",LockOn_Options.script_path.."RadioSystems/radio.lua"}
creators[devices.RADIO_ARC_522]     		= {"avUHF_ARC_164",LockOn_Options.script_path.."RadioSystems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM_EMERGENCY_BUS}}
creators[devices.RADIO_TR_3]       		= {"avUHF_ARC_164",LockOn_Options.script_path.."RadioSystems/uhf_radio.lua", {devices.ELECTRIC_SYSTEM_BATTERY_BUS}}
creators[devices.INTERCOM_AIC_18]        		= {"avIntercom",LockOn_Options.script_path.."RadioSystems/intercom.lua", {devices.VUHF1_RADIO, devices.ELECTRIC_SYSTEM_EMERGENCY_BUS}}

creators[devices.HUD_SYSTEM] 			={"avLuaDevice", LockOn_Options.script_path.."HUD/HUD_System.lua"}
creators[devices.AVIONIC_SYSTEM]		={"avLuaDevice", LockOn_Options.script_path.."Systems/Avionic_System.lua"}

creators[devices.WEAPON_SYSTEM]         ={"avSimpleWeaponSystem",LockOn_Options.script_path.."Systems/weapon_system.lua"}
creators[devices.WEAPON_PANEL]			={"avLuaDevice", LockOn_Options.script_path.."Systems/Weapon_Panel.lua"}

creators[devices.CANOPY]          = {"avLuaDevice"           ,LockOn_Options.script_path.."Systems/canopy.lua"}

indicators = {} --DAS HIER MUSS SEIN SONST CRASHT ES DCS

dofile(LockOn_Options.script_path.."avRadar/radarexample_device_init.lua")
dofile(LockOn_Options.script_path.."avRWR/rwrexample_device_init.lua")

-- remove this line to disable a2g radar
dofile(LockOn_Options.script_path.."avTerrain/terrainexample_device_init.lua")

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


---------------------------------------------
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")
---------------------------------------------
