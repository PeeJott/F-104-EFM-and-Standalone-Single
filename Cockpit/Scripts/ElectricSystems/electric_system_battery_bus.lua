dofile(LockOn_Options.script_path.."ElectricSystems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

make_default_activity(0.5)

function post_initialize()
    -- battery_bus is always on
    dev:AC_Generator_1_on(true)
    dev:AC_Generator_2_on(true)
    dev:DC_Battery_on(true)
end

function update()
    if electric_system_api.no_1_battery_bus:get() == 0.0 then
        dev:AC_Generator_1_on(false)
        dev:AC_Generator_2_on(false)
        dev:DC_Battery_on(false)
    else
        dev:AC_Generator_1_on(true)
        dev:AC_Generator_2_on(true)
        dev:DC_Battery_on(true)
    end
end

need_to_be_closed = false