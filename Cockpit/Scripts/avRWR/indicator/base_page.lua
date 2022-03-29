dofile(LockOn_Options.script_path.."avRWR/Indicator/definitions.lua")

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
total_field_of_view.level			= RWR_DEFAULT_LEVEL
total_field_of_view.change_opacity	= false
total_field_of_view.collimated 		= false
total_field_of_view.isvisible		= SHOW_MASKS
Add(total_field_of_view)

]]--

local x_size        = 1 * RWR_SCALE	--MFD_SIZE-- * MFD_SCALE
local y_size        = 1 * RWR_SCALE	--MFD_SIZE --* MFD_SCALE
local corner		= 0.9

local x_coord		= x_size --1 * SCALE_SIZE -- Ausdehnung des Zwölfecks in der Horizontalen (von - bis +)
local y_coord		= y_size --1 * SCALE_SIZE -- Ausdehnung des Zwölfecks in der Vertikalen (von - bis +)


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
local indi		 	= {	0, 1, 2, 0, 2, 3,
						4, 5, 6, 4, 6, 7,
						8, 9, 10, 8, 10, 11,
						} --default_box_indices

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



RWR_base               	= CreateElement "ceSimple"
RWR_base.name			= "RWR_base"
RWR_base.init_pos		= {0.17,-0.18,0}
Add(RWR_base)

---------------------------------------------------
local 	Clipping_Mask_RWR_Small 					= CreateElement "ceMeshPoly"
		Clipping_Mask_RWR_Small.name 				= "Clipping_Mask_RWR_Small"
		Clipping_Mask_RWR_Small.primitivetype 		= "triangles"
		Clipping_Mask_RWR_Small.init_pos			= {0,0,0}
		Clipping_Mask_RWR_Small.vertices			= ZwoelfeckMaske_Vertices
		Clipping_Mask_RWR_Small.indices		 		= ZwoelfeckMaske_Indices
		
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
												
		Clipping_Mask_RWR_Small.material		= MakeMaterial(nil,{255,1,1,255}) --das ist ROT
		Clipping_Mask_RWR_Small.h_clip_relation = h_clip_relations.REWRITE_LEVEL
		Clipping_Mask_RWR_Small.level			= RWR_DEFAULT_NOCLIP_LEVEL--MDF_FOV_LEVEL
		Clipping_Mask_RWR_Small.isdraw			= true
		Clipping_Mask_RWR_Small.collimated 		= false
		Clipping_Mask_RWR_Small.isvisible		= false --false 
		Clipping_Mask_RWR_Small.parent_element	= "RWR_base"
	Add(Clipping_Mask_RWR_Small)
---------------------------------

local 	black_background     				= CreateElement "ceTexPoly"
		black_background.primitivetype 		= "triangles"
		black_background.name				="black_background"
		black_background.init_pos			= {0,0,0}
		black_background.material      		= MakeMaterial(nil,{30, 140, 240, 255}) --das ist schwarz (nil,{30, 30, 30, 255})
		
		black_background.vertices			= ZwoelfeckMaske_Vertices
		black_background.indices    		= ZwoelfeckMaske_Indices
		--[[
		black_background.vertices		= {	{-x_size, y_size},
											{ x_size, y_size},
											{ x_size,-y_size},
											{-x_size,-y_size}}
		black_background.indices       	= {0, 1, 2, 0, 2, 3} 
		]]--
		black_background.isvisible			= false --false 
		black_background.parent_element 	= "RWR_base"
		black_background.h_clip_relation	= h_clip_relations.INCREASE_IF_LEVEL
		black_background.level	  			= RWR_DEFAULT_NOCLIP_LEVEL--MDF_FOV_LEVEL
	Add(black_background)