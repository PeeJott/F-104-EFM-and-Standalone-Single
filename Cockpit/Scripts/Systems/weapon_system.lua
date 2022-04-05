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


--WeaponSystem-Params
local ir_missile_lock_param = get_param_handle("WS_IR_MISSILE_LOCK")
local ir_missile_az_param = get_param_handle("WS_IR_MISSILE_TARGET_AZIMUTH")
local ir_missile_el_param = get_param_handle("WS_IR_MISSILE_TARGET_ELEVATION")
local ir_missile_des_az_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH")
local ir_missile_des_el_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION")
--local gunpipper_sideways_automatic_param = get_param_handle("WS_GUN_PIPER_AZIMUTH")
--local gunpipper_updown_automatic_param = get_param_handle("WS_GUN_PIPER_ELEVATION")
--local target_range_param = get_param_handle("WS_TARGET_RANGE")

local current_station = 1
--target_range_param:set(800.0) --Target-Range auf 800m gesetzt

--gunpipper_auto_movement_side 	= 0.0
--gunpipper_auto_movement_updown	= 0.0

function keys_pickle_on(value)
	dev:launch_station(current_station)
    	
	--dev:drop_flare(1, 1)


	-- TODO: Improve station selection to use one station pressed/activated by the pilot
	next_station = current_station + 1
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
    dev:select_station(current_station)
	
	--print_message_to_user("Missile_Seeker_Elevation " ..tostring(ir_missile_des_el_param:get()))
	--print_message_to_user("Missile_Seeker_Azimuth " ..tostring(ir_missile_des_az_param:get()))

end


function update()

--gunpipper_auto_movement_side 		= gunpipper_sideways_automatic_param:get()
--gunpipper_auto_movement_updown		= gunpipper_updown_automatic_param:get()

	--print_message_to_user("IR Missile got lock = " ..tostring(ir_missile_lock_param:get()))
    if ir_missile_lock_param:get() == 1.0 then --vorher if ir_lock:get() > 0 then 
        print_message_to_user("Missile Lock")
	
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
	--print_message_to_user("GunPipper_Automatic_UpDown " ..tostring(gunpipper_auto_movement_updown))

end

need_to_be_closed = false