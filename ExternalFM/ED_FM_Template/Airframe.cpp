#include "Airframe.h"
#include <algorithm>
#include <random>
#include <cstdlib>
#include <ctime>
#include <chrono>

//=========================================================================//
//
//		FILE NAME	: Airframe.cpp
//		AUTHOR		: Joshua Nelson & A4-Comunity-Team & Paul Stich
//		Copyright	: Joshua Nelson & A4-Comunity-Team & Paul Stich
//		DATE		: August 2021
//
//		DESCRIPTION	: All moving parts, gauges, indicators, stick and throttle 
//					  and external animations that are driven from within the EFM.
//					  AND internal damage modell.
//================================ Includes ===============================//
//=========================================================================//

//-----------Neu eingefügt wegen Chrono und Millisekunden---------
using std::chrono::duration_cast;
using std::chrono::milliseconds;
using std::chrono::seconds;
using std::chrono::system_clock;
//-----------------------------------------------------------------

Airframe::Airframe(State& state, Input& input, Engine& engine, ElectricSystemAPI& electricSystemAPI, RamAirTurbine& ramAirTurbine) :
	m_state(state),
	m_input(input),
	m_engine(engine),
	m_electricSystemAPI(electricSystemAPI),
	m_ramAirTurbine(ramAirTurbine),
	m_actuatorFlap(0.9),
	m_actuatorAirbrk(1.2),
	m_actuatorGearL(0.2),
	m_actuatorGearN(0.2),
	m_actuatorGearR(0.2),
	m_actuatorHook(0.6),
	m_actuatorNozzle(1.1),
	m_actuatorNosewheel(2.0),
	m_actuatorChuteY(3.0),
	m_actuatorChuteZ(3.0)
{
	m_integrityElement = new float[(int)Damage::COUNT];
	zeroInit();

	m_damageStack.reserve(10);
}

Airframe::~Airframe()
{
	delete[] m_integrityElement;
}

void Airframe::printDamageState()
{
	printf("===========================================\n");

	printf("            ||\n");
	printf("            ||\n");
	printf("%.1lf %.1lf %.1lf || %.1lf %.1lf %.1lf\n",
		DMG_ELEM(Damage::WING_L_OUT),
		DMG_ELEM(Damage::WING_L_CENTER),
		DMG_ELEM(Damage::WING_L_IN),
		DMG_ELEM(Damage::WING_R_IN),
		DMG_ELEM(Damage::WING_R_CENTER),
		DMG_ELEM(Damage::WING_R_OUT));

	printf("        %.1f || %.1f\n", DMG_ELEM(Damage::AILERON_L), DMG_ELEM(Damage::AILERON_R));
	printf("            ||\n");
	printf("        %.1f || %.1f\n", DMG_ELEM(Damage::STABILIZATOR_L), DMG_ELEM(Damage::STABILIZATOR_R));
	printf("        %.1f || %.1f\n", DMG_ELEM(Damage::ELEVATOR_L), DMG_ELEM(Damage::ELEVATOR_R));
	printf("            %.1f\n", getVertStabDamage());
	printf("            %.1f\n", getRudderDamage());
}

void Airframe::resetDamage()
{
	for (int i = 0; i < (int)Damage::COUNT; i++)
	{
		m_integrityElement[i] = 1.0f;
	}
}

void Airframe::zeroInit()
{
	//-----------WeightOnWheels-Sensor--------------
	m_weightOnWheels = 0.0;
	
	//---Gear position--------
	m_gearLPosition = 0.0;
	m_gearRPosition = 0.0;
	m_gearNPosition = 0.0;

	m_gear = 0.0;

	m_gearFLamp = 0.0;
	m_gearLLamp = 0.0;
	m_gearRLamp = 0.0;

	m_instLightOn = 0.0;

	
	m_gunSwitch = 0.0;

	/*
	m_pylonIndLightG = 0.0;
	m_pylonIndLightA = 0.0;
	m_pylonIndLight = 0.0;
	*/
	//----------gear--------
	m_gearStart = 0.0;

	m_gearOversped = 0.0;
	m_flapOversped = 0.0;

	m_flapOSind = 0.0;
	m_gearOSind = 0.0;

	//---------AntiSkid----------------
	m_antiSkid = 0.0;
	m_antiSkidFunctional = false;

	//------aerodynamic surfaces-------
	m_flapsPosition = 0.0;
	m_speedBrakePosition = 0.0;
	m_airbrake = 0.0;
	m_speedBrakeFunctional = 0.0;

	m_aileronLeft = 0.0;
	m_aileronRight = 0.0;
	m_stabilizer = 0.0;
	m_rudder = 0.0;

	m_ailDef = 0.0;
	m_rudDef = 0.0;

	m_brakeLeft = 0.0;
	m_brakeRight = 0.0;
	m_brakeMoment = 0.0;

	//----Speed-O-Meters--------------
	m_vMetEAS = 0.0;
	m_vKnotsEAS = 0.0;
	m_vKnotsEASInd = 0.0;
	m_vKnotsCAS = 0.0;
	m_vMach = 0.0;
	m_altInM = 0;
	m_altInFt = 0;
	m_altIndTenThousands = 0;
	m_altIndThousands = 0;
	m_altIndHundreds = 0.0;
	m_altIndTens = 0.0;
	m_retAltIndTK = 0.0;
	m_retAltIndK = 0.0;

	//----------QNH-Variables-------------
	m_qnhVar = 101320;//NEU statt 101325.0
	m_indQnhThousand = 0.0;
	m_indQnhHundred = 0.0;
	m_indQnhTen = 0.0;
	m_indQnhOne = 0.0;
	m_retIndQnhHundred = 0.0;
	
	
	
	m_hookPosition = 0.0;
	m_hookInd = 0.0;

	m_noseWheelAngle = 0.0;

	resetDamage();
	
	
	m_nozzlePosition = 0.0;

	m_int_throttlePos = 0.0;

	//set to "0" after each init
	//m_input.m_brake = 0.0; geht nicht, da jetzt funktion
	
	//m_chuteSlewingZ = false;
	//m_chuteSlewingY = false;//Neu eingefügt zum Testen für Chute return 0.0;
	//m_chuteTimeZPassed = 0;
	//m_chuteTimeYPassed = 0;

	m_nwsEngage = 0.0;
	m_chuteState = 0.0;
	m_brkChuteInd = 0.0;
	m_chuteDeployed = false;
	m_speedBrakeInd = 0.0;
	m_mass = 1.0;
	
	m_damageStack.clear();
	
	m_timePassed = 0;

	m_engDmgMulti = 1.0;


	m_desiredAlt = 0.0;
	m_previousAlt = 0.0;
	m_autPilAltEng = 0.0;
	m_altHold = 0.0;
	m_ascHA = 0.0;
	m_decHA = 0.0;
	m_decend = false;
	m_acend = false;
	m_level = false;
	m_acendHoldAngle = false;
	m_decendHoldAngle = false;

	m_autoPilotInd = 0.0;

	m_flapsLevPos = 0.0;
	m_flapsIndTEPos = 0.0;
	m_flapsIndLEPos = 0.0;

	m_fuelHundred = 0.0;
	m_fuelThousand = 0.0;
	m_fuelDivide = 0.0;

	m_horizonRollAngle = 0.0;
	m_horizonRollValue = 0.0;
	m_horizonPitchAngle = 0.0;
	m_horizonPitchValue = 0.0;

	/*m_elevUP = 0.0;
	m_elevDOWN = 0.0;
	m_ailRIGHT = 0.0;
	m_ailLEFT = 0.0;
	m_rudRIGHT = 0.0;
	m_rudLEFT = 0.0;
	
	m_keyPitch = 0.0;
	m_keyRoll = 0.0;
	m_keyYaw = 0.0;

	m_finalPitch = 0.0;
	m_finalRoll = 0.0;
	m_finalYaw = 0.0;*/

	m_ailDamInd = 0.0;
	m_stabDamInd = 0.0;

	m_scalarVelocity = 0.0;

	m_chuteYAxis = 0.0;
	m_chuteZAxis = 0.0;

	//-------------Hydraulic Stuff--------------
	m_hydroPumpOne = 0.0;
	m_hydroPumpTwo = 0.0;
	m_ramAirHydroPump = 0.0;
	m_hydroSystemStatus = 0.0;
	m_hydroPower = 0.0;

	m_hydroSysOneVALUE = 0.0;
	m_hydroSysTwoVALUE = 0.0;

	//-----------CrossHair Test Stuff------------
	//-----komplett auskommentiert, da alles über CockpitScripts jetzt
	/*
	m_crossHairHori = 0.0;
	m_crossHairVerti = 0.46;

	m_vertAccPrevY = 0.0;
	m_vertAccdotY = 0.0;
	m_vertAccPrevZ = 0.0;
	m_vertAccdotZ = 0.0;

	m_CHforceVerticalDPure = 0.0;
	m_CHforceVerticalDSmooth = 0.0;
	m_CHforceHori = 0.0;

	m_smoothingValue = 0.0;
	m_smoothingValue2 = 0.0;
	m_smoothingFactor = 0.0;
	m_firstCallV = true;

	m_radiusV = 0.0;
	m_radiusH = 0.0;
	m_defAngleVCOS = 0.0;
	m_defAngleV = 0.0;
	m_defAngleHCOS = 0.0;
	m_defAngleH = 0.0;
	m_angleIndNen = 0.0;
	m_thetaV = 0.0;
	m_thetaH = 0.0;
	m_omegaV = 0.0;
	m_omegaH = 0.0;
	m_targetDist = 600.0;
	m_bulletSpeed = 1050.0;
	m_defAngleVCNen = 0.1;
	m_centriPetalV = 0.0;

	m_moveSightH = 0.0;
	m_moveSightV = 0.0;
	*/

	m_actuatorFlap.revOverSpeedMalFunction();
	m_actuatorGearL.revOverSpeedMalFunction();
	m_actuatorGearN.revOverSpeedMalFunction();
	m_actuatorGearR.revOverSpeedMalFunction();
}

