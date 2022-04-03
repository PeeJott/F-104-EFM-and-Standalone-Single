start_custom_command   = 10000
local __count_custom = start_custom_command-1
local function __custom_counter()
	__count_custom = __count_custom + 1
	return __count_custom
end

Keys =
{
	ICommandHUDBrightnessDown	                = 747,
	iCommandPlaneWingtipSmokeOnOff 				= 78,
	iCommandPlaneJettisonWeapons 				= 82,
 	iCommandPlaneFire 							= 84,
	iCommandPlaneFireOff 						= 85,
	iCommandPlaneChangeWeapon 					= 101,
	iCommandActiveJamming 						= 136,
	iCommandPlaneJettisonFuelTanks 				= 178,
	iCommandPlanePickleOn	 					= 350,
	iCommandPlanePickleOff 						= 351,
	--PlaneGear                   				= 68,
	--PlaneGearUp	               				= 430, 
	--PlaneGearDown              				= 431,
	
	pickle_on 									= __custom_counter(),
	pickle_off 									= __custom_counter(),
	trigger_on									= __custom_counter(),
	trigger_off									= __custom_counter(),
	
	GunPipper_Up								= __custom_counter(),
	GunPipper_Down								= __custom_counter(),
	GunPipper_Right								= __custom_counter(),
	GunPipper_Left								= __custom_counter(),
	GunPipper_Center							= __custom_counter(),
	GunPipper_Automatic							= __custom_counter(),




	-- APG-53A Radar
    RadarModeOFF                    = __custom_counter(),
    RadarModeSTBY                   = __custom_counter(),
    RadarModeSearch                 = __custom_counter(),
    RadarModeTC                     = __custom_counter(),
    RadarModeA2G                    = __custom_counter(),
    RadarMode                       = __custom_counter(),  -- cycles between "on" radar modes
    RadarModeCW                     = __custom_counter(),  -- cycles mode button clockwise
    RadarModeCCW                    = __custom_counter(),  -- cycles mode button counter clockwise
    RadarTCPlanProfile              = __custom_counter(),  -- 1 Plan, 0 Profile, -1 Toggle
    RadarRangeLongShort             = __custom_counter(),  -- 1 Long, 0 Short, -1 Toggle
    RadarVolume                     = __custom_counter(),  -- 1 Inc, 0 Dec
    RadarAntennaAngle               = __custom_counter(),  -- 1 Inc, 0 Dec
    RadarAoAComp                    = __custom_counter(),  -- 1 Enable, 0 Disable
}

start_command   = 3000
local __count = start_command-1
local function __counter()
	__count = __count + 1
	return __count
end

device_commands = {

    radar_planprofile               = __counter(),
    radar_range                     = __counter(),
    radar_storage                   = __counter(),
    radar_brilliance                = __counter(),
    radar_detail                    = __counter(),
    radar_gain                      = __counter(),
    radar_filter                    = __counter(),
    radar_reticle                   = __counter(),
    radar_mode                      = __counter(),
    radar_aoacomp                   = __counter(),
    radar_angle                     = __counter(),
    radar_angle_axis                = __counter(),
    radar_angle_axis_abs            = __counter(),
    radar_volume                    = __counter(),
}

