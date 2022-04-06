dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
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

function keys_pickle_on(value)

    --dev:drop_flare(1, 1)
    local info = dev:get_station_info(current_station)
    --print_message_to_user("Station "..tostring(current_station).." "..tostring(info.count))
    
	
    --dev:launch_station(current_station)
    --current_station = (current_station + 1) % 11
	

	dev:launch_station(current_station)
    print_message_to_user(" Launching selected station: ".. tostring(current_station).." "..tostring(info.count))	
	--dev:drop_flare(1, 1)


	-- TODO: Improve station selection to use one station pressed/activated by the pilot
	--[[next_station = current_station + 1
	while(next_station <= 11)
	do
		info = dev:get_station_info(next_station)
		if info.count == 0 then
			next_station = next_station + 1
		else
			break
		end
	end

	current_station = next_station
	dev:select_station(current_station)
	print_message_to_user("Selected station: ".. current_station)
	]]
	
	if (station_1 == 1) then
		dev:launch_station(2)
	end
	
	if (station_2 == 1) then
		dev:launch_station(4)
	end
	
	if (station_3 == 1) then
		dev:launch_station(5)
	end
	
	if (station_4 == 1) then
		dev:launch_station(6)
	end
	
	if (station_5 == 1) then
		dev:launch_station(7)
	end
	
	if (station_6 == 1) then
		dev:launch_station(8)
	end
	
	if (station_7 == 1) then
		dev:launch_station(10)
	end
	
	
	
	
	
end

function keys_trigger_on(value)
    if electric_system_api:get_AC() then
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
}

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

	if(station_1_selector:get() == 1) then
	--current_station = 1
	station_1 = 1
	dev:select_station(2)
	else
	--current_station = 0
	station_1 = 0
	end
	
	if(station_2_selector:get() == 1) then
	--current_station = 2
	station_2 = 1
	dev:select_station(4)
	else
	--current_station = 0
	station_2 = 0
	end
	
	if(station_3_selector:get() == 1) then
	--current_station = 3
	station_3 = 1
	dev:select_station(5)
	end
	
	if(station_4_selector:get() == 1) then
	--current_station = 4
	station_4 = 1
	dev:select_station(6)
	end
	
	if(station_5_selector:get() == 1) then
	--current_station = 5
	station_5	= 1
	dev:select_station(7)
	end
	
	if(station_6_selector:get() == 1) then
	--current_station = 6
	station_6 = 1
	dev:select_station(8)
	end
	
	if(station_7_selector:get() == 1) then
	--current_station = 7
	station_7 = 1
	dev:select_station(10)
	end
	
	
	
	--dev:select_station(current_station)
	
--gunpipper_auto_movement_side 		= gunpipper_sideways_automatic_param:get()
--gunpipper_auto_movement_updown		= gunpipper_updown_automatic_param:get()

	--print_message_to_user("IR Missile got lock = " ..tostring(ir_missile_lock_param:get()))
    if ir_missile_lock_param:get() == 1.0 then --vorher if ir_lock:get() > 0 then 
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