void Airframe::coldInit()
{
	zeroInit();
	
	//--Ground Init SET Actuator---------
	m_actuatorGearL.groundInit(1.0, 1.0);
	m_actuatorGearN.groundInit(1.0, 1.0);
	m_actuatorGearR.groundInit(1.0, 1.0);
	
	//---Gear position--------
	m_gearLPosition = 0.0;
	m_gearRPosition = 0.0;
	m_gearNPosition = 0.0;

	//-----gear position for ground start
	m_gearStart = 0.0;
	m_gear = 1.0;
	//m_actuatorGearL = 0.0;
	//m_actuatorGearN = 0.0;
	//m_actuatorGearR = 0.0;
	//m_input.m_gear_toggle = 1.0; auskommentiert weil nicht zeroable da jetzt funktion
	
	//------aerodynamic surfaces-------
	m_flapsPosition = 0.0;
	m_speedBrakePosition = 0.0;

	m_aileronLeft = 0.0;
	m_aileronRight = 0.0;
	m_stabilizer = 0.0;
	m_rudder = 0.0;

	m_hookPosition = 0.0;

	m_noseWheelAngle = 0.0;

	m_nozzlePosition = 0.0;
	m_int_throttlePos = 0.0;

	//m_input.m_brake = 0.0; geht nicht, da jetzt funktion

	m_nwsEngage = 0.0;
	m_chuteState = 0.0;
	m_mass = 1.0;
	m_timePassed = 0;

}

void Airframe::hotInit()
{
	zeroInit();

	//--Ground Init SET Actuator---------
	m_actuatorGearL.groundInit(1.0, 1.0);
	m_actuatorGearN.groundInit(1.0, 1.0);
	m_actuatorGearR.groundInit(1.0, 1.0);
	//---Gear position--------
	m_gearLPosition = 0.0;
	m_gearRPosition = 0.0;
	m_gearNPosition = 0.0;

	m_gear = 1.0;

	//---Gear position for ground start----------
	m_gearStart = 0.0;
	//m_actuatorGearL = 0.0;
	//m_actuatorGearN = 0.0;
	//m_actuatorGearR = 0.0;
	//m_input.m_gear_toggle = 1.0; nicht mehr setzbar, da jetzt funktion

	//------aerodynamic surfaces-------
	m_flapsPosition = 0.0;
	m_speedBrakePosition = 0.0;

	m_aileronLeft = 0.0;
	m_aileronRight = 0.0;
	m_stabilizer = 0.0;
	m_rudder = 0.0;

	m_hookPosition = 0.0;

	m_noseWheelAngle = 0.0;

	m_nozzlePosition = 0.0;
	m_int_throttlePos = 0.0;

	//m_input.m_brake = 0.0; geht nicht, da jetzt funktion
	
	m_nwsEngage = 0.0;
	m_chuteState = 0.0;
	m_mass = 1.0;
	m_timePassed = 0;

	m_hydroPumpOne = 1.0;
	m_hydroPumpTwo = 1.0;
	m_ramAirHydroPump = 0.0;
	m_hydroSystemStatus = 1.0;
}

void Airframe::airborneInit()
{
	zeroInit();

	m_hydroPumpOne = 1.0;
	m_hydroPumpTwo = 1.0;
	m_ramAirHydroPump = 0.0;
	m_hydroSystemStatus = 1.0;
}


