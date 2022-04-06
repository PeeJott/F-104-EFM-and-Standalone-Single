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
	
	-------------------AtoA-RADAR-COMMANDS----------------------------
	iCommandPlaneChangeLock						= 100,
	iCommandSelecterLeft						= 139,
	iCommandSelecterRight						= 140,
	iCommandSelecterUp							= 141,
	iCommandSelecterDown						= 142,
	iCommandPlaneChangeRadarPRF					= 394,
	iCommandPlane_LockOn_start					= 509,
	iCommandPlane_LockOn_finish					= 510,
	iCommandPlaneRadarChangeMode				= 285,
	iCommandPlaneRadarHorizontal				= 2025,
	iCommandPlaneRadarVertical					= 2026,
	iCommandPlaneSelecterHorizontal				= 2031,
	iCommandPlaneSelecterVertical				= 2032,
	
	------------------WEAPON SYSTEM---------------------------------
	-----------------Launch, Fire, Release and Drop-----------------
	pickle_on 									= __custom_counter(),
	pickle_off 									= __custom_counter(),
	trigger_on									= __custom_counter(),
	trigger_off									= __custom_counter(),
	
	----------------Station Selection--------------------------------
	station_one									= __custom_counter(),
	station_two									= __custom_counter(),
	station_three								= __custom_counter(),
	station_four								= __custom_counter(),
	station_five								= __custom_counter(),
	station_six									= __custom_counter(),
	station_seven								= __custom_counter(),
	-----------------------------------------------------------------
	-----------------------------HUD--------------------------------
	GunPipper_Up								= __custom_counter(),
	GunPipper_Down								= __custom_counter(),
	GunPipper_Right								= __custom_counter(),
	GunPipper_Left								= __custom_counter(),
	GunPipper_Center							= __custom_counter(),
	GunPipper_Automatic							= __custom_counter(),
	-----------------------------------------------------------------
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

