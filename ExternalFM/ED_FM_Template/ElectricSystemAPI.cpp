#include "ElectricSystemAPI.h"

ElectricSystemAPI::ElectricSystemAPI()
{
	m_cockpitParamAPI = ed_get_cockpit_param_api();

	ground_power = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(GROUND_POWER);
	no_1_primary_ac_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(NO_1_PRIMARY_AC_BUS);
	no_1_secondary_ac_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(NO_1_SECONDARY_AC_BUS);
	no_2_ac_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(NO_2_AC_BUS);
	emergency_ac_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(EMERGENCY_AC_BUS);
	primary_fixed_frequency_ac_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(PRIMARY_FIXED_FEQUENCY_AC_BUS);
	secondary_fixed_frequency_ac_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(SECONDARY_FIXED_FEQUENCY_AC_BUS);
	engine_insturment_and_indicator_power = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(ENGINE_INSTRUMENTS_AND_INDICATOR_POWER);
	primary_dc_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(PRIMARY_DC_BUS);
	no_1_emergency_dc_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(NO_1_EMERGENCY_DC_BUS);
	no_1_battery_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(NO_1_BATTERY_BUS);
	no_2_emergency_dc_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(NO_2_EMERGENCY_DC_BUS);
	no_2_battery_bus = m_cockpitParamAPI.pfn_ed_cockpit_get_parameter_handle(NO_2_BATTERY_BUS);
}


void ElectricSystemAPI::zeroInit()
{
	double init = 0.0;
	SetNo1PrimaryAcBus(init);
	SetNo1SecondaryAcBus(init);
	SetNo2AcBus(init);
	SetEmergencyAcBus(init);
	SetPrimaryFixesFrequencyAcBus(init);
	SetSecondaryFixesFrequencyAcBus(init);
	SetEngineInstrumentAndIndicatorPower(init);
	SetPrimaryDcBus(init);
	SetNo1EmergencyDcBus(init);
	SetNo1BatteryBus(init);
	SetNo2EmergencyDcBus(init);
	SetNo2BatteryBus(init);
}
void ElectricSystemAPI::coldInit()
{
	double init = 0.0;
	SetNo1PrimaryAcBus(init);
	SetNo1SecondaryAcBus(init);
	SetNo2AcBus(init);
	SetEmergencyAcBus(init);
	SetPrimaryFixesFrequencyAcBus(init);
	SetSecondaryFixesFrequencyAcBus(init);
	SetEngineInstrumentAndIndicatorPower(init);
	SetPrimaryDcBus(init);
	SetNo1EmergencyDcBus(init);
	SetNo1BatteryBus(init);
	SetNo2EmergencyDcBus(init);
	SetNo2BatteryBus(init);
}
void ElectricSystemAPI::hotInit()
{
	double init = 1.0;
	SetNo1PrimaryAcBus(init);
	SetNo1SecondaryAcBus(init);
	SetNo2AcBus(init);
	SetEmergencyAcBus(init);
	SetPrimaryFixesFrequencyAcBus(init);
	SetSecondaryFixesFrequencyAcBus(init);
	SetEngineInstrumentAndIndicatorPower(init);
	SetPrimaryDcBus(init);
	SetNo1EmergencyDcBus(init);
	SetNo1BatteryBus(init);
	SetNo2EmergencyDcBus(init);
	SetNo2BatteryBus(init);
}

void ElectricSystemAPI::airborneInit()
{
	double init = 1.0;
	SetNo1PrimaryAcBus(init);
	SetNo1SecondaryAcBus(init);
	SetNo2AcBus(init);
	SetEmergencyAcBus(init);
	SetPrimaryFixesFrequencyAcBus(init);
	SetSecondaryFixesFrequencyAcBus(init);
	SetEngineInstrumentAndIndicatorPower(init);
	SetPrimaryDcBus(init);
	SetNo1EmergencyDcBus(init);
	SetNo1BatteryBus(init);
	SetNo2EmergencyDcBus(init);
	SetNo2BatteryBus(init);
}

double ElectricSystemAPI::GetGroundPower()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(ground_power, value, false);
	return value;
}

double ElectricSystemAPI::GetNo1PrimaryAcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(no_1_primary_ac_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetNo1SecondaryAcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(no_1_secondary_ac_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetNo2AcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(no_2_ac_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetEmergencyAcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(emergency_ac_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetPrimaryFixesFrequencyAcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(primary_fixed_frequency_ac_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetSecondaryFixesFrequencyAcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(secondary_fixed_frequency_ac_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetEngineInstrumentAndIndicatorPower()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(engine_insturment_and_indicator_power, value, false);
	return value;
}

double ElectricSystemAPI::GetPrimaryDcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(primary_dc_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetNo1EmergencyDcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(no_1_emergency_dc_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetNo1BatteryBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(no_1_battery_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetNo2EmergencyDcBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(no_2_emergency_dc_bus, value, false);
	return value;
}

double ElectricSystemAPI::GetNo2BatteryBus()
{
	double value;
	m_cockpitParamAPI.pfn_ed_cockpit_parameter_value_to_number(no_2_battery_bus, value, false);
	return value;
}

void ElectricSystemAPI::SetNo1PrimaryAcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(no_1_primary_ac_bus, value);
}

void ElectricSystemAPI::SetNo1SecondaryAcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(no_1_secondary_ac_bus, value);
}

void ElectricSystemAPI::SetNo2AcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(no_2_ac_bus, value);
}

void ElectricSystemAPI::SetEmergencyAcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(emergency_ac_bus, value);
}

void ElectricSystemAPI::SetPrimaryFixesFrequencyAcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(primary_fixed_frequency_ac_bus, value);
}

void ElectricSystemAPI::SetSecondaryFixesFrequencyAcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(secondary_fixed_frequency_ac_bus, value);
}

void ElectricSystemAPI::SetEngineInstrumentAndIndicatorPower(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(engine_insturment_and_indicator_power, value);
}

void ElectricSystemAPI::SetPrimaryDcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(primary_dc_bus, value);
}

void ElectricSystemAPI::SetNo1EmergencyDcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(no_1_emergency_dc_bus, value);
}

void ElectricSystemAPI::SetNo1BatteryBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(no_1_battery_bus, value);
}

void ElectricSystemAPI::SetNo2EmergencyDcBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(no_2_emergency_dc_bus, value);
}

void ElectricSystemAPI::SetNo2BatteryBus(double value)
{
	m_cockpitParamAPI.pfn_ed_cockpit_update_parameter_with_number(no_2_battery_bus, value);
}
