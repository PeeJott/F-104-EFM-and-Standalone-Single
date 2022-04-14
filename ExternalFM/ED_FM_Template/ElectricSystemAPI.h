#pragma once
#include "../../include/Cockpit/ccParametersAPI.h"
#include "BaseComponent.h"

#define GROUND_POWER "GROUND_POWER"
#define NO_1_PRIMARY_AC_BUS "NO_1_PRIMARY_AC_BUS"
#define NO_1_SECONDARY_AC_BUS "NO_1_SECONDARY_AC_BUS"
#define NO_2_AC_BUS "NO_2_AC_BUS"
#define EMERGENCY_AC_BUS "EMERGENCY_AC_BUS"
#define PRIMARY_FIXED_FEQUENCY_AC_BUS "PRIMARY_FIXED_FEQUENCY_AC_BUS"
#define SECONDARY_FIXED_FEQUENCY_AC_BUS "SECONDARY_FIXED_FEQUENCY_AC_BUS"
#define ENGINE_INSTRUMENTS_AND_INDICATOR_POWER "ENGINE_INSTRUMENTS_AND_INDICATOR_POWER"
#define PRIMARY_DC_BUS "PRIMARY_DC_BUS"
#define NO_1_EMERGENCY_DC_BUS "NO_1_EMERGENCY_DC_BUS"
#define NO_1_BATTERY_BUS "NO_2_EMERGENCY_DC_BUS"
#define NO_2_EMERGENCY_DC_BUS "NO_2_EMERGENCY_DC_BUS"
#define NO_2_BATTERY_BUS "NO_2_EMERGENCY_DC_BUS"

class ElectricSystemAPI : public BaseComponent
{
private:
	cockpit_param_api m_cockpitParamAPI;

	void* ground_power;
	void* no_1_primary_ac_bus;
	void* no_1_secondary_ac_bus;
	void* no_2_ac_bus;
	void* emergency_ac_bus;
	void* primary_fixed_frequency_ac_bus;
	void* secondary_fixed_frequency_ac_bus;
	void* engine_insturment_and_indicator_power;
	void* primary_dc_bus;
	void* no_1_emergency_dc_bus;
	void* no_1_battery_bus;
	void* no_2_emergency_dc_bus;
	void* no_2_battery_bus;

public:
	ElectricSystemAPI();

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	double GetGroundPower();
	double GetNo1PrimaryAcBus();
	double GetNo1SecondaryAcBus();
	double GetNo2AcBus();
	double GetEmergencyAcBus();
	double GetPrimaryFixesFrequencyAcBus();
	double GetSecondaryFixesFrequencyAcBus();
	double GetEngineInstrumentAndIndicatorPower();
	double GetPrimaryDcBus();
	double GetNo1EmergencyDcBus();
	double GetNo1BatteryBus();
	double GetNo2EmergencyDcBus();
	double GetNo2BatteryBus();

	void SetNo1PrimaryAcBus(double value);
	void SetNo1SecondaryAcBus(double value);
	void SetNo2AcBus(double value);
	void SetEmergencyAcBus(double value);
	void SetPrimaryFixesFrequencyAcBus(double value);
	void SetSecondaryFixesFrequencyAcBus(double value);
	void SetEngineInstrumentAndIndicatorPower(double value);
	void SetPrimaryDcBus(double value);
	void SetNo1EmergencyDcBus(double value);
	void SetNo1BatteryBus(double value);
	void SetNo2EmergencyDcBus(double value);
	void SetNo2BatteryBus(double value);
};