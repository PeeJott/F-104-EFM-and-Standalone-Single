dofile(LockOn_Options.script_path.."ElectricSystems/electric_system_api.lua")
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

dev:listen_command(Keys.station_one)
dev:listen_command(Keys.station_two)
dev:listen_command(Keys.station_three)
dev:listen_command(Keys.station_four)
dev:listen_command(Keys.station_five)
dev:listen_command(Keys.station_six)
dev:listen_command(Keys.station_seven)

dev:listen_command(Keys.change_station)


--WeaponSystem-Params
local ir_missile_lock_param = get_param_handle("WS_IR_MISSILE_LOCK")
local ir_missile_az_param = get_param_handle("WS_IR_MISSILE_TARGET_AZIMUTH")
local ir_missile_el_param = get_param_handle("WS_IR_MISSILE_TARGET_ELEVATION")
local ir_missile_des_az_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH")
local ir_missile_des_el_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION")
local stt_azimuth_h 	= get_param_handle("RADAR_STT_AZIMUTH")
local stt_elevation_h 	= get_param_handle("RADAR_STT_ELEVATION")
--local gunpipper_sideways_automatic_param = get_param_handle("WS_GUN_PIPER_AZIMUTH")
--local gunpipper_updown_automatic_param = get_param_handle("WS_GUN_PIPER_ELEVATION")
--local target_range_param = get_param_handle("WS_TARGET_RANGE")
local station_1_selector = get_param_handle("PYLON_ONE_SELECTOR_LIGHT")
local station_2_selector = get_param_handle("PYLON_TWO_SELECTOR_LIGHT")
local station_3_selector = get_param_handle("PYLON_THREE_SELECTOR_LIGHT")
local station_4_selector = get_param_handle("PYLON_FOUR_SELECTOR_LIGHT")
local station_5_selector = get_param_handle("PYLON_FIVE_SELECTOR_LIGHT")
local station_6_selector = get_param_handle("PYLON_SIX_SELECTOR_LIGHT")
local station_7_selector = get_param_handle("PYLON_SEVEN_SELECTOR_LIGHT")


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
local station_ONE 		= 0
local station_TWO 		= 0
local station_THREE 	= 0
local station_FOUR		= 0
local station_FIVE		= 0
local station_SIX 		= 0
local station_SEVEN     = 0

-------------Params-----------------
local Station_One_Param			= get_param_handle("PYLON_ONE_SELECTOR_LIGHT")
local Station_Two_Param			= get_param_handle("PYLON_TWO_SELECTOR_LIGHT")
local Station_Three_Param		= get_param_handle("PYLON_THREE_SELECTOR_LIGHT")
local Station_Four_Param		= get_param_handle("PYLON_FOUR_SELECTOR_LIGHT")
local Station_Five_Param		= get_param_handle("PYLON_FIVE_SELECTOR_LIGHT")
local Station_Six_Param			= get_param_handle("PYLON_SIX_SELECTOR_LIGHT")
local Station_Seven_Param		= get_param_handle("PYLON_SEVEN_SELECTOR_LIGHT")


function keys_station_one(value)
	
	local info = dev:get_station_info(PYLON.LH_TIP)
	if station_ONE == 0 and info.count > 0 then
		station_ONE = 1
		Station_One_Param:set(1)
	else
		station_ONE = 0
		Station_One_Param:set(0)
	end
		
	current_station = GetNextStation()
end

function keys_station_two(value)
	
	local info = dev:get_station_info(PYLON.LH_PYLON)
	if station_TWO == 0 and info.count > 0 then
		station_TWO = 1
		Station_Two_Param:set(1)
	else
		station_TWO = 0
		Station_Two_Param:set(0)
	end
	
	current_station = GetNextStation()
end

function keys_station_three(value)

	local info = dev:get_station_info(PYLON.LH_FUS)
	if station_THREE == 0 and info.count > 0 then
		station_THREE = 1
		Station_Three_Param:set(1)
	else
		station_THREE = 0
		Station_Three_Param:set(0)
	end
	
	current_station = GetNextStation()
end

function keys_station_four(value)
	
	local info = dev:get_station_info(PYLON.CENTERLINE)
	if station_FOUR == 0 and info.count > 0 then
		station_FOUR = 1
		Station_Three_Param:set(1)
		Station_Five_Param:set(1)
	else
		station_FOUR = 0
		Station_Three_Param:set(0)
		Station_Five_Param:set(0)
	end

	current_station = GetNextStation()
end

function keys_station_five(value)

	local info = dev:get_station_info(PYLON.RH_FUS)
	if station_FIVE == 0 and info.count > 0 then
		station_FIVE = 1
		Station_Five_Param:set(1)
	else
		station_FIVE = 0
		Station_Five_Param:set(0)
	end
	
	current_station = GetNextStation()
end

function keys_station_six(value)

	local info = dev:get_station_info(PYLON.RH_PYLON)
	if station_SIX == 0 and info.count > 0 then
		station_SIX = 1
		Station_Six_Param:set(1)
	else
		station_SIX = 0
		Station_Six_Param:set(0)
	end
	
	current_station = GetNextStation()
end

function keys_station_seven(value)

	local info = dev:get_station_info(PYLON.RH_TIP)
	if station_SEVEN == 0 and info.count > 0 then
		station_SEVEN = 1
		Station_Seven_Param:set(1)
	else
		station_SEVEN = 0
		Station_Seven_Param:set(0)
	end
	
	current_station = GetNextStation()
