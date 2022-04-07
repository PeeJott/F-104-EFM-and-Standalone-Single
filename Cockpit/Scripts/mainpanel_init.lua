shape_name   	   = "Cockpit_VSN_F104G"
is_EDM			   = true
new_model_format   = true

--Hier kommen ein paar Möglichketien der Beinflussung für später----------

--ambient_light    = {255,255,255}
--ambient_color_day_texture    = {72, 100, 160}
--ambient_color_night_texture  = {40, 60 ,150}
--ambient_color_from_devices   = {50, 50, 40}
--ambient_color_from_panels	 = {35, 25, 25}

--dusk_border					 = 0.4
--draw_pilot					 = false

--------------------ENDE--------------------------------------------------

external_model_canopy_arg	 = 38

use_external_views = false

local  aircraft = get_aircraft_type()

local controllers = LoRegisterPanelControls()

-----------AoA-Indexer------------------------------------------------------------
AOAindicationGauge = CreateGauge("parameter")
AOAindicationGauge.arg_number = 7
AOAindicationGauge.input = { -10.0, 0.0, 10.0, 20.0, 30.0, 36.0}
AOAindicationGauge.output = { -0.022, 0.213, 0.426, 0.640, 0.853, 1.0}
AOAindicationGauge.parameter_name = "AOA_INDICATOR"

---------G-Meter------------------------------------------------------------------
G_meterGauge = CreateGauge("parameter")
G_meterGauge.arg_number = 6
G_meterGauge.input = { -5.0, -4.0, 0.0, 4.0, 8.0, 10.0} 
G_meterGauge.output = {-1.0, -0.8, 0.0, 0.4, 0.8, 1.0}
G_meterGauge.parameter_name = "G_METER"

---------Radar Altimeter----------------------------------------------------------
RadAltimeterHunHand 				= CreateGauge("parameter")
RadAltimeterHunHand.arg_number		= 18
RadAltimeterHunHand.input 			= { 0.0, 500.0, 1000.0}
RadAltimeterHunHand.output 			= { 0.0, 0.5, 0.64}
RadAltimeterHunHand.parameter_name 	= "RAD_ALT_HUN_HAND"

RadAltimeterKHand					= CreateGauge("parameter")
RadAltimeterKHand.arg_number		= 19
RadAltimeterKHand.input				= {0.0, 5000.0, 10000.0, 50000.0}
RadAltimeterKHand.output			= {0.0, 0.5, 0.64, 0.80}
RadAltimeterKHand.parameter_name	= "RAD_ALT_K_HAND"

-----Pylon-Selectors and Light----------------------------------------------------
Pylon1SelectorAndLight1						= CreateGauge("parameter")
Pylon1SelectorAndLight1.arg_number			= 621
Pylon1SelectorAndLight1.input				= {0.0, 1.0}
Pylon1SelectorAndLight1.output				= {0.0, 1.0}
Pylon1SelectorAndLight1.parameter_name		= "PYLON_ONE_SELECTOR_LIGHT"

Pylon1SelectorAndLight2						= CreateGauge("parameter")
Pylon1SelectorAndLight2.arg_number			= 622
Pylon1SelectorAndLight2.input				= {0.0, 1.0}
Pylon1SelectorAndLight2.output				= {0.0, 1.0}
Pylon1SelectorAndLight2.parameter_name		= "PYLON_TWO_SELECTOR_LIGHT"

Pylon1SelectorAndLight3						= CreateGauge("parameter")
Pylon1SelectorAndLight3.arg_number			= 623
Pylon1SelectorAndLight3.input				= {0.0, 1.0}
Pylon1SelectorAndLight3.output				= {0.0, 1.0}
Pylon1SelectorAndLight3.parameter_name		= "PYLON_THREE_SELECTOR_LIGHT"

--[[Pylon1SelectorAndLight4						= CreateGauge("parameter")
Pylon1SelectorAndLight4.arg_number			= 624
Pylon1SelectorAndLight4.input				= {0.0, 1.0}
Pylon1SelectorAndLight4.output				= {0.0, 1.0}
Pylon1SelectorAndLight4.parameter_name		= "PYLON_FOUR_SELECTOR_LIGHT"
]]

