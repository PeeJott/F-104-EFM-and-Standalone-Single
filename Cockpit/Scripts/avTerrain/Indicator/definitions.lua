dofile(LockOn_Options.common_script_path.."elements_defs.lua")
SetScale(FOV)

RADAR_DEFAULT_LEVEL = 4
RADAR_DEFAULT_NOCLIP_LEVEL  = RADAR_DEFAULT_LEVEL - 1

TEXT_ORANGE_COLOR	= {255, 130, 5, 255}
TEXT_ORANGE_SOFT	= {255, 130, 5, 128}


RADAR_FOV = MakeMaterial(nil,{17,80,7,0})
RADAR_GRID = MakeMaterial(nil,{0,100,0,192})
RADAR_SCRIBE = MakeMaterial(nil,{0,200,0,192})
BLOB_TEXTURE = MakeMaterial(LockOn_Options.script_path .. "Textures/radar_blob.dds", TEXT_ORANGE_COLOR
--{0,128,0,192}
)


function AddElement(object)
    object.use_mipfilter    = true
	object.additive_alpha   = true
	object.h_clip_relation  = h_clip_relations.COMPARE
	object.level			= RADAR_DEFAULT_LEVEL
    Add(object)
end

z_offset = 0
blob_scale=0.08