void Airframe::airframeUpdate(double dt)
{
	

	m_scalarVelocity = magnitude(m_state.m_localAirspeed);

	

	//printf("LEFT: %lf, CENTRE: %lf, RIGHT: %lf, INTERNAL: %lf\n", m_fuel[Tank::LEFT_EXT], m_fuel[Tank::CENTRE_EXT], m_fuel[Tank::RIGHT_EXT], m_fuel[Tank::INTERNAL]);
	//m_engine.setHasFuel(m_fuel[Tank::INTERNAL] > 20.0);

	//printf( "Compressor Damage %lf, Turbine Damage: %lf\n", getCompressorDamage(), getTurbineDamage() );
	
	//m_engine.setIntegrity(DMG_ELEM(Damage::ENGINE)); NOCH einfügen in der engine-class
	
	aeroSurfaceMulti(dt);//NEU
	
	m_stabilizer = setStabilizer(dt);
	m_aileronLeft = setAileron(dt);
	m_aileronRight = -m_aileronLeft;
	m_rudder = setRudder(dt);
	
	m_flapsPosition = setFlapsPosition(dt);
	m_speedBrakePosition = setAirbrakePosition(dt);
	
	m_gearLPosition = setGearLPosition(dt);
	m_gearRPosition = setGearRPosition(dt);
	m_gearNPosition = setGearNPosition(dt);

	
	m_hookPosition = setHookPosition(dt);

	m_chuteYAxis = setChutePositionY(dt);
	m_chuteZAxis = setChutePositionZ(dt);

	m_nozzlePosition = setNozzlePosition(dt);

	m_noseWheelAngle = setNoseWheelAngle(dt);

	//Neuer Test, falls der KeyBind nur beim Drücke "1" ist
	//m_flapsPosition = getFlapsPosition();
	
	//printf("Flp-Down-Value %f \n", m_input.m_flapsdown);
	//printf("Flp-Up-Value %f \n", m_input.m_flapsup);
	
	
	//---------Engine flame-out function------------------

	if (((getCompressorDamage() < 0.15) || (getTurbineDamage() < 0.15)) && (m_input.getEngineStart() == 1))
	{
		m_engine.m_needRepair = true;
		m_engine.m_needRestart = true; 
	}
	/*else if (((getCompressorDamage() < 0.15) || (getTurbineDamage() < 0.15)) && (m_input.m_engine_start == 0) && (m_input.m_engine_stop == 0))
	{
		m_input.m_engine_stop = 2.0;
		m_input.m_engine_start = 2.0;
	}*/
	else if ((getCompressorDamage() >= 0.65) && (getTurbineDamage() >= 0.65) && (m_engine.m_needRestart == false))
	{
		m_engine.m_needRepair = false;
	}

	//------------------AutoPilot-Update------------------
	autoPilotAltH(dt);


//------------------FuelFlow Indicator Update-----------(NEU ggf. überflüssig)
	fuelFlowIndGaugeUpdate();
	//printf("FuelIndicator %f \n", m_fuelThousand);

//----------Brake update---------------(NEU ggf. überflüssig)
	//updateBrake();

//---------Internal Throttle Position update---(NEU, ggf. überflüssig)
	//getIntThrottlePosition();

//----Alle folgenden NEU eingefpgt und von () zu (doubel dt) geändert!!!
	//brkChutePosition();
	//brkChuteSlewY();
	//brkChuteSlewZ();

	//BLCsystem();
	getEngineDamageMult();

	//----SpeedIndicator-Functions------------
	airSpeedInKnotsEASInd();
	//airSpeedInKnotsCASInd();
	airSpeedInMachInd();
	altitudeInd();

	osGearDamage();
	osFlapDamage();

	//pylonIndLights();

	
	//printf("AS_Knots_EAS_Indicator %f \n", airSpeedInKnotsEASInd());
	


	horizonPitchValue();
	horizonRollValue();

	hydraulicPump();
	hydroGaugeSysONE();
	hydroGaugeSysTWO();

	updateAirBrake();
	updateGear();
	NWSstate();
	antiSkidSystem();
	
	//printf("Horizon_Pitch_Angle %f\n", m_horizonPitchAngle);
	//printf("Horizon_Pitch_Value %f\n", m_horizonPitchValue);
	//printf("Horizon_Roll_Angle %f\n", m_horizonRollAngle);
	//printf("Horizon_Roll_Value %f\n", m_horizonRollValue);
	//printf("Input_CrossH_Down %f \n", m_input.getCrossHDown());
	
}

//-------------Neu eingefügt für multiplikator AERO-Surfaces--------------
void Airframe::aeroSurfaceMulti(double dt)
{
	if (getGearNPosition() > 0.1)
	{
		m_ailDef = 1.0;
	}
	if (getGearNPosition() == 0.0)
	{
		m_ailDef = 0.5;
	}

	if (getGearNPosition() > 0.1)
	{
		m_rudDef = 1.0;
	}
	if (getGearNPosition() == 0.0)
	{
		m_rudDef = 0.5;
	}
}

//----------Wheel-Brakes-------------------------------------------------
double Airframe::updateBrake()
{
	//m_brakeMoment = 0.0;//überflüssig weil in ZeroInit auf 0.0 gesetzt
	
	/*if (m_input.m_release_brake == 1.0)
	{
		if (m_input.m_brake == 1.0)
		{
			m_input.m_brake = 0.0;
			m_input.m_release_brake = 0.0;
		}
	}*/ //wurde in Input.cpp verschoben "setBrake()"
	
	if (m_input.getBrake() == 1.0)
	{
		m_brakeMoment = 0.66;
	}
	else
	{
		m_brakeMoment = 0.0;
	}
	
	return m_brakeMoment;
}

double Airframe::updateBrakeLeft()
{
	if (updateBrake() != 0.0)
	{
		m_brakeLeft = updateBrake();
	}
	else
	{
		m_brakeLeft = m_input.getBrakeLeft();
	}

	return m_brakeLeft;
}

double Airframe::updateBrakeRight()
{
	if (updateBrake() != 0.0)
	{
		m_brakeRight = updateBrake();
	}
	else
	{
		m_brakeRight = m_input.getBrakeRight();
	}
	return m_brakeRight;
}
//------------------------------------------------

//----------Airbrake-----------------------------
void Airframe::updateAirBrake()
{
	if (m_hydroPumpTwo == 1.0)
	{
		m_speedBrakeFunctional = 1.0;
	}
	else
	{
		m_speedBrakeFunctional = 0.0;
	}

	if ((m_input.getAirbrake() == 1.0) && (m_speedBrakeFunctional == 1.0))
	{
		m_airbrake = 1.0;
	}
	else if ((m_input.getAirbrake() == 0.0) && (m_speedBrakeFunctional == 1.0))
	{
		m_airbrake = 0.0;
	}

}

//-----------Gear-------------------------------
void Airframe::updateGear()
{
	if ((m_input.getGearToggle() == 1.0) && (m_hydroPumpTwo == 1.0))
	{
		m_gear = m_input.getGearToggle();
	}
	else if ((m_input.getGearToggle() == 0.0) && (m_hydroPumpTwo == 1.0))
	{
		m_gear = m_input.getGearToggle();
	}
}

//---------------------------------------------

//-------------AntiSkid------------------------

void Airframe::antiSkidSystem()
{
	
	if (m_hydroPumpTwo == 1.0)
	{
		m_antiSkid = 1.0;
	}
	else
	{
		m_antiSkid = 0.0;
	}

}

double Airframe::setNozzlePosition(double dt) //Nozzle-Position 0-10% Thrust open, 11-84% Thrust closed, 85-100% Thrust open
{
	double NozzlePos = 0.0;
	double corrThrottle = 0.0;

	if (m_input.getThrottle() >= 0.0)
	{
		corrThrottle = (1 - CON_ThrotIDL) * m_input.getThrottle() + CON_ThrotIDL;
	}
	else
	{
		corrThrottle = (m_input.getThrottle() + 1.0) / 2.0;
	}

	if (corrThrottle <= 0.10)
	{
		NozzlePos = 0.4;
	}
	else if (corrThrottle >= 0.85)
	{
		NozzlePos = 0.80;
	}
	else
	{
		NozzlePos = 0.2;
	}

	double input = NozzlePos;
	return m_actuatorNozzle.inputUpdate(input, dt);
}

double Airframe::getIntThrottlePosition()
{
	m_int_throttlePos = 0.0;
	double corrThrottle = 0.0;

	if (m_input.getThrottle() >= 0.0)
	{
		corrThrottle = (1.0 - CON_ThrotIDL) * m_input.getThrottle() + CON_ThrotIDL;
	}
	else
	{
		corrThrottle = (m_input.getThrottle() + 1.0) / 2.0;
	}

	m_int_throttlePos = corrThrottle;

	return m_int_throttlePos;
}

double Airframe::NWSstate()
{
	if ((m_input.getNWS() == 1.0) && (m_hydroPumpTwo == 1.0))
	{
		m_nwsEngage = m_input.getNWS();
	}
	else if ((m_input.getNWS() == 0.0) && (m_hydroPumpTwo == 1.0))
	{
		m_nwsEngage = m_input.getNWS();
	}
	else
	{
		m_nwsEngage = 0.0;
	}
	return m_nwsEngage;
}

