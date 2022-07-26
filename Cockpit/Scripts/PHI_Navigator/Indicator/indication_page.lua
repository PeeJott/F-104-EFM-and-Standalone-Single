dofile(LockOn_Options.script_path.."PHI_Navigator/Indicator/definitions.lua")
dofile(LockOn_Options.script_path.."definitions.lua")

--local MARK_MATERIAL   = MakeMaterial(nil,{255,120,0,255})
-- RadarScale verändere ich mal von 1.1 auf geringer, damit das Radar auch mal ins Radar passt...
RS = RADAR_SCALE * 0.40

local BLOB_FACTOR = 1
local BLOB_COUNT = 2500 * BLOB_FACTOR
local NOISE_COUNT = 200

ud_scale 	= 0.00001 * 0.25	* RS	--0.00001
lr_scale 	= 0.095	  * 0.9	*2	* RS	--0.2		--0.085

--ud_scale 	= 0.00001 * 0.45		* RS   *4 	 --0.00001
--lr_scale 	= 0.095	  * 0.45	* RS	--0.2		--0.085



--life_time 	= 0.75 -- 0.5
--life_time 	= 1.5 -- A/G
life_time 	= 5 -- A/G
life_time_low = 0


-------------------------------------------------------------

--!!!!Ein Radar-Grid hat das NASARR-F15A gar nicht, daher auskommentiert!!!---

--[[
local x_size = 0.004
local y_size = 0.9 *RS



for i = -2,2 do
	local   radar_grid_v 				= CreateElement "ceMeshPoly"
			radar_grid_v.name 			= "radar_grid_v"
			radar_grid_v.primitivetype 	= "triangles"
			radar_grid_v.vertices 		= {	{-x_size, -y_size},
											{-x_size,  y_size},	
											{ x_size,  y_size},	
											{ x_size, -y_size}
										  }
			radar_grid_v.indices  		= default_box_indices
			radar_grid_v.init_pos 		= {i*0.45*RS,0,0}
			radar_grid_v.material 		= MFCD_GREEN_SOFT
			radar_grid_v.h_clip_relation= h_clip_relations.COMPARE
			radar_grid_v.level			= RADAR_DEFAULT_LEVEL
			radar_grid_v.isdraw		 	= true
		Add(radar_grid_v)

end

	x_size = 0.9*RS
	y_size = 0.004
for i = -2,2 do
	local   radar_grid_v 				= CreateElement "ceMeshPoly"
			radar_grid_v.name 			= "radar_grid_v"
			radar_grid_v.primitivetype 	= "triangles"
			radar_grid_v.vertices 		= {	{-x_size, -y_size},
											{-x_size,  y_size},
											{ x_size,  y_size},	
											{ x_size, -y_size}
										  }
			radar_grid_v.indices  		= default_box_indices
			radar_grid_v.init_pos 		= {0,i*0.45*RS,0}
			radar_grid_v.material 		= MFCD_GREEN_SOFT
			radar_grid_v.h_clip_relation= h_clip_relations.COMPARE
			radar_grid_v.level			= RADAR_DEFAULT_LEVEL
			radar_grid_v.isdraw		 	= true
		Add(radar_grid_v)

end
]]


function create_textured_box(UL_X,UL_Y,DR_X,DR_Y)
    local size_per_pixel = 1
    local texture_size_x = DR_X-UL_X
    local texture_size_y = DR_Y-UL_Y
    local W = DR_X - UL_X
    local H = DR_Y - UL_Y

    local half_x = 0.5 * W * size_per_pixel
    local half_y = 0.5 * H * size_per_pixel
    local ux 	 = UL_X / texture_size_x
    local uy 	 = UL_Y / texture_size_y
    local w  	 = W / texture_size_x
    local h 	 = H / texture_size_y

    local object = CreateElement "ceTexPoly"
    object.vertices =  {{-half_x, half_y},
    				    { half_x, half_y},
    				    { half_x,-half_y},
    				    { -half_x,-half_y}}
    object.indices	  = {0,1,2,2,3,0}
    object.tex_coords = {{ux -w/2    ,uy-h/2},
    					 {ux + w/2 ,uy-h/2},
    					 {ux + w/2 ,uy + h/2},
    				     {ux-w/2 	 ,uy + h/2}}

    return object
