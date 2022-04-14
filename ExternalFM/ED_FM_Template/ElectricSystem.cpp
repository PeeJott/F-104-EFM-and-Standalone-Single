#include "ElectricSystem.h"

ElectricSystem::ElectricSystem(ElectricSystemAPI& electricSystemAPI, State& state, Input& input, Engine& engine, Airframe& airframe, RamAirTurbine& ramAirTurbine) :
	m_electricSystemAPI(electricSystemAPI),
	m_state(state),
	m_input(input),
	m_engine(engine),
	m_airframe(airframe),
	m_ramAirTurbine(ramAirTurbine)
{

}

void ElectricSystem::zeroInit()
{
	m_no1generator.groundInit(1.0, 1.0);
	m_no2generator.groundInit(1.0, 1.0);
	m_hydraulicDrivenGenerator.groundInit(1.0, 1.0);
	m_groundPower.groundInit(0.0, 0.0);
}
void ElectricSystem::coldInit()
{
	m_no1generator.groundInit(1.0, 1.0);
	m_no2generator.groundInit(1.0, 1.0);
	m_hydraulicDrivenGenerator.groundInit(1.0, 1.0);
	m_groundPower.groundInit(0.0, 0.0);
}
void ElectricSystem::hotInit()
{
	m_no1generator.groundInit(1.0, 1.0);
	m_no2generator.groundInit(1.0, 1.0);
	m_hydraulicDrivenGenerator.groundInit(1.0, 1.0);
	m_groundPower.groundInit(0.0, 0.0);
}

void ElectricSystem::airborneInit()
{
	m_no1generator.groundInit(1.0, 1.0);
	m_no2generator.groundInit(1.0, 1.0);
	m_hydraulicDrivenGenerator.groundInit(1.0, 1.0);
	m_groundPower.groundInit(0.0, 0.0);
}