double Airframe::brkChutePosition()
{
	int timeToGo1 = 20; //war 50, jetzt aber meherere Stationen
	int timeToGo2 = 40;
	int timeToGo3 = 60;
	int timeToGo4 = 80;

	if ((m_input.getBrkChute() == 1) && (m_timePassed < timeToGo1) && (m_chuteDeployed == false))
	{
		m_chuteState = 0.2;
	}
	if (m_chuteState == 0.2) 
	{
		m_timePassed++;
	}
	if ((m_chuteState == 0.2) && (m_timePassed >= timeToGo1) && (m_timePassed < timeToGo2)) 
	{
		m_chuteState = 0.5;
	}
	if (m_chuteState == 0.5)
	{
		m_timePassed++;
	}
	if ((m_chuteState == 0.5) && (m_timePassed >= timeToGo2) && (m_timePassed <= timeToGo3))
	{
		m_chuteState = 0.7;
	}
	if (m_chuteState == 0.7)
	{
		m_timePassed++;
	}
	if ((m_chuteState == 0.7) && (m_timePassed >= timeToGo3))
	{
		m_chuteState = 1.0;
		m_timePassed = 85;
	}
	else if (m_input.getBrkChute() == 0.0)
	{
		m_chuteState = 0.0;
		m_timePassed = 0;
	}
	else if (m_input.getBrkChute() == 2.0)
	{
		m_chuteState = 0.0;
		m_timePassed = 0;
		m_chuteDeployed = true; //jetzt gibt es keine unendlichen Bremsfallschirme mehr...
	}
	if ((m_engine.getRPMNorm() == 0.0) && (m_state.m_mach <= 0.1))
	{
		m_chuteDeployed = false;
	}

	return m_chuteState;
}

double Airframe::brkChuteInd()
{
	if ((m_input.getElectricSystem() == 1.0) && ((brkChutePosition() == 1.0) || (m_input.getBrkChute() == 2.0)))
	{
		m_brkChuteInd = 1.0; //brkChutePosition();
	}
	else
	{
		m_brkChuteInd = 0.0;
	}
	return m_brkChuteInd;
}


double Airframe::brkChuteSlewY()
{
	m_chuteSlewY = 0.0; 
	double m_chuteDiceRoll = 0.0;
	int dice_roll = 0;
	int dice_roll1 = 0;
	int dice_roll2 = 0;
	double m_mach_speed = 0.0;
	m_mach_speed = m_state.m_mach;
	
	if (m_chuteState != 0)
	{
		
		if (m_mach_speed >= 0.12)
		{
			/*std::default_random_engine generator;
			std::uniform_int_distribution<int> distribution(1, 19);
			dice_roll = distribution(generator);  // generates number in the range 1-19 */
			
			int mill_seconds = (duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count()) / 100; //weil es eine INT ist macht / 100 Sinn, da dann nur jede 10tel-Sekunde eine neue Zahl kommt, da gerundet wird.

			srand(mill_seconds); //vorher srand(timt(0)); das gab die sekunden-ticks zurück, wir brauchen aber millisekunden

			dice_roll = (rand() % 19) + 1;

			if ((dice_roll == 2) || (dice_roll == 1))
			{
				m_chuteDiceRoll = -0.05; //was -0.65	
				//m_chuteSlewingY = true; //Neu überall eingefügt, ggf. wieder hier und im If entfernen
			}
			if ((dice_roll == 3) || (dice_roll ==4 ))
			{
				m_chuteDiceRoll = 0.00; //was -0.55
				//m_chuteSlewingY = true;
			}
			if ((dice_roll == 5) || (dice_roll == 6))
			{
				m_chuteDiceRoll = 0.10;//was -0.40
				//m_chuteSlewingY = true;
			}
			if ((dice_roll == 7) || (dice_roll == 8))
			{
				m_chuteDiceRoll = 0.25;//was -0.19
				//m_chuteSlewingY = true;
			}
			if ((dice_roll == 9) || (dice_roll == 10))
			{
				m_chuteDiceRoll = 0.35;//was 0.0
				//m_chuteSlewingY = true;
			}
			if ((dice_roll == 11) || (dice_roll == 12))
			{
				m_chuteDiceRoll = 0.55; //was 0.19	
				//m_chuteSlewingY = true;
			}
			if ((dice_roll == 13) || (dice_roll == 14))
			{
				m_chuteDiceRoll = 0.65; //was 0.40	
				//m_chuteSlewingY = true;
			}
			if ((dice_roll == 15) || (dice_roll == 16))
			{
				m_chuteDiceRoll = 0.80;//was 0.55	
				//m_chuteSlewingY = true;
			}
			if (dice_roll >= 17)
			{
				m_chuteDiceRoll = 0.95;//was 0.65	
				//m_chuteSlewingY = true;
			}
			
			m_chuteSlewY = m_chuteDiceRoll;
			return m_chuteSlewY;
		}
		if ((m_mach_speed >= 0.05) && (m_mach_speed < 0.11))// && (m_chuteSlewing == false))
		{
			/*std::default_random_engine generator;
			std::uniform_int_distribution<int> distribution(1, 11);
			dice_roll1 = distribution(generator);  // generates number in the range -0.20....0.20*/ 
			
			int mill_seconds = (duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count()) / 100;

			srand(mill_seconds); //vorher srand(timt(0)); das gab die sekunden-ticks zurück, wir brauchen aber millisekunden

			dice_roll1 = (rand() % 11) + 1;

			if (dice_roll1 <= 2)
			{
				m_chuteDiceRoll = -0.05;//was -0.35
				//m_chuteSlewingY = true;
			}
			if ((dice_roll1 == 3) || (dice_roll1 == 4))
			{
				m_chuteDiceRoll = 0.05;//was -0.15
				//m_chuteSlewingY = true;
			}
			if ((dice_roll1 == 5) || (dice_roll1 == 6))
			{
				m_chuteDiceRoll = 0.10;//was -0.05
				//m_chuteSlewingY = true;
			}
			if ((dice_roll1 == 7) || (dice_roll1 == 8))
			{
				m_chuteDiceRoll = 0.35;//was 0.10
				//m_chuteSlewingY = true;
			}
			if (dice_roll1 >= 9)
			{
				m_chuteDiceRoll = 0.60;//was 0.25
				//m_chuteSlewingY = true;
			}
			m_chuteSlewY = m_chuteDiceRoll;
			return m_chuteSlewY;
		}
		if ((m_mach_speed < 0.05) && (m_mach_speed > 0.00))// && (m_chuteSlewing == false))
		{
			/*std::default_random_engine generator;
			std::uniform_int_distribution<int> distribution(1, 11);
			dice_roll2 = distribution(generator);  // generates number in the range -0.20....0.20*/
			
			int mill_seconds = (duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count()) / 100;

			srand(mill_seconds); //vorher srand(timt(0)); das gab die sekunden-ticks zurück, wir brauchen aber millisekunden


			dice_roll2 = (rand() % 11) + 1;

			if (dice_roll2 <= 2)
			{
				m_chuteDiceRoll = -0.15;//was -0.99
				//m_chuteSlewingY = true;
			}
			if ((dice_roll2 == 3) || (dice_roll2 == 4))
			{
				m_chuteDiceRoll = -0.05;//was -0.95
				//m_chuteSlewingY = true;
			}
			if ((dice_roll2 == 5) || (dice_roll2 == 6))
			{
				m_chuteDiceRoll = 0.05;//was -0.90
				//m_chuteSlewingY = true;
			}
			if ((dice_roll2 == 7) || (dice_roll2 == 8))
			{
				m_chuteDiceRoll = 0.15;//was -0.89
				//m_chuteSlewingY = true;
			}
			if (dice_roll2 >= 9)
			{
				m_chuteDiceRoll = 0.25;//was -0.87
				//m_chuteSlewingY = true;
			}
			m_chuteSlewY = m_chuteDiceRoll;
			return m_chuteSlewY;
		}
		if (m_mach_speed == 0.00)
		{
			m_chuteSlewY = 0.00;//was -1.0
			//m_chuteSlewingY = false;

			return m_chuteSlewY;
		}		
	}
	
	return 0.0;

	/*if (m_chuteSlewingY == true)
	{
	int chuteTimeToPass = 10;

		if (m_chuteTimeYPassed < chuteTimeToPass)
		{
			m_chuteTimeYPassed++;
		}
		if (m_chuteTimeYPassed >= chuteTimeToPass)
		{
			m_chuteSlewingY = false;
			m_chuteTimeYPassed = 0;
			m_chuteSlewY = 0.0;
			return m_chuteSlewY;
		}
	//return m_chuteSlewY;
	}

	printf("ChuteYTimePassed %f \n", m_chuteTimeYPassed);
	*/
}

