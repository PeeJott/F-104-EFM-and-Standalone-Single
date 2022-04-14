dofile(LockOn_Options.script_path.."definitions.lua")

electric_system_api = {
	ground_power = get_param_handle(ELECTRIC_SYSTEM.GROUND_POWER),
	no_1_primary_ac_bus = get_param_handle(ELECTRIC_SYSTEM.NO_1_PRIMARY_AC_BUS),
	no_1_secondary_ac_bus = get_param_handle(ELECTRIC_SYSTEM.NO_1_SECONDARY_AC_BUS),
	no_2_ac_bus = get_param_handle(ELECTRIC_SYSTEM.NO_2_AC_BUS),
	emergency_ac_bus =  get_param_handle(ELECTRIC_SYSTEM.EMERGENCY_AC_BUS),
	primary_fixed_freqency_ac_bus = get_param_handle(ELECTRIC_SYSTEM.PRIMARY_FIXED_FEQUENCY_AC_BUS),
	secondary_fixed_freqency_ac_bus = get_param_handle(ELECTRIC_SYSTEM.SECONDARY_FIXED_FEQUENCY_AC_BUS),
	engine_instruments_and_indicator_power = get_param_handle(ELECTRIC_SYSTEM.ENGINE_INSTRUMENTS_AND_INDICATOR_POWER),
	primary_dc_bus = get_param_handle(ELECTRIC_SYSTEM.PRIMARY_DC_BUS),
	no_1_emergency_dc_bus = get_param_handle(ELECTRIC_SYSTEM.NO_1_EMERGENCY_DC_BUS),
	no_1_battery_bus = get_param_handle(ELECTRIC_SYSTEM.NO_1_BATTERY_BUS),
	no_2_emergency_dc_bus = get_param_handle(ELECTRIC_SYSTEM.NO_2_EMERGENCY_DC_BUS),
	no_2_battery_bus = get_param_handle(ELECTRIC_SYSTEM.NO_2_BATTERY_BUS),
}

--electric_system_api = {
--    ac_gen_power_param = get_param_handle("AC_GEN_POWER"),
--    dc_bat_power_param = get_param_handle("DC_BAT_POWER"),
--}
