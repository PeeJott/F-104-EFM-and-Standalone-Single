dofile(LockOn_Options.script_path.."avRadar/Indicator/definitions.lua")

--local TST  		 = MakeMaterial(nil,{80,17,7,200})
local TST  		 = MakeMaterial(nil,{220,220,220,5})

local SHOW_MASKS = true
--[[
total_field_of_view 				= CreateElement "ceMeshPoly"
total_field_of_view.name 			= "total_field_of_view"
total_field_of_view.primitivetype 	= "triangles"
total_field_of_view.vertices 		=  {{-1,1},{1,1},{1,-1},{-1,-1}}
total_field_of_view.indices			=  {0,1,2,0,2,3}
total_field_of_view.init_pos		= {0, 0, 0}
total_field_of_view.material		= TST
total_field_of_view.h_clip_relation = h_clip_relations.REWRITE_LEVEL
total_field_of_view.level			= RADAR_DEFAULT_LEVEL
total_field_of_view.change_opacity	= false
total_field_of_view.collimated 		= false
total_field_of_view.isvisible		= SHOW_MASKS
Add(total_field_of_view)

]]--

local x_size        = 1 * RADAR_SCALE	--MFD_SIZE-- * MFD_SCALE
local y_size        = 1 * RADAR_SCALE	--MFD_SIZE --* MFD_SCALE
local corner		= 0.9

local x_coord		= x_size --1 * SCALE_SIZE -- Ausdehnung des Zwölfecks in der Horizontalen (von - bis +)
local y_coord		= y_size --1 * SCALE_SIZE -- Ausdehnung des Zwölfecks in der Vertikalen (von - bis +)

--local SCALE_SIZE	= 0.2 --für SetScale(METERS) zum gleichmäßigen Vergrößern, Verkleinern des Zwölfecks


local vert		= {	{-x_size, y_size * corner},
					{ x_size, y_size * corner},
					{ x_size,-y_size * corner},
					{-x_size,-y_size * corner},
					
					{-x_size, 		y_size * corner},
					{ x_size, 		y_size * corner},
					{ x_size * corner, y_size},
					{-x_size * corner, y_size},
					
					{-x_size, 		-y_size * corner},
					{ x_size, 		-y_size * corner},
					{ x_size * corner,-y_size},
					{-x_size * corner,-y_size},
				}
local indi		 	= {	0, 1, 2, 
						0, 2, 3,
						4, 5, 6, 
						4, 6, 7,
						8, 9, 10, 
						8, 10, 11,
						} --default_box_indices

--Wir wolen aber kein abgerundetes Quadrat, sondern eigentlich einen Kreis. Weil ich keinen Kreis kann,
--gibt es eben ein 12-Eck :-)

local ZwoelfeckMaske_Vertices	=	{	{-x_coord * 0.25, y_coord * 1.0}, 
										{-x_coord * 0.75, y_coord * 0.75},
										{-x_coord * 1.0, y_coord * 0.25},
										{-x_coord * 1.0, -y_coord * 0.25},
										{-x_coord * 0.75, -y_coord * 0.75},
										{-x_coord * 0.25, -y_coord * 1.0},
										{x_coord * 0.25, -y_coord * 1.0},
										{x_coord * 0.75, -y_coord * 0.75},
										{x_coord * 1.0, -y_coord * 0.25},
										{x_coord * 1.0, y_coord * 0.25},
										{x_coord * 0.75, y_coord * 0.75},
										{x_coord * 0.25, y_coord * 1.0},
									}


local ZwoelfeckMaske_Indices		= { 0,10,11,  
									0,1,10,  
									1,2,10,  
									2,3,10,  
									3,4,10,  
									4,9,10,  
									4,5,9,  
									5,8,9,  
									5,7,8,  
									5,6,7,
								}



Radar_base               	= CreateElement "ceSimple"
Radar_base.name				= "Radar_base"
Radar_base.init_pos			= {0,0,0}
Add(Radar_base)

---------------------------------------------------
--Clipping-Mask-1:
local 	RADAR_CLIPPING_MASK_SMALL 					= CreateElement "ceMeshPoly"
		RADAR_CLIPPING_MASK_SMALL.name 				= "RADAR_CLIPPING_MASK_SMALL"
		RADAR_CLIPPING_MASK_SMALL.init_pos			= {0,0.12,0}
		RADAR_CLIPPING_MASK_SMALL.primitivetype 	= "triangles"
		
		RADAR_CLIPPING_MASK_SMALL.vertices			= ZwoelfeckMaske_Vertices -- war "vert"
		RADAR_CLIPPING_MASK_SMALL.indices		 	= ZwoelfeckMaske_Indices -- war "indi"
		
		--[[
		total_field_of_view.vertices		= {	{-x_size, y_size * 0.7},
												{ x_size, y_size * 0.7},
												{ x_size,-y_size * 0.7},
												{-x_size,-y_size * 0.7},
												
												{-x_size, 		y_size * 0.7},
												{ x_size, 		y_size * 0.7},
												{ x_size * 0.7, y_size},
												{-x_size * 0.7, y_size},
												
												{-x_size, 		-y_size * 0.7},
												{ x_size, 		-y_size * 0.7},
												{ x_size * 0.7,-y_size},
												{-x_size * 0.7,-y_size},
												
												}
		total_field_of_view.indices		 	= {	0, 1, 2, 0, 2, 3,
												4, 5, 6, 4, 6, 7,
												8, 9, 10, 8, 10, 11,
												} --default_box_indices
												]]--
												
		RADAR_CLIPPING_MASK_SMALL.material			= MakeMaterial(nil,{255,1,1,255}) --Farbe ROT
		RADAR_CLIPPING_MASK_SMALL.h_clip_relation 	= h_clip_relations.REWRITE_LEVEL
		RADAR_CLIPPING_MASK_SMALL.level				= RADAR_DEFAULT_NOCLIP_LEVEL--MDF_FOV_LEVEL
		RADAR_CLIPPING_MASK_SMALL.isdraw			= true
		RADAR_CLIPPING_MASK_SMALL.collimated 		= false
		RADAR_CLIPPING_MASK_SMALL.isvisible			= false --false 
		RADAR_CLIPPING_MASK_SMALL.parent_element	= "Radar_base"
	Add(RADAR_CLIPPING_MASK_SMALL)
---------------------------------
--Clipping-Mask-2:
local 	black_background     				= CreateElement "ceTexPoly"
		black_background.primitivetype 		= "triangles"
		black_background.name				="black_background"
		black_background.init_pos			= {0,0.12,0}
		black_background.material      		= MakeMaterial(nil,{30, 30, 30, 255})
		
		black_background.vertices			= ZwoelfeckMaske_Vertices -- war "vert"
		black_background.indices    		= ZwoelfeckMaske_Indices -- war "indi"
		--[[
		black_background.vertices			= {	{-x_size, y_size},
												{ x_size, y_size},
												{ x_size,-y_size},
												{-x_size,-y_size}}
		black_background.indices       		= {0, 1, 2, 0, 2, 3} 
		]]--
		black_background.parent_element 	= "Radar_base"
		black_background.h_clip_relation	= h_clip_relations.INCREASE_IF_LEVEL
		black_background.level	  			= RADAR_DEFAULT_NOCLIP_LEVEL--MDF_FOV_LEVEL
		--black_background.isdraw				= true --war false
		--black_background.collimated 		= false
		black_background.isvisible			= false --false 
	Add(black_background)