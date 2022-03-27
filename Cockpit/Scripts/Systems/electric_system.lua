dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.05
make_default_activity(update_time_step)


--dev:listen_command(Keys.your_command_name)

-- Called with commands that are being listened to and their values.
function SetCommand(command,value)

end

-- Run after aircraft is loaded.
function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_COLD" then
        --
    else
        --
    end

    dev:AC_Generator_1_on(true)
    dev:AC_Generator_2_on(false)
    dev:DC_Battery_on(true)
end


-- Ran every frame.
function update()
    if dev:get_AC_Bus_1_voltage() > 0 then
        electric_system_api.ac_gen_power_param:set(1)
    else
        electric_system_api.ac_gen_power_param:set(0)
    end

    if dev:get_DC_Bus_1_voltage() > 0 or dev:get_DC_Bus_2_voltage() > 0 then
        electric_system_api.dc_bat_power_param:set(1)
    else
        electric_system_api.dc_bat_power_param:set(0)
    end
end

need_to_be_closed = false -- don't close after