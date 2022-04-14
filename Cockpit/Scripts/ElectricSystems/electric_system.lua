dofile(LockOn_Options.script_path.."ElectricSystems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

make_default_activity(1.0)

local dev = GetSelf()

dev:listen_event("GroundPowerOn")
dev:listen_event("GroundPowerOff")


function CockpitEvent(event,val)
    if event == "GroundPowerOn" then
        electric_system_api.ground_power:set(1.0)
    elseif event == "GroundPowerOff" then
        electric_system_api.ground_power:set(0.0)
    end
end

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_COLD" then
        
    else
        
    end
end

function update()
    -- Test the bus states
        
    -- print_message_to_user("************ ElectricSystemState ************** ")
    -- print_message_to_user("ground_power: " .. electric_system_api.ground_power:get())
    -- print_message_to_user("no_1_primary_ac_bus: " .. electric_system_api.no_1_primary_ac_bus:get())
	-- print_message_to_user("no_1_secondary_ac_bus: " .. electric_system_api.no_1_secondary_ac_bus:get())
	-- print_message_to_user("no_2_ac_bus: " .. electric_system_api.no_2_ac_bus:get())
	-- print_message_to_user("emergency_ac_bus: " .. electric_system_api.emergency_ac_bus:get())
	-- print_message_to_user("primary_fixed_freqency_ac_bus: " .. electric_system_api.primary_fixed_freqency_ac_bus:get())
	-- print_message_to_user("secondary_fixed_freqency_ac_bus: " .. electric_system_api.secondary_fixed_freqency_ac_bus:get())
	-- print_message_to_user("engine_instruments_and_indicator_power: " .. electric_system_api.engine_instruments_and_indicator_power:get())
	-- print_message_to_user("primary_dc_bus: " .. electric_system_api.primary_dc_bus:get())
	-- print_message_to_user("no_1_emergency_dc_bus: " .. electric_system_api.no_1_emergency_dc_bus:get())
	-- print_message_to_user("no_1_battery_bus: " .. electric_system_api.no_1_battery_bus:get())
	-- print_message_to_user("no_2_emergency_dc_bus: " .. electric_system_api.no_2_emergency_dc_bus:get())
	-- print_message_to_user("no_2_battery_bus: " .. electric_system_api.no_2_battery_bus:get())
end

need_to_be_closed = false

