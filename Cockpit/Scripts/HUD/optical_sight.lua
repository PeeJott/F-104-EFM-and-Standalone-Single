dofile(LockOn_Options.script_path.."HUD/HUD_definitions.lua")
dofile(LockOn_Options.common_script_path .."elements_defs.lua")
dofile(LockOn_Options.script_path.."definitions.lua")

function AddOpticalSight(parent_base_name, parent_roll_name)
    local optical_sight_colour = {251.0, 114.0, 0.0, 200.0 } -- {255.0, 139.0, 50.0, 150.0}
    local optical_sight_material = MakeMaterial(nil, optical_sight_colour)


    -- 50 milliradian diameter ring, 1 millirad thick
    local ring			    = CreateElement "ceCircle"
    ring.name				= create_guid_string()
    ring.init_pos	        = {0.0, 0.0, 0.0}
    ring.parent_element		= parent_base_name
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
    center_dot.parent_element	= parent_base_name
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
        range_bar.parent_element	= parent_base_name
        range_bar.radius			= {19.5, 24.5}
        range_bar.arc				= {math.pi, math.pi + ((math.pi/180) * i) }
        range_bar.segment			= math.pi * 4 / 64
        range_bar.gap				= math.pi * 4 / 64
        range_bar.segment_detail	= 4
        range_bar.dashed		    = false
        range_bar.material          = optical_sight_material
        range_bar.element_params    = { HUD.RANGE }
        range_bar.controllers       = {{"parameter_in_range" ,0, i, (i+0.99999)} }
        AddHudElement(range_bar)

        -- Add the small index at the end of the range bar
        local range_index			= CreateElement "ceCircle"
        range_index.name			= create_guid_string()
        range_index.init_pos	    = {0.0, 0.0, 0.0}
        range_index.parent_element	= parent_base_name
        range_index.radius			= {17.0, 19.5}
        range_index.arc				= {(math.pi + ((math.pi/180) * i))-(0.0174533*5), math.pi + ((math.pi/180) * i)}
        range_index.segment			= math.pi * 4 / 64
        range_index.gap				= math.pi * 4 / 64
        range_index.segment_detail	= 4
        range_index.dashed		    = false
        range_index.material        = optical_sight_material
        range_index.element_params  = { HUD.RANGE }
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
    zenith.parent_element	= parent_roll_name
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
    fire_index.parent_element	= parent_base_name
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
    INDEX_HEIGHT = 1.0 * INDEX_SIZE
    INDEX_WIDTH = 2.0 * INDEX_SIZE

    local roll_reference_index_3			= CreateElement "ceMeshPoly"
    roll_reference_index_3.name				= create_guid_string()
    roll_reference_index_3.init_pos	        = {25.5 + (INDEX_WIDTH / 2), 0.0, 0.0}
    roll_reference_index_3.parent_element	= parent_base_name
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
    roll_index_3.parent_element	= parent_roll_name
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
    roll_reference_index_9.parent_element	= parent_base_name
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
    roll_index_9.parent_element	= parent_roll_name
    roll_index_9.primitivetype	= "triangles"
    roll_index_9.vertices			= {
            {  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, 
            {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
            {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, 
            {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
    roll_index_9.indices			= {0,1,3,  1,2,3}
    roll_index_9.material = optical_sight_material
    AddHudElement(roll_index_9)
end