double Airframe::brkChuteSlewZ()
{
	//m_chuteSlewZ = 0.0; auskommentiert zum testen
	double m_chuteDiceRoll = 0.0;
	int dice_roll = 0;
	int dice_roll1 = 0;
	int dice_roll2 = 0;
	double m_mach_speed = 0.0;
	m_mach_speed = m_state.m_mach;

	if (m_chuteState != 0)// && (m_chuteSlewingZ == false))
	{
	
		if (m_mach_speed >= 0.12)
		{
			/*std::default_random_engine generator;
			std::uniform_int_distribution<int> distribution(1, 19);
			dice_roll = distribution(generator);  // generates number in the range -0.75....0.75 
			*/
			int mill_seconds = (duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count()) / 100;

			srand(mill_seconds); //vorher srand(timt(0)); das gab die sekunden-ticks zurück, wir brauchen aber millisekunden

			dice_roll = (rand() % 19) + 1;

			if (dice_roll <= 3)
			{
				m_chuteDiceRoll = -0.95;
				//m_chuteSlewingZ = true;
				//dice_roll = 0;
			}
			if ((dice_roll == 4) || (dice_roll == 5))
			{
				m_chuteDiceRoll = -0.75;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll == 6) || (dice_roll == 7))
			{
				m_chuteDiceRoll = -0.44;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll == 8) || (dice_roll == 9))
			{
				m_chuteDiceRoll = -0.19;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll == 10) || (dice_roll == 11))
			{
				m_chuteDiceRoll = 0;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll == 12) || (dice_roll == 13))
			{
				m_chuteDiceRoll = 0.19;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll == 14) || (dice_roll == 15))
			{
				m_chuteDiceRoll = 0.44;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll == 16) || (dice_roll == 17))
			{
				m_chuteDiceRoll = 0.75;
				//m_chuteSlewingZ = true;
			}
			if (dice_roll >= 18)
			{
				m_chuteDiceRoll = 0.95;
				//m_chuteSlewingZ = true;
			}
			m_chuteSlewZ = m_chuteDiceRoll;
			return m_chuteSlewZ;
			}
		if ((m_mach_speed >= 0.05) && (m_mach_speed < 0.12))
			{
			/*std::default_random_engine generator;
			std::uniform_int_distribution<int> distribution(1, 11);
			dice_roll1 = distribution(generator);  // generates number in the range -0.20....0.20 
			*/

			int mill_seconds = (duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count()) / 100;

			srand(mill_seconds); //vorher srand(timt(0)); das gab die sekunden-ticks zurück, wir brauchen aber millisekunden

			dice_roll1 = (rand() % 11) + 1;

			if (dice_roll1 <= 2)
			{
				m_chuteDiceRoll = -0.45;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll1 == 3) || (dice_roll1 == 4))
			{
				m_chuteDiceRoll = -0.25;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll1 == 5) || (dice_roll1 == 6))
			{
				m_chuteDiceRoll = 0.00;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll1 == 7) || (dice_roll1 == 8))
			{
				m_chuteDiceRoll = 0.25;
				//m_chuteSlewingZ = true;
			}
			if (dice_roll1 >= 9)
			{
				m_chuteDiceRoll = 0.45;
				//m_chuteSlewingZ = true;
			}
			m_chuteSlewZ = m_chuteDiceRoll;
			return m_chuteSlewZ;
			}
		if ((m_mach_speed < 0.05) && (m_mach_speed > 0.00))
			{
			/*std::default_random_engine generator;
			std::uniform_int_distribution<int> distribution(1, 11);
			dice_roll2 = distribution(generator);  // generates number in the range -0.20....0.20 
			*/
			int mill_seconds = (duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count()) / 100; //NEU wegen Chrono

			srand(mill_seconds); //vorher srand(timt(0)); das gab die sekunden-ticks zurück, wir brauchen aber millisekunden

			dice_roll2 = (rand() % 11) + 1;

			if (dice_roll2 <= 2)
			{
				m_chuteDiceRoll = -0.15;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll2 == 3) || (dice_roll2 == 4))
			{
				m_chuteDiceRoll = -0.07;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll2 == 5) || (dice_roll2 == 6))
			{
				m_chuteDiceRoll = 0.00;
				//m_chuteSlewingZ = true;
			}
			if ((dice_roll2 == 7) || (dice_roll2 == 8))
			{
				m_chuteDiceRoll = 0.07;
				//m_chuteSlewingZ = true;
			}
			if (dice_roll2 >= 9)
			{
				m_chuteDiceRoll = 0.15;
				//m_chuteSlewingZ = true;
			}
			m_chuteSlewZ = m_chuteDiceRoll;
			return m_chuteSlewZ;
		}
		if (m_mach_speed == 0.00)
		{
			m_chuteSlewZ = 0.0;
			//m_chuteSlewingZ = false;
		
			//printf("ChuteSlewZ-Value %f \n", m_chuteSlewZ);

			return m_chuteSlewZ;
		}
	}
	
	return 0.0;
	
	/*if (m_chuteSlewingZ == true)
	{
	int chuteTimeToPass = 10;

		if (m_chuteTimeZPassed < chuteTimeToPass)
		{
			m_chuteTimeZPassed++;
		}
		if (m_chuteTimeZPassed >= chuteTimeToPass)
		{
			m_chuteSlewingZ = false;
			m_chuteTimeZPassed = 0;
			m_chuteSlewZ = 0.0;
			return m_chuteSlewZ;
		}
	//return m_chuteSlewY;
	}*/
	//printf("TimeZPassed %f \n", m_chuteTimeZPassed);
}

double Airframe::BLCsystem()
{
	m_blcLift = 0.0;

	if ((getFlapsPosition() == 1.0) && (m_engine.getRPMNorm() >= 0.85))
	{
		m_blcLift = (0.31 * m_engine.getRPMNorm());// * CON_FlpL2; //von 0.50 * zu 0.31*
	}

	else
	{
		m_blcLift = 0.0;
	}
	return m_blcLift;
}

