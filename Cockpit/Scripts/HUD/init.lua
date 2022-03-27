dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."ViewportHandling.lua") 

indicator_type      = indicator_types.COLLIMATOR  -- COMMON, COLLIMATOR, HELMET
init_pageID     	= 1 --
purposes 	   		= {render_purpose.GENERAL,render_purpose.HUD_ONLY_VIEW} -- GENERAL,HUD_ONLY_VIEW,SCREENSPACE_INSIDE_COCKPIT,SCREENSPACE_OUTSIDE_COCKPIT,GROUND_UNIT_OPERATOR,GROUND_UNIT_OPERATOR_SCREENSPACE
--subset ids
BASE    			= 1
--INDICATION 			= 2 --eingetragen, war vorher auskommentiert

page_subsets  		= {
[BASE]    			= LockOn_Options.script_path.."/HUD/base_page.lua",
--[INDICATION]    	= LockOn_Options.script_path.."HUD/HUD_indication_page.lua",--diese beiden hier eingefügt
}

pages = 
{
	{
	 BASE,
	 --INDICATION,--diese beiden hier eingefügt
	 },
}

collimator_default_distance_factor = {0.6,0,0} --before it was 0.15, 0, 0

update_screenspace_diplacement(SelfWidth/SelfHeight,false)
dedicated_viewport_arcade = dedicated_viewport