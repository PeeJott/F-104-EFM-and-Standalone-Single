--dofile("Scripts/Database/Weapons/warheads.lua")
--local GALLON_TO_KG = 3.785 * 0.8

local pylon_mass 	= 0.0
local PTB500M_name 	= '500L Tank'
local PTB500L_name 	= '500L Tank L'
local PTB500R_name 	= '500L Tank R'


declare_loadout(
    {
        category    = CAT_FUEL_TANKS,
        name        = PTB500M_name,
        displayName = _(PTB500M_name),
        Picture     = "PTB.png",
        attribute   = {wsType_Air, wsType_Free_Fall, wsType_FuelTank, WSTYPE_PLACEHOLDER},
        CLSID       = "VSN_F104G_PTB",
        
        Weight_Empty 	= 132 + pylon_mass,
        Weight 			= 132 + 500 + pylon_mass,
        Cx_pil 			= 0.00042, --von 0.00148 zu 0.00115//Sidewinder mit Adapter ist 0.00014. Gegentesten und ggf. anpassen...angepasst auf 0.000151 zu 0.0032
        shape_table_data =
        {
            {
                name = PTB500M_name,
                file = "VSN_F104M_PTB",
                life = 1,
                fire = { 0, 1},
                username = PTB500M_name,
                index = WSTYPE_PLACEHOLDER,
            },
        },
        Elements =
        {
            {
                Position = {0, 0, 0},
                ShapeName = "VSN_F104M_PTB",
            },
        },
    }
)

declare_loadout(
    {
        category    = CAT_FUEL_TANKS,
        name        = PTB500L_name,
        displayName = _(PTB500L_name),
        Picture     = "PTB.png",
        attribute   = {wsType_Air, wsType_Free_Fall, wsType_FuelTank, WSTYPE_PLACEHOLDER},
        CLSID       = "VSN_F104G_L_PTB",
        
        Weight_Empty 	= 132 + pylon_mass,
        Weight 			= 132 + 500 + pylon_mass,
        Cx_pil 			= 0.00042, --von 0.00148 zu 0.00115// angepasst wie oben da gleiche Kapazität zu 0.0032
        shape_table_data =
        {
            {
                name = PTB500L_name,
                file = "VSN_F104L_PTB",
                life = 1,
                fire = { 0, 1},
                username = PTB500L_name,
                index = WSTYPE_PLACEHOLDER,
            },
        },
        Elements =
        {
            {
                Position = {0, 0, 0},
                ShapeName = "VSN_F104L_PTB",
            },
        },
    }
)

declare_loadout(
    {
        category    = CAT_FUEL_TANKS,
        name        = PTB500R_name,
        displayName = _(PTB500R_name),
        Picture     = "PTB.png",
        attribute   = {wsType_Air, wsType_Free_Fall, wsType_FuelTank, WSTYPE_PLACEHOLDER},
        CLSID       = "VSN_F104G_R_PTB",
        
        Weight_Empty 	= 132 + pylon_mass,
        Weight 			= 132 + 500 + pylon_mass,
        Cx_pil 			= 0.00042, --von 0.00148 zu 0.00115 zu 0.0032
        shape_table_data =
        {
            {
                name = PTB500R_name,
                file = "VSN_F104R_PTB",
                life = 1,
                fire = { 0, 1},
                username = PTB500R_name,
                index = WSTYPE_PLACEHOLDER,
            },
        },
        Elements =
        {
            {
                Position = {0, 0, 0},
                ShapeName = "VSN_F104R_PTB",
            },
        },
    }
)