double Airframe::getEngineDamageMult()
{
	if ((getCompressorDamage() <= 0.75) || (getTurbineDamage() <= 0.75))
	{
		m_engDmgMulti = ((getCompressorDamage() + getTurbineDamage()) / 2.0) * 1.15;
	}
	else
	{
		m_engDmgMulti = 1.0;
	}
	return m_engDmgMulti;
}

void Airframe::autoPilotAltH(double dt)
{
	
	m_ascHA = 0.1309; // = 7,5° in Radians
	m_decHA = -0.1309;

	double altHoldCorridorLow = m_altHold * 1.02;
	double altHoldCorridorHigh = m_altHold * 0.98;
	
	if (m_state.m_angle.z > m_ascHA)
	{
		m_acendHoldAngle = true;
	}
	else
	{
		m_acendHoldAngle = false;
	}

	if (m_state.m_angle.z < m_decHA)
	{
		m_decendHoldAngle = true;
	}
	else
	{
		m_decendHoldAngle = false;
	}

	if (m_state.m_angle.z == m_state.m_aoa)
	{
		m_level = true;
	}
	else
	{
		m_level = false;
	}

	if ((m_state.m_angle.z > 0.0) && ((m_state.m_angle.z - m_state.m_aoa) > 0.0))
	{
		m_acend = true;
	}
	else
	{
		m_acend = false;
	}

	if ((m_state.m_angle.z < 0.0) || ((m_state.m_angle.z) - (m_state.m_aoa) < 0.0)) //|| ((m_state.m_angle.z) - (m_state.m_aoa) < 0.0)) neu eingefügt 24.10.
	{
		m_decend = true;
	}
	else
	{
		m_decend = false;
	}
	
	if ((m_input.getAutoPEng() == 1.0) && (getHydroPumpONE() == 1.0))
	{
		m_desiredAlt = m_state.m_airDensity;

		if ((m_input.getAutoPEng() == 1.0) && (m_altHold > m_state.m_airDensity) && ((m_state.m_airDensity < altHoldCorridorHigh) || (m_state.m_airDensity > altHoldCorridorLow)))
		{
			if ((m_decendHoldAngle == false) && (m_altHold != 0.0))
			{
				if (m_state.m_angle.z == m_decHA)
				{
					m_pitchAPadj = 0.0;
				}
				if (m_state.m_angle.z > m_decHA)
				{
					m_pitchAPadj = -0.03;
				}
			}

			if ((m_decendHoldAngle == true) && (m_altHold != 0.0))
			{
				if (m_state.m_angle.z < -0.34)
				{
					m_pitchAPadj = 0.05;
				}
				if ((m_state.m_angle.z >= -0.34) && (m_state.m_angle.z < m_decHA))
				{
					m_pitchAPadj = 0.03;
				}
			}
		}

		if ((m_input.getAutoPEng() == 1.0) && (m_altHold < m_state.m_airDensity) && ((m_state.m_airDensity < altHoldCorridorHigh) || (m_state.m_airDensity > altHoldCorridorLow)))
		{
			if ((m_acendHoldAngle == false) && (m_altHold != 0.0))
			{
				if (m_state.m_angle.z == m_ascHA)
				{
					m_pitchAPadj = 0.0;
				}
				if (m_state.m_angle.z < m_ascHA)
				{
					m_pitchAPadj = 0.03;
				}
			}

			if ((m_acendHoldAngle == true) && (m_altHold != 0.0))
			{
				if (m_state.m_angle.z > 0.34)
				{
					m_pitchAPadj = -0.05;
				}
				if ((m_state.m_angle.z <= 0.34) && (m_state.m_angle.z > m_ascHA))
				{
					m_pitchAPadj = -0.03;
				}
			}
		}

		if ((m_input.getAutoPEng() == 1.0) && ((m_state.m_airDensity >= altHoldCorridorHigh) && (m_state.m_airDensity <= altHoldCorridorLow)))
		{
			if ((m_state.m_angle.z == m_state.m_aoa) && (m_state.m_angle.z >= 0.0))
			{
				m_pitchAPadj = 0.0;
			}
			if ((m_state.m_angle.z > m_state.m_aoa) && (m_state.m_angle.z > 0.0))
			{
				m_pitchAPadj = -0.01;
			}
			if ((m_state.m_angle.z < m_state.m_aoa) && (m_state.m_angle.z <= 0.0))
			{
				m_pitchAPadj = 0.02;
			}
			if (m_state.m_angle.z < m_state.m_aoa)
			{
				m_pitchAPadj = 0.01;
			}


		}

		if ((m_previousAlt != m_desiredAlt) && (m_previousAlt != 0.0) && (m_input.getAutoPEng() == 1) && (m_altHold == 0.0))
		{
			m_altHold = m_state.m_airDensity;
		}
		else if ((m_altHold != 0.0) && (m_previousAlt != m_desiredAlt) && (m_input.getAutoPEng() == 1.0))
		{

		}

		m_previousAlt = m_desiredAlt;
	}
	else if ((m_input.getAutoPEng() == 0.0) || (getHydroPumpONE() == 0.0))
	{
		m_pitchAPadj = 0.0;
		m_previousAlt = 0.0;
		m_altHold = 0.0;
		m_desiredAlt = 0.0;
	}



	/*printf("m_altHold %f \n", m_altHold);
	printf("airDensity %f \n", m_state.m_airDensity);
	printf("Angle %f \n", m_state.m_angle.z);
	printf("AP_Pitch_Adj. %f \n", m_pitchAPadj);
	printf("AoA %f \n", m_state.m_aoa);*/
}

double Airframe::fuelFlowIndGaugeUpdate()
{
	//direct fuelFlowGauge has 1-100 with 12.000 = 100 and 0 = 0; 0-70 = 0 - 6.000 lbs/h; 72,5 = 7.000 lbs/h; 75 = 8.000 lbs/h; 81,25 = 9; 87,5 = 10; 93,75 = 11; 100 = 12

	if (m_input.getElectricSystem() == 1.0)
	{
		if (m_engine.FuelFlowUpdate() <= 6000.0)
		{
			m_fuelThousand = m_engine.FuelFlowUpdate() * 0.01166;
		}
		else if ((m_engine.FuelFlowUpdate() > 6000) && (m_engine.FuelFlowUpdate() < 12000.0))
		{
			m_fuelThousand = (m_engine.FuelFlowUpdate() * 0.005) + 40.0;
		}
		else if (m_engine.FuelFlowUpdate() >= 12000.0)
		{
			m_fuelThousand = 100.0;
		}
	}
	else
	{
		m_fuelThousand = 0.0;
	}

	return m_fuelThousand * 0.01;
}

double Airframe::airSpeedInKnotsEASInd()
{
	m_vMetEAS = (m_scalarVelocity / sqrt(CON_sDay_den / m_state.m_airDensity)); //Geschwindigkeit TAS zu EAS in m/s 
	m_vKnotsEAS = m_vMetEAS * 1.94384;

	if (m_input.getElectricSystem() == 1.0)
	{
		if ((m_vKnotsEAS >= 0.0) && (m_vKnotsEAS <= 400.0))
		{
			m_vKnotsEASInd = (0.6 / 400.0) * m_vKnotsEAS;//(m_vKnotsEAS / 1000) * 1.5;
		}
		else if ((m_vKnotsEAS > 400.0) && (m_vKnotsEAS <= 700.0))
		{
			m_vKnotsEASInd = (0.26 / 300.0) * (m_vKnotsEAS - 400.0) + 0.6; //((((m_vKnotsEAS / 1000) - 0.4) * 0.866 ) + 0.60);
		}
		else if ((m_vKnotsEAS > 700.0) && (m_vKnotsEAS <= 1000.0))
		{
			m_vKnotsEASInd = (0.14 / 300) * (m_vKnotsEAS - 700.0) + 0.86;//((((m_vKnotsEAS / 1000) - 0.7) * 0.466) + 0.86);
		}
	}
	else
	{
		m_vKnotsEASInd = 0.0;
	}

	return m_vKnotsEASInd; //EAS in Knoten / 1000 = Werte von 0.0 - 1.0
}

