self_ID = "VSN_F104G"
declare_plugin(self_ID,
{
image     	 = "FC3.bmp",
installed 	 = true, -- if false that will be place holder , or advertising
dirName	  	 = current_mod_path,
displayName  = _("VSN_F104G"),
developerName = _("VSN"),

fileMenuName = _("VSN_F104G"),
update_id        = "VSN_F104G",
version		 = "2.7.7",
state		 = "installed",
info		 = _("Lockheed F-104 Starfighter war ein einstrahliges Kampfflugzeug der Lockheed Corporation, Burbank (USA). Ab 1956 bauten Lockheed und spaeter auch kanadische und europaeische Lizenznehmer das Modell in grosser Stueckzahl. Die F-104 gehoerte zur sogenannten Century-Reihe (F-100 bis F-110) und war als reiner Tag- und Abfangjaeger konzipiert, optimiert fuer hohe Geschwindigkeiten und Steigleistung."),

Skins	=
	{
		{
		    name	= _("VSN_F104G"),
			dir		= "Theme"
		},
	},
Missions =
	{
		{
			name		    = _("VSN_F104G"),
			dir			    = "Missions",
  		},
	},
LogBook =
	{
		{
			name		= _("VSN_F104C"),
			type		= "VSN_F104C",
		},
		{
			name		= _("VSN_F104G"),
			type		= "VSN_F104G",
		},
		{
			name		= _("VSN_F104S"),
			type		= "VSN_F104S",
		},
		{
			name		= _("VSN_F104S_AG"),
			type		= "VSN_F104S_AG",
		},
	},	
--[[		
Options =
	{
		{
			name		= _("VSN_F104G"),
			nameId		= "VSN_F104G",
			dir			= "Options",
		},
	},		
--]]		
InputProfiles =
	{
		["VSN_F104G"] = current_mod_path .. '/Input/VSN_F104G',
		["VSN_F104G_AG"] = current_mod_path .. '/Input/VSN_F104G_AG',
	},
	
binaries = {
"F104G",
},

})
----------------------------------------------------------------------------------------
mount_vfs_model_path	(current_mod_path.."/Shapes")
mount_vfs_liveries_path (current_mod_path.."/Liveries")
mount_vfs_texture_path  (current_mod_path.."/Textures/VSN_F104G")
mount_vfs_texture_path  (current_mod_path.."/Textures/VSN_F104G_cpt")
mount_vfs_texture_path  (current_mod_path.."/Textures/VSN_F104G_Skins")
mount_vfs_texture_path  (current_mod_path.."/Textures/F-104G_German_Highres_Skinpack_by_Soulfreak")
-------------------------------------------------------------------------------------
--[[local cfg_path = current_mod_path ..  "/FM/F104G/config.lua"
dofile(cfg_path)
F104G[1]             = self_ID
F104G[2]             = 'F104G'
F104G.config_path     = cfg_path
F104G.old             = 6 -- SU27-3, SU33-4, F-15-6, SU25-54

dofile(current_mod_path.."/LUA/Views_F104Pit.lua")
make_view_settings('VSN_F104C', ViewSettings, SnapViews)
make_flyable('VSN_F104C',current_mod_path..'/Cockpit/KneeboardRight/', F104G, current_mod_path..'/comm.lua')--EFM
--make_flyable('VSN_F104C',current_mod_path..'/Cockpit/Scripts/', F104G, current_mod_path..'/comm.lua')--EFM
-------------------------------------------------------------------------------------
]]

----------/////////////////////////////////////////////////////////////////////////////////////---------------
------------------ALLE VERSIONEN BIS AUF DIE "G" AUSKOMMENTIERT UM TRUE STANDALONE ZU TESTEN------------------
----------////////////////////////////////////////////////////////////////////////////////////----------------

local cfg_path = current_mod_path ..  "/FM/F104G/config.lua"
dofile(cfg_path)
F104G[1]             = self_ID
F104G[2]             = 'F104G'
F104G.config_path    = cfg_path
--F104G.old             = 6 -- SU27-3, SU33-4, F-15-6, SU25-54

dofile(current_mod_path.."/LUA/Views_F104Pit.lua")
make_view_settings('VSN_F104G', ViewSettings, SnapViews)
--make_flyable('VSN_F104G',current_mod_path..'/Cockpit/KneeboardRight/', F104G, current_mod_path..'/comm.lua')--EFM
make_flyable('VSN_F104G',current_mod_path..'/Cockpit/Scripts/', F104G, current_mod_path..'/comm.lua')--EFM mit CockpitScripts


--[[-------------------------------------------------------------------------------------
local cfg_path = current_mod_path ..  "/FM/F104G/config.lua"
dofile(cfg_path)
F104G[1]             = self_ID
F104G[2]             = 'F104G'
F104G.config_path     = cfg_path
F104G.old             = 6 -- SU27-3, SU33-4, F-15-6, SU25-54

dofile(current_mod_path.."/LUA/Views_F104Pit.lua")
make_view_settings('VSN_F104S', ViewSettings, SnapViews)
make_flyable('VSN_F104S',current_mod_path..'/Cockpit/KneeboardRight/', F104G, current_mod_path..'/comm.lua')--EFM
--make_flyable('VSN_F104S',current_mod_path..'/Cockpit/Scripts/', F104G, current_mod_path..'/comm.lua')--EFM
-------------------------------------------------------------------------------------
local cfg_path = current_mod_path ..  "/FM/F104G/config.lua"
dofile(cfg_path)
F104G[1]             = self_ID
F104G[2]             = 'F104G'
F104G.config_path     = cfg_path
F104G.old             = 54 -- SU27-3, SU33-4, F-15-6, SU25-54

dofile(current_mod_path.."/LUA/Views_F104Pit.lua")
make_view_settings('VSN_F104S_AG', ViewSettings, SnapViews)
make_flyable('VSN_F104S_AG',current_mod_path..'/Cockpit/KneeboardRight/', F104G, current_mod_path..'/comm.lua')--EFM
--make_flyable('VSN_F104S_AG',current_mod_path..'/Cockpit/Scripts/', F104G, current_mod_path..'/comm.lua')--EFM ]]
-------------------------------------------------------------------------------------
--dofile(current_mod_path..'/VSN_F104C.lua')
dofile(current_mod_path..'/VSN_F104G.lua')
--dofile(current_mod_path..'/VSN_F104S.lua')
--dofile(current_mod_path..'/VSN_F104S_AG.lua')
dofile(current_mod_path.."/WEAPONS/Weapons.lua")
-------------------------------------------------------------------------------------
plugin_done()