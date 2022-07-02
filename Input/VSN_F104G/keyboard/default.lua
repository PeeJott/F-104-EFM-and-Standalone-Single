local cscripts = folder.."../../../Cockpit/Scripts/"
dofile(cscripts.."devices.lua")
dofile(cscripts.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_keyboard_binding.lua")

join(res.keyCommands,{
-- General (Gameplay)
{combos = {{key = 'U'}},							down = iCommandPlaneShipTakeOff,			name = _('Ship Take Off Position'),		category = _('General') , features = {"shiptakeoff"}},
{combos = {{key = 'P', reformers = {'RShift'}}},	down = iCommandCockpitShowPilotOnOff,		name = _('Show Pilot Body'),			category = _('General')},

-- Flight Control
{combos = {{key = 'Up'}},		down = iCommandPlaneUpStart,			up = iCommandPlaneUpStop,			name = _('Aircraft Pitch Down'),	category = _('Flight Control')},
{combos = {{key = 'Down'}},		down = iCommandPlaneDownStart,			up = iCommandPlaneDownStop,			name = _('Aircraft Pitch Up'),		category = _('Flight Control')},
{combos = {{key = 'Left'}},		down = iCommandPlaneLeftStart,			up = iCommandPlaneLeftStop,			name = _('Aircraft Bank Left'),		category = _('Flight Control')},
{combos = {{key = 'Right'}},	down = iCommandPlaneRightStart,			up = iCommandPlaneRightStop,		name = _('Aircraft Bank Right'),	category = _('Flight Control')},
{combos = {{key = 'Z'}},		down = iCommandPlaneLeftRudderStart,	up = iCommandPlaneLeftRudderStop,	name = _('Aircraft Rudder Left'),	category = _('Flight Control')},
{combos = {{key = 'X'}},		down = iCommandPlaneRightRudderStart,	up = iCommandPlaneRightRudderStop,	name = _('Aircraft Rudder Right'),	category = _('Flight Control')},

{combos = {{key = '.', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimUp,			up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'),			category = _('Flight Control')},
{combos = {{key = ';', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimDown,		up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'),		category = _('Flight Control')},
{combos = {{key = ',', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimLeft,		up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'),	category = _('Flight Control')},
{combos = {{key = '/', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimRight,		up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'),	category = _('Flight Control')},
{combos = {{key = 'Z', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimLeftRudder,	up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'),		category = _('Flight Control')},
{combos = {{key = 'X', reformers = {'RCtrl'}}},	pressed = iCommandPlaneTrimRightRudder,	up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'),		category = _('Flight Control')},

{combos = {{key = 'PageUp'}}, down = iCommandPlaneAUTIncreaseRegime,                                name = _('Throttle Position - Increment'),                  category = {_('Flight Control')}},
{combos = {{key = 'PageDown'}}, down = iCommandPlaneAUTDecreaseRegime,                              name = _('Throttle Position - Decrement'),                  category = {_('Flight Control')}},
{combos = {{key = 'Num+'}}, pressed = iCommandThrottleIncrease, up = iCommandThrottleStop,          name = _('Throttle Position Continuous - Increase'),        category = {_('Flight Control')}},
{combos = {{key = 'Num-'}}, pressed = iCommandThrottleDecrease, up = iCommandThrottleStop,          name = _('Throttle Position Continuous - Decrease'),        category = {_('Flight Control')}},

-- Systems
{combos = {{key = 'L', reformers = {'RShift'}}},	down = iCommandPowerOnOff,					name = _('Electric Power Switch'),					category = _('Systems')},
{combos = {{key = 'B'}},							down = iCommandPlaneAirBrake,				name = _('Airbrake'),								category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'B', reformers = {'LShift'}}},	down = iCommandPlaneAirBrakeOn,				name = _('Airbrake On'),							category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'B', reformers = {'LCtrl'}}},		down = iCommandPlaneAirBrakeOff,			name = _('Airbrake Off'),							category = _('Systems') , features = {"airbrake"}},
{combos = {{key = 'T'}},							down = iCommandPlaneWingtipSmokeOnOff,		name = _('Smoke'),									category = _('Systems')},
{combos = {{key = 'L'}},							down = iCommandPlaneCockpitIllumination,	name = _('Illumination Cockpit'),					category = _('Systems')},
{combos = {{key = 'L', reformers = {'RCtrl'}}},		down = iCommandPlaneLightsOnOff,			name = _('Navigation lights'),						category = _('Systems')},
{combos = {{key = 'L', reformers = {'RAlt'}}},		down = iCommandPlaneHeadLightOnOff,			name = _('Gear Light Near/Far/Off'),				category = _('Systems')},
{combos = {{key = 'F'}},							down = iCommandPlaneFlaps,					name = _('Flaps Up/Down'),							category = _('Systems')},
{combos = {{key = 'F', reformers = {'LShift'}}},	down = iCommandPlaneFlapsOn,				name = _('Flaps Landing Position'),					category = _('Systems')},
{combos = {{key = 'F', reformers = {'LCtrl'}}},		down = iCommandPlaneFlapsOff,				name = _('Flaps Up'),								category = _('Systems')},
{combos = {{key = 'G'}},							down = iCommandPlaneGear,					name = _('Landing Gear Up/Down'),					category = _('Systems')},
{combos = {{key = 'G', reformers = {'LCtrl'}}},		down = iCommandPlaneGearUp,					name = _('Landing Gear Up'),						category = _('Systems')},
{combos = {{key = 'G', reformers = {'LShift'}}},	down = iCommandPlaneGearDown,				name = _('Landing Gear Down'),						category = _('Systems')},
{combos = {{key = 'W'}},							down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff, name = _('Wheel Brake On'),	category = _('Systems')},
{combos = {{key = 'C', reformers = {'LCtrl'}}},		down = iCommandPlaneFonar,					name = _('Canopy Open/Close'),						category = _('Systems')},
{combos = {{key = 'P'}},							down = iCommandPlaneParachute,				name = _('Dragging Chute'),							category = _('Systems') , features = {"dragchute"}},
{combos = {{key = 'N', reformers = {'RShift'}}},	down = iCommandPlaneResetMasterWarning,		name = _('Audible Warning Reset'),					category = _('Systems')},
{combos = {{key = 'W', reformers = {'LCtrl'}}},		down = iCommandPlaneJettisonWeapons,up = iCommandPlaneJettisonWeaponsUp, name = _('Weapons Jettison'), category = _('Systems')},
{combos = {{key = 'E', reformers = {'LCtrl'}}},		down = iCommandPlaneEject,					name = _('Eject (3 times)'),						category = _('Systems')},
{combos = {{key = 'C', reformers = {'RShift'}}},	down = iCommandFlightClockReset,			name = _('Flight Clock Start/Stop/Reset'),			category = _('Systems') , features = {"flightclock"}},
{combos = {{key = 'Home', reformers = {'RShift'}}}, down = iCommandEnginesStart,				name = _('Engines Start'),							category = _('Systems')},
{combos = {{key = 'End', reformers = {'RShift'}}},	down = iCommandEnginesStop,					name = _('Engines Stop'),							category = _('Systems')},
{combos = {{key = 'H', reformers = {'RCtrl'}}},		down = iCommandBrightnessILS,				name = _('HUD Color'),								category = _('Systems') , features = {"HUDcolor"}},
{combos = {{key = 'H', reformers = {'RCtrl','RShift'}}}, pressed = iCommandHUDBrightnessUp,		name = _('HUD Brightness up'),						category = _('Systems') , features = {"HUDbrightness"}},
{combos = {{key = 'H', reformers = {'RShift','RAlt'}}}, pressed = iCommandHUDBrightnessDown,	name = _('HUD Brightness down'),					category = _('Systems') , features = {"HUDbrightness"}},
{combos = {{key = 'R'}},							down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff, name = _('Fuel Dump'),					category = _('Systems') , features = {"fueldump"}},
{combos = {{key = 'R', reformers = {'LCtrl'}}}, 	down = iCommandPlaneAirRefuel, 				name = _('Refueling Boom'), 						category = _('Systems')},

{combos = {{key = '=', reformers = {'RShift'}}}, pressed = iCommandAltimeterPressureIncrease,	up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Increase'), category = _('Systems')},
{combos = {{key = '-', reformers = {'RShift'}}}, pressed = iCommandAltimeterPressureDecrease, up = iCommandAltimeterPressureStop, name = _('Altimeter Pressure Decrease'), category = _('Systems')},

-- Modes
{combos = {{key = '`', reformers = {'LCtrl'}}},		down = iCommandPlaneChangeTarget,			name = _('Next Waypoint, Airfield Or Target'),		category = _('Modes')},
{combos = {{key = '`', reformers = {'LShift'}}},	down = iCommandPlaneUFC_STEER_DOWN,			name = _('Previous Waypoint, Airfield Or Target'),	category = _('Modes')},
{combos = {{key = '1'}},							down = iCommandPlaneModeNAV,				name = _('(1) Navigation Modes'),					category = _('Modes')},

-- Weapons
--{combos = {{key = 'Space'}},					down = iCommandPlaneFire,	up = iCommandPlaneFireOff,	name = _('Weapon Fire'),		category = _('Weapons')},
{combos = {{key = 'D'}},						down = iCommandPlaneChangeWeapon,						name = _('Weapon Change'),		category = _('Weapons')},
{combos = {{key = 'C'}},						down = iCommandPlaneModeCannon,							name = _('Cannon'),				category = _('Weapons')},
--{combos = {{key = 'W', reformers = {'LAlt'}}},	down = iCommandPlaneLaunchPermissionOverride,			name = _('Launch Permission Override'), category = _('Weapons') , features = {"LaunchPermissionOverride"}},

--CUSTOM WEAPONs Keys :-)
{combos = {{key = 'Space', reformers = {'RShift'}}}, down = Keys.pickle_on,	up = Keys.pickle_off, name = _('Weapon Release'), category = _('Weapons')},
{combos = {{key = 'Space'}}, down = Keys.trigger_on,	up = Keys.trigger_off, name = _('Gun Trigger'), category = _('Weapons')},
{down = Keys.station_one,														name = _('Station Button One'), category = _('Weapons')},
{down = Keys.station_two,														name = _('Station Button Two'), category = _('Weapons')},
{down = Keys.station_three,														name = _('Station Button Three'), category = _('Weapons')},
{down = Keys.station_four,														name = _('Station Button Four'), category = _('Weapons')},
{down = Keys.station_five,														name = _('Station Button Five'), category = _('Weapons')},
{down = Keys.station_six,														name = _('Station Button Six'), category = _('Weapons')},
{down = Keys.station_seven,														name = _('Station Button Seven'), category = _('Weapons')},





-- Countermeasures
{combos = {{key = 'Q', reformers = {'LShift'}}},	down = iCommandPlaneDropSnar,			name = _('Countermeasures Continuously Dispense'),					category = _('Countermeasures') , features = {"Countermeasures"}},
{combos = {{key = 'Q'}},							down = iCommandPlaneDropSnarOnce, up = iCommandPlaneDropSnarOnceOff, name = _('Countermeasures Release'),	category = _('Countermeasures') , features = {"Countermeasures"}},
{combos = {{key = 'Delete'}},						down = iCommandPlaneDropFlareOnce,		name = _('Countermeasures Flares Dispense'),						category = _('Countermeasures') , features = {"Countermeasures"}},
{combos = {{key = 'Insert'}},						down = iCommandPlaneDropChaffOnce,		name = _('Countermeasures Chaff Dispense'),							category = _('Countermeasures') , features = {"Countermeasures"}},
--{combos = {{key = 'E'}},							down = iCommandActiveJamming,			name = _('ECM'),													category = _('Countermeasures') , features = {"ECM"}},

-- Communications
{combos = {{key = 'I', reformers = {'LWin'}}},											down = iCommandAWACSTankerBearing,	name = _('Request AWACS Available Tanker'),	category = _('Communications')},
{combos = {{key = '\\', reformers = {'RShift'}}, {key = 'M', reformers = {'RShift'}}},	down = iCommandToggleReceiveMode,	name = _('Receive Mode'),					category = _('Communications')},

-- Cockpit Camera Motion (Передвижение камеры в кабине)
{combos = {{key = 'N', reformers = {'RAlt'}}},	down = iCommandViewLeftMirrorOn ,	up = iCommandViewLeftMirrorOff ,	name = _('Mirror Left On'),		category = _('View Cockpit') , features = {"Mirrors"}},
{combos = {{key = 'M', reformers = {'RAlt'}}},	down = iCommandViewRightMirrorOn,	up = iCommandViewRightMirrorOff,	name = _('Mirror Right On'),	category = _('View Cockpit') , features = {"Mirrors"}},
{combos = {{key = 'M' }},						down = iCommandToggleMirrors,											name = _('Toggle Mirrors'),		category = _('View Cockpit') , features = {"Mirrors"}},

-- Auto Lock On
{combos = {{key = 'F5', reformers = {'RAlt'}}},		down = iCommandAutoLockOnNearestAircraft,		name = _('Auto lock on nearest aircraft'),			category = _('Simplifications')},
{combos = {{key = 'F6', reformers = {'RAlt'}}},		down = iCommandAutoLockOnCenterAircraft,		name = _('Auto lock on center aircraft'),			category = _('Simplifications')},
{combos = {{key = 'F7', reformers = {'RAlt'}}},		down = iCommandAutoLockOnNextAircraft,			name = _('Auto lock on next aircraft'),				category = _('Simplifications')},
{combos = {{key = 'F8', reformers = {'RAlt'}}},		down = iCommandAutoLockOnPreviousAircraft,		name = _('Auto lock on previous aircraft'),			category = _('Simplifications')},
{combos = {{key = 'F9', reformers = {'RAlt'}}},		down = iCommandAutoLockOnNearestSurfaceTarget,	name = _('Auto lock on nearest surface target'),	category = _('Simplifications')},
{combos = {{key = 'F10', reformers = {'RAlt'}}},	down = iCommandAutoLockOnCenterSurfaceTarget,	name = _('Auto lock on center surface target'),		category = _('Simplifications')},
{combos = {{key = 'F11', reformers = {'RAlt'}}},	down = iCommandAutoLockOnNextSurfaceTarget,		name = _('Auto lock on next surface target'),		category = _('Simplifications')},
{combos = {{key = 'F12', reformers = {'RAlt'}}},	down = iCommandAutoLockOnPreviousSurfaceTarget, name = _('Auto lock on previous surface target'),	category = _('Simplifications')},

-- Autopilot
{combos = {{key = 'A'}, {key = '1', reformers = {'LAlt'}}}, down = iCommandPlaneAutopilot, name = _('Autopilot - Attitude Hold'), category = _('Autopilot')},
{combos = {{key = 'H'}, {key = '2', reformers = {'LAlt'}}}, down = iCommandPlaneStabHbar, name = _('Autopilot - Altitude Hold'), category = _('Autopilot')},
{combos = {{key = '9', reformers = {'LAlt'}}}, down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'), category = _('Autopilot')},
{combos = {{key = '1', reformers = {'LCtrl'}}}, down = iCommandHelicopter_PPR_button_T_up, name = _('CAS Pitch'), category = _('Autopilot')},
{combos = {{key = '2', reformers = {'LCtrl'}}}, down = iCommandHelicopter_PPR_button_K_up, name = _('CAS Roll'), category = _('Autopilot')},
{combos = {{key = '3', reformers = {'LCtrl'}}}, down = iCommandHelicopter_PPR_button_H_up, name = _('CAS Yaw'), category = _('Autopilot')},

-- Flight Control
--{combos = {{key = 'T', reformers = {'LAlt'}}}, down = iCommandPlaneTrimOn, up = iCommandPlaneTrimOff, name = _('T/O Trim'), category = _('Flight Control')},

-- Systems
--{combos = {{key = 'R', reformers = {'LCtrl'}}}, down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = _('Systems')},
{combos = {{key = 'R', reformers = {'LAlt'}}}, down = iCommandPlaneJettisonFuelTanks, name = _('Jettison Fuel Tanks'), category = _('Systems')},
{combos = {{key = 'S'}}, down = iCommandPlane_HOTAS_NoseWheelSteeringButton, up = iCommandPlane_HOTAS_NoseWheelSteeringButton, name = _('Nose Gear Maneuvering Range'), category = _('Systems')},
{combos = {{key = 'Q', reformers = {'LAlt'}}}, down = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, up = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, name = _('Nose Wheel Steering'), category = _('Systems')},
{combos = {{key = 'A', reformers = {'LCtrl'}}}, down = iCommandPlaneWheelBrakeLeftOn, up = iCommandPlaneWheelBrakeLeftOff, name = _('Wheel Brake Left On/Off'), category = _('Systems')},
{combos = {{key = 'A', reformers = {'LAlt'}}}, down = iCommandPlaneWheelBrakeRightOn, up = iCommandPlaneWheelBrakeRightOff, name = _('Wheel Brake Right On/Off'), category = _('Systems')},
{combos = {{key = 'T', reformers = {'LShift'}}}, down = iCommandClockElapsedTimeReset, name = _('Elapsed Time Clock Start/Stop/Reset'), category = _('Systems')},
{combos = {{key = 'D', reformers = {'LShift'}}}, down = iCommandPlaneFSQuantityIndicatorSelectorMAIN, name = _('Fuel Quantity Selector'), category = _('Systems')},
{combos = {{key = 'D', reformers = {'LCtrl','LAlt'}}}, down = iCommandPlaneFSQuantityIndicatorTest, up = iCommandPlaneFSQuantityIndicatorTest, value_down = 1, value_up = 0, name = _('Fuel Quantity Test'), category = _('Systems')},
{combos = {{key = 'D', reformers = {'LAlt'}}}, down = iCommandPlaneFSQuantityIndicatorSelectorINT,	up = iCommandPlaneFSQuantityIndicatorSelectorINT, value_down = 1,  value_up = 0, 	name = _('Bingo Fuel Index, CW'),  category = _('Systems')},
{combos = {{key = 'D', reformers = {'LCtrl'}}}, down = iCommandPlaneFSQuantityIndicatorSelectorINT,	up = iCommandPlaneFSQuantityIndicatorSelectorINT, value_down = -1, value_up = 0, 	name = _('Bingo Fuel Index, CCW'), category = _('Systems')},
{combos = {{key = 'L', reformers = {'RCtrl','RAlt'}}}, down = iCommandPlaneAntiCollisionLights, name = _('Anti-collision lights'), category = _('Systems')},
{combos = {{key = 'G', reformers = {'LAlt'}}}, down = iCommandPlaneHook, name = _('Tail Hook'), category = _('Systems')},

-- Modes
{combos = {{key = '2'}}, down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
{combos = {{key = '3'}}, down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
{combos = {{key = '4'}}, down = iCommandPlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
{combos = {{key = '6'}}, down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode/FLOOD mode'), category = _('Modes')},
{combos = {{key = '7'}}, down = iCommandPlaneModeGround, name = _('(7) Air-To-Ground Mode'), category = _('Modes')},

-- Sensors


-- Important inputs for SimpleRadar
{combos = {{key = 'Enter'}}, down = iCommandPlane_LockOn_start, up = iCommandPlane_LockOn_finish, name = 'Target Lock', category = 'Sensors'},

{combos = {{key = ';'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
{combos = {{key = '.'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
{combos = {{key = ','}}, pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
{combos = {{key = '/'}}, pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},


-- end


-- Misc Switches Panel
{down = Keys.RadarTCPlanProfile, value_down = 1,                                              name = _('Radar Terrain Clearance - PLAN'),         category = {_('Instrument Panel'), _('Misc Switches Panel')}},
{down = Keys.RadarTCPlanProfile, value_down = 0,                                              name = _('Radar Terrain Clearance - PROFILE'),      category = {_('Instrument Panel'), _('Misc Switches Panel')}},
{down = Keys.RadarTCPlanProfile, value_down = -1,                                             name = _('Radar Terrain Clearance - PLAN/PROFILE'), category = {_('Instrument Panel'), _('Misc Switches Panel')}},
{down = Keys.RadarRangeLongShort, value_down = 1,                                             name = _('Radar Range - LONG'),                     category = {_('Instrument Panel'), _('Misc Switches Panel')}},
{down = Keys.RadarRangeLongShort, value_down = 0,                                             name = _('Radar Range - SHORT'),                    category = {_('Instrument Panel'), _('Misc Switches Panel')}},
{down = Keys.RadarRangeLongShort, value_down = -1,                                            name = _('Radar Range - LONG/SHORT'),               category = {_('Instrument Panel'), _('Misc Switches Panel')}},



-- Radar Control Panel
{down = Keys.RadarModeOFF,                  name = _('Radar Mode Selector Switch Knob - OFF'),               category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarModeSTBY,                 name = _('Radar Mode Selector Switch Knob - STANDBY'),           category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarModeSearch,               name = _('Radar Mode Selector Switch Knob - SEARCH'),            category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarModeTC,                   name = _('Radar Mode Selector Switch Knob - TERRAIN CLEARANCE'), category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarModeA2G,                  name = _('Radar Mode Selector Switch Knob - A2G'),               category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarMode,                     name = _('Radar Mode Selector Switch Knob Cycle'),               category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarModeCW,                   name = _('Radar Mode Selector Switch Knob - CW'),                category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarModeCCW,                  name = _('Radar Mode Selector Switch Knob - CCW'),               category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarAoAComp, value_down = 1,  name = _('Radar AoA Compensation Switch - ON'),                  category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarAoAComp, value_down = 0,  name = _('Radar AoA Compensation Switch - OFF'),                 category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarAoAComp, value_down = -1, name = _('Radar AoA Compensation Switch - ON/OFF'),              category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarVolume, value_down = 1,   name = _('Radar Obstacle Tone Volume Knob - Increase'),          category = {_('Left Console'), _('Radar Control Panel')}},
{down = Keys.RadarVolume, value_down = 0,   name = _('Radar Obstacle Tone Volume Knob - Decrease'),          category = {_('Left Console'), _('Radar Control Panel')}},

-- Radio
{down = Keys.COM1, up = Keys.COM1, name = _('PTT (AN/ARC-552 UHF)'), category = {_('Throttle'), _('HOTAS'), _('Communications')}, value_down =  1.0,		value_up = 0.0},
{down = Keys.COM2, up = Keys.COM2, name = _('PTT (EMERGENCY UHF)'), category = {_('Throttle'), _('HOTAS'), _('Communications')}, value_down =  1.0,		value_up = 0.0},

-- Electric System
{down = iCommandPowerBattery1,              up = iCommandPowerBattery1,             value_down =  1.0,		value_up = 0.0,     name = _('No. 1 Generator - On Reset'),     category = _('Electric')},
{down = iCommandPowerBattery1_Cover,        up = iCommandPowerBattery1_Cover,       value_down =  1.0,		value_up = 0.0,     name = _('No. 1 Generator - Cover'),        category = _('Electric')},
{down = iCommandPowerBattery2,              up = iCommandPowerBattery2,             value_down =  1.0,		value_up = 0.0,     name = _('No. 2 Generator - On Reset'), category = _('Electric')},
{down = iCommandPowerBattery2_Cover,        up = iCommandPowerBattery2_Cover,       value_down =  1.0,		value_up = 0.0,     name = _('No. 2 Generator - Cover'), category = _('Electric')},
{down = iCommandPowerGeneratorLeft,         up = iCommandPowerGeneratorLeft,        value_down =  1.0,		value_up = 0.0,     name = _('No. 1 Generator - Off'), category = _('Electric')},
{down = iCommandPowerGeneratorRight,        up = iCommandPowerGeneratorRight,       value_down =  1.0,		value_up = 0.0,     name = _('No. 2 Generator - Off'), category = _('Electric')},
{down = iCommandGroundPowerAC,              up = iCommandGroundPowerAC,             value_down =  1.0,		value_up = 0.0,     name = _('Hydraulic Driven Generator - Reset'), category = _('Electric')},
{down = iCommandElectricalPowerInverter,    up = iCommandElectricalPowerInverter,   value_down =  1.0,		value_up = 0.0,     name = _('Ram Air Turbine - Extend'), category = _('Electric')},

--iCommandGroundPowerDC	704
--iCommandGroundPowerDC_Cover	705
--iCommandPowerBattery1 706
--iCommandPowerBattery1_Cover 707
--iCommandPowerBattery2	708
--iCommandPowerBattery2_Cover 709
--iCommandGroundPowerAC 710
--iCommandPowerGeneratorLeft 711
--iCommandPowerGeneratorRight 712
--iCommandElectricalPowerInverter 713
--iCommandAPUGeneratorPower	1071


--{combos = {{key = 'Enter'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
--{combos = {{key = 'Back'}}, down = iCommandSensorReset, name = _('Radar - Return To Search/NDTWS'), category = _('Sensors')},
{down = iCommandRefusalTWS, name = _('Unlock TWS Target'), category = _('Sensors')},
{combos = {{key = 'I'}}, down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
{combos = {{key = 'I', reformers = {'RAlt'}}}, down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
{combos = {{key = 'I', reformers = {'RCtrl'}}}, down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
{combos = {{key = 'I', reformers = {'RShift'}}}, down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},
--{combos = {{key = ';'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
--{combos = {{key = '.'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
--{combos = {{key = ','}}, pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
--{combos = {{key = '/'}}, pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
{combos = {{key = ';', reformers = {'RShift'}}}, pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
{combos = {{key = '.', reformers = {'RShift'}}}, pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
{combos = {{key = ',', reformers = {'RShift'}}}, pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
{combos = {{key = '/', reformers = {'RShift'}}}, pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
{combos = {{key = '='}}, down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
{combos = {{key = '-'}}, down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
{combos = {{key = '-', reformers = {'RCtrl'}}}, down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
{combos = {{key = '=', reformers = {'RCtrl'}}}, down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
{combos = {{key = 'R', reformers = {'RShift'}}}, down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
{combos = {{key = ',', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
{combos = {{key = '.', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},
--{combos = {{key = 'Enter'}}, down = iCommandPlane_LockOn_start, up = iCommandPlane_LockOn_finish, name = 'Target Lock', category = 'Sensors'},
-- Weapons
{combos = {{key = 'V', reformers = {'LCtrl'}}}, down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
--{combos = {{key = 'Space', reformers = {'RAlt'}}}, down = iCommandPlanePickleOn,	up = iCommandPlanePickleOff, name = _('Weapon Release'), category = _('Weapons')},

--Special Category
{combos = {{key = 's', reformers = {'RAlt'}}}, down = iCommandPlaneRightMFD_OSB5_Off, name = _('Flood/Instrument lights toggle'), category =_('Systems')},--CommandNr. 1011
{combos = {{key = 'r', reformers = {'RAlt'}}}, down = iCommandPlaneLeftMFD_DSP_Increase, name = _('Rocket-Motor engage'), category = _('Special')},--Command Nr. 664

--Gunpipper Commands
{combos = {{key = 'ü', reformers = {'RAlt'}}},	down = Keys.GunPipper_Up,				name = _('Crosshairs-Up'),		category = _('Gunpipper')},
{combos = {{key = 'ä', reformers = {'RAlt'}}},	down = Keys.GunPipper_Down,				name = _('Crosshairs-Down'),	category = _('Gunpipper')},
{combos = {{key = '-', reformers = {'RAlt'}}},	down = Keys.GunPipper_Center,			name = _('Crosshairs-Center'),	category = _('Gunpipper')},
{combos = {{key = '.', reformers = {'RAlt'}}},	down = Keys.GunPipper_Automatic,		name = _('Crosshairs-Automatic'),	category = _('Gunpipper')},

--Improved Radar Commands
{down = Keys.RadarModeToggle,			name = _('Radar Mode Toggle'),			category = _('Improved Radar')},

{down = Keys.RadarRangeModeUp,				name = _('Radar Range Mode Up'),				category = _('Improved Radar')},
{down = Keys.RadarRangeModeDown,			name = _('Radar Range Mode Down'),			category = _('Improved Radar')},
{down = Keys.RadarRangeModeToggle,			name = _('Radar Range Mode Toggle'),			category = _('Improved Radar')},

--{down = Keys.RadarRangeGateUp,				name = _('Radar Range Gate Up'),				category = _('Improved Radar')},
--{down = Keys.RadarRangeGateDown,			name = _('Radar Range Gate Down'),			category = _('Improved Radar')},

{down = Keys.RadarElevUp,				name = _('Radar Elevation Up'),			category = _('Improved Radar')},
{down = Keys.RadarElevDown,				name = _('Radar Elevation Down'),		category = _('Improved Radar')},

{down = Keys.RadarClearanceUp,	    	name = _('Radar Clearance Plane Up'),	category = _('Improved Radar')},
{down = Keys.RadarClearanceDown,		name = _('Radar Clearance Plane Down'),	category = _('Improved Radar')},

{down = Keys.RadarMemoryUp,	        	name = _('Radar Memory Up'),	category = _('Improved Radar')},
{down = Keys.RadarMemoryDown,		name = _('Radar Memory Down'),	category = _('Improved Radar')},

{down = Keys.RadarIfGainUp,	    	name = _('Radar If Gain Up'),	category = _('Improved Radar')},
{down = Keys.RadarIfGainDown,		name = _('Radar If Gain Down'),	category = _('Improved Radar')},

-- iCommandPlaneRadarOnOff        86    -- power on/off
-- iCommandPlane_LockOn_start     509   -- to ACQUISITION 
-- iCommandPlane_LockOn_finish    510   -- to SCAN
-- iCommandPlaneRadarUp           90    -- increase TDC 
-- iCommandPlaneRadarDown         91    -- decrease TDC
-- iCommandPlaneRadarLeft         88    -- slew TDC left
-- iCommandPlaneRadarRight        89    -- slew TDC right

{down = iCommandPlane_LockOn_start, name = 'Lock On Start', category = 'Improved Radar'},
{down = iCommandPlane_LockOn_finish, name = 'Lock On Off', category = 'Improved Radar'},
{pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Improved Radar')},
{pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Improved Radar')},
--{pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Improved Radar')},
--{pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Improved Radar')},




})
return res
