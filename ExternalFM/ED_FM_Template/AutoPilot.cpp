#include "AutoPilot.h"

AutoPilot::AutoPilot
(
	State& state, 
	Input& input, 
	PID& pid,
	Airframe& airframe,
	ElectricSystemAPI& electricSystemAPI
) :
	m_state(state),
	m_input(input),
	m_pid(pid),
	m_airframe(airframe),
	m_electricSystemAPI(electricSystemAPI)

{
	// shalalalaaaaa
}

void AutoPilot::zeroInit()
{

	m_desiredAngle = 0.0;
	m_desiredAlt = 0.0;
	m_desiredAngleMax = 0.0;
	m_desiredAngleMin = 0.0;

	m_attAPengaged = false;
	m_altAPengaged = false;

	m_pitchUpMax = 0.0;
	m_pitchDownMax = 0.0;

	m_autoPilotPitch = 0.0;
	m_autoPilotAngle = 0.0;

	m_verticalControlEngaged = 0.0;

	m_attAP_working = 0.0;
	m_altAP_working = 0.0;

	m_apIsWorkingCorrectly = 0.0;

}

void AutoPilot::coldInit()
{
	zeroInit();
}

void AutoPilot::hotInit()
{
	zeroInit();
}

void AutoPilot::airborneInit()
{
	zeroInit();
}


void AutoPilot::AutoPilotUpdate(double dt)
{
	if ((m_input.getAttAutoPilot() == 0.0) && (m_input.getAutoPEng() == 1.0))
	{
		m_verticalControlEngaged = 1.0;
	}
	else
	{
		m_verticalControlEngaged = 0.0;
	}
	
	VerticalAngleControl(dt);
	AltitudeControl(dt);
	RollControl();
	AP_indicator();

}

void AutoPilot::VerticalAngleControl(double dt)
{
	
	//----Check if electrical energy is sufficent
	bool hasElectricEnergy = false;

	if((m_electricSystemAPI.GetSecondaryFixesFrequencyAcBus() == 1.0) || (m_electricSystemAPI.GetPrimaryDcBus() == 1.0))
	{
		hasElectricEnergy = true;
	}
	else
	{
		hasElectricEnergy = false;
	}



	//---------Start of AP-PID Function-----
	double ActualAngle = 0.0;
	//double desiredMaxPositiveAngle = 0.0;
	//double desiredMaxNegativeAngle = 0.0;
	double desiredMaxPositivePitch = 0.0;
	double desiredMaxNegativePitch = 0.0;
	double deltaTime = 0.0;

	deltaTime = dt;

	//desiredMaxNegativeAngle = -0.261799; // -> -15°
	//desiredMaxPositiveAngle = 0.261799; // -> +15°

	desiredMaxPositivePitch = 0.5; //50% of positive MaxPitch
	desiredMaxNegativePitch = -0.5; //50% of negative MaxPitch

	
	ActualAngle = m_state.m_angle.z;


	//to store actual-angle in desired angle as long as ATT-Hold AP is engaged
	if ((hasElectricEnergy == true) && ((m_input.getAttAutoPilot() == 1.0) || (m_input.getAutoPEng() == 1.0)) && (m_attAPengaged == false))
	{
		m_desiredAngle = ActualAngle;
		m_attAPengaged = true;

		if (m_verticalControlEngaged == 1.0)
		{
			m_desiredAngle = m_autoPilotAngle;
		}
	}
	else if ((hasElectricEnergy == true) && ((m_input.getAttAutoPilot() == 1.0) || (m_input.getAutoPEng() == 1.0)) && ((m_attAPengaged == true) || (m_verticalControlEngaged == 1.0)))
	{
		//just don't touch those two variable and chill
		//m_desiredAngle = 0.0;
		//m_attAPengaged = false;

		if (m_verticalControlEngaged == 1.0)
		{
			m_desiredAngle = m_autoPilotAngle;
		}


		m_pid.p_limMax = desiredMaxPositivePitch;
		m_pid.p_limMin = desiredMaxNegativePitch;
		m_pid.p_Kp = 0.5; //protportional gain
		m_pid.p_Ki = 0.05; //integrational gain
		m_pid.p_Kd = 0.01; //differential gain
		m_pid.p_time = deltaTime;
		m_pid.p_TAU = 0.55;// Wenn Tau näher an 1.0 -> starker Filter; Wenn TAU näher an 0.0 direkter Derivativer-Output 

		m_autoPilotPitch = m_pid.attitudePIDControl(m_desiredAngle, ActualAngle);

	}
	else if ((hasElectricEnergy == true) && ((m_input.getAttAutoPilot() == 0.0) || (m_input.getAutoPEng() == 0.0)) && ((m_attAPengaged == true) || (m_verticalControlEngaged == 1.0)))
	{
		m_desiredAngle = 0.0;
		m_attAPengaged = false;

		m_pid.p_limMax = 0.0;
		m_pid.p_limMin = 0.0;
		m_pid.p_Kp = 0.0; //protportional gain
		m_pid.p_Ki = 0.00; //integrational gain
		m_pid.p_Kd = 0.00; //differential gain
		m_pid.p_time = 0.0;
		m_pid.p_TAU = 0.0;// Wenn Tau näher an 1.0 -> starker Filter; Wenn TAU näher an 0.0 direkter Derivativer-Output

		m_autoPilotPitch = 0.0;
	}
	/*else
	{
		m_desiredAngle = 0.0;
		m_attAPengaged = false;
		m_autoPilotPitch = 0.0;
	}
	*/
}