double Airframe::airSpeedInKnotsCASInd()
{
	double d = m_state.m_pressure / CON_sDay_pr;
	double M = m_state.m_mach;
	m_vKnotsCAS = m_vKnotsEAS * (1.0 + 0.125 * (1.0 - d) * M * M + (3.0 / 640.0 * (1.0 - 10.0 * d + 9 * d * d) * M * M * M * M));

	return (m_vKnotsCAS * 1.94384) / 1000; //CAS in Knoten / 1000 = Werte von 0.0 bis 1.0
}

//Erläuterung: Machmeter hat 2 Steigungen 1: Mach 0.0 - 1.0 = 0.117/1 = 0.117 und 2: Mach 1.0 - 2.5 = (1.0 - 0.117) / (2.5 -1.0) = 0.5846666
//jetzt für Ermittlung der "Höhe" im 2ten Abshcnitt am Schluss die Höhe des Endes des ersten Abschnitts (0.117) addieren...

double Airframe::airSpeedInMachInd()
{
	
	if (m_input.getElectricSystem() == 1.0)
	{
		if (m_state.m_mach <= 1.0)
		{
			m_vMach = 0.117 * m_state.m_mach; //Skala aktuell Mach 0-1.0 = 2/17
		}
		else if ((m_state.m_mach > 1.0) && (m_state.m_mach <= 2.5))
		{
			m_vMach = ((m_state.m_mach) - 1.0) * (0.883 / 1.5) + 0.117;//((m_state.m_mach / 2.5) * (15.0 / 17.0)) + (2.0 / 17.0);
		}
		else if (m_state.m_mach > 2.5)
		{
			m_vMach = 1.0;
		}
	}
	else
	{
		m_vMach = 0.0;
	}
	
	return m_vMach;//mit dem Faktor * 0.4 ist 2,5 = 1.0 mit dem Quotienten 10 ist 10 = 1.0
}

void Airframe::altitudeInd()
{
	
	//--------------Hier ist die alte starre Höhenformel, die auf der std.day Atmosphäre bei 0m Höhe aufbaut. In einer variablen barometrischen Messung muss 101325.0 ersetzt werden durch die QNH-Variable
	/*
	if (m_input.getElectricSystem() == 1.0)
	{
		m_altInM = ((288.15 / 0.0065) * (1.0 - pow((m_state.m_pressure / 101325.00), (1.0 / 5.255))));
	}
	else
	{
		m_altInM = 0;
	}
	*/
	//-----------------Neue Formel mit Variablen
	m_qnhVar = m_input.getQnhValue();
	//-----------Altitude Formel--------------------------------------------------------------------
	if (m_input.getElectricSystem() == 1.0)
	{
		m_altInM = ((288.15 / 0.0065) * (1.0 - pow((m_state.m_pressure / m_qnhVar), (1.0 / 5.255))));
	}
	else
	{
		m_altInM = 0;
	}

	m_altInFt = (m_altInM * 3.28084) * 1000.0; //hier * 1000 um die INT um 3 Stellen zu vergrößern, damit die Gleitkomma-Zahl nachher schöner ist

	m_altIndTenThousands = m_altInFt / 10000000; //gibt immer glatte 10k aus also 10000, 20000, 30000 usw.
	m_altIndThousands = (m_altInFt % 10000000) / 1000000 ;//gibt immer 1 - 9999 aus
	m_altIndHundreds = (m_altInFt % 1000000) / 100000.0;//gibt 1 - 999 aus
	m_altIndTens = (m_altInFt % 1000) / 10.0;

	m_retAltIndTK = m_altIndTenThousands / 10.0;
	m_retAltIndK = m_altIndThousands / 10.0;

	//----------------QNH Variablen------------------------------------------------------------
	m_indQnhThousand = m_qnhVar / 100000; //gibt 101320 / 100000 = 1 (da int); bei unter 1 = 0 
	m_indQnhHundred = (m_qnhVar % 100000) / 10000; //gibt bei 101320 = 01320 = 1320 / 10000 = 0.132 gibt "0" (da int)// bei 098855 = 98855 / 10000 = 9.8855 = "9" (da int) 
	m_indQnhTen = (m_qnhVar % 10000) / 1000;// bei 101320 = 1320 / 1000 = 1.32
	m_indQnhOne = (m_qnhVar % 1000) / 100;// bei 101320 = 320 / 100 = 3.2
}

double Airframe::getAltIndTenThousands()
{
	return m_retAltIndTK;
}

double Airframe::getAltIndThousands()
{
	return m_retAltIndK;
}

double Airframe::getAltIndHundreds()
{
	return m_altIndHundreds / 10.0;
}

double Airframe::getAltIndTens()
{
	return m_altIndTens / 10.0;
}


double Airframe::getQNHinThousand()
{
	return m_indQnhThousand;
}

double Airframe::getQNHinHundred()
{
	if (m_indQnhHundred >= 9.0)
	{
		m_retIndQnhHundred = 0.0;
	}
	else
	{
		m_retIndQnhHundred = 1.0;
	}

	return m_retIndQnhHundred;
}

double Airframe::getQNHinTen()
{
	return m_indQnhTen / 10.0;
}

double Airframe::getQNHinOne()
{
	return m_indQnhOne / 10.0;
}

//--------------------------3d-horizon functions--------------------------------------------

void Airframe::horizonRollValue()
{
	if (m_input.getElectricSystem() == 1.0)
	{
		m_horizonRollAngle = toDegrees(m_state.m_angle.x);

		m_horizonRollValue = -1.0 * (m_horizonRollAngle * 0.005556);
	}
	else
	{
		m_horizonRollAngle = 0.0;

		m_horizonRollValue = 0.0;
	}
}

void Airframe::horizonPitchValue()
{
	if (m_input.getElectricSystem() == 1.0)
	{
		m_horizonPitchAngle = toDegrees(m_state.m_angle.z);

		m_horizonPitchValue = m_horizonPitchAngle * 0.011111;
	}
	else
	{
		m_horizonPitchAngle = 0.0;

		m_horizonPitchValue = 0.0;
	}
}

//-------------------Gear and Flap overspeed Damage functions----------------
double Airframe::osGearDamage()
{
	if ((m_state.m_mach > 0.53) && (getGearNPosition() > 0.2))
	{
		m_actuatorGearN.setOverSpeedMalFunction();
		m_actuatorGearL.setOverSpeedMalFunction();
		m_actuatorGearR.setOverSpeedMalFunction();

		m_gearOversped = 1.0;
	}
	return m_gearOversped;
}

double Airframe::osFlapDamage()
{
	if ((m_state.m_mach > 0.53) && (getFlapsPosition() > 0.75))
	{
		m_actuatorFlap.setOverSpeedMalFunction();
		m_flapOversped = 1.0;
	}
	if ((m_state.m_mach > 0.95) && (getFlapsPosition() > 0.25))
	{
		m_actuatorFlap.setOverSpeedMalFunction();
		m_flapOversped = 1.0;
	}
	return m_flapOversped;
}

//------------------Hydraulic-System functions-----------------------------
//------------------Hydraulic-System ONE and TWO Gauges-------------------