end

function keys_change_station(value)
	-- Not implemented
end

function keys_pickle_on(value)

	dev:launch_station(current_station)
	
	UpdateSelectorButtons()
	
	current_station = GetNextStation()

    --dev:drop_flare(1, 1)
end

function keys_trigger_on(value)
	if electric_system_api.emergency_ac_bus:get() == 1.0 then    
        dispatch_action(nil, Keys.iCommandPlaneFire)
    end
end

function keys_trigger_off(value)
    dispatch_action(nil, Keys.iCommandPlaneFireOff)
end

command_table = {
    [Keys.pickle_on] 			= keys_pickle_on,
    [Keys.trigger_on] 			= keys_trigger_on,
    [Keys.trigger_off] 			= keys_trigger_off,
	[Keys.GunPipper_Automatic]	= keys_gunpipper_automatic,

	-- Weapon panel
	[Keys.station_one]		= keys_station_one,
	[Keys.station_two]		= keys_station_two,
	[Keys.station_three]		= keys_station_three,
	[Keys.station_four]		= keys_station_four,
	[Keys.station_five]		= keys_station_five,
	[Keys.station_six]		= keys_station_six,
	[Keys.station_seven]		= keys_station_seven,
	--[Keys.change_station]		= keys_change_station,  
}

-- Use this function to disable the selector buttons after weapon release or jettison
function UpdateSelectorButtons()
	if (station_ONE == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.LH_TIP)
		if(info.count == 0) then
			station_ONE = 0
			Station_One_Param:set(0)
		end
	end

	if (station_SEVEN == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_TIP)
		if(info.count == 0) then
			station_SEVEN = 0
			Station_Seven_Param:set(0)
		end
	end

	if (station_THREE == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.LH_FUS)
		if(info.count == 0) then
			station_THREE = 0
			Station_Three_Param:set(0)
		end
	end

	if (station_FIVE == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.RH_FUS)
		if(info.count == 0) then
			station_FIVE = 0
			Station_Five_Param:set(0)
		end
	end

	if (station_TWO == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.LH_PYLON)
		if(info.count == 0) then
			station_TWO = 0
			Station_Two_Param:set(0)
		end
	end

	if (station_SIX == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_PYLON)
		if(info.count == 0) then
			station_SIX = 0
			Station_Six_Param:set(0)
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
		if(info.count > 0) then
			print_message_to_user("Next station: PYLON.LH_TIP")
			return PYLON.LH_TIP		
		end
	end
	-- check RH tip active
	if (station_SEVEN == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_TIP)
		if(info.count > 0) then
			print_message_to_user("Next station: PYLON.RH_TIP")
			return PYLON.RH_TIP
		end
	end
	if (station_THREE == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.LH_FUS)
		if(info.count > 0) then
			print_message_to_user("Next station: PYLON.LH_FUS")
			return PYLON.LH_FUS
		end
	end
	if (station_FIVE == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.RH_FUS)
		if(info.count > 0) then
		print_message_to_user("Next station: PYLON.RH_FUS")
			return PYLON.RH_FUS
		end
	end

	if (station_TWO == 1) then
	-- check if loaded
		local info = dev:get_station_info(PYLON.LH_PYLON)
		if(info.count > 0) then
			print_message_to_user("Next station: PYLON.LH_PYLON")
			return PYLON.LH_PYLON
		end
	end

	if (station_SIX == 1) then
		-- check if loaded
		local info = dev:get_station_info(PYLON.RH_PYLON)
		if(info.count > 0) then
			print_message_to_user("Next station: PYLON.RH_PYLON")
			return PYLON.RH_PYLON
		end
	end

	print_message_to_user("Next station: None")
	return 0
end

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

function update()
	
	--gunpipper_auto_movement_side 		= gunpipper_sideways_automatic_param:get()
	--gunpipper_auto_movement_updown		= gunpipper_updown_automatic_param:get()

	--print_message_to_user("IR Missile got lock = " ..tostring(ir_missile_lock_param:get()))
    if ir_missile_lock_param:get() > 0.0 then --vorher if ir_lock:get() > 0 then 
        print_message_to_user("Missile Lock")

	end
	
	--[[if ir_missile_az_param:get() > 0.0 then
		print_message_to_user("Target_Azimuth " ..tostring(ir_missile_az_param:get()))
	end
	
	
		--if ir_missile_az_param:get() > 0.0 then
		--	print_message_to_user("Target_Azimuth " ..tostring(ir_missile_az_param:get()))
		--end
		--
		--if ir_missile_el_param:get() > 0.0 then
		--	print_message_to_user("Target_Elevation " ..tostring(ir_missile_el_param:get()))
		--end
	else	

		-- radar is providíng target position, but it no lock was achieved yet
	    if ir_missile_des_az_param:get() ~= 0.0 then
			print_message_to_user("Desired Azimuth " ..tostring(ir_missile_des_az_param:get()))
		end
		
		if ir_missile_des_el_param:get() ~= 0.0 then
			print_message_to_user("Desired Elevation " ..tostring(ir_missile_des_el_param:get()))
		end
	end

	
	--print_message_to_user("GunPipper_Automatic_Sideways " ..tostring(gunpipper_auto_movement_side))
	--print_message_to_user("GunPipper_Automatic_UpDown " ..tostring(gunpipper_auto_movement_updown))]]

end

need_to_be_closed = false