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
local otpical_sight_base		= CreateElement "ceSimple"
otpical_sight_base.name  					= create_guid_string()
otpical_sight_base.init_pos				= {0.0, 0.0, 0.0}
otpical_sight_base.element_params 		= {"WS_GUN_PIPER_AZIMUTH","WS_GUN_PIPER_ELEVATION"}
otpical_sight_base.controllers    		= {{"move_left_right_using_parameter", 0, 1.0}, {"move_up_down_using_parameter", 1, 1.0}}
AddHudElement(otpical_sight_base)

local otpical_sight_roll		= CreateElement "ceSimple"
otpical_sight_roll.name  					= create_guid_string()
otpical_sight_roll.init_pos				= {0.0, 0.0, 0.0}
otpical_sight_roll.parent_element	= otpical_sight_base.name
otpical_sight_roll.element_params 		= {"HUD_ROLL"}
otpical_sight_roll.controllers    		= {{"rotate_using_parameter", 0, 1.0}}
AddHudElement(otpical_sight_roll)


local optical_sight_colour = {251.0, 114.0, 0.0, 200.0 } -- {255.0, 139.0, 50.0, 150.0}
local optical_sight_material = MakeMaterial(nil, optical_sight_colour)

-- 50 milliradian diameter ring, 1 millirad thick
local ring			    = CreateElement "ceCircle"
ring.name				= create_guid_string()
ring.init_pos	        = {0.0, 0.0, 0.0}
ring.parent_element		= otpical_sight_base.name
ring.radius			    = {24.5, 25.5}
ring.arc				= {0, math.pi * 2}
ring.segment			= math.pi * 4 / 64
ring.gap				= math.pi * 4 / 64
ring.segment_detail	    = 4
ring.dashed		        = false
ring.material           = optical_sight_material
AddHudElement(ring)

-- 2 milliradian diameter center dot
local center_dot			= CreateElement "ceCircle"
center_dot.name				= create_guid_string()
center_dot.init_pos	        = {0.0, 0.0, 0.0}
center_dot.parent_element	= otpical_sight_base.name
center_dot.radius			= {0.01, 1}
center_dot.arc				= {0, math.pi * 2}
center_dot.segment			= math.pi * 4 / 16 --64
center_dot.gap				= math.pi * 4 / 16 --64
center_dot.segment_detail	= 4
center_dot.dashed		= false
center_dot.material = optical_sight_material
AddHudElement(center_dot)


local range_bar_segments=180 -- one segment for each degree
for i=1,range_bar_segments do
    -- 5 milliradian range bar
    local range_bar			    = CreateElement "ceCircle"
    range_bar.name				= create_guid_string()
    range_bar.init_pos	        = {0.0, 0.0, 0.0}
    range_bar.parent_element	= otpical_sight_base.name
    range_bar.radius			= {19.5, 24.5}
    range_bar.arc				= {math.pi, math.pi + ((math.pi/180) * i) }
    range_bar.segment			= math.pi * 4 / 64
    range_bar.gap				= math.pi * 4 / 64
    range_bar.segment_detail	= 4
    range_bar.dashed		    = false
    range_bar.material          = optical_sight_material
    range_bar.element_params    = {"HUD_RANGE"}
    range_bar.controllers       = {{"parameter_in_range" ,0, i, (i+0.99999)} }
    AddHudElement(range_bar)

    -- Add the small index at the end of the range bar
    local range_index			= CreateElement "ceCircle"
    range_index.name			= create_guid_string()
    range_index.init_pos	    = {0.0, 0.0, 0.0}
    range_index.parent_element	= otpical_sight_base.name
    range_index.radius			= {17.0, 19.5}
    range_index.arc				= {(math.pi + ((math.pi/180) * i))-(0.0174533*5), math.pi + ((math.pi/180) * i)}
    range_index.segment			= math.pi * 4 / 64
    range_index.gap				= math.pi * 4 / 64
    range_index.segment_detail	= 4
    range_index.dashed		    = false
    range_index.material        = optical_sight_material
    range_index.element_params  = {"HUD_RANGE"}
    range_index.controllers     = {{"parameter_in_range" ,0, i, (i+0.99999)} }
    AddHudElement(range_index)