void Airframe::hydraulicPump()
{

	bool sufficientEnginePower = false;

	//------both HydroPumps No1 and No2 are powered directly from the engine--
	//------45% RPM is a good guess when there is enough RPM to power the pumps---
	//------if there is less than 45% RPM but the RAT is extended, the RAT will power the Hydro-Systems
	if ((m_engine.getRPMNorm() >= 0.45) || ((m_engine.getRPMNorm() < 0.45) && (m_ramAirHydroPump == 1.0)))
	{
		sufficientEnginePower = true;
	}
	else
	{
		sufficientEnginePower = false;
	}
	

	if (m_ramAirTurbine.IsRamAirTurbineExteneded() == true)
	{
		if (m_state.m_mach >= 0.7)
		{
			m_ramAirHydroPump = 1.0;
		}
		else if ((m_state.m_mach >= 0.2) && (m_state.m_mach < 0.7))
		{
			m_ramAirHydroPump = 0.5 + (0.714 * m_state.m_mach); // 0.5 + max 0.4998
		}
		else
		{
			m_ramAirHydroPump = 0.0;
		}
	}
	else
	{
		m_ramAirHydroPump = 0.0;
	}
	
	if((sufficientEnginePower == true) && (getTurbineDamage() > 0.35))
	{
		m_hydroPumpOne = 1.0;
		m_hydroPumpTwo = 1.0;
		//m_ramAirHydroPump = 0.0; //wird unabhängig oben gesetzt
		m_hydroSystemStatus = 1.0; 
	}
	else if((sufficientEnginePower == true) && ((getTurbineDamage() < 0.35) && (getTurbineDamage() > 0.15)))
	{
		m_hydroPumpOne = 0.0;
		m_hydroPumpTwo = 1.0;
		//m_ramAirHydroPump = 0.0;//wird unabhängig oben gesetzt
		m_hydroSystemStatus = 0.75;
	}
	else if ((sufficientEnginePower == true) && (getTurbineDamage() < 0.15))
	{
		m_hydroPumpOne = 0.0;
		m_hydroPumpTwo = 0.0;
		m_hydroSystemStatus = 0.5;

	}
	else
	{
		m_hydroPumpOne = 0.0;
		m_hydroPumpTwo = 0.0;
		//m_ramAirHydroPump = 0.5; //wird unabhängig oben gesetzt
		m_hydroSystemStatus = 0.0;
	}

	m_hydroPower = m_hydroPumpOne + m_hydroPumpTwo + m_ramAirHydroPump; //aufpassen, Pump1 und Pump2 sind redundant bzgl. AeroSteuerflächen d.h. 0.66 reicht für volle Power...
}


//------------------Hydraulic-system gauges--------------------------

void Airframe::hydroGaugeSysONE()
{
	//RAT fängt die PumpONE auf, wenn diese ausfällt

	double hydroSysOneGaugePure = 0.0;
	
	if ((m_engine.getRPMNorm() < 0.67) && (m_hydroPumpOne == 1.0))
	{
		hydroSysOneGaugePure = m_engine.getRPMNorm() * 3731.0; // 0.67 * 3731 = 2499 psi Druck = Normaldruck Sys-1
	}
	else if ((m_engine.getRPMNorm() >= 0.67) && (m_hydroPumpOne == 1.0))
	{
		hydroSysOneGaugePure = 2500.0;
	}
	else if ((m_engine.getRPMNorm() < 0.67) && (m_ramAirHydroPump == 1.0) && (m_hydroPumpOne == 0.0) && (m_state.m_mach >= 0.25))
	{
		hydroSysOneGaugePure = 2125.0; //emergengy hydro-power due to RAT Extension
	}
	else if ((m_engine.getRPMNorm() < 0.67) && (m_ramAirHydroPump != 1.0) && (m_hydroPumpOne != 1.0) && (m_state.m_mach < 0.25))
	{
		hydroSysOneGaugePure = 0.0;
	}

	if ((hydroSysOneGaugePure >= 0.0) && (hydroSysOneGaugePure <= 1500.0))
	{
		m_hydroSysOneVALUE = hydroSysOneGaugePure * 0.0002; //erster Abschnitt der Anzeigeskala von 0 bis 1500.0 PSI
	}
	else
	{
		m_hydroSysOneVALUE = ((hydroSysOneGaugePure - 1500.0) * 0.00028) + 0.3;
	}
}

void Airframe::hydroGaugeSysTWO()
{
	//RAT fängt die PumpTWO NICHT auf wenn diese ausfällt
	//HydroSysTWO nur dann funktional, wenn Engine ausreichend RPM hat

	double hydroSysTwoGaugePure = 0.0;

	if ((m_engine.getRPMNorm() < 0.67) && (m_hydroPumpTwo == 1.0))
	{
		hydroSysTwoGaugePure = m_engine.getRPMNorm() * 3731.0; // 0.67 * 3731 = 2499 psi Druck = Normaldruck Sys-2
	}
	else if ((m_engine.getRPMNorm() >= 0.67) && (m_hydroPumpTwo == 1.0))
	{
		hydroSysTwoGaugePure = 2500.0;
	}
	else if ((m_engine.getRPMNorm() < 0.67) && (m_hydroPumpTwo != 1.0))
	{
		hydroSysTwoGaugePure = 0.0;
	}

	if ((hydroSysTwoGaugePure >= 0.0) && (hydroSysTwoGaugePure <= 1500.0))
	{
		m_hydroSysTwoVALUE = hydroSysTwoGaugePure * 0.0002; //erster Abschnitt der Anzeigeskala von 0 bis 1500.0 PSI
	}
	else
	{
		m_hydroSysTwoVALUE = ((hydroSysTwoGaugePure - 1500.0) * 0.00028) + 0.3; //zweiter Abschnitt der Anzeigeskala von 1500 - 4000 PSI
	}
}



//-------------------Repair-Needs and Repair-Function-----------------------


void Airframe::resetOSdamage()
{
	m_flapOversped = 0.0;
	m_gearOversped = 0.0;
	m_actuatorFlap.revOverSpeedMalFunction();
	m_actuatorGearL.revOverSpeedMalFunction();
	m_actuatorGearN.revOverSpeedMalFunction();
	m_actuatorGearR.revOverSpeedMalFunction();

}

//--------------Pylon-Lights + GunSwitch Function-----------------------------------
//PylonLights kann ich auskommentieren wenn fertig, da dann Steuerung über CockpitScripts
/*
void Airframe::pylonIndLights()
{
	if (m_input.getElectricSystem() == 1.0)
	{
		if ((m_input.getMasterAtoA1() == 1.0) || (m_input.getMasterAtoA2() == 1.0) || (m_input.getMasterAtoA3() == 1.0) || (m_input.getMasterAtoA4() == 1.0))
		{
			m_pylonIndLightG = 1.0;
			m_pylonIndLightA = 1.0;

		}
		else if (m_input.getMasterAtoG() == 1.0)
		{
			m_pylonIndLightG = 1.0;
			m_pylonIndLightA = 0.0;
		}
		else if ((m_input.getMasterGUN() == 1.0) || (m_input.getMasterNAVI() == 1.0))
		{
			m_pylonIndLightG = 0.0;
			m_pylonIndLightA = 0.0;
		}
		else
		{
			m_pylonIndLightG = 0.0;
			m_pylonIndLightA = 0.0;
		}
	}
	else
	{
		m_pylonIndLightG = 0.0;
		m_pylonIndLightA = 0.0;
	}

}
*/




