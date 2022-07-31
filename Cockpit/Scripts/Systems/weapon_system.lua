dofile(LockOn_Options.script_path.."ElectricSystems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."avRadar/Device/radar_api.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.05
make_default_activity(update_time_step)

local sensor_data = get_base_data()


--dev:
--devices for direct weapon-usage
dev:listen_command(Keys.pickle_on)
dev:listen_command(Keys.pickle_off)
dev:listen_command(Keys.trigger_on)
dev:listen_command(Keys.trigger_off)
dev:listen_command(Keys.change_station)
dev:listen_command(Keys.station_one)
dev:listen_command(Keys.station_two)
dev:listen_command(Keys.station_three)
dev:listen_command(Keys.station_four)
dev:listen_command(Keys.station_five)
dev:listen_command(Keys.station_six)
dev:listen_command(Keys.station_seven)
-----------Armament Selector Switch---------
dev:listen_command(Keys.armSelSwitch_toggle)
dev:listen_command(Keys.armSelSwitch_GUN)
dev:listen_command(Keys.armSelSwitch_ROCKET)
dev:listen_command(Keys.armSelSwitch_MISSILE)
--------------------------------------------
----------MasterArm Switch------------------
dev:listen_command(Keys.masterArmSwitch_toggle)
dev:listen_command(Keys.masterArmSwitch_ARM)
dev:listen_command(Keys.masterArmSwitch_CAM)
dev:listen_command(Keys.masterArmSwitch_OFF)
-------------------------------------------
------------Bomb Release Switch------------
dev:listen_command(Keys.bombReleaseSwitch_toggle)
dev:listen_command(Keys.bombReleaseSwitch_AUTO)
dev:listen_command(Keys.bombReleaseSwitch_MANUAL)
-------------------------------------------
------------Bomb Arming Switch-------------
dev:listen_command(Keys.bombArmingSwitch_toggle)
dev:listen_command(Keys.bombArmingSwitch_NOSETAIL)
dev:listen_command(Keys.bombArmingSwitch_SAFE)
dev:listen_command(Keys.bombArmingSwitch_TAIL)
--------------------------------------------------
------------Special Stores Switch------------------
dev:listen_command(Keys.specialStoresSelector_toggle)
dev:listen_command(Keys.specialStoresSelector_SPLStores)
dev:listen_command(Keys.specialStoresSelector_SAFE)
dev:listen_command(Keys.specialStoresSelector_PylBombs)
dev:listen_command(Keys.specialStoresSelector_PylTanks)
dev:listen_command(Keys.specialStoresSelector_TipStores)
dev:listen_command(Keys.specialStoresSelector_UAR)
---------------------------------------------------
-----------Drop-Lock Switch------------------------
dev:listen_command(Keys.dropLockSwitch_toggle)
dev:listen_command(Keys.dropLockSwitch_SAFE)
dev:listen_command(Keys.dropLockSwitch_READY)




---------------------------alte Params----------------------------------
--local stt_azimuth_h 	= get_param_handle("RADAR_STT_AZIMUTH")
--local stt_elevation_h 	= get_param_handle("RADAR_STT_ELEVATION")
--local station_1_selector = get_param_handle("PYLON_ONE_SELECTOR_LIGHT")
--local station_2_selector = get_param_handle("PYLON_TWO_SELECTOR_LIGHT")
--local station_3_selector = get_param_handle("PYLON_THREE_SELECTOR_LIGHT")
--local station_4_selector = get_param_handle("PYLON_FOUR_SELECTOR_LIGHT")
--local station_5_selector = get_param_handle("PYLON_FIVE_SELECTOR_LIGHT")
--local station_6_selector = get_param_handle("PYLON_SIX_SELECTOR_LIGHT")
--local station_7_selector = get_param_handle("PYLON_SEVEN_SELECTOR_LIGHT")
---------------------------------------------------------------------------





local current_station = 0

local station_1 = 0
local station_2 = 0
local station_3 = 0
local station_4 = 0
local station_5 = 0
local station_6 = 0
local station_7 = 0

--target_range_param:set(800.0) --Target-Range auf 800m gesetzt

--gunpipper_auto_movement_side 	= 0.0
--gunpipper_auto_movement_updown	= 0.0


-------------Variables and initializing----
--Stations/Pylons----------
local station_ONE 		= 0
local station_TWO 		= 0
local station_THREE 	= 0
local station_FOUR		= 0
local station_FIVE		= 0
local station_SIX 		= 0
local station_SEVEN     = 0
----------------------------
--------Weapon Panel---------------
local arm_sel_position 			= 0
local master_arm_switch_pos 	= 0
local bomb_rel_switch_pos 		= 0
local bomb_arm_switch_pos 		= 0
local special_store_switch_pos 	= 0
local drop_lock_switch_pos 		= 0
-----------------------------------
-------Check Weapon on Rack--------
local usable weapon = 0
local usable pylon = 0
local desired_weapon = 0
local Aim9_fired = 0
local Hydra_two_fired = 0
local Hydra_six_fired = 0

local weapontype_on_station_1_L2 	= 0
local weapontype_on_station_1_L3 	= 0
local usable_weapon_station_1		= 0
local weapontype_on_station_2_L2 	= 0
local weapontype_on_station_2_L3 	= 0
local usable_weapon_station_2		= 0
local weapontype_on_station_3_L2 	= 0
local weapontype_on_station_3_L3 	= 0
local usable_weapon_station_3		= 0
local weapontype_on_station_4_L2 	= 0
local weapontype_on_station_4_L3	= 0
local usable_weapon_station_4		= 0
local weapontype_on_station_5_L2 	= 0
local weapontype_on_station_5_L3 	= 0
local usable_weapon_station_5		= 0
local weapontype_on_station_6_L2 	= 0
local weapontype_on_station_6_L3 	= 0
local usable_weapon_station_6		= 0
local weapontype_on_station_7_L2 	= 0
local weapontype_on_station_7_L3 	= 0
local usable_weapon_station_7		= 0
-----------------------------------
--local arm_sel_tgl = 0
--local GUN_selected = 0
--local MISSILE_selected = 0
--local ROCKET_selected = 0
-------------Params-----------------
local Station_One_Param			= get_param_handle("PYLON_ONE_SELECTOR_LIGHT")
local Station_Two_Param			= get_param_handle("PYLON_TWO_SELECTOR_LIGHT")
local Station_Three_Param		= get_param_handle("PYLON_THREE_SELECTOR_LIGHT")
local Station_Four_Param		= get_param_handle("PYLON_FOUR_SELECTOR_LIGHT")
local Station_Five_Param		= get_param_handle("PYLON_FIVE_SELECTOR_LIGHT")
local Station_Six_Param			= get_param_handle("PYLON_SIX_SELECTOR_LIGHT")
local Station_Seven_Param		= get_param_handle("PYLON_SEVEN_SELECTOR_LIGHT")
--WeaponSystem-Params
local ir_missile_lock_param = get_param_handle("WS_IR_MISSILE_LOCK")
local ir_missile_az_param = get_param_handle("WS_IR_MISSILE_TARGET_AZIMUTH")
local ir_missile_el_param = get_param_handle("WS_IR_MISSILE_TARGET_ELEVATION")
local ir_missile_des_az_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH")
local ir_missile_des_el_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION")
--Gunpipper Params (hier überflüssig??)
local gunpipper_sideways_automatic_param = get_param_handle("WS_GUN_PIPER_AZIMUTH")
local gunpipper_updown_automatic_param = get_param_handle("WS_GUN_PIPER_ELEVATION")
local target_range_param = get_param_handle("WS_TARGET_RANGE")
--Weapon Panel Params
local arm_Selector_switch_param = get_param_handle("ARMAMENT_SEL_SWITCH")
---------------------------
local master_arm_switch_param = get_param_handle("MASTER_ARM_SWITCH")
--------------------------
local bomb_am_release_switch_param = get_param_handle("BOMB_AM_REL_SWITCH")
-------------------------
local bomb_arming_switch_param	= get_param_handle("BOMB_ARM_SWITCH")


function keys_station_one(value)
	
	local info = dev:get_station_info(PYLON.LH_TIP)
	weapontype_on_station_1_L2 = info.weapon.level2
	weapontype_on_station_1_L3 = info.weapon.level3
	
	if(weapontype_on_station_1_L2 == 4.0) then
		usable_weapon_station_1 = 0.0 -- 0.0 -> missiles
	--elseif(weapontype_on_station_1_L2 == 5.0) then
		--usable_weapon_station_1 = 1.5 -- 1.5 -> bombs
	--elseif(weapontype_on_station_1_L3 == 33) then
		--usable_weapon_station_1 = 1.0 -- 1.0 -> rockets
	elseif(weapontype_on_station_1_L3 == 43) then
		usable_weapon_station_1 = 2.0 -- 2.0 -> Fueltank
	else
		usable_weapon_station_1 = 7.0 -- 7.0 -> NIX!
	end
	
	if station_ONE == 0 and info.count > 0 then
		station_ONE = 1
		Station_One_Param:set(1)
	else
		station_ONE = 0
		Station_One_Param:set(0)
	end
	
	if(usable_weapon_station_1 == 0.0)  then
		current_station = GetNextStation()
		dev:select_station(current_station)
	elseif((usable_weapon_station_1 == 1.0) or (usable_weapon_station_1 == 1.5))then
		dev:select_station(PYLON.LH_TIP)
		print_message_to_user("Station LH-TIP selected")
	end
	
end

function keys_station_two(value)
	
	local info = dev:get_station_info(PYLON.LH_PYLON)
	weapontype_on_station_2_L2 = info.weapon.level2
	weapontype_on_station_2_L3 = info.weapon.level3
	
	if(weapontype_on_station_2_L2 == 4.0) then
		usable_weapon_station_2 = 0.0 -- 0.0 -> missiles
	elseif(weapontype_on_station_2_L2 == 5.0) then
		usable_weapon_station_2 = 1.5 -- 1.5 -> bombs
	elseif(weapontype_on_station_2_L3 == 33) then
		usable_weapon_station_2 = 1.0 -- 1.0 -> rockets
	elseif(weapontype_on_station_2_L3 == 43) then
		usable_weapon_station_2 = 2.0 -- 2.0 -> Fueltank
	else
		usable_weapon_station_2 = 7.0 -- 7.0 -> NIX!
	end 
	
	if station_TWO == 0 and info.count > 0 then
		station_TWO = 1
		Station_Two_Param:set(1)
	else
		station_TWO = 0
		Station_Two_Param:set(0)
	end
	
	
	
	if(usable_weapon_station_2 == 0.0) then
		current_station = GetNextStation()
		dev:select_station(current_station)
	elseif((usable_weapon_station_2 == 1.0) or (usable_weapon_station_2 == 1.5)) then
		dev:select_station(PYLON.LH_PYLON)
		print_message_to_user("Station LH-PYLON selected")
	end
end

function keys_station_three(value)

	local info = dev:get_station_info(PYLON.LH_FUS)
	weapontype_on_station_3_L2 = info.weapon.level2
	weapontype_on_station_3_L3 = info.weapon.level3
	
	if(weapontype_on_station_3_L2 == 4.0) then
		usable_weapon_station_3 = 0.0 -- 0.0 -> missiles
	elseif(weapontype_on_station_3_L2 == 5.0) then
		usable_weapon_station_3 = 1.5 -- 1.5 -> bombs
	elseif(weapontype_on_station_3_L3 == 33) then
		usable_weapon_station_3 = 1.0 -- 1.0 -> rockets
	elseif(weapontype_on_station_3_L3 == 43) then
		usable_weapon_station_3 = 2.0 -- 2.0 -> Fueltank
	else
		usable_weapon_station_3 = 7.0 -- 7.0 -> NIX!
	end
	
	if station_THREE == 0 and info.count > 0 then
		station_THREE = 1
		Station_Three_Param:set(1)
	else
		station_THREE = 0
		Station_Three_Param:set(0)
	end
	
	if((usable_weapon_station_3 == 0.0) or (usable_weapon_station_3 == 1.5)) then
		current_station = GetNextStation()
		dev:select_station(current_station)
	elseif(usable_weapon_station_3 == 1.0) then
		dev:select_station(PYLON.LH_FUS)
		print_message_to_user("Station LH-FUS selected")
	end
end

function keys_station_four(value)
	
	local info = dev:get_station_info(PYLON.CENTERLINE)
	weapontype_on_station_4_L2 = info.weapon.level2
	weapontype_on_station_4_L3 = info.weapon.level3
	
	if(weapontype_on_station_4_L2 == 4.0) then
		usable_weapon_station_4 = 0.0 -- 0.0 -> missiles
	elseif(weapontype_on_station_4_L2 == 5.0) then
		usable_weapon_station_4 = 1.5 -- 1.5 -> bombs
	elseif(weapontype_on_station_4_L3 == 33) then
		usable_weapon_station_4 = 1.0 -- 1.0 -> rockets
	elseif(weapontype_on_station_4_L3 == 43) then
		usable_weapon_station_4 = 2.0 -- 2.0 -> Fueltank
	else
		usable_weapon_station_4 = 7.0 -- 7.0 -> NIX!
	end
	
	if station_FOUR == 0 and info.count > 0 then
		station_FOUR = 1
		Station_Three_Param:set(1)
		Station_Five_Param:set(1)
	else
		station_FOUR = 0
		Station_Three_Param:set(0)
		Station_Five_Param:set(0)
	end

	if(usable_weapon_station_4 == 0.0)  then
		current_station = GetNextStation()
		dev:select_station(current_station)
	elseif((usable_weapon_station_4 == 1.0) or (usable_weapon_station_4 == 1.5))then
		dev:select_station(PYLON.CENTERLINE)
		print_message_to_user("Station CENTERLINE selected")
	end
end

function keys_station_five(value)

	local info = dev:get_station_info(PYLON.RH_FUS)
	weapontype_on_station_5_L2 = info.weapon.level2
	weapontype_on_station_5_L3 = info.weapon.level3
	
	if(weapontype_on_station_5_L2 == 4.0) then
		usable_weapon_station_5 = 0.0 -- 0.0 -> missiles
	elseif(weapontype_on_station_5_L2 == 5.0) then
		usable_weapon_station_5 = 1.5 -- 1.5 -> bombs
	elseif(weapontype_on_station_5_L3 == 33) then
		usable_weapon_station_5 = 1.0 -- 1.0 -> rockets
	elseif(weapontype_on_station_5_L3 == 43) then
		usable_weapon_station_5 = 2.0 -- 2.0 -> Fueltank
	else
		usable_weapon_station_5 = 7.0 -- 7.0 -> NIX!
	end
	
	if station_FIVE == 0 and info.count > 0 then
		station_FIVE = 1
		Station_Five_Param:set(1)
	else
		station_FIVE = 0
		Station_Five_Param:set(0)
	end
	
	if(usable_weapon_station_5 == 0.0) then
		current_station = GetNextStation()
		dev:select_station(current_station)
	elseif((usable_weapon_station_5 == 1.0)  or (usable_weapon_station_5 == 1.5))then
		dev:select_station(PYLON.RH_FUS)
		print_message_to_user("Station RH-FUS selected")
	end
end

function keys_station_six(value)

	local info = dev:get_station_info(PYLON.RH_PYLON)
	weapontype_on_station_6_L2 = info.weapon.level2
	weapontype_on_station_6_L3 = info.weapon.level3
	
	if(weapontype_on_station_6_L2 == 4.0) then
		usable_weapon_station_6 = 0.0 -- 0.0 -> missiles
	elseif(weapontype_on_station_6_L2 == 5.0) then
		usable_weapon_station_6 = 1.5 -- 1.5 -> bombs
	elseif(weapontype_on_station_6_L3 == 33) then
		usable_weapon_station_6 = 1.0 -- 1.0 -> rockets
	elseif(weapontype_on_station_6_L3 == 43) then
		usable_weapon_station_6 = 2.0 -- 2.0 -> Fueltank
	else
		usable_weapon_station_6 = 7.0 -- 7.0 -> NIX!
	end
	
	if station_SIX == 0 and info.count > 0 then
		station_SIX = 1
		Station_Six_Param:set(1)
	else
		station_SIX = 0
		Station_Six_Param:set(0)
	end
	
	if(usable_weapon_station_6 == 0.0)  then
		current_station = GetNextStation()
		dev:select_station(current_station)
	elseif((usable_weapon_station_6 == 1.0) or (usable_weapon_station_6 == 1.5))then
		dev:select_station(PYLON.RH_PYLON)
		print_message_to_user("Station RH-PYLON selected")
	end
end

function keys_station_seven(value)

	local info = dev:get_station_info(PYLON.RH_TIP)
	weapontype_on_station_7_L2 = info.weapon.level2
	weapontype_on_station_7_L3 = info.weapon.level3
	
	if(weapontype_on_station_5_L2 == 4.0) then
		usable_weapon_station_5 = 0.0 -- 0.0 -> missiles
	elseif(weapontype_on_station_5_L3 == 43) then
		usable_weapon_station_5 = 2.0 -- 2.0 -> Fueltank
	else
		usable_weapon_station_5 = 7.0 -- 7.0 -> NIX!
	end
	
	if station_SEVEN == 0 and info.count > 0 then
		station_SEVEN = 1
		Station_Seven_Param:set(1)
	else
		station_SEVEN = 0
		Station_Seven_Param:set(0)
	end
	
	if(usable_weapon_station_7 == 0.0)  then
		current_station = GetNextStation()
		dev:select_station(current_station)
	elseif((usable_weapon_station_7 == 1.0) or (usable_weapon_station_7 == 1.5))then
		dev:select_station(PYLON.RH_TIP)
		print_message_to_user("Station RH-TIP selected")
	end
end

function keys_change_station(value)
	-- Not implemented
end

function keys_pickle_on(value)
	
	if ((electric_system_api.emergency_ac_bus:get() == 1.0) and
		(bomb_arm_switch_pos ~= 0.5) and (master_arm_switch_pos == 1.0))then
        usable_weapon(1.5)
	end
	
	--dev:launch_station(current_station)
	
	--UpdateSelectorButtons()
	
	--current_station = GetNextStation()
	--dev:select_station(current_station)


    --dev:drop_flare(1, 1)
	
end

function release_weapon()

	dev:launch_station(current_station)
	
	UpdateSelectorButtons()
	
	current_station = GetNextStation()
	dev:select_station(current_station)

end

function keys_trigger_on(value)

if(master_arm_switch_pos == 1.0) then
	if ((electric_system_api.emergency_ac_bus:get() == 1.0) and
		(arm_sel_position == 0.5))then    -- -> Gun
        dispatch_action(nil, Keys.iCommandPlaneFire)
	end
	
	if(electric_system_api.emergency_ac_bus:get() == 1.0 and
		arm_sel_position == 0.0)then -- -> Missiles
		usable_weapon(0.0)
    end
	
	if(electric_system_api.emergency_ac_bus:get() == 1.0 and
		arm_sel_position == 1.0)then -- -> Rockets
		usable_weapon(1.0)
    end
end

	
end

function keys_trigger_off(value)
    dispatch_action(nil, Keys.iCommandPlaneFireOff)
	
	Aim9_fired = 0.0
end

function usable_weapon(wp)

	local launched_weapon = wp
	
--Weapon-Types -> 0.0 = Misslies; 0.5 = GUN; 1.0 = Rocket; 1.5 = Bombs; 2.0 = Fueltank; 7.0 = NIX
	
	if((usable_weapon_station_1 == launched_weapon) and
		(station_ONE == 1.0) and (launched_weapon == 0.0) and (Aim9_fired == 0.0))then
		release_weapon()
		Aim9_fired = 1.0
		return
	elseif((usable_weapon_station_1 == launched_weapon) and
		(station_ONE == 1.0) and ((launched_weapon == 1.0) or (launched_weapon == 1.5)))then
		release_double_station()
	end
	
	if((usable_weapon_station_2 == launched_weapon) and
		(station_TWO == 1.0) and (launched_weapon == 0.0) and (Aim9_fired == 0.0))then
		release_weapon()
		Aim9_fired = 1.0
		return
	elseif((usable_weapon_station_2 == launched_weapon) and
		(station_TWO == 1.0) and ((launched_weapon == 1.0) or (launched_weapon == 1.5)))then
		release_double_station()
	end
	
	if((usable_weapon_station_3 == launched_weapon) and
		(station_THREE == 1.0) and (launched_weapon == 0.0)and (Aim9_fired == 0.0))then
		release_weapon()
		Aim9_fired = 1.0
		return
	elseif((usable_weapon_station_3 == launched_weapon) and
		(station_THREE == 1.0) and ((launched_weapon == 1.0) or (launched_weapon == 1.5)))then
		release_double_station()
	end
	
	if((usable_weapon_station_4 == launched_weapon) and
		(station_FOUR == 1.0) and (launched_weapon == 0.0)and (Aim9_fired == 0.0))then
		release_weapon()
		Aim9_fired = 1.0
		return
	elseif((usable_weapon_station_4 == launched_weapon) and
		(station_FOUR == 1.0) and ((launched_weapon == 1.0) or (launched_weapon == 1.5)))then
		release_double_station()
	end
	
	if((usable_weapon_station_5 == launched_weapon) and
		(station_FIVE == 1.0) and (launched_weapon == 0.0) and (Aim9_fired == 0.0))then
		release_weapon()
		Aim9_fired = 1.0
		return
	elseif((usable_weapon_station_5 == launched_weapon) and
		(station_FIVE == 1.0) and ((launched_weapon == 1.0) or (launched_weapon == 1.5)))then
		release_double_station()
	end
	
	if((usable_weapon_station_6 == launched_weapon) and
		(station_SIX == 1.0) and (launched_weapon == 0.0)and (Aim9_fired == 0.0))then
		release_weapon()
		Aim9_fired = 1.0		
		return
	elseif((usable_weapon_station_6 == launched_weapon) and
		(station_SIX == 1.0) and ((launched_weapon == 1.0) or (launched_weapon == 1.5)))then
		release_double_station()
	end
	
	if((usable_weapon_station_7 == launched_weapon) and
		(station_SEVEN == 1.0) and (Aim9_fired == 0.0))then
		release_weapon()
		Aim9_fired = 1.0		
		return
	end
end

----------!!! Weapon Panel functions!!----------------------
----------Armament Selector Switch functions----------------
function keys_armSelSwitch_tgl(value)

	--Positions -> animation Arg-Values to make life easier
	-- Missiles = 0.0; GUN = 0.5, ROCKET = 1.0
	if(arm_sel_position == 0.0) then
		arm_sel_position = 0.5
		arm_Selector_switch_param:set(arm_sel_position)
		print_message_to_user("Arm-Sel is in position GUN.")
		arm_Selector_switch_param:set(arm_sel_position)--workaround for drifting animation
	elseif(arm_sel_position == 0.5) then
		arm_sel_position = 1.0
		arm_Selector_switch_param:set(arm_sel_position)
		print_message_to_user("Arm-Sel is in position ROCKET.")
	else
		arm_sel_position = 0.0
		arm_Selector_switch_param:set(arm_sel_position)
		print_message_to_user("Arm-Sel is in position MISSILE.")
	end
	
end


function keys_armSelSwitch_msl(value)
	
	arm_sel_position = 0.0
	arm_Selector_switch_param:set(arm_sel_position)
	print_message_to_user("Arm-Sel is in position MISSILE.")

end

function keys_armSelSwitch_gun(value)

	arm_sel_position = 0.5
	arm_Selector_switch_param:set(arm_sel_position)
	print_message_to_user("Arm-Sel is in position GUN.")
	arm_Selector_switch_param:set(arm_sel_position) --workaround for drifting animation

end

function keys_armSelSwitch_rkt(value)

	arm_sel_position = 1.0
	arm_Selector_switch_param:set(arm_sel_position)
	print_message_to_user("Arm-Sel is in position ROCKET.")

end
-------------------------------------------------------------

--------------------Master Arm Switch functions----------------
function keys_masterArmSwitch_toggle(value)
--Position -> 0.0 = CAM, 0.5 = OFF, 1.0 = ARM+CAM

	if(master_arm_switch_pos == 0.0) then
		master_arm_switch_pos = 0.5
		master_arm_switch_param:set(master_arm_switch_pos)
		print_message_to_user("Master Arms set to OFF.")
	elseif(master_arm_switch_pos == 0.5) then
		master_arm_switch_pos = 1.0
		master_arm_switch_param:set(master_arm_switch_pos)
		print_message_to_user("Master Arms set to ARM + CAM.")
	else
		master_arm_switch_pos = 0.0
		master_arm_switch_param:set(master_arm_switch_pos)
		print_message_to_user("Master Arms set to CAM.")
	end
	
end

function keys_masterArmSwitch_CAM(value)

	master_arm_switch_pos = 0.0
	master_arm_switch_param:set(master_arm_switch_pos)
	print_message_to_user("Master Arms set to CAM.")

end

function keys_masterArmSwitch_OFF(value)

	master_arm_switch_pos = 0.5
	master_arm_switch_param:set(master_arm_switch_pos)
	print_message_to_user("Master Arms set to CAM.")

end

function keys_masterArmSwitch_ARM(value)

	master_arm_switch_pos = 1.0
	master_arm_switch_param:set(master_arm_switch_pos)
	print_message_to_user("Master Arms set to ARM + CAM.")

end
----------------------------------------------------------
---------------------Bomb Release Switch------------------
function keys_bombReleaseSwitch_toggle(value)
-- Position 0.0 -> Manual; 1.0 -> AUTO
	if(bomb_rel_switch_pos == 0) then
		bomb_rel_switch_pos = 1
		bomb_am_release_switch_param:set(bomb_rel_switch_pos)
		print_message_to_user("Bomb Release Switch in Position AUTO") 
	else
		bomb_rel_switch_pos = 0
		print_message_to_user("Bomb Release Switch in Position MANUAL")
	end

end

function keys_bombReleaseSwitch_MANUAL(value)

	bomb_rel_switch_pos = 0
	bomb_am_release_switch_param:set(bomb_rel_switch_pos)
	print_message_to_user("Bomb Release Switch in Position MANUAL")

end

function keys_bombReleaseSwitch_AUTO(value)

	bomb_rel_switch_pos = 0
	print_message_to_user("Bomb Release Switch in Position MANUAL")

end
--------------------------------------------------------------------
---------------------Bomb Arming Switch-----------------------------
function keys_bombArmingSwitch_toggle(value)

--Bomb Arming Positions: 0.0 -> Tail; 0.5 ->SAFE; 1.0 -> NoseTail

	if(bomb_arm_switch_pos == 0) then
		bomb_arm_switch_pos = 0.5
		bomb_arming_switch_param:set(bomb_arm_switch_pos)
		print_message_to_user("Bomb Arm Switch in Position SAFE") 
	elseif(bomb_arm_switch_pos == 0.5) then
		bomb_arm_switch_pos = 1.0
		bomb_arming_switch_param:set(bomb_arm_switch_pos)
		print_message_to_user("Bomb Arm Switch in Position N/T")
	else
		bomb_arm_switch_pos = 0.0
		bomb_arming_switch_param:set(bomb_arm_switch_pos)
		print_message_to_user("Bomb Arm Switch in Position Tail Only")
	end

end

function keys_bombArmingSwitch_TAIL(value)

	bomb_arm_switch_pos = 0.0
	bomb_arming_switch_param:set(bomb_arm_switch_pos)
	print_message_to_user("Bomb Arm Switch in Position Tail Only")

end

function keys_bombArmingSwitch_SAFE(value)

	bomb_arm_switch_pos = 0.5
	bomb_arming_switch_param:set(bomb_arm_switch_pos)
	print_message_to_user("Bomb Arm Switch in Position SAFE")

end

function keys_bombArmingSwitch_NOSETAIL(value)

	bomb_arm_switch_pos = 1.0
	bomb_arming_switch_param:set(bomb_arm_switch_pos)
	print_message_to_user("Bomb Arm Switch in Position N/T")

end






command_table = {
    [Keys.pickle_on] 						= keys_pickle_on,
    [Keys.trigger_on] 						= keys_trigger_on,
    [Keys.trigger_off] 						= keys_trigger_off,
	[Keys.GunPipper_Automatic]				= keys_gunpipper_automatic,

	-- Weapon panel
	[Keys.station_one]						= keys_station_one,
	[Keys.station_two]						= keys_station_two,
	[Keys.station_three]					= keys_station_three,
	[Keys.station_four]						= keys_station_four,
	[Keys.station_five]						= keys_station_five,
	[Keys.station_six]						= keys_station_six,
	[Keys.station_seven]					= keys_station_seven,
	--[Keys.change_station]					= keys_change_station,
	--Armament Selector Switch
	[Keys.armSelSwitch_toggle]				= keys_armSelSwitch_tgl,
	[Keys.armSelSwitch_GUN]					= keys_armSelSwitch_gun,
	[Keys.armSelSwitch_ROCKET]				= keys_armSelSwitch_rkt,
	[Keys.armSelSwitch_MISSILE]				= keys_armSelSwitch_msl,
	--Master Arm Switch
	[Keys.masterArmSwitch_toggle]			= keys_masterArmSwitch_toggle,
	[Keys.masterArmSwitch_ARM]				= keys_masterArmSwitch_ARM,
	[Keys.masterArmSwitch_CAM]				= keys_masterArmSwitch_CAM,
	[Keys.masterArmSwitch_OFF]				= keys_masterArmSwitch_OFF,
	--Bomb amount release switch
	[Keys.bombReleaseSwitch_toggle] 		= keys_bombReleaseSwitch_toggle,
	[Keys.bombReleaseSwitch_AUTO]			= keys_bombReleaseSwitch_AUTO,
	[Keys.bombReleaseSwitch_MANUAL]			= keys_bombReleaseSwitch_MANUAL,
	--Bomb Arming Switch
	[Keys.bombArmingSwitch_toggle]			= keys_bombArmingSwitch_toggle,
	[Keys.bombArmingSwitch_NOSETAIL] 		= keys_bombArmingSwitch_NOSETAIL,
	[Keys.bombArmingSwitch_SAFE]			= keys_bombArmingSwitch_SAFE,
	[Keys.bombArmingSwitch_TAIL]			= keys_bombArmingSwitch_TAIL,
	--Special Stores Selector
	[Keys.specialStoresSelector_toggle]		= keys_specialStoresSelector_toggle,
	[Keys.specialStoresSelector_SPLStores]	= keys_specialStoresSelector_SPLStores,
	[Keys.specialStoresSelector_SAFE]		= keys_specialStoresSelector_SAFE,
	[Keys.specialStoresSelector_PylBombs]	= keys_specialStoresSelector_PylBombs,
	[Keys.specialStoresSelector_PylTanks]	= keys_specialStoresSelector_PylTanks,
	[Keys.specialStoresSelector_TipStores]	= keys_specialStoresSelector_TipStores,
	[Keys.specialStoresSelector_UAR]		= keys_specialStoresSelector_UAR,
	--DropLock-Switch
	[Keys.dropLockSwitch_toggle]			= keys_dropLockSwitch_toggle,
	[Keys.dropLockSwitch_SAFE]				= keys_dropLockSwitch_SAFE,
	[Keys.dropLockSwitch_READY]				= keys_dropLockSwitch_READY,
	
}

-- Use this function to disable the selector buttons after weapon release or jettison
function UpdateSelectorButtons()
	if (station_ONE == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.LH_TIP)
		if(info.count == 0) then
			station_ONE = 0
			Station_One_Param:set(0)
			usable_weapon_station_1 = 7.0 --set Weapon to NIX
		end
	end

	if (station_SEVEN == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_TIP)
		if(info.count == 0) then
			station_SEVEN = 0
			Station_Seven_Param:set(0)
			usable_weapon_station_7 = 7.0 --set Weapon to NIX
		end
	end

	if (station_THREE == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.LH_FUS)
		if(info.count == 0) then
			station_THREE = 0
			Station_Three_Param:set(0)
			usable_weapon_station_3 = 7.0 --set Weapon to NIX
		end
	end

	if (station_FIVE == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.RH_FUS)
		if(info.count == 0) then
			station_FIVE = 0
			Station_Five_Param:set(0)
			usable_weapon_station_5 = 7.0 --set Weapon to NIX
		end
	end

	if (station_TWO == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.LH_PYLON)
		if(info.count == 0) then
			station_TWO = 0
			Station_Two_Param:set(0)
			usable_weapon_station_2 = 7.0 --set Weapon to NIX
		end
	end

	if (station_SIX == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_PYLON)
		if(info.count == 0) then
			station_SIX = 0
			Station_Six_Param:set(0)
			usable_weapon_station_6 = 7.0 --set Weapon to NIX
		end
	end


end

-- Use this function to determine the next station that will be fired depeding on the order for the activated stations.
function GetNextStation()
	-- find the next active station 
	-- order for sidewinder is: LH tip, RH tip, LH fus, RH fus, assumed: LH pyl, RH pyl 	
	if (station_ONE == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.LH_TIP)
		if((info.count > 0) and ((usable_weapon_station_1 == 0.0) or (usable_weapon_station_1 == 1.5))) then
			print_message_to_user("Next station: PYLON.LH_TIP")
			return PYLON.LH_TIP		
		end
	end
	-- check RH tip active
	if (station_SEVEN == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_TIP)
		if((info.count > 0) and ((usable_weapon_station_7 == 0.0) or (usable_weapon_station_7 == 1.5))) then
			print_message_to_user("Next station: PYLON.RH_TIP")
			return PYLON.RH_TIP
		end
	end
	if (station_THREE == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.LH_FUS)
		if((info.count > 0) and ((usable_weapon_station_3 == 0.0) or (usable_weapon_station_3 == 1.5))) then
			print_message_to_user("Next station: PYLON.LH_FUS")
			return PYLON.LH_FUS
		end
	end
	if (station_FIVE == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.RH_FUS)
		if((info.count > 0) and ((usable_weapon_station_5 == 0.0) or (usable_weapon_station_5 == 1.5))) then
		print_message_to_user("Next station: PYLON.RH_FUS")
			return PYLON.RH_FUS
		end
	end

	if (station_TWO == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.LH_PYLON)
		if((info.count > 0) and ((usable_weapon_station_2 == 0.0) or (usable_weapon_station_2 == 1.5))) then
			print_message_to_user("Next station: PYLON.LH_PYLON")
			return PYLON.LH_PYLON
		end
	end

	if (station_SIX == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_PYLON)
		if((info.count > 0) and ((usable_weapon_station_6 == 0.0) or (usable_weapon_station_6 == 1.5))) then
			print_message_to_user("Next station: PYLON.RH_PYLON")
			return PYLON.RH_PYLON
		end
	end

	print_message_to_user("Next station: None")
	return 0
end
------------------------------------------------------------
function release_double_station()

	if(station_ONE == 1.0) then
	dev:select_station(PYLON.LH_TIP)
	dev:launch_station(PYLON.LH_TIP)
	end
	
	if((station_TWO == 1.0) and (usable_weapon_station_2 == 1.0) and (Hydra_two_fired == 0.0)) then
	dev:select_station(PYLON.LH_PYLON)
	dev:launch_station(PYLON.LH_PYLON)
	Hydra_two_fired = 1.0
	elseif((station_TWO == 1.0) and (usable_weapon_station_2 ~= 1.0))then
	dev:select_station(PYLON.LH_PYLON)
	dev:launch_station(PYLON.LH_PYLON)
	end
	
	if(station_THREE == 1.0) then
	dev:select_station(PYLON.LH_FUS)
	dev:launch_station(PYLON.LH_FUS)
	end
	
	if(station_FOUR == 1.0) then
	dev:select_station(PYLON.CENTERLINE)
	dev:launch_station(PYLON.CENTERLINE)
	end
	
	if(station_FIVE == 1.0) then
	dev:select_station(PYLON.RH_FUS)
	dev:launch_station(PYLON.RH_FUS)
	end
	
	if((station_SIX == 1.0) and (usable_weapon_station_6 == 1.0) and (Hydra_six_fired == 0.0)) then
	dev:select_station(PYLON.RH_PYLON)
	dev:launch_station(PYLON.RH_PYLON)
	Hydra_six_fired = 1.0
	elseif((station_SIX == 1.0) and (usable_weapon_station_6 ~= 1.0)) then
	dev:select_station(PYLON.RH_PYLON)
	dev:launch_station(PYLON.RH_PYLON)
	end
	
	if(station_SEVEN == 1.0) then
	dev:select_station(PYLON.RH_TIP)
	dev:launch_station(PYLON.RH_TIP)
	end
	
	UpdateSelectorButtons()
	Hydra_Trigger_Counter()
	
end

function Hydra_Trigger_Counter()

	if((Hydra_two_fired ~= 0.0) and (Hydra_two_fired < 15.0))then
		Hydra_two_fired = Hydra_two_fired + 1.0
	else
		Hydra_two_fired = 0.0
	end
	
	if((Hydra_six_fired ~= 0.0) and (Hydra_six_fired < 15.0))then
		Hydra_six_fired = Hydra_six_fired + 1.0
	else
		Hydra_six_fired = 0.0
	end
end



-------------Standard Device functions---------------- 

function SetCommand(command, value)

    if command_table[command] then
        command_table[command](value)
    end
end


function post_initialize()
    
	--dev:select_station(current_station)
	
	--print_message_to_user("Missile_Seeker_Elevation " ..tostring(ir_missile_des_el_param:get()))
	--print_message_to_user("Missile_Seeker_Azimuth " ..tostring(ir_missile_des_az_param:get()))

end

function on_launch(var)
	-- this is a callback function called after a weapon was launched. Might be useful in the future, e.g. to select the next station or reset the sidewinder flag.
    print_message_to_user("on_launch: " .. tostring(var) ..".")
end

function update()
		
 	local mode = radar_api.mode_h:get()	
	if mode == 3 then -- TRACKING
		local target_range = radar_api.stt_range_h:get()
		local target_az = radar_api.stt_azimuth_h:get()
		local target_el = radar_api.stt_elevation_h:get()

		-- Slew the seeker to the target
		-- This feature is most likely not available in a real F-104G
		--ir_missile_des_az_param:set(target_az)		
		--ir_missile_des_el_param:set(target_el)


		--gunpipper_sideways_automatic_param:set(ir_missile_des_az_param)
		--gunpipper_updown_automatic_param:set(target_el)

		-- Limit the range that is set to the weapon system to the maximum effective range of the gun
		-- If this is not done, the gun pipper will move strangely at it has a lot of lead for the long ranges.
		if target_range < 1200.0 then
			dev:set_target_range(target_range)
		else
			dev:set_target_range(1200.0)
		end
	else
		ir_missile_des_az_param:set(0.0)
		ir_missile_des_el_param:set(0.0)
		dev:set_target_range(1200.0)
	end
	
	--print_message_to_user("IR Missile got lock = " ..tostring(ir_missile_lock_param:get()))
    if ir_missile_lock_param:get() > 0.0 then --vorher if ir_lock:get() > 0 then 
        print_message_to_user("Missile Lock")

	end
end

need_to_be_closed = false