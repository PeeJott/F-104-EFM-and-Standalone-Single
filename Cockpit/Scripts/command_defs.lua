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
}

start_command   = 3000
local __count = start_command-1
local function __counter()
	__count = __count + 1
	return __count
end

device_commands = {
}

