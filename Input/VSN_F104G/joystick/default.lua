local cscripts = folder.."../../../Cockpit/Scripts/"
dofile(cscripts.."devices.lua")
dofile(cscripts.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands,{
{down = iCommandPlaneAutopilot, name = _('Autopilot - Attitude Hold'), category = _('Autopilot')},
{down = iCommandPlaneStabHbar, name = _('Autopilot - Altitude Hold'), category = _('Autopilot')},
{down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'), category = _('Autopilot')},
{down = iCommandHelicopter_PPR_button_T_up, name = _('CAS Pitch'), category = _('Autopilot')},
{down = iCommandHelicopter_PPR_button_K_up, name = _('CAS Roll'), category = _('Autopilot')},
{down = iCommandHelicopter_PPR_button_H_up, name = _('CAS Yaw'), category = _('Autopilot')},

--Flight Control
--{down = iCommandPlaneTrimOn, up = iCommandPlaneTrimOff, name = _('T/O Trim'), category = _('Flight Control')},

-- Systems
--{down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = _('Systems')},
{down = iCommandPlaneJettisonFuelTanks, name = _('Jettison Fuel Tanks'), category = _('Systems')},
{down = iCommandPlane_HOTAS_NoseWheelSteeringButton, up = iCommandPlane_HOTAS_NoseWheelSteeringButton, name = _('Nose Gear Maneuvering Range'), category = _('Systems')},
{down = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, up = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, name = _('Nose Wheel Steering'), category = _('Systems')},
{down = iCommandPlaneWheelBrakeLeftOn, up = iCommandPlaneWheelBrakeLeftOff, name = _('Wheel Brake Left On/Off'), category = _('Systems')},
{down = iCommandPlaneWheelBrakeRightOn, up = iCommandPlaneWheelBrakeRightOff, name = _('Wheel Brake Right On/Off'), category = _('Systems')},
{down = iCommandPlaneFSQuantityIndicatorSelectorMAIN, name = _('Fuel Quantity Selector'), category = _('Systems')},
{down = iCommandPlaneFSQuantityIndicatorTest, up = iCommandPlaneFSQuantityIndicatorTest, value_down = 1, value_up = 0, name = _('Fuel Quantity Test'), category = _('Systems')},
{down = iCommandPlaneFSQuantityIndicatorSelectorINT,	up = iCommandPlaneFSQuantityIndicatorSelectorINT, value_down = 1,  value_up = 0, 	name = _('Bingo Fuel Index, CW'),  category = _('Systems')},
{down = iCommandPlaneFSQuantityIndicatorSelectorINT,	up = iCommandPlaneFSQuantityIndicatorSelectorINT, value_down = -1, value_up = 0, 	name = _('Bingo Fuel Index, CCW'), category = _('Systems')},
{down = iCommandPlaneAntiCollisionLights, name = _('Anti-collision lights'), category = _('Systems')},
{down = iCommandPlaneHook, name = _('Tail Hook'), category = _('Systems')},

-- Modes
{down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
{down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
{down = iCommandPlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
{down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode/FLOOD mode'), category = _('Modes')},
{down = iCommandPlaneModeGround, name = _('(7) Air-To-Ground Mode'), category = _('Modes')},

-- Sensors
{combos = {{key = 'JOY_BTN3'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
{down = iCommandSensorReset, name = _('Radar - Return To Search/NDTWS'), category = _('Sensors')},
{down = iCommandRefusalTWS, name = _('Unlock TWS Target'), category = _('Sensors')},
{down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
{down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
{down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
{down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},
{pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
{pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
{pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
{pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
{pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
{pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
{pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
{pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
{down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
{down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
{down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
{down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
{down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
{down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
{down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},

-- Weapons
{down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
--{combos = {{key = 'JOY_BTN2'}}, down = iCommandPlanePickleOn,	up = iCommandPlanePickleOff, name = _('Weapon Release'), category = _('Weapons')},

--Custom Weapons Keys from CScripts :-)
{combos = {{key = 'JOY_BTN2'}}, down = Keys.pickle_on,	up = Keys.pickle_off, 	name = _('Weapon Release'), category = _('Weapons')},
{combos = {{key = 'JOY_BTN1'}}, down = Keys.trigger_on,	up = Keys.trigger_off, 	name = _('Gun Trigger'), category = _('Weapons')},

--Weapons normal
{combos = {{key = 'JOY_BTN4'}},	down = iCommandPlaneChangeWeapon,		name = _('Weapon Change'),		category = _('Weapons')},
{combos = {{key = 'JOY_BTN5'}},	down = iCommandPlaneModeCannon,			name = _('Cannon'),				category = _('Weapons')},
{down = iCommandPlaneLaunchPermissionOverride,	name = _('Launch Permission Override'), category = _('Weapons') , features = {"LaunchPermissionOverride"}},
-- Gameplay
{down = iCommandPlaneShipTakeOff,		name = _('Ship Take Off Position'), category = _('General') , features = {"shiptakeoff"}},
{down = iCommandCockpitShowPilotOnOff,	name = _('Show Pilot Body'),		category = _('General')},

--Flight Control
{down = iCommandPlaneUpStart,				up = iCommandPlaneUpStop,			name = _('Aircraft Pitch Down'),	category = _('Flight Control')},
{down = iCommandPlaneDownStart,				up = iCommandPlaneDownStop,			name = _('Aircraft Pitch Up'),		category = _('Flight Control')},
{down = iCommandPlaneLeftStart,				up = iCommandPlaneLeftStop,			name = _('Aircraft Bank Left'),		category = _('Flight Control')},
{down = iCommandPlaneRightStart,			up = iCommandPlaneRightStop,		name = _('Aircraft Bank Right'),	category = _('Flight Control')},
{down = iCommandPlaneLeftRudderStart,		up = iCommandPlaneLeftRudderStop,	name = _('Aircraft Rudder Left'),	category = _('Flight Control')},
{down = iCommandPlaneRightRudderStart,		up = iCommandPlaneRightRudderStop,	name = _('Aircraft Rudder Right'),	category = _('Flight Control')},

{pressed = iCommandPlaneTrimUp,				up = iCommandPlaneTrimStop,	name = _('Trim: Nose Up'),			category = _('Flight Control')},
{pressed = iCommandPlaneTrimDown,			up = iCommandPlaneTrimStop,	name = _('Trim: Nose Down'),		category = _('Flight Control')},
{pressed = iCommandPlaneTrimLeft,			up = iCommandPlaneTrimStop,	name = _('Trim: Left Wing Down'),	category = _('Flight Control')},
{pressed = iCommandPlaneTrimRight,			up = iCommandPlaneTrimStop,	name = _('Trim: Right Wing Down'),	category = _('Flight Control')},
{pressed = iCommandPlaneTrimLeftRudder,		up = iCommandPlaneTrimStop,	name = _('Trim: Rudder Left'),		category = _('Flight Control')},
{pressed = iCommandPlaneTrimRightRudder,	up = iCommandPlaneTrimStop,	name = _('Trim: Rudder Right'),		category = _('Flight Control')},

{pressed = iCommandThrottleIncrease, up = iCommandThrottleStop,  name = _('Throttle Up'),			category = _('Flight Control')},
{pressed = iCommandThrottleDecrease, up = iCommandThrottleStop,  name = _('Throttle Down'),			category = _('Flight Control')},
{pressed = iCommandThrottle1Increase,up = iCommandThrottle1Stop, name = _('Throttle Left Up'),		category = _('Flight Control')},
{pressed = iCommandThrottle1Decrease,up = iCommandThrottle1Stop, name = _('Throttle Left Down'),	category = _('Flight Control')},
{pressed = iCommandThrottle2Increase,up = iCommandThrottle2Stop, name = _('Throttle Right Up'),		category = _('Flight Control')},
{pressed = iCommandThrottle2Decrease,up = iCommandThrottle2Stop, name = _('Throttle Right Down'),	category = _('Flight Control')},

{down = iCommandPlaneAUTIncreaseRegime,			name = _('Throttle Step Up'),			category = _('Flight Control')},
{down = iCommandPlaneAUTDecreaseRegime,			name = _('Throttle Step Down'),			category = _('Flight Control')},
{down = iCommandPlaneAUTIncreaseRegimeLeft,		name = _('Throttle Step Up Left'),		category = _('Flight Control')},
{down = iCommandPlaneAUTDecreaseRegimeLeft,		name = _('Throttle Step Down Left'),	category = _('Flight Control')},
{down = iCommandPlaneAUTIncreaseRegimeRight,	name = _('Throttle Step Up Right'),		category = _('Flight Control')},
{down = iCommandPlaneAUTDecreaseRegimeRight,	name = _('Throttle Step Down Right'),	category = _('Flight Control')},

{pressed = iCommandThrottleIncrease, up = iCommandThrottleStop,  name = _('Throttle Up'),			category = _('Flight Control')},
{pressed = iCommandThrottleDecrease, up = iCommandThrottleStop,  name = _('Throttle Down'),			category = _('Flight Control')},

{down = iCommandPlaneAUTIncreaseRegime,			name = _('Throttle Step Up'),			category = _('Flight Control')},
{down = iCommandPlaneAUTDecreaseRegime,			name = _('Throttle Step Down'),			category = _('Flight Control')},

-- Systems
{down = iCommandPowerOnOff,					name = _('Electric Power Switch'),		category = _('Systems')},
{down = iCommandPlaneAirBrake,				name = _('Airbrake'),					category = _('Systems') , features = {"airbrake"}},
{down = iCommandPlaneAirBrakeOn,			name = _('Airbrake On'),				category = _('Systems') , features = {"airbrake"}},
{down = iCommandPlaneAirBrakeOff,			name = _('Airbrake Off'),				category = _('Systems') , features = {"airbrake"}},
{down = iCommandPlaneWingtipSmokeOnOff,		name = _('Smoke'),						category = _('Systems')},
{down = iCommandPlaneCockpitIllumination,	name = _('Illumination Cockpit'),		category = _('Systems')},
{down = iCommandPlaneLightsOnOff,			name = _('Navigation lights'),			category = _('Systems')},
{down = iCommandPlaneHeadLightOnOff,		name = _('Gear Light Near/Far/Off'),	category = _('Systems')},
{down = iCommandPlaneFlaps,					name = _('Flaps Up/Down'),				category = _('Systems')},
{down = iCommandPlaneFlapsOn,				name = _('Flaps Landing Position'),		category = _('Systems')},
{down = iCommandPlaneFlapsOff,				name = _('Flaps Up'),					category = _('Systems')},
{down = iCommandPlaneGear,					name = _('Landing Gear Up/Down'),		category = _('Systems')},
{down = iCommandPlaneGearUp,				name = _('Landing Gear Up'),			category = _('Systems')},
{down = iCommandPlaneGearDown,				name = _('Landing Gear Down'),			category = _('Systems')},
{down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff,			name = _('Wheel Brake On'),		category = _('Systems')},
{down = iCommandPlaneFonar,					name = _('Canopy Open/Close'),			category = _('Systems')},
{down = iCommandPlaneParachute,				name = _('Dragging Chute'),				category = _('Systems'),	features = {"dragchute"}},
{down = iCommandPlaneResetMasterWarning,	name = _('Audible Warning Reset'),		category = _('Systems')},
{down = iCommandPlaneJettisonWeapons,up = iCommandPlaneJettisonWeaponsUp,	name = _('Weapons Jettison'),	category = _('Systems')},
{down = iCommandPlaneEject,					name = _('Eject (3 times)'),			category = _('Systems')},
{down = iCommandFlightClockReset,			name = _('Flight Clock Start/Stop/Reset'),						category = _('Systems') , features = {"flightclock"}},
{down = iCommandClockElapsedTimeReset,		name = _('Elapsed Time Clock Start/Stop/Reset'),				category = _('Systems') , features = {"flightclock"}},
{down = iCommandEnginesStart,				name = _('Engines Start'),				category = _('Systems')},
{down = iCommandEnginesStop,				name = _('Engines Stop'),				category = _('Systems')},
{down = iCommandBrightnessILS,				name = _('HUD Color'),					category = _('Systems') , features = {"HUDcolor"}},
{pressed = iCommandHUDBrightnessUp,			name = _('HUD Brightness up'),			category = _('Systems') , features = {"HUDbrightness"}},
{pressed = iCommandHUDBrightnessDown,		name = _('HUD Brightness down'),		category = _('Systems') , features = {"HUDbrightness"}},
{down = iCommandPlaneFuelOn,	up = iCommandPlaneFuelOff,					name = _('Fuel Dump'),			category = _('Systems') , features = {"fueldump"}},



{pressed = iCommandAltimeterPressureIncrease,	up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Increase'), category = _('Systems')},
{pressed = iCommandAltimeterPressureDecrease, up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Decrease'), category = _('Systems')},


-- Modes
{down = iCommandPlaneChangeTarget,		name = _('Next Waypoint, Airfield Or Target'),		category = _('Modes')},
{down = iCommandPlaneUFC_STEER_DOWN,	name = _('Previous Waypoint, Airfield Or Target'),	category = _('Modes')},
{down = iCommandPlaneModeNAV,			name = _('(1) Navigation Modes'),					category = _('Modes')},

-- Weapons
--{combos = defaultDeviceAssignmentFor("fire"),	down = iCommandPlaneFire, up = iCommandPlaneFireOff, name = _('Weapon Fire'),	category = _('Weapons')},


-- Countermeasures
{down = iCommandPlaneDropSnar,		name = _('Countermeasures Continuously Dispense'),	category = _('Countermeasures') , features = {"Countermeasures"}},
{down = iCommandPlaneDropSnarOnce,	up = iCommandPlaneDropSnarOnceOff,	name = _('Countermeasures Release'),	category = _('Countermeasures') , features = {"Countermeasures"}},
{down = iCommandPlaneDropFlareOnce, name = _('Countermeasures Flares Dispense'),		category = _('Countermeasures') , features = {"Countermeasures"}},
{down = iCommandPlaneDropChaffOnce, name = _('Countermeasures Chaff Dispense'),			category = _('Countermeasures') , features = {"Countermeasures"}},
--{down = iCommandActiveJamming,		name = _('ECM'),									category = _('Countermeasures') , features = {"ECM"}},

-- Communications
{down = iCommandAWACSTankerBearing, name = _('Request AWACS Available Tanker'), category = _('Communications')},
{down = iCommandToggleReceiveMode,	name = _('Receive Mode'),					category = _('Communications')},

-- Cockpit Camera Motion
{down = iCommandViewLeftMirrorOn,	up = iCommandViewLeftMirrorOff,		name = _('Mirror Left On'),		category = _('View Cockpit') , features = {"Mirrors"}},
{down = iCommandViewRightMirrorOn,	up = iCommandViewRightMirrorOff,	name = _('Mirror Right On'),	category = _('View Cockpit') , features = {"Mirrors"}},
{down = iCommandToggleMirrors,											name = _('Toggle Mirrors'),		category = _('View Cockpit') , features = {"Mirrors"}},

-- Auto Lock On
{down = iCommandAutoLockOnNearestAircraft,		name = _('Auto lock on nearest aircraft'),			category = _('Simplifications')},
{down = iCommandAutoLockOnCenterAircraft,		name = _('Auto lock on center aircraft'),			category = _('Simplifications')},
{down = iCommandAutoLockOnNextAircraft,			name = _('Auto lock on next aircraft'),				category = _('Simplifications')},
{down = iCommandAutoLockOnPreviousAircraft,		name = _('Auto lock on previous aircraft'),			category = _('Simplifications')},
{down = iCommandAutoLockOnNearestSurfaceTarget, name = _('Auto lock on nearest surface target'),	category = _('Simplifications')},
{down = iCommandAutoLockOnCenterSurfaceTarget,	name = _('Auto lock on center surface target'),		category = _('Simplifications')},
{down = iCommandAutoLockOnNextSurfaceTarget,	name = _('Auto lock on next surface target'),		category = _('Simplifications')},
{down = iCommandAutoLockOnPreviousSurfaceTarget, name = _('Auto lock on previous surface target'),	category = _('Simplifications')},

--Custom Category
{down = iCommandPlaneRightMFD_OSB5_Off,			name = _('Flood/Instrument lights toggle'),		category =_('Systems')},--CommandNr. 1011
{down = iCommandPlaneLeftMFD_DSP_Increase,		name = _('Rocket-Motor engage'),				category = _('Special')},--iCommandPlaneLeftMFD_DSP_Increase	664
--Gunpipper Commands
{down = Keys.GunPipper_Up,			name = _('Crosshairs-Up'),			category = _('Gunpipper')},
{down = Keys.GunPipper_Down,			name = _('Crosshairs-Down'),			category = _('Gunpipper')},
{down = Keys.GunPipper_Right,			name = _('Crosshairs-Right'),			category = _('Gunpipper')},
{down = Keys.GunPipper_Left,			name = _('Crosshairs-Left'),			category = _('Gunpipper')},
{down = Keys.GunPipper_Center,			name = _('Crosshairs-Center'),			category = _('Gunpipper')},
{down = Keys.GunPipper_Automatic,		name = _('Crosshairs-Automatic'),		category = _('Gunpipper')},
})

-- joystick axes
join(res.axisCommands,{
{action = iCommandPlaneSelecterHorizontalAbs, name = _('TDC Slew Horizontal')},
{action = iCommandPlaneSelecterVerticalAbs	, name = _('TDC Slew Vertical')},
{action = iCommandPlaneRadarHorizontalAbs	, name = _('Radar Horizontal')},
{action = iCommandPlaneRadarVerticalAbs		, name = _('Radar Vertical')},

{action = iCommandPlaneMFDZoomAbs 			, name = _('MFD Range')},
{action = iCommandPlaneBase_DistanceAbs 	, name = _('Base/Distance')},

{action = iCommandWheelBrake,		name = _('Wheel Brake')},
{action = iCommandLeftWheelBrake,	name = _('Wheel Brake Left')},
{action = iCommandRightWheelBrake,	name = _('Wheel Brake Right')},

{action = iCommandPlaneThrustLeft,			name = _('Thrust Left')},
{action = iCommandPlaneThrustRight,			name = _('Thrust Right')},

{combos = defaultDeviceAssignmentFor("roll"),	action = iCommandPlaneRoll,			name = _('Roll')},
{combos = defaultDeviceAssignmentFor("pitch"),	action = iCommandPlanePitch,		name = _('Pitch')},
{combos = defaultDeviceAssignmentFor("rudder"),	action = iCommandPlaneRudder,		name = _('Rudder')},
{combos = defaultDeviceAssignmentFor("thrust"),	action = iCommandPlaneThrustCommon, name = _('Thrust')},




})
return res