end


local INDEX_SIZE = 0.5

local INDEX_HEIGHT = 2.0 * INDEX_SIZE
local INDEX_WIDTH = 1.0 * INDEX_SIZE

-- zenith (movable)
local zenith			= CreateElement "ceMeshPoly"
zenith.name				= create_guid_string()
zenith.init_pos	        = {0.0, 28.0 + (INDEX_HEIGHT / 2), 0.0}
zenith.parent_element	= otpical_sight_roll.name
zenith.primitivetype	= "triangles"
zenith.vertices			= {
        {  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, 
        {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
zenith.indices			= {0,1,3,  1,2,3}
zenith.material = optical_sight_material
AddHudElement(zenith)

-- fire index (fixed)
local fire_index			= CreateElement "ceMeshPoly"
fire_index.name				= create_guid_string()
fire_index.init_pos	        = {0.0, -(25.5 + (INDEX_HEIGHT / 2)), 0.0}
fire_index.parent_element	= otpical_sight_base.name
fire_index.primitivetype	= "triangles"
fire_index.vertices			= {
        {  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, 
        {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
fire_index.indices			= {0,1,3,  1,2,3}
fire_index.material = optical_sight_material
AddHudElement(fire_index)


-- roll reference index 3 o clock (fixed)
local INDEX_HEIGHT = 1.0 * INDEX_SIZE
local INDEX_WIDTH = 2.0 * INDEX_SIZE

local roll_reference_index_3			= CreateElement "ceMeshPoly"
roll_reference_index_3.name				= create_guid_string()
roll_reference_index_3.init_pos	        = {25.5 + (INDEX_WIDTH / 2), 0.0, 0.0}
roll_reference_index_3.parent_element	= otpical_sight_base.name
roll_reference_index_3.primitivetype	= "triangles"
roll_reference_index_3.vertices			= {
        {  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, 
        {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
roll_reference_index_3.indices			= {0,1,3,  1,2,3}
roll_reference_index_3.material = optical_sight_material
AddHudElement(roll_reference_index_3)

-- roll index 3 o clock (movable)
local roll_index_3			= CreateElement "ceMeshPoly"
roll_index_3.name				= create_guid_string()
roll_index_3.init_pos	        = {28.0 + (INDEX_WIDTH / 2), 0.0, 0.0}
roll_index_3.parent_element	= otpical_sight_roll.name
roll_index_3.primitivetype	= "triangles"
roll_index_3.vertices			= {
        {  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, 
        {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
roll_index_3.indices			= {0,1,3,  1,2,3}
roll_index_3.material = optical_sight_material
AddHudElement(roll_index_3)


-- roll reference index 9 o clock (fixed)
local roll_reference_index_9			= CreateElement "ceMeshPoly"
roll_reference_index_9.name				= create_guid_string()
roll_reference_index_9.init_pos	        = {- (25.5 + (INDEX_WIDTH / 2)), 0.0, 0.0}
roll_reference_index_9.parent_element	= otpical_sight_base.name
roll_reference_index_9.primitivetype	= "triangles"
roll_reference_index_9.vertices			= {
        {  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, 
        {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
roll_reference_index_9.indices			= {0,1,3,  1,2,3}
roll_reference_index_9.material = optical_sight_material
AddHudElement(roll_reference_index_9)

-- roll index 9 o clock (movable)
local roll_index_9			= CreateElement "ceMeshPoly"
roll_index_9.name				= create_guid_string()
roll_index_9.init_pos	        = {- (28.0 + (INDEX_WIDTH / 2)), 0.0, 0.0}
roll_index_9.parent_element	= otpical_sight_roll.name
roll_index_9.primitivetype	= "triangles"
roll_index_9.vertices			= {
        {  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, 
        {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
        {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
roll_index_9.indices			= {0,1,3,  1,2,3}
roll_index_9.material = optical_sight_material
AddHudElement(roll_index_9)