void AutoPilot::AltitudeControl(double dt)
{
	//----Check if electrical energy is sufficent
	bool hasElectricEnergy = false;

	if ((m_electricSystemAPI.GetSecondaryFixesFrequencyAcBus() == 1.0) || (m_electricSystemAPI.GetPrimaryDcBus() == 1.0))
	{
		hasElectricEnergy = true;
	}
	else
	{
		hasElectricEnergy = false;
	}



	//---------Start of AP-PID Function-----
	
	double ActualAngle = 0.0;
	double ActualAltitude = 0.0;
	double desiredMaxPositiveAngle = 0.0;
	double desiredMaxNegativeAngle = 0.0;
	//double desiredMaxPositivePitch = 0.0;
	//double desiredMaxNegativePitch = 0.0;
	double deltaTime = 0.0;

	deltaTime = dt;

	desiredMaxNegativeAngle = -0.09; // -> -10°
	desiredMaxPositiveAngle = 0.09; // -> +10°

	//desiredMaxPositivePitch = 0.5; //50% of positive MaxPitch
	//desiredMaxNegativePitch = -0.5; //50% of negative MaxPitch


	ActualAngle = m_state.m_angle.z;
	ActualAltitude = m_airframe.getAltInFeet();


	//to store actual-alt in desired angle as long as ALT-Hold AP is engaged
	if ((hasElectricEnergy == true) && (m_input.getAutoPEng() == 1.0) && (m_input.getAttAutoPilot() == 0.0) && (m_altAPengaged == false))
	{
		m_desiredAlt = ActualAltitude;
		m_altAPengaged = true;

	}
	else if ((hasElectricEnergy == true) && (m_input.getAutoPEng() == 1.0) && (m_input.getAttAutoPilot() == 0.0) && (m_altAPengaged == true))
	{
		//just don't touch those two variables and chill
		//----------------------
		//m_desiredAlt = 0.0;
		//m_altAPengaged = false;
		//----------------------
		m_pid.p_ALT_limMax = desiredMaxPositiveAngle;
		m_pid.p_ALT_limMin = desiredMaxNegativeAngle;
		m_pid.p_ALT_Kp = 0.0025; //protportional gain//0.5 -> 0.4 -> 0.3 -> 0.15 -> 0.10
		m_pid.p_ALT_Ki = 0.0001; //integrational gain// 0.05 -> 0.07 -> 0.10
		m_pid.p_ALT_Kd = 0.0005; //differential gain//0.01 -> 0.15 -> 0.25 -> 0.45
		m_pid.p_ALT_time = deltaTime;
		m_pid.p_ALT_TAU = 0.55;// Wenn Tau näher an 1.0 -> starker Filter; Wenn TAU näher an 0.0 direkter Derivativer-Output 

		m_autoPilotAngle = m_pid.altitudePIDControl(m_desiredAlt, ActualAltitude); 

	}
	else if ((hasElectricEnergy == true) && (m_input.getAutoPEng() == 0.0) && (m_input.getAttAutoPilot() == 0.0) && (m_altAPengaged == true))
	{
		m_desiredAlt = 0.0;
		m_altAPengaged = false;

		m_pid.p_ALT_limMax = 0.0;
		m_pid.p_ALT_limMin = 0.0;
		m_pid.p_ALT_Kp = 0.0; //protportional gain
		m_pid.p_ALT_Ki = 0.00; //integrational gain
		m_pid.p_ALT_Kd = 0.00; //differential gain
		m_pid.p_ALT_time = 0.0;
		m_pid.p_ALT_TAU = 0.0;// Wenn Tau näher an 1.0 -> starker Filter; Wenn TAU näher an 0.0 direkter Derivativer-Output

		m_autoPilotAngle = 0.0;

		//Wenn SOWOHL ATT als auch ALT-AP ausgeschaltet sind, müssen ALLE PID-Werte zurückgesetz werden!!!
		m_desiredAngle = 0.0;
		m_attAPengaged = false;

		m_pid.p_limMax = 0.0;
		m_pid.p_limMin = 0.0;
		m_pid.p_Kp = 0.0; //protportional gain
		m_pid.p_Ki = 0.00; //integrational gain
		m_pid.p_Kd = 0.00; //differential gain
		m_pid.p_time = 0.0;
		m_pid.p_TAU = 0.0;// Wenn Tau näher an 1.0 -> starker Filter; Wenn TAU näher an 0.0 direkter Derivativer-Output

		m_autoPilotAngle = 0.0;//NUR beim Ausschalten auf 0.0 setzen, nicht IMMER, weil sonst Alt-AP nicht geht
	}
	/*else
	{
		m_desiredAlt = 0.0;
		m_altAPengaged = false;
		m_autoPilotAngle = 0.0;
	}
	*/



}

void AutoPilot::RollControl()
{

}

void AutoPilot::AP_indicator()
{
	
	bool hasElectricEnergy = false;

	if ((m_electricSystemAPI.GetSecondaryFixesFrequencyAcBus() == 1.0) || (m_electricSystemAPI.GetPrimaryDcBus() == 1.0))
	{
		hasElectricEnergy = true;
	}
	else
	{
		hasElectricEnergy = false;
	}

	if ((hasElectricEnergy == true) && ((m_input.getAttAutoPilot() == 1.0) || (m_input.getAutoPEng() == 1.0)))
	{
		//Attittude AP Engaged and working
		m_attAP_working = 1.0;
		//m_altAP_working = 0.0;
	}
	else
	{
		m_attAP_working = 0.0;
	}
	
	if ((hasElectricEnergy == true) && ((m_input.getAutoPEng() == 1.0) && (m_input.getAttAutoPilot() == 0.0)))
	{
		m_altAP_working = 1.0;
	}
	else
	{
		m_altAP_working = 0.0;
	}

	if ((m_altAP_working == 1.0) || (m_attAP_working == 1.0))
	{
		m_apIsWorkingCorrectly = 1.0;
	}
	else
	{
		m_apIsWorkingCorrectly = 0.0;
	}

}