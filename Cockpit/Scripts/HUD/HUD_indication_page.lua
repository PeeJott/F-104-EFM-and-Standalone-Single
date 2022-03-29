dofile(LockOn_Options.script_path.."HUD/HUD_definitions.lua")
dofile(LockOn_Options.common_script_path .."elements_defs.lua")




--[[
-- alignment options:
--"RightBottom"
--"LeftTop"
--"RightTop"
--"LeftCenter"
--"RightCenter"
--"CenterBottom"
--"CenterTop"
--"CenterCenter"
--"LeftBottom"

========================================================================================================================================

--GUN_PIPPER.element_params 	= {"param_nr0","param_nr1","param_nr2"}

-- {"change_color_when_parameter_equal_to_number", param_nr, number, red, green, blue}
-- {"text_using_parameter", param_nr, format_nr}
-- {"move_left_right_using_parameter", param_nr, gain}
-- {"move_up_down_using_parameter", param_nr, gain}
-- {"opacity_using_parameter", param_nr}
-- {"rotate_using_parameter", param_nr, gain}
-- {"compare_parameters", param1_nr, param2_nr} -- if param1 == param2 then visible
-- {"parameter_in_range", param_nr, greaterthanvalue, lessthanvalue} -- if greaterthanvalue < param < lessthanvalue then visible
-- {"parameter_compare_with_number", param_nr, number} -- if param == number then visible
-- {"draw_argument_in_range", arg_nr, greaterthanvalue, lessthanvalue} -- if greaterthanvalue < arg < lessthanvalue then visible
-- {"line_object_set_point_using_parameters", point_nr, param_x, param_y, gain_x, gain_y} -- applies to ceSimpleLineObject at least


--]]

--local sensor_data 				= get_base_data() ---it is always a good idea to get_base_data :-)
-- this might not work since get_base_data() has to be updated every frame in a function update(). see hud device
 

----------Creation of parent-Element to "slave" the Gunpipper to-----------------------------------
local HUD_BASE 					= CreateElement "ceSimple"
HUD_BASE.name  					= create_guid_string()
HUD_BASE.init_pos				= {0.0, -0.0, 0.0}									--{0, -1.345,0}
--HUD_BASE.element_params     = {"MAINPOWER"}             
--HUD_BASE.controllers        = {{"parameter_in_range" ,0,0.9,1.1} }
AddHudElement(HUD_BASE)

-----------Finally, the Gunpipper built through the function/s in HUD_definitions.lua-----------------------------------------------------------
GUN_PIPPER 						= create_HUD_texture(HUD_GUNPIPPER_TEXT, 0,0,1024,1024, 40.0) -- Alte Werte für SetScale(Meters): create_HUD_texture(HUD_GUNPIPPER_TEXT, 0,0,1024,1024, 0.022)
GUN_PIPPER.name					= create_guid_string()
GUN_PIPPER.init_pos				= {0.0, 0.00, 0.0} -- "{0.0, -0.005, 0.0}" passt gut :-) war zuvor {0.0, 0.0, 0.0} sollte aber {-links/+rechts, -runter/+hoch, +vor/-zurück}
GUN_PIPPER.parent_element		= HUD_BASE.name --mal auskommentiert
--									Param #0,        Param #1
GUN_PIPPER.element_params 		= {"GUNPIPPER_SIDE","GUNPIPPER_UPDOWN"}
--									  								Param #, Gain							Param #, Gain // Gain von 0,1 zu 1 wegen auto Gunpipper Test
GUN_PIPPER.controllers    		= {{"move_left_right_using_parameter", 0, 1.0}, {"move_up_down_using_parameter", 1, 1.0}}
AddHudElement(GUN_PIPPER)

