dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 2.0
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local hsi = get_param_handle("...")

function SetCommand(command,value)	
	
end

function post_initialize()
	print_message_to_user("Air Data Computer - INIT")
end

function update()
    
end

need_to_be_closed = false
