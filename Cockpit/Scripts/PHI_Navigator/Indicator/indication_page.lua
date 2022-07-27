dofile(LockOn_Options.script_path.."PHI_Navigator/Indicator/definitions.lua")
dofile(LockOn_Options.script_path.."definitions.lua")

--local MARK_MATERIAL   = MakeMaterial(nil,{255,120,0,255})
-- RadarScale verändere ich mal von 1.1 auf geringer, damit das Radar auch mal ins Radar passt...
RS = RADAR_SCALE * 0.5
	
local 	phi_range					= CreateElement "ceStringPoly"
		phi_range.name			  	= create_guid_string()
		phi_range.material        	= PHI_FONT
		phi_range.init_pos		  	= {0,-0.02,0}--{-0.40*RS,0.9*RS,0} --ALT {-0.45*RS,0.9*RS,0} 
		phi_range.stringdefs      	= txt_m_stringdefs
		phi_range.alignment       	= "CenterCenter"
		phi_range.value				= "999"
		phi_range.formats		  	= {"%03.0f"}
		phi_range.UseBackground		= false
		phi_range.use_mipfilter 	= true
		phi_range.h_clip_relation 	= h_clip_relations.COMPARE
		phi_range.level 			= RADAR_DEFAULT_LEVEL
		phi_range.element_params    = { "PHI_RANGE" }
		phi_range.controllers       = {{"text_using_parameter" ,0, 0}}
Add(phi_range)		
	
local roll		= CreateElement "ceSimple"
roll.name  					= create_guid_string()
roll.init_pos				= {0.0, 0.0, 0.0}
roll.element_params 		= { "PHI_BEARING" }
roll.controllers    		= {{"rotate_using_parameter", 0, 1.0}}
Add(roll)



local INDEX_SIZE = 0.01
local INDEX_HEIGHT = 35.0 * INDEX_SIZE
local INDEX_WIDTH = 0.5 * INDEX_SIZE


local phi_bearing					= CreateElement "ceMeshPoly"
phi_bearing.name					= create_guid_string()
phi_bearing.parent_element			= roll.name
phi_bearing.init_pos				= {0, 0, 0}
phi_bearing.primitivetype			= "triangles"
phi_bearing.vertices				= {
										{  -1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT}, {  -1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, {   1.0 * INDEX_WIDTH, -1.0 * INDEX_HEIGHT}, {   1.0 * INDEX_WIDTH,  1.0 * INDEX_HEIGHT},}
phi_bearing.indices					= {0,1,3,  1,2,3}
phi_bearing.material				= PHI_WHITE
phi_bearing.h_clip_relation 		= h_clip_relations.COMPARE
phi_bearing.level 					= RADAR_DEFAULT_LEVEL
phi_bearing.isdraw					= true
phi_bearing.isvisible				= true
phi_bearing.use_mipfilter			= true
--phi_bearing.additive_alpha   = true
Add(phi_bearing)


local INDEX_HEIGHT = 5 * INDEX_SIZE
local INDEX_WIDTH = 5 * INDEX_SIZE

local phi_bearing_head					= CreateElement "ceMeshPoly"
phi_bearing_head.name					= create_guid_string()
phi_bearing_head.parent_element			= roll.name
phi_bearing_head.init_pos				= {0, 35.0 * INDEX_SIZE, 0}
--phi_bearing_head.init_pos				= {0, 0, 0}
phi_bearing_head.primitivetype			= "triangles"
phi_bearing_head.vertices				= {{ 0, INDEX_HEIGHT}, {  -INDEX_WIDTH, -INDEX_HEIGHT}, { INDEX_WIDTH, -INDEX_HEIGHT},}
phi_bearing_head.indices				= {1,0,2}
phi_bearing_head.material				= PHI_WHITE
phi_bearing_head.h_clip_relation 		= h_clip_relations.COMPARE
phi_bearing_head.level 					= RADAR_DEFAULT_LEVEL
phi_bearing_head.isdraw					= true
phi_bearing_head.isvisible				= true
phi_bearing_head.use_mipfilter			= true
--phi_bearing_head.additive_alpha   = true
Add(phi_bearing_head)