electric_system_api = {
    ac_gen_power_param = get_param_handle("AC_GEN_POWER"),
    dc_bat_power_param = get_param_handle("DC_BAT_POWER"),
}

function electric_system_api:get_AC()
    return self.ac_gen_power_param:get() == 1.0
end

function electric_system_api:get_DC()
    return self.dc_gen_power_param:get() == 1.0
end