end

function create_textured_box_scale(UL_X,UL_Y,DR_X,DR_Y)
    local size_per_pixel = 1
    local texture_size_x = DR_X-UL_X
    local texture_size_y = DR_Y-UL_Y
    local W = DR_X - UL_X
    local H = DR_Y - UL_Y

    local half_x = 0.5 * W * size_per_pixel
    local half_y = 0.5 * H * size_per_pixel
    local ux 	 = UL_X / texture_size_x
    local uy 	 = UL_Y / texture_size_y
    local w  	 = W / texture_size_x
    local h 	 = H / texture_size_y

    local object = CreateElement "ceTexPoly"
    object.vertices =  {{-half_x, half_y},
    				    { half_x, half_y},
    				    { half_x,-half_y},
    				    { -half_x,-half_y}}
    object.indices	  = {0,1,2,2,3,0}

	tex_state = {}
	local frame = 10
	local current_scale = 1
	local scale_step = 1
	for i = 1,frame,1 do
		tex_state[#tex_state+1] = {{(ux-w/2), (uy-h/2)}, {(ux+w/2), (uy-h/2)}, {(ux+w/2), (uy+h/2)}, {(ux-w/2), (uy+h/2)}}
		current_scale = current_scale + scale_step
	end
	object.state_tex_coords = tex_state
	--object.state_tex_coords = {
	--		{{(ux-w/2)*1, (uy-h/2)*1}, {(ux+w/2)*1, (uy-h/2)*1}, {(ux+w/2)*1, (uy+h/2)*1}, {(ux-w/2)*1, (uy+h/2)*1}},
	--		{{(ux-w/2)*2, (uy-h/2)*2}, {(ux+w/2)*2, (uy-h/2)*2}, {(ux+w/2)*2, (uy+h/2)*2}, {(ux-w/2)*2, (uy+h/2)*2}},
	--		{{(ux-w/2)*3, (uy-h/2)*3}, {(ux+w/2)*2, (uy-h/2)*3}, {(ux+w/2)*3, (uy+h/2)*3}, {(ux-w/2)*3, (uy+h/2)*3}},
	--		{{(ux-w/2)*4, (uy-h/2)*4}, {(ux+w/2)*3, (uy-h/2)*4}, {(ux+w/2)*4, (uy+h/2)*4}, {(ux-w/2)*4, (uy+h/2)*4}},
	--}
    --object.tex_coords = {{ux -w/2    ,uy-h/2},
    --					 {ux + w/2 ,uy-h/2},
    --					 {ux + w/2 ,uy + h/2},
    --				     {ux-w/2 	 ,uy + h/2}}

    return object
end







local x_size = 0.01 *3 --0.01 *2
local y_size = 0.01 *3 --0.01 *2
local blob_scale = 0.02--0.02 * 3 
local blob_scale_x = (blob_scale*4)/2
local blob_scale_y = (blob_scale)/2

local beam_scale = 0.005 --0.02 * 3 
local beam_scale_x = 150*beam_scale
local beam_scale_y = 600*beam_scale


TEXT_ORANGE_COLOR		= {255, 130, 5, 255}
TEXT_ORANGE_COLOR_LIGHT	= {255, 130, 5, 75}
--BLOB_TEXTURE = MakeMaterial(LockOn_Options.script_path .. "Textures/radar_blob.dds", TEXT_ORANGE_COLOR_LIGHT)
BLOB_TEXTURE = MakeMaterial(LockOn_Options.script_path .. "Textures/radar_blob.dds", TEXT_ORANGE_COLOR)
GATE_TEXTURE = MakeMaterial(LockOn_Options.script_path .. "Textures/radar_blob.dds", TEXT_ORANGE_COLOR)
NOISE_TEXTURE = MakeMaterial(LockOn_Options.script_path .. "Textures/radar_noise.dds", TEXT_ORANGE_COLOR_LIGHT)


local radar_ppi		= CreateElement "ceSimple"
radar_ppi.name  					= "radar_ppi"
radar_ppi.init_pos				= {0.0, 0.0, 0.0}
radar_ppi.element_params 		= { "RADAR_MODE" }
radar_ppi.controllers    		= {{"parameter_in_range",0,0.9,2.1}}
radar_ppi.isdraw				= true
radar_ppi.isvisible			= true
radar_ppi.h_clip_relation 	= h_clip_relations.COMPARE
radar_ppi.level 				= RADAR_DEFAULT_LEVEL 
radar_ppi.collimated			= false
Add(radar_ppi)

for s = 1,4 do
	for ia = 1,BLOB_COUNT do

		if ia  < 10 then
			i = "_0".. ia .."_"
		else
			i = "_".. ia .."_"
		end

		local scale_factor = s - ((s-1) * 0.5)
		
		--local	radar_contact			   		= CreateElement "ceMeshPoly"
		local	radar_contact			   		= create_textured_box(-blob_scale_x*scale_factor,-blob_scale_y*scale_factor,blob_scale_x*scale_factor,blob_scale_y*scale_factor)
				radar_contact.material       	= BLOB_TEXTURE
				radar_contact.name		   		= "radar_contact" .. i .. "name"				
				radar_contact.init_pos	   		= {0, -1.80*RS, 0}				
				radar_contact.use_mipfilter     = true
				radar_contact.additive_alpha    = true
				radar_contact.isdraw			= true
				radar_contact.isvisible			= true
				radar_contact.h_clip_relation 	= h_clip_relations.COMPARE
				radar_contact.level 			= RADAR_DEFAULT_LEVEL
				radar_contact.collimated		= false
				radar_contact.parent_element	= "radar_ppi"
				radar_contact.controllers     	= {													
													--{"parameter_compare_with_number",8,s},
													--{"rotate_using_parameter"	,1, -1.0},
													--{"move_up_down_using_parameter"		,2,ud_scale},

													--{"parameter_in_range",2,(s-1)*10000,s*10000},
													--{"parameter_in_range",3,life_time_low,life_time},

													--{"change_color_when_parameter_equal_to_number", 4, 1, 1.0,1.0,0.0}, -- IFF

													--{"change_color_when_parameter_equal_to_number", 5, 1, 0.0,0.0,1.0},	-- sea
													--{"change_color_when_parameter_equal_to_number", 5, 2, 0.0,1.0,0.0},	-- land
													--{"change_color_when_parameter_equal_to_number", 5, 3, 1.0,0.0,0.0},		-- artificial
													
													{"parameter_compare_with_number", 6, 1},
													{"rotate_using_parameter", 10, -1.0},
													{"move_up_down_using_parameter", 9, ud_scale},
													--{"change_texture_state_using_parameter",8},
													{"parameter_in_range", 8, (s-1)*0.25, s*0.25},
													{"opacity_using_parameter",7},
													} 
				radar_contact.element_params  	= {	
													"RADAR_CONTACT"..i.."ELEVATION", -- 0
													"RADAR_CONTACT"..i.."AZIMUTH",	 -- 1
													"RADAR_CONTACT"..i.."RANGE",	 -- 2
													"RADAR_CONTACT"..i.."TIME",		 -- 3
													"RADAR_CONTACT"..i.."FRIENDLY",	 -- 4
													"RADAR_CONTACT"..i.."RCS",		 -- 5

													"BLOB"..i.."SHOW",		 -- 6
													"BLOB"..i.."OPACITY",	 -- 7
													"BLOB"..i.."SCALE",		 -- 8
													"BLOB"..i.."RANGE",		 -- 9
													"BLOB"..i.."AZIMUTH",	 -- 10
													}
			Add(radar_contact)

	end
end

---- scaling test code
--for ia = 1,BLOB_COUNT do
--
--	if ia  < 10 then
--		i = "_0".. ia .."_"
--	else
--		i = "_".. ia .."_"
--	end
--
--	local scale_factor = 1
--		
--	--local	radar_contact			   		= CreateElement "ceMeshPoly"
--	local	radar_contact			   		= create_textured_box_scale(-blob_scale_x*scale_factor,-blob_scale_y*scale_factor,blob_scale_x*scale_factor,blob_scale_y*scale_factor)
--	--local	radar_contact			   		= create_textured_box(-blob_scale_x*scale_factor,-blob_scale_y*scale_factor,blob_scale_x*scale_factor,blob_scale_y*scale_factor)
--			radar_contact.material       	= BLOB_TEXTURE
--			radar_contact.name		   		= "radar_contact" .. i .. "name"				
--			radar_contact.init_pos	   		= {0, -1.80*RS, 0}				
--			radar_contact.use_mipfilter     = true
--			radar_contact.additive_alpha    = true
--			radar_contact.isdraw			= true
--			radar_contact.isvisible			= true
--			radar_contact.h_clip_relation 	= h_clip_relations.COMPARE
--			radar_contact.level 			= RADAR_DEFAULT_LEVEL
--			radar_contact.collimated		= false
--			radar_contact.controllers     	= {													
--												--{"parameter_compare_with_number",8,s},
--												--{"rotate_using_parameter"	,1, -1.0},
--												--{"move_up_down_using_parameter"		,2,ud_scale},
--
--												--{"parameter_in_range",2,(s-1)*10000,s*10000},
--												--{"parameter_in_range",3,life_time_low,life_time},
--
--												--{"change_color_when_parameter_equal_to_number", 4, 1, 1.0,1.0,0.0}, -- IFF
--
--												--{"change_color_when_parameter_equal_to_number", 5, 1, 0.0,0.0,1.0},	-- sea
--												--{"change_color_when_parameter_equal_to_number", 5, 2, 0.0,1.0,0.0},	-- land
--												--{"change_color_when_parameter_equal_to_number", 5, 3, 1.0,0.0,0.0},		-- artificial
--													
--												{"parameter_compare_with_number", 6, 1},
--												{"rotate_using_parameter", 10, -1.0},
--												{"move_up_down_using_parameter", 9, ud_scale},
--												{"change_texture_state_using_parameter",8},
--												--{"parameter_in_range", 8, (s-1)*0.25, s*0.25},
--												{"opacity_using_parameter",7},
--												} 
--			radar_contact.element_params  	= {	
--												"RADAR_CONTACT"..i.."ELEVATION", -- 0
--												"RADAR_CONTACT"..i.."AZIMUTH",	 -- 1
--												"RADAR_CONTACT"..i.."RANGE",	 -- 2
--												"RADAR_CONTACT"..i.."TIME",		 -- 3
--												"RADAR_CONTACT"..i.."FRIENDLY",	 -- 4
--												"RADAR_CONTACT"..i.."RCS",		 -- 5
--
--												"BLOB"..i.."SHOW",		 -- 6
--												"BLOB"..i.."OPACITY",	 -- 7
--												"BLOB"..i.."SCALE",		 -- 8
--												"BLOB"..i.."RANGE",		 -- 9
--												"BLOB"..i.."AZIMUTH",	 -- 10
--												}
--		Add(radar_contact)
--
--end



----------------- NOISE START -------------

for n = 0,NOISE_COUNT do
	local	radar_noise					= create_textured_box(-blob_scale/2,-blob_scale/2,blob_scale/2,blob_scale/2)
			radar_noise.material       	= NOISE_TEXTURE
			radar_noise.name		   		= "noise_" .. n .. "_name"				
			radar_noise.init_pos	   		= {0, -1.80*RS, 0}				
			radar_noise.use_mipfilter     = true
			radar_noise.additive_alpha    = true
			radar_noise.isdraw			= true
			radar_noise.isvisible			= true
			radar_noise.h_clip_relation 	= h_clip_relations.COMPARE
			radar_noise.level 			= RADAR_DEFAULT_LEVEL
			radar_noise.collimated		= false
			radar_noise.parent_element	= "radar_ppi"
			radar_noise.controllers     	= {													
												{"parameter_compare_with_number", 0, 1},
												{"rotate_using_parameter", 2, -1.0},
												{"move_up_down_using_parameter", 1, ud_scale},
												{"opacity_using_parameter",3},
												} 
			radar_noise.element_params  	= {	
												"NOISE_"..n.."_SHOW",		 -- 0
												"NOISE_"..n.."_RANGE",		 -- 1
												"NOISE_"..n.."_AZIMUTH",	 -- 2
												"NOISE_"..n.."_OPACITY",	 -- 7
												}
		Add(radar_noise)
end

------------------- NOISE END -------------




local x_size = 0.01--ALT 0.005--0.006
local y_size = 0.07--ALT 0.03--0.05


local	radar_cursor			   		= CreateElement "ceMeshPoly"
		radar_cursor.name		   		= "radar_cursor" 
		radar_cursor.primitivetype		= "triangles"
		radar_cursor.vertices	   		= {	
											{-x_size-0.04 , -y_size},
											{-x_size-0.04 , y_size},
											{ x_size-0.04 , y_size},
											{ x_size-0.04 ,-y_size},	
											
											{-x_size+0.04 , -y_size},
											{-x_size+0.04 , y_size},
											{ x_size+0.04 , y_size},
											{ x_size+0.04 ,-y_size},	
											}
		radar_cursor.indices	   		= { 0,1,2,	0,2,3	,4,5,6,4,6,7}--{0, 1, 2, 0, 2, 3} 
		radar_cursor.init_pos	   		= {0, -2.0*RS, 0} --ALT {0, -0.90*RS, 0}
		radar_cursor.material    	 	= MFCD_ORANGE
		radar_cursor.isdraw				= true
		radar_cursor.isvisible			= true
		radar_cursor.h_clip_relation 	= h_clip_relations.COMPARE
		radar_cursor.level 				= RADAR_DEFAULT_LEVEL 
		radar_cursor.collimated			= false
		radar_cursor.controllers     	= {
											{"rotate_using_parameter"	,1, -1.0},
											{"move_up_down_using_parameter"		,0,ud_scale},																						
											{"parameter_in_range",2,-0.1,2.1},	
										  } 
		radar_cursor.element_params  	= {	
											"RADAR_TDC_RANGE",
											"RADAR_TDC_AZIMUTH",
											"RADAR_MODE",
										  }
	--Add(radar_cursor)
	
for r=0,9 do
    local range_gate	   		= create_textured_box(-(4*blob_scale)/2,-blob_scale/2,(4*blob_scale)/2,blob_scale/2)								
	range_gate.material       	= GATE_TEXTURE
    range_gate.name				= create_guid_string()
    range_gate.init_pos	        = {0, -2.0*RS, 0}
	range_gate.isdraw				= true
	range_gate.isvisible			= true
	range_gate.use_mipfilter     = true
	range_gate.additive_alpha    = true
	range_gate.h_clip_relation 	= h_clip_relations.COMPARE
	range_gate.level 				= RADAR_DEFAULT_LEVEL 
	range_gate.collimated			= false
	range_gate.parent_element	= "radar_ppi"
	range_gate.controllers     	= {
											{"rotate_using_parameter"	,1,-1.0},
											{"move_up_down_using_parameter"		,0,ud_scale},										
											{"parameter_in_range",2,-0.1,2.1},	
											{"opacity_using_parameter",3},
										  } 
	range_gate.element_params  	= {	
											"RANGE_GATE_"..r.."_RANGE",		-- 0											
											"RANGE_GATE_"..r.."_AZIMUTH",	-- 1
											"RANGE_GATE_"..r.."_SHOW",		-- 2
											"RANGE_GATE_"..r.."_OPACITY",	-- 3
										  }
    Add(range_gate)
end

------------------------------------ LOCK MODE ------------------------------------------



local radar_track		= CreateElement "ceSimple"
radar_track.name  					= "radar_track"
radar_track.init_pos				= {0.0, 0.0, 0.0}
radar_track.element_params 		= { "RADAR_MODE" }
radar_track.controllers    		= {{"parameter_in_range",0,2.9,3.1}}
radar_track.isdraw				= true
radar_track.isvisible			= true
radar_track.h_clip_relation 	= h_clip_relations.COMPARE
radar_track.level 				= RADAR_DEFAULT_LEVEL 
radar_track.collimated			= false
Add(radar_track)





local range_rate_circle_size = 100
for i=1,range_rate_circle_size do
        local range_rate_circle			    = CreateElement "ceCircle"
        range_rate_circle.name				= create_guid_string()
        range_rate_circle.init_pos	        = {0.0, 0.0, 0.0}
        range_rate_circle.parent_element	= "radar_track"
        range_rate_circle.radius			= { (RS * 0.5) + (0.01 * i) * RS, (RS * 0.5) + (0.01 * i) * RS + 0.02 * RS }
        range_rate_circle.arc				= {0.1 * math.pi, 1.9 * math.pi}
        range_rate_circle.segment			= math.pi * 4 / 64
        range_rate_circle.gap				= math.pi * 4 / 64
        range_rate_circle.segment_detail	= 4
        range_rate_circle.dashed		    = false
        range_rate_circle.material          = MFCD_ORANGE
        range_rate_circle.element_params    = { "RADAR_RANGE", "RADAR_CLOSURE" }
        range_rate_circle.controllers       = {{"parameter_in_range" ,0, i, (i+0.999999)}, {"rotate_using_parameter", 1, -1.0}}
		range_rate_circle.isdraw			= true
		range_rate_circle.isvisible			= true
		range_rate_circle.h_clip_relation 	= h_clip_relations.COMPARE
		range_rate_circle.level 			= RADAR_DEFAULT_LEVEL 
		range_rate_circle.collimated		= false
        Add(range_rate_circle)
end

local	steering_circle			   			= CreateElement "ceCircle"
		steering_circle.name		   		= "steering_circle" 
		steering_circle.init_pos	        = {0.0, 0.0, 0.0}
		steering_circle.init_pos	        = {0.0, 0.0, 0.0}
        steering_circle.parent_element		= "radar_track"
        steering_circle.radius				= { RS * 0.33, (RS * 0.33) + 0.02 * RS }
        steering_circle.arc					= {0, 2 * math.pi}
        steering_circle.segment				= math.pi * 4 / 64
        steering_circle.gap					= math.pi * 4 / 64
        steering_circle.segment_detail		= 4
        steering_circle.dashed				= false
        steering_circle.material			= MFCD_ORANGE
		steering_circle.controllers     	= {
												{"move_left_right_using_parameter"	,1,lr_scale},
												{"move_up_down_using_parameter"		,2,lr_scale},
												{"parameter_in_range",3,2.9,3.1},	
											  } 
		steering_circle.element_params  	= {	
												"RADAR_STT_RANGE",
												"RADAR_STT_AZIMUTH",
												"RADAR_STT_ELEVATION",
												"RADAR_MODE",
											  }
		steering_circle.isdraw				= true
		steering_circle.isvisible			= true
		steering_circle.h_clip_relation 	= h_clip_relations.COMPARE
		steering_circle.level 				= RADAR_DEFAULT_LEVEL 
		steering_circle.collimated			= false
        Add(steering_circle)


local	steering_dot			   			= CreateElement "ceCircle"
		steering_dot.name		   			= "steering_dot" 
		steering_dot.init_pos				= {0.0, 0.0, 0.0}
		steering_dot.init_pos				= {0.0, 0.0, 0.0}
        steering_dot.parent_element			= "radar_track"
        steering_dot.radius					= { 0.00001, 0.05 * RS }
        steering_dot.arc					= {0, 2 * math.pi}
        steering_dot.segment				= math.pi * 4 / 64
        steering_dot.gap					= math.pi * 4 / 64
        steering_dot.segment_detail			= 4
        steering_dot.dashed					= false
        steering_dot.material				= MFCD_ORANGE
		steering_dot.controllers     		= {
												{"move_left_right_using_parameter"	,1,lr_scale*2},
												{"move_up_down_using_parameter"		,2,lr_scale*2},
												{"parameter_in_range",3,2.9,3.1},	
											  } 
		steering_dot.element_params  		= {	
												"RADAR_STT_RANGE",
												"RADAR_STT_AZIMUTH",
												"RADAR_STT_ELEVATION",
												"RADAR_MODE",
											  }
		steering_dot.isdraw					= true
		steering_dot.isvisible				= true
		steering_dot.h_clip_relation 		= h_clip_relations.COMPARE
		steering_dot.level 					= RADAR_DEFAULT_LEVEL 
		steering_dot.collimated				= false
        Add(steering_dot)
	
------------------------------------- MARKINGS -----------------------------------------------------------
	
	local 	radar_bearing_L15	 				= CreateElement "ceStringPoly"
			radar_bearing_L15.name			  	= "radar_bearing_L15"
			radar_bearing_L15.material        	= HUD_FONT
			radar_bearing_L15.init_pos		  	= {-1.1*RS,2.2*RS,0}--{-0.40*RS,0.9*RS,0} --ALT {-0.45*RS,0.9*RS,0} 
			radar_bearing_L15.stringdefs      	= txt_m_stringdefs
			radar_bearing_L15.alignment       	= "CenterBottom"--"LeftTop"
			radar_bearing_L15.value				= "15"
			radar_bearing_L15.formats		  	= {"%.0f"}
			radar_bearing_L15.UseBackground		= false
			radar_bearing_L15.use_mipfilter 	= true
			radar_bearing_L15.h_clip_relation 	= h_clip_relations.COMPARE
			radar_bearing_L15.level 			= RADAR_DEFAULT_LEVEL
		Add(radar_bearing_L15)		
	
	local 	radar_bearing_R15				= Copy(radar_bearing_L15)
			radar_bearing_R15.name			= "radar_bearing_R15"
			radar_bearing_R15.init_pos		= {1.1*RS,2.2*RS,0}--{0.40*RS,0.9*RS,0} --ALT {0.45*RS,0.9*RS,0}
		Add(radar_bearing_R15)	
		
	local 	radar_bearing_L30				= Copy(radar_bearing_L15)
			radar_bearing_L30.name			= "radar_bearing_L30"
			radar_bearing_L30.value			= "30"
			radar_bearing_L30.init_pos		= {-2.2*RS,0.0*RS,0}--{-0.80*RS,0.0*RS,0} -- ALT {-0.90*RS,0.9*RS,0}
		Add(radar_bearing_L30)		
	
	local 	radar_bearing_R30				= Copy(radar_bearing_L15)
			radar_bearing_R30.name			= "radar_bearing_R30"
			radar_bearing_R30.value			= "30"
			radar_bearing_R30.init_pos		= {2.2*RS,0.0*RS,0}--{0.80*RS,0.0*RS,0} --ALT {0.90*RS,0.9*RS,0}
		Add(radar_bearing_R30)
	
	
	


	x_size = 0.02 --0.01
	y_size = 0.25  --0.15	
local	radar_SZ_AZIMUTH			   		= CreateElement "ceMeshPoly"
		radar_SZ_AZIMUTH.name		   		= "radar_SZ_AZIMUTH" 
		radar_SZ_AZIMUTH.primitivetype		= "triangles"	--"lines"--
		radar_SZ_AZIMUTH.vertices	   		= {	
										{-x_size ,0},
										{-x_size , y_size},
										{ x_size , y_size},
										{ x_size ,0},	
									  }
		radar_SZ_AZIMUTH.indices	   		= { 0,1,2,	0,2,3}--{0, 1, 2, 0, 2, 3} 
		radar_SZ_AZIMUTH.init_pos	   		= {0, -2.2*RS, 0} -- ALT {0, -0.85*RS, 0}
		radar_SZ_AZIMUTH.material    	 	= MFCD_ORANGE--MakeMaterial(nil,{10,10,255,150})
		radar_SZ_AZIMUTH.isdraw				= true
		radar_SZ_AZIMUTH.isvisible			= true
		radar_SZ_AZIMUTH.h_clip_relation 	= h_clip_relations.COMPARE
		radar_SZ_AZIMUTH.level 				= RADAR_DEFAULT_LEVEL 
		radar_SZ_AZIMUTH.collimated			= false
		--radar_SZ_AZIMUTH.parent_element	= "radar_STT"
		radar_SZ_AZIMUTH.controllers     	= {
												{"rotate_using_parameter",0,1}
											--{"parameter_in_range",0,0.9,1.1},
											--{"change_color_when_parameter_equal_to_number", 0, 1, 1.0,1.0,0.0},
											} 
		radar_SZ_AZIMUTH.element_params  	= {"SCAN_ZONE_ORIGIN_AZIMUTH",}
--	Add(radar_SZ_AZIMUTH)	
	







	
local radar_horizon		= CreateElement "ceSimple"
radar_horizon.name  					= "radar_horizon"
radar_horizon.init_pos				= {0.0, 0.0, 0.0}
radar_horizon.element_params 		= { "RADAR_ROLL", "RADAR_PITCH" }
radar_horizon.controllers    		= {{"rotate_using_parameter", 0, 1.0}, {"move_up_down_using_parameter", 1, -0.2}}
radar_horizon.isdraw				= true
radar_horizon.isvisible			= true
radar_horizon.h_clip_relation 	= h_clip_relations.COMPARE
radar_horizon.level 				= RADAR_DEFAULT_LEVEL 
radar_horizon.collimated			= false
Add(radar_horizon)

x_size = 0.2
y_size = 0.01
local	radar_roll_left			   		= CreateElement "ceMeshPoly"
		radar_roll_left.name		   		= "radar_roll_left" 
		radar_roll_left.primitivetype		= "triangles"	--"lines"--
		radar_roll_left.vertices	   		= {	
										{-x_size ,0},
										{-x_size , y_size},
										{ x_size , y_size},
										{ x_size ,0},	
									  }
		radar_roll_left.indices	   		= { 0,1,2,	0,2,3}
		radar_roll_left.init_pos	   		= {-0.75, 0, 0}
		radar_roll_left.material    	 	= MFCD_ORANGE--MakeMaterial(nil,{10,10,255,150})
		radar_roll_left.isdraw				= true
		radar_roll_left.isvisible			= true
		radar_roll_left.h_clip_relation 	= h_clip_relations.COMPARE
		radar_roll_left.level 				= RADAR_DEFAULT_LEVEL 
		radar_roll_left.collimated			= false
		radar_roll_left.parent_element		= "radar_horizon"		
Add(radar_roll_left)	
	
local	radar_roll_right			   		= CreateElement "ceMeshPoly"
		radar_roll_right.name		   		= "radar_roll_left" 
		radar_roll_right.primitivetype		= "triangles"	--"lines"--
		radar_roll_right.vertices	   		= {	
										{-x_size ,0},
										{-x_size , y_size},
										{ x_size , y_size},
										{ x_size ,0},	
									  }
		radar_roll_right.indices	   		= { 0,1,2,	0,2,3}
		radar_roll_right.init_pos	   		= {0.75, 0, 0}
		radar_roll_right.material    	 	= MFCD_ORANGE--MakeMaterial(nil,{10,10,255,150})
		radar_roll_right.isdraw				= true
		radar_roll_right.isvisible			= true
		radar_roll_right.h_clip_relation 	= h_clip_relations.COMPARE
		radar_roll_right.level 				= RADAR_DEFAULT_LEVEL 
		radar_roll_right.collimated			= false
		radar_roll_right.parent_element	= "radar_horizon"		
Add(radar_roll_right)	