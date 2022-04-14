dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.02  --50 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

--local canopy_int_anim_arg = 181
local canopy_ext_anim_arg = 38

local initial_canopy = get_aircraft_draw_argument_value(canopy_ext_anim_arg)
local CANOPY_COMMAND = 0   -- 0 closing, 1 opening, 2 jettisoned
if (initial_canopy > 0) then
    CANOPY_COMMAND = 1
end

dev:listen_command(Keys.iCommandPlaneFonar)

dev:listen_event("repair")

function SetCommand(command, value)
	if (command == Keys.iCommandPlaneFonar) then
        if CANOPY_COMMAND <= 1 then -- only toggle while not jettisoned
            CANOPY_COMMAND = 1 - CANOPY_COMMAND --toggle
        end
    end
end

local prev_canopy_val = -1
local canopy_warning = 0

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_COLD" then
        CANOPY_COMMAND = 1
    else
        CANOPY_COMMAND = 0
    end
end

function update()
    local current_canopy_position = get_aircraft_draw_argument_value(canopy_ext_anim_arg)
    if current_canopy_position > 0.95 then
        CANOPY_COMMAND = 2 -- canopy was jettisoned
    end

	if (CANOPY_COMMAND == 0 and current_canopy_position > 0) then
        current_canopy_position = current_canopy_position - 0.01
        set_aircraft_draw_argument_value(canopy_ext_anim_arg, current_canopy_position)
        --set_cockpit_draw_argument_value(canopy_int_anim_arg, current_canopy_position)
	elseif (CANOPY_COMMAND == 1 and current_canopy_position <= 0.89) then
		current_canopy_position = current_canopy_position + 0.01
        set_aircraft_draw_argument_value(canopy_ext_anim_arg, current_canopy_position)    
        --set_cockpit_draw_argument_value(canopy_int_anim_arg, current_canopy_position)
    end    
end

function CockpitEvent(event, val)
    if event == "repair" then
        CANOPY_COMMAND = 1 -- reset canopy from jettison state to open state
    end
end

need_to_be_closed = false -- close lua state after initialization