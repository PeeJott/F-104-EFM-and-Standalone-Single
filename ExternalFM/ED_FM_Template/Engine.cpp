#include "Engine.h"

//=========================================================================//
//
//		FILE NAME	: Engine.cpp
//		AUTHOR		: Paul Stich
//		Copyright	: Paul Stich
//		DATE		: August 2021
//
//		DESCRIPTION	: Everything concerning the engine e.g. Thrust, Heat, spooling-times, 
//					  fuel-flow and overheat-damage, warnings and indicators.
//					  
//================================ Includes ===============================//
//=========================================================================//

Engine::Engine
(
	State& state,
	Input& input,
	ElectricSystemAPI& electricSystemAPI

) :
	m_state(state),
	m_input(input),
	m_electricSystemAPI(electricSystemAPI),
	//---------------Thrust------------------------------------
	PMax(DAT_PMax, CON_PMaxmin, CON_PMaxmax),
	PFor(DAT_PFor, CON_PFormin, CON_PFormax),
	CADen(DAT_CADen, CON_CADenMin, CON_CADenMax),
	EngDel(DAT_EngDel, CON_EngDelMin, CON_EngDelMax)
	//der letzte Eintrag darf KEIN Komma haben...
{
	//huhu!!
}

void Engine::zeroInit()
{
	m_scalarVelocity = 0.0;
	m_scalarVelocitySquared = 0.0;
	//-------------Engine Values/Commands----------------------------
	m_thrust = 0.0;
	//m_input.m_throttle = -1.0; da jetzt Funktion getThrottle()
	
	m_burner = 0.0;
	m_fuelFlow = 0.0;
	m_correctedFuelFlow = 0;
	m_corrAirDensity = 0.0;
	
	m_spoolFactor = 0.0;
	m_spoolFactorPrevious = 0.0;
	m_deltaSpool = 0.0;
	m_throttleNEW = 0.0;
	m_newThrottle = 0.0;
	m_oldThrottle = 0.0;
	m_deltaSpoolABS = 0.0;
	m_newSpoolStep = 0.0;
	m_desiredThrottle = 0.0;

	m_spoolFactorFuel = 0.0;
	m_deltaSpoolFuel = 0.0;
	m_newThrottleFuel = 0.0;
	m_oldThrottleFuel = 0.0;
	m_deltaSpoolABSFuel = 0.0;
	m_newSpoolStepFuel = 0.0;
	m_spoolFactorFuel1 = 0.0;
	
	
	m_hasFuel = true;
	m_ignitors = false;
	//m_input.m_engine_start = 0.0; auskomentiert da in Funktionen
	//m_input.m_engine_stop = 0.0;
	m_needRestart = false;
	m_needRepair = false;
	
	m_spoolCDelta = 0.0;
	m_spoolCDeltaABS = 0.0;
	m_spoolCDown = 0.0;
	m_spoolCNewSpool = 0.0;
	m_spoolCOldSpool = 0.0;
	m_spoolCSpoolStep = 0.0;
	m_spoolCStart = 0.0;
	m_spoolCFactor = 0.0;

	m_spoolHDelta = 0.0;
	m_spoolHDeltaABS = 0.0;
	m_spoolHFactor = 0.0;
	m_spoolHNewSpool = 0.0;
	m_spoolHOldSpool = 0.70;
	m_spoolHSpoolStep = 0.0;

	m_rpmNormal = 0.0;
	m_rpmPrevious = 0.0;

	m_tempInC = 0.0;

	m_overHeat = 0.0;
	m_heatOne = 0.0;
	m_heatTwo = 0.0;
	m_heatTimerUP = 0;
	m_heatTimerDOWN = 0;
	m_overSpeedInd = 0.0;
	m_heatFailure = false;
	m_overHeatInd = 0.0;

}

void Engine::coldInit()
{
	zeroInit();
	
}

void Engine::hotInit()
{
	zeroInit();

	m_ignitors = true;
	m_rpmNormal = 0.72;
	m_rpmPrevious = 0.72;
	//m_input.m_engine_start = 1.0;
	m_spoolHOldSpool = 0.70;
	m_spoolCOldSpool = 0.71;
}

void Engine::airborneInit()
{
	zeroInit();

	m_ignitors = true;
	m_rpmNormal = 0.85;
	m_rpmPrevious = 0.85;
	//m_input.m_engine_start = 1.0;
	m_spoolHOldSpool = 0.70;
	m_spoolCOldSpool = 0.71;
}

void Engine::update(double dt)
{
	//--------Check if there is enough electric energy
	bool hasElectricPower = false;
	
	if ((m_electricSystemAPI.GetNo2EmergencyDcBus() == 1.0) || (m_electricSystemAPI.GetNo1BatteryBus() == 1.0) || (m_electricSystemAPI.GetNo2BatteryBus() == 1.0))
	{
		hasElectricPower = true;
	}
	else
	{
		hasElectricPower = false;
	}
	//------------------------------
	//------------Start of update function-----------

	double corrThrottle = 0.0;
	
	if ((m_input.getEngineStart() == 1.0) && (m_needRepair == false) && (m_heatFailure == false) && (m_needRestart == false) && (hasElectricPower == true))
	{
		m_ignitors = true;
	}
	if ((m_input.getEngineStop() == 1.0) || (m_input.getEngineStart() == 0.0) || (m_needRepair == true) || (m_heatFailure == true) || (m_needRestart == true) || (hasElectricPower = false))
	{
		m_ignitors = false;
		//m_input.m_engine_start = 0.0;
		//m_input.m_engine_stop = 0.0;
	}

	//---------------OLD corrected Air Density with 2 steps
	/*if ((m_state.m_airDensity < 0.74) && (m_state.m_airDensity > 0.4))
	{
		m_corrAirDensity = m_state.m_airDensity * 0.30;
	}
	else if (m_state.m_airDensity <= 0.4)
	{
		m_corrAirDensity = m_state.m_airDensity * 0.45;
	}
	else
	{
		m_corrAirDensity = 0.0;
	}*/

	//------------NEW corrected Air Density with a lot of steps through lookup----------
	//-------------OLD Version---------------------------------------------------------
	/*if (m_state.m_airDensity <= 0.88)
	{
		m_corrAirDensity = CADen(m_state.m_airDensity);
	}
	else
	{
		m_corrAirDensity = 0.0;
	}*/
	//-----------------NEW Version mit CAD bis SL---------------------------------------
	m_corrAirDensity = CADen(m_state.m_airDensity);

//--------------END of corrected airdensity----------------------------------------------
//--------------Start of Engine starting up and spooling down//Noch drüber nachdenken----------------------------	
	
	/*if ((m_ignitors == true) && (m_hasFuel == true) && (getRPMNorm() <= 0.69))
	{
		m_spoolColdStart = 1 * (DAT_EngSpool[50]--);
	}
	else if (((m_ignitors == false) || (m_hasFuel == false)) && (getRPMNorm() > 0.0))
	{
		m_spoolColdStart = 1 * (DAT_EngSpool[0]++);
	}
	else
	{
		m_spoolColdStart = 1;
	}*/
	
	//RESET updateSpoolCold
	if ((m_ignitors == false) || (m_hasFuel == false) || (overHeat() == 1.0))
	{
		m_spoolCOldSpool = getRPMNorm();
		m_spoolCDelta = 0.0;
		m_spoolCDeltaABS = 0.0;
		m_spoolCFactor = 0.0;
		m_spoolCNewSpool = 0.0;
		m_spoolCSpoolStep = 0.0;
	}

	//RESET updateSpoolHot
	if ((m_ignitors == true) && (m_hasFuel == true))
	{
		m_spoolHOldSpool = getRPMNorm();
		m_spoolHDelta = 0.0;
		m_spoolHDeltaABS = 0.0;
		m_spoolHFactor = 0.0;
		m_spoolHNewSpool = 0.0;
		m_spoolHSpoolStep = 0.0;
	}

	//heatCoolDown();

	//printf("Throttle_Position %f \n", m_input.getThrottle());
	/*printf("FuelIndicator %f \n", m_heatTimerUP);
	printf("OHStage %f \n", m_overHeat);
	printf("OverSpeedInd %f \n", m_overSpeedInd);
	printf("Mach %f \n", m_state.m_mach);
	printf("AirDensity %f \n", m_state.m_airDensity);*/

	//-------------NEU eingefügt wegen Replay-Käse--------------
	updateThrust();
	FuelFlowUpdate();
	updateSpool();
	updateBurner();
	updateSpoolCold();
	updateSpoolHot();
	tempInC();
	overHeat();
	overHeatCount();
	overSpeedInd();
	restartNeeded();
	overHeatInd();
}

double Engine::updateThrust() //Wenn Veränderungen dann hier verändern NICHT oben!!!!! //dt in die Klammer eingefügt//double zu void mit double dt verändert
{
	m_force = Vec3(); //braucht man hier vielleicht nicht, trotzdem wieder eingesetzt zum testen
	m_throttle = 0.0; //neu eingefügt
	m_thrust = 0.0; //wieder eingefügt nach auskommentierung
	//m_thrust = 150000; //nur zum testen, wieder rausnehmen
	
	m_scalarVelocity = magnitude(m_state.m_localAirspeed);
	m_scalarVelocitySquared = m_scalarVelocity * m_scalarVelocity;
	m_state.m_mach = m_scalarVelocity / m_state.m_speedOfSound;
	
	//--------------Alte Thrust-Funktion die funktioniert-------------------
	/*double corrThrottle = 0.0;

	if (m_input.m_throttle >= 0.0)
	{
		corrThrottle = (1 - CON_ThrotIDL) * m_input.m_throttle + CON_ThrotIDL;
	}
	else
	{
		corrThrottle = (m_input.m_throttle + 1.0) / 2.0;
	}

	if ((corrThrottle <= 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_thrust = (corrThrottle * PMax(m_state.m_mach)) * (m_state.m_airDensity / CON_sDay_den);
	}
	else if ((corrThrottle > 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_thrust = (corrThrottle * PFor(m_state.m_mach)) * ((m_state.m_airDensity + m_corrAirDensity) / CON_sDay_den);

	}
	else
	{
		m_thrust = 0.0;
	}*/
	//---------------------Alte Funktion ENDE------------------------------------------



	//corrThrottle = -0.55 * m_input.m_throttle + 1.0; //TESTSETTINGS
	//m_thrust = corrThrottle * PFor(m_state.m_mach); //TESTSETTINGS
	
	//printf("Throttle %f \n", corrThrottle);
	//printf("Thrust %f \n", m_thrust); //eingefügt zum testen, ob M_thrust ausgegeben wird...
	//printf("CurrentAirDensity %f \n", m_state.m_airDensity);

	//-----------Thrust-function---------------------------------------------------------------------------
	//bei PMax den airdensity-correction-multiplyer eingefügt. Dieser bedarf einer Überarbeitung zusammen mit dem Drag und Thrust-profil...
	//
	
	if ((updateSpool() <= 0.85) && (m_ignitors == true) && (m_hasFuel == true) && (getRPMNorm() >= 0.70))
	{
		m_thrust = (updateSpool() * PMax(m_state.m_mach)) * ((m_state.m_airDensity + ( 0.66 * m_corrAirDensity)) / CON_sDay_den);
	}
	else if ((updateSpool() > 0.85) && (m_ignitors == true) && (m_hasFuel == true) && (getRPMNorm() >= 0.70))
	{
		m_thrust = (updateSpool() * PFor(m_state.m_mach)) * ((m_state.m_airDensity + m_corrAirDensity) / CON_sDay_den);

	}
	else
	{
		m_thrust = 0.0;
	}
	
	return m_thrust;
}

double Engine::FuelFlowUpdate() 
{
	double lowOmegaInertia = 1.0;

	double spoolUpFactor = 0.0;

	if ((getRPMNorm() < 0.70) && (m_ignitors == true) && (m_hasFuel == true))
	{
		spoolUpFactor = updateSpoolCold();
	}
	else
	{
		spoolUpFactor = 1.0;
	}
	//starting up or restarting
	/*if (getRPMNorm() < 0.50)
	{
		lowOmegaInertia = 7.0;
	}*/

	//normaler Betrieb, die Engine läuft
	//passt aktuell nicht ganz, da die CON-Werte von 100% Mil/AB-Power ausgehen
	//Alter kram der aber funktioniert hat
	/*if ((getRPMNorm() >= 0.70) && (getRPMNorm() < 0.95))
	{
		m_fuelFlow = getRPMNorm() * (CON_CeMax * 3600 * 2.205) ;
	}

	if (getRPMNorm() >= 0.95)
	{
		m_fuelFlow = getRPMNorm() * (CON_CeFor * 3600 * 2.205);
	}
	else
	{
		m_fuelFlow = 1.300;
	}*/
	
	//------------Alte FuelFlow-Funktion die funktioniert----------------
	/*double corrThrottle = 0.0;

	if (m_input.m_throttle >= 0.0)
	{
		corrThrottle = (1 - CON_ThrotIDL) * m_input.m_throttle + CON_ThrotIDL;
	}
	else
	{
		corrThrottle = (m_input.m_throttle + 1.0) / 2.0;
	}
	
	if ((corrThrottle < 0.01 ) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = 1500.0 * (m_state.m_airDensity / CON_sDay_den) + (m_state.m_mach * (0.60 * corrThrottle * CON_CeMax * 3600 * 2.205));
	}
	
	else if ((corrThrottle >= 0.01) && (corrThrottle < 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = (corrThrottle * (CON_CeMax * 3600 * 2.205) + 1500) * (m_state.m_airDensity / CON_sDay_den) + (m_state.m_mach * ( 0.60 * corrThrottle * CON_CeMax * 3600 * 2.205));
	}
	else if ((corrThrottle >= 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = (corrThrottle * (CON_CeFor * 3600 * 2.205) + 1500) * (m_state.m_airDensity / CON_sDay_den) + (m_state.m_mach * (0.60 * corrThrottle * CON_CeFor * 3600 * 2.205));
	}
	else
	{
		m_fuelFlow = 0;
	}*/
	//------------------------------------Alte Funktion ENDE--------------------------------------------------------------
	
	double corrThrottle = 0.0;

		
	if (m_input.getThrottle() >= 0.0)
	{
		corrThrottle = (1.0 - CON_ThrotIDL) * m_input.getThrottle() + CON_ThrotIDL;
	}
	else
	{
		corrThrottle = (m_input.getThrottle() + 1.0) / 2.0;
	}
	

	
	m_deltaSpoolFuel = corrThrottle - m_oldThrottleFuel;
	m_deltaSpoolABSFuel = abs(m_deltaSpoolFuel);
	//m_spoolFactor = EngDel(m_deltaSpoolABS);//die alte Idee mit der Alten "Table"
	int indexInArray = m_deltaSpoolABSFuel / 0.02; //hier wird der Index für den Array aus einer "double" in eine "int" umgemünzt, damit ganze Zahlen generiert werden// kein Factor, damit nicht außerhalb des Arrays verschoben wird
	m_spoolFactorFuel = (DAT_EngSpoolFuel[indexInArray]);//Variale indexInArray ergibt diejenige Zahl die dem Index in dem Array entspricht// /5 hinzugefügt, für langsameres Ansprechen testweise
	m_spoolFactorFuel1 = m_spoolFactorFuel * 10;
	m_newSpoolStepFuel = m_deltaSpoolFuel * m_spoolFactorFuel1;
	m_newThrottleFuel = m_oldThrottleFuel + m_newSpoolStepFuel;

	m_oldThrottleFuel = m_newThrottleFuel; //m_newThrottleFuel ist der Wert anstatt des corrThrottle

	//printf("Throttle %f \n", corrThrottle);
	//printf("NEW_Throttle %f \n", m_newThrottle);
	
	//---------------------FuelFlow-OLD an RPM-angelehnt, funktioniert aber-----------------------
	/*if ((updateSpool() < 0.01) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = 1500.0 * (m_state.m_airDensity / CON_sDay_den) + (m_state.m_mach * (0.60 * updateSpool() * CON_CeMax * 3600 * 2.205));
	}

	else if ((updateSpool() >= 0.01) && (updateSpool() < 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = (updateSpool() * (CON_CeMax * 3600 * 2.205) + 1500) * (m_state.m_airDensity / CON_sDay_den) + (m_state.m_mach * (0.60 * updateSpool() * CON_CeMax * 3600 * 2.205));
	}
	else if ((updateSpool() >= 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = (updateSpool() * (CON_CeFor * 3600 * 2.205) + 1500) * (m_state.m_airDensity / CON_sDay_den) + (m_state.m_mach * (0.60 * updateSpool() * CON_CeFor * 3600 * 2.205));
	}
	else
	{
		m_fuelFlow = 0;
	}*/
	//--------------------Ende FuelFlow-OLD-------------------------------------------------------------
	//-------------------Begin FuelFlow-NEW angelehnt an Leistung kN-----------------------------------
	
	if ((corrThrottle < 0.01) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = spoolUpFactor * (1500.0 * (m_state.m_airDensity / CON_sDay_den) + (m_state.m_mach * (0.60 * m_newThrottleFuel * (CON_FuCoMil * PMax(m_state.m_mach) / 1000.0))));
	}

	else if ((corrThrottle >= 0.01) && (corrThrottle < 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = spoolUpFactor *((m_newThrottleFuel * ((CON_FuCoMil * PMax(m_state.m_mach)) / 1000.0) + 1500.0) * (m_state.m_airDensity / CON_sDay_den)); //+ (m_state.m_mach * (0.60 * updateSpool() * CON_CeMax * 3600 * 2.205));
	}
	else if ((corrThrottle >= 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_fuelFlow = spoolUpFactor * ((m_newThrottleFuel * ((CON_FuCoAB * PFor(m_state.m_mach)) / 1000.0) + 1500.0) * (m_state.m_airDensity / CON_sDay_den)); // (m_state.m_mach * (0.60 * updateSpool() * CON_CeFor * 3600 * 2.205));
	}
	else
	{
	m_fuelFlow = 0.0;
	}

	return m_fuelFlow;
}

double Engine::updateSpool()
{
	double corrThrottle = 0.0;


	if (m_input.getThrottle() >= 0.0)
	{
		corrThrottle = (1.0 - CON_ThrotIDL) * m_input.getThrottle() + CON_ThrotIDL;
	}
	else
	{
		corrThrottle = (m_input.getThrottle() + 1.0) / 2.0;
	}
	
	
	
	m_deltaSpool = corrThrottle - m_oldThrottle;
	m_deltaSpoolABS = abs(m_deltaSpool);
	//m_spoolFactor = EngDel(m_deltaSpoolABS);//die alte Idee mit der Alten "Table"
	int indexInArray = m_deltaSpoolABS / 0.02; //hier wird der Index für den Array aus einer "double" in eine "int" umgemünzt, damit ganze Zahlen generiert werden// kein Factor, damit nicht außerhalb des Arrays verschoben wird
	m_spoolFactor = (DAT_EngSpool[indexInArray]) / 6.0;//Variale indexInArray ergibt diejenige Zahl die dem Index in dem Array entspricht// /5 hinzugefügt, für langsameres Ansprechen testweise/ jetzt auf 6.0 erhöht
	m_newSpoolStep = m_deltaSpool * m_spoolFactor;
	m_newThrottle = m_oldThrottle + m_newSpoolStep;
	
	m_oldThrottle = m_newThrottle;

	//printf("Throttle %f \n", corrThrottle);
	//printf("NEW_Throttle %f \n", m_newThrottle);
	return m_newThrottle;

	//double spool[50] = { 1.0000, 0.7817, 0.6753, 0.5834, 0.5040, 0.4354, 0.3762, 0.3250, 0.2808, 0.2425, 0.2095, 0.1810, 0.1564, 0.1351, 0.1167, 0.1008, 0.0871, 0.0753, 0.0650, 0.0562, 0.0485, 0.0419, 0.0362, 0.0313, 0.0270, 0.0234, 0.0202, 0.0174, 0.0151, 0.0130, 0.0112, 0.0097, 0.0084, 0.0072, 0.0063, 0.0054, 0.0047, 0.0040, 0.0035, 0.0030, 0.0026, 0.0022, 0.0019, 0.0017, 0.0014, 0.0013, 0.0011, 0.0009, 0.0008, 0.0007,};// voll aufgefüllt
}

double Engine::updateSpoolCold()
{
	double spoolColdEnd = 0.71;
	

		m_spoolCDelta = spoolColdEnd - m_spoolCOldSpool;
		m_spoolCDeltaABS = abs(m_spoolCDelta);
		//m_spoolFactor = EngDel(m_deltaSpoolABS);//die alte Idee mit der Alten "Table"
		int indexInArray = m_spoolCDeltaABS / 0.014; //hier wird der Index für den Array aus einer "double" in eine "int" umgemünzt, damit ganze Zahlen generiert werden// kein Factor, damit nicht außerhalb des Arrays verschoben wird
		m_spoolCFactor = (DAT_EngSpool[indexInArray]) / 22;//von /10 auf / 15 hochgesetzt für langsameren Cold-Start//Variable indexInArray ergibt diejenige Zahl die dem Index in dem Array entspricht
		m_spoolCSpoolStep = m_spoolCDelta * m_spoolCFactor;
		m_spoolCNewSpool = m_spoolCOldSpool + m_spoolCSpoolStep + 0.000001;
		m_spoolCOldSpool = m_spoolCNewSpool;

		//printf("Throttle %f \n", corrThrottle);
		//printf("NEW_Throttle %f \n", m_newThrottle);
		return m_spoolCNewSpool;
}

double Engine::updateSpoolHot()
{
	double SpoolHotEnd = -0.1;

	

		m_spoolHDelta = SpoolHotEnd - m_spoolHOldSpool;
		m_spoolHDeltaABS = abs(m_spoolHDelta);
		//m_spoolFactor = EngDel(m_deltaSpoolABS);//die alte Idee mit der Alten "Table"
		int indexInArray = m_spoolHDeltaABS / 0.022; //hier wird der Index für den Array aus einer "double" in eine "int" umgemünzt, damit ganze Zahlen generiert werden// kein Factor, damit nicht außerhalb des Arrays verschoben wird
		m_spoolHFactor = (DAT_HtoCspool[indexInArray]) / 120.0;//Variale indexInArray ergibt diejenige Zahl die dem Index in dem Array entspricht
		m_spoolHSpoolStep = (m_spoolHDelta * m_spoolHFactor) - 0.00001;
		m_spoolHNewSpool = m_spoolHOldSpool + m_spoolHSpoolStep;
		m_spoolHOldSpool = m_spoolHNewSpool;

	//printf("Throttle %f \n", corrThrottle);
	//printf("NEW_Throttle %f \n", m_newThrottle);


	return m_spoolHNewSpool;
}

double Engine::updateBurner()
{
	m_burner = 0.0;
	
	//------------------Alte Burner-Funktion die funktioniert----------------
	/*double corrThrottle = 0.0;

	if (m_input.m_throttle >= 0.0)
	{
		corrThrottle = ((1 - CON_ThrotIDL) * m_input.m_throttle + CON_ThrotIDL);
	}
	else
	{
		corrThrottle = ((m_input.m_throttle + 1.0) / 2.0);
	}*/

	if ((updateSpool() >= 0.85) && (m_ignitors == true) && (m_hasFuel == true))
	{
		m_burner = 1.0;
	}
	else
	{
		m_burner = 0.0;
	}
	return m_burner;
}

double Engine::tempInC()
{
	m_tempInC = 0.0;

	if (getRPMNorm() > 0.0)
	{
		m_tempInC = (950 * getRPMNorm()) * overHeatCount();
	}
	else
	{
		m_tempInC = 0.0;
	}

	return m_tempInC;
}

double Engine::overHeatCount()
{
	//Overheating of the engine due to overspeed
	bool CounterGo = false;
	bool CounterBack = false;

	if ((((m_state.m_mach > 1.17) && (m_state.m_mach <= 1.25)) && (m_state.m_airDensity > 1.112)) || (((m_state.m_mach > 1.40) && (m_state.m_mach <= 1.55)) && ((m_state.m_airDensity > 0.9093) && (m_state.m_airDensity <= 1.112))) || (((m_state.m_mach > 1.70) && (m_state.m_mach <= 1.9)) && ((m_state.m_airDensity > 0.6601) && (m_state.m_airDensity < 0.9093))) || (((m_state.m_mach > 2.2) && (m_state.m_mach <= 2.3)) && (m_state.m_airDensity < 0.6601)))
	{
		m_heatOne = 0.00001;
		CounterGo = true;
	}
	else if (((m_state.m_mach > 1.25) && (m_state.m_airDensity > 1.112)) || ((m_state.m_mach > 1.55) && ((m_state.m_airDensity > 0.9093) && (m_state.m_airDensity <= 1.112))) || ((m_state.m_mach > 1.90) && ((m_state.m_airDensity > 0.6601) && (m_state.m_airDensity < 0.9093))) || ((m_state.m_mach > 2.3) && (m_state.m_airDensity < 0.6601)))
	{
		m_heatOne = 0.00005;
		CounterGo = true;
	}
	else if ((m_state.m_mach < 1.0) && (m_heatTimerUP > 1) && (m_heatFailure == false))
	{
		CounterBack = true;
	}

	if (CounterGo == true)
	{
		m_heatTimerUP++;
	}
	else if ((CounterBack == true) && (CounterGo == false) && (m_heatTimerUP > m_heatTimerDOWN))
	{
		m_heatTimerDOWN++;
	}

	m_heatTwo = (m_heatOne * (m_heatTimerUP - m_heatTimerDOWN)) + 1.0;

	return m_heatTwo;
}

/*void Engine::heatCoolDown()
{
	if ((m_state.m_mach < 1.0) && (m_heatTimer > 1) && (m_overHeat != 1.0))
	{
		m_heatTimer--;
	}
	
}*/

double Engine::overHeat()
{
	if ((tempInC() > 1045.0) && (tempInC() <= 1250.0))
	{
		m_overHeat = 0.5;
	}
	else if ((tempInC() > 1250.0) && (tempInC() <= 1350.0))
	{
		m_overHeat = 0.75;
	}
	else if (tempInC() > 1350.0)
	{
		m_overHeat = 1.0;
		//m_input.m_engine_start = 0.0;
		//m_input.m_engine_stop = 0.0;
		m_heatFailure = true;
	}
	else if (((m_heatFailure == true) ||(m_needRepair == true)) && (m_input.getEngineStart() == 1.0))
	{
		//m_input.m_engine_start = 2.0;
		//m_input.m_engine_stop = 2.0;
		m_needRestart = true;
	}
	else
	{
		m_overHeat = 0.0;
	}

	return m_overHeat;
}

double Engine::overHeatInd()
{
	if (m_input.getElectricSystem() == 1.0)
	{
		if ((overHeat() >= 0.75) || (m_heatFailure == true))
		{
			m_overHeatInd = 1.0;
		}
		else
		{
			m_overHeatInd = 0.0;
		}
	}
	else
	{
		m_overHeatInd = 0.0;
	}
	return m_overHeatInd;
}

double Engine::overSpeedInd()
{
	if (m_input.getElectricSystem() == 1.0)
	{
		if (((m_state.m_mach > 1.114) && (m_state.m_airDensity > 1.112)) || ((m_state.m_mach > 1.25) && ((m_state.m_airDensity > 0.9093) && (m_state.m_airDensity <= 1.112))) || ((m_state.m_mach > 1.60) && ((m_state.m_airDensity > 0.6601) && (m_state.m_airDensity < 0.9093))) || ((m_state.m_mach > 2.2) && (m_state.m_airDensity < 0.6601)))
		{
			m_overSpeedInd = 1.0;
		}
		else
		{
			m_overSpeedInd = 0.0;
		}
	}
	else
	{
		m_overSpeedInd = 0.0;
	}

	return m_overSpeedInd;
}

void Engine::repairHeatDamage()
{
	m_overHeat = 0.0;
	m_overHeatInd = 0.0;
	//m_input.m_engine_start = 0.0;
	//m_input.m_engine_stop = 0.0;
	m_heatFailure = false;
	m_needRepair = false;
	m_heatTimerDOWN = 0;
	m_heatTimerUP = 0;

}

void Engine::restartNeeded()
{
	if ((m_input.getEngineStart() == 0.0) && (m_heatFailure == false) && (m_needRepair == false) && (m_needRestart == true))
	{
		m_needRestart = false;
	}
}