bool ElectricSystem::HasGroundPower()
{
	if (m_electricSystemAPI.GetGroundPower() == 1.0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool ElectricSystem::IsNo1GeneratorNormal()
{
	
	if (m_engine.getRPMNorm() >= 0.65 && // generator automatically dropped of the bus below 65% engine rpm according to T.0. 1F-104G-1
		m_no1generator.getPosition() == 1.0) // Not in reset state
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool ElectricSystem::IsNo2GeneratorNormal()
{
	
	if (m_engine.getRPMNorm() >= 0.65 && // generator automatically dropped of the bus below 65% engine rpm according to T.0. 1F-104G-1
		m_no2generator.getPosition() == 1.0) // Not in reset state
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool ElectricSystem::IsHydraulicDrivenGeneratorNormal()
{	
	if (m_airframe.getHyraulicPumpPower() > 0.0 && // There is hydraulic power
		m_engine.getRPMNorm() >= 0.20 && // engine speed must be above 20% according to T.0. 1F-104G-1
		m_hydraulicDrivenGenerator.getPosition() == 1.0) // Not in reset state
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool ElectricSystem::IsEmergencyGeneratorNormal()
{
	if (m_ramAirTurbine.IsRamAirTurbineExteneded()
		&& m_state.m_mach > 0.25) // TODO: Find speed range where emergency generator is working
	{
		return true;
	}
	else
	{
		return false;
	}
}

void ElectricSystem::update(double dt)
{
	// React to No. 1 Generator Switch
	if (m_input.getNo1GeneratorSwitch() == -1.0) // OFF
	{
		m_no1generator.inputUpdate(0.0, dt);
	}
	else if (m_input.getNo1GeneratorSwitch() == 1.0) // ON RESET
	{
		m_no1generator.inputUpdate(1.0, dt);
	}
	else
	{
		m_no1generator.physicsUpdate(dt);
	}

	// React to No. 2 Generator Switch
	if (m_input.getNo2GeneratorSwitch() == -1.0) // OFF
	{
		m_no2generator.inputUpdate(0.0, dt);
	}
	else if (m_input.getNo2GeneratorSwitch() == 1.0) // ON RESET
	{
		m_no2generator.inputUpdate(1.0, dt);
	}
	else
	{
		m_no2generator.physicsUpdate(dt);
	}
	
	// React to Hydraulic Driven Generator Reset Switch
	if (m_input.getHydraulicDrivenGeneratorResetSwitch() == 1.0) // OFF
	{
		// Perform reset whenever the switch is pressed
		m_hydraulicDrivenGenerator.inputUpdate(0.0, dt);
	}
	else if (m_hydraulicDrivenGenerator.getPosition() == 0.0)
	{
		// If it is completely resetted (== 0.0), bring it back to normal (1.0)
		m_hydraulicDrivenGenerator.inputUpdate(1.0, dt);
	}
	else
	{
		m_hydraulicDrivenGenerator.physicsUpdate(dt);
	}

	bool temp_no_1_primary_ac_bus = 0.0;
	bool temp_no_1_secondary_ac_bus = 0.0;
	bool temp_no_2_ac_bus = 0.0;
	bool temp_emergency_ac_bus = 0.0;
	bool temp_primary_fixed_frequency_ac_bus = 0.0;
	bool temp_secondary_fixed_frequency_ac_bus = 0.0;
	bool temp_engine_insturment_and_indicator_power = 0.0;
	bool temp_primary_dc_bus = 0.0;
	bool temp_no_1_emergency_dc_bus = 0.0;
	bool temp_no_1_battery_bus = 0.0;
	bool temp_no_2_emergency_dc_bus = 0.0;
	bool temp_no_2_battery_bus = 0.0;
		
	// Power the AC busses

	if (HasGroundPower())
	{
		// All AC busses are supplied by ground power
		temp_no_1_primary_ac_bus = 1.0;
		temp_no_1_secondary_ac_bus = 1.0;
		temp_no_2_ac_bus = 1.0;
		temp_emergency_ac_bus = 1.0;
		// It's not needed to power the fixed frequency busses from ground power directly
		// because they are powered by emergency bus in this case (see Mode 4)
	}

	// Determine mode of the automatic bus transfer system
	if (IsNo1GeneratorNormal() && IsNo2GeneratorNormal())
	{		
		// Mode 1: NORMAL OPERATION
		temp_no_1_primary_ac_bus = m_no1generator.getPosition();
		temp_no_1_secondary_ac_bus = m_no1generator.getPosition();
		temp_no_2_ac_bus = m_no2generator.getPosition();
		temp_emergency_ac_bus = m_no2generator.getPosition();
	}
	else if (!IsNo1GeneratorNormal() && IsNo2GeneratorNormal())
	{
		// Mode 2: NO. 1 GENERATOR-OUT
		temp_no_1_primary_ac_bus = m_no2generator.getPosition();
		temp_no_1_secondary_ac_bus = 0.0; // OUT
		temp_no_2_ac_bus = m_no2generator.getPosition();
		temp_emergency_ac_bus = m_no2generator.getPosition();
	}
	else if (IsNo1GeneratorNormal() && !IsNo2GeneratorNormal())
	{
		// Mode 3: NO. 2 GENERATOR-OUT
		temp_no_1_primary_ac_bus = m_no1generator.getPosition();
		temp_no_1_secondary_ac_bus = 0.0; // OUT
		temp_no_2_ac_bus = m_no1generator.getPosition();
		temp_emergency_ac_bus = m_no1generator.getPosition();
	}
	
	if(IsEmergencyGeneratorNormal())
	{
		// It's not clear what happens if both generators are working while extending the RAT
		// however according to Fig 1-37 a relay interupts the connection between
		// the emergency bus and the normal generators.
		temp_emergency_ac_bus = 1.0;
	}

	if (IsHydraulicDrivenGeneratorNormal())
	{
		// Normal
		temp_primary_fixed_frequency_ac_bus = m_hydraulicDrivenGenerator.getPosition();
		if (temp_no_2_ac_bus != 0.0)
		{
			// There's a relay that cuts out the secondary bus if No. 2 AC bus is not powered
			temp_secondary_fixed_frequency_ac_bus = m_hydraulicDrivenGenerator.getPosition();
		}
	}
	else
	{
		// Mode 4:
		temp_primary_fixed_frequency_ac_bus = temp_emergency_ac_bus;
		if (temp_no_2_ac_bus != 0.0)
		{
			// There's a relay that cuts out the secondary bus if No. 2 AC bus is not powered
			temp_secondary_fixed_frequency_ac_bus = m_hydraulicDrivenGenerator.getPosition();
		}
	}

	temp_engine_insturment_and_indicator_power = temp_primary_fixed_frequency_ac_bus;



	// Power the DC busses depending on AC bus states
	temp_primary_dc_bus = temp_no_2_ac_bus;
		
	if (temp_primary_dc_bus == 1.0)
	{
		// Normal operation
		temp_no_1_emergency_dc_bus = temp_primary_dc_bus;
		temp_no_2_emergency_dc_bus = temp_primary_dc_bus;
	}
	else
	{
		temp_no_1_emergency_dc_bus = temp_emergency_ac_bus;
		temp_no_2_emergency_dc_bus = temp_emergency_ac_bus;
	}

	if (IsEmergencyGeneratorNormal() && m_airframe.areFlapsOperating())
	{
		// Check if flaps are operated in emergency mode, no 1 emergency dc bus is disconnected
		temp_no_1_emergency_dc_bus = 0.0;
	}

	// Batteries are always on.
	// TODO: Reduce battery loading.
	temp_no_1_battery_bus = 1.0;
	temp_no_2_battery_bus = 1.0;

	// Write the results to the param handles
	m_electricSystemAPI.SetNo1PrimaryAcBus(temp_no_1_primary_ac_bus);
	m_electricSystemAPI.SetNo1SecondaryAcBus(temp_no_1_secondary_ac_bus);
	m_electricSystemAPI.SetNo2AcBus(temp_no_2_ac_bus);
	m_electricSystemAPI.SetEmergencyAcBus(temp_emergency_ac_bus);
	m_electricSystemAPI.SetPrimaryFixesFrequencyAcBus(temp_primary_fixed_frequency_ac_bus);
	m_electricSystemAPI.SetSecondaryFixesFrequencyAcBus(temp_secondary_fixed_frequency_ac_bus);		
	m_electricSystemAPI.SetEngineInstrumentAndIndicatorPower(temp_engine_insturment_and_indicator_power);

	m_electricSystemAPI.SetPrimaryDcBus(temp_primary_dc_bus);
	m_electricSystemAPI.SetNo1EmergencyDcBus(temp_no_1_emergency_dc_bus);
	m_electricSystemAPI.SetNo1BatteryBus(temp_no_1_battery_bus);
	m_electricSystemAPI.SetNo2EmergencyDcBus(temp_no_2_emergency_dc_bus);
	m_electricSystemAPI.SetNo2BatteryBus(temp_no_2_battery_bus);	
}