Pylon1SelectorAndLight5						= CreateGauge("parameter")
Pylon1SelectorAndLight5.arg_number			= 624
Pylon1SelectorAndLight5.input				= {0.0, 1.0}
Pylon1SelectorAndLight5.output				= {0.0, 1.0}
Pylon1SelectorAndLight5.parameter_name		= "PYLON_FIVE_SELECTOR_LIGHT"

Pylon1SelectorAndLight6						= CreateGauge("parameter")
Pylon1SelectorAndLight6.arg_number			= 625
Pylon1SelectorAndLight6.input				= {0.0, 1.0}
Pylon1SelectorAndLight6.output				= {0.0, 1.0}
Pylon1SelectorAndLight6.parameter_name		= "PYLON_SIX_SELECTOR_LIGHT"

Pylon1SelectorAndLight7						= CreateGauge("parameter")
Pylon1SelectorAndLight7.arg_number			= 626
Pylon1SelectorAndLight7.input				= {0.0, 1.0}
Pylon1SelectorAndLight7.output				= {0.0, 1.0}
Pylon1SelectorAndLight7.parameter_name		= "PYLON_SEVEN_SELECTOR_LIGHT"





--HUD_BRIGHTNESS_DOWN      		= CreateGauge("parameter")
--HUD_BRIGHTNESS_DOWN.parameter_name   	= "HUDBrightnessDown"
--HUD_BRIGHTNESS_DOWN.arg_number       	= 0
--HUD_BRIGHTNESS_DOWN.input    		= {0,100}
--HUD_BRIGHTNESS_DOWN.output    	= {0,1}

need_to_be_closed = true -- schließt diese Lua nach der Initialisierung

-- RudderPedals						= CreateGauge()
-- RudderPedals.arg_number				= 500
-- RudderPedals.input					= {-100,100}
-- RudderPedals.output					= {-1,1}
-- RudderPedals.controller				= controllers.base_gauge_RudderPosition

-- StickPitch							= CreateGauge()
-- StickPitch.arg_number				= 1001
-- StickPitch.input					= {-100, 100}
-- StickPitch.output					= {-1, 1}
-- StickPitch.controller				= controllers.base_gauge_StickRollPosition

-- StickRoll							= CreateGauge()
-- StickRoll.arg_number				= 1002
-- StickRoll.input						= {-100, 100}
-- StickRoll.output					= {-1, 1}
-- StickRoll.controller				= controllers.base_gauge_StickPitchPosition

-- ThrottleL							= CreateGauge()
-- ThrottleL.arg_number				= 104
-- ThrottleL.input						= {0, 100}
-- ThrottleL.output					= {0, 1}
-- ThrottleL.controller				= controllers.base_gauge_ThrottleLeftPosition

-- ThrottleR							= CreateGauge()
-- ThrottleR.arg_number				= 105
-- ThrottleR.input						= {0, 100}
-- ThrottleR.output					= {0, 1}
-- ThrottleR.controller				= controllers.base_gauge_ThrottleRightPosition

-- mirrors_data = {
--     center_point          = {0.0,0.0,0}, 
--     width                 = 0.8, --integrated (keep in mind that mirrors can be none planar )
--     aspect                = 5.0,
--     rotation              = math.rad(-4);
--     animation_speed       = 4.0;
--     near_clip             = 0.1;
--     middle_clip           = 40;
--     far_clip              = 60000;
--     flaps                 = 
--     {
--         "PNT_MIRROR_CTR",
--         "PNT_L_MIRROR",
--         "PNT_R_MIRROR",
--     }
-- }
-- mirrors_draw                        = CreateGauge()
-- mirrors_draw.arg_number                = 1000
-- mirrors_draw.input                   = {0,1}
-- mirrors_draw.output                   = {1,0}
-- mirrors_draw.controller             = controllers.mirrors_draw
--need_to_be_closed = true
-- need_to_be_closed = false


