#include "FlightModel.h"

//=========================================================================//
//
//		FILE NAME	: FlightModel.cpp
//		AUTHOR		: Joshua Nelson & Paul Stich
//		Copyright	: Joshua Nelson & Paul Stich
//		DATE		: August 2021
//
//		DESCRIPTION	: Every force that is needed for the flight-simulation. 
//					  As well as the Camera-Shaker.
//					  
//================================ Includes ===============================//
//=========================================================================//


FlightModel::FlightModel
(
	State& state,
	Input& input,
	Engine& engine, //NEU 21Feb21
	Airframe& airframe
	//der letzte Eintrag hier darf kein Komma haben!
) :
	m_state(state),
	m_input(input),
	m_engine(engine), //NEU 21Feb21
	m_airframe(airframe),

	m_scalarVelocity(0.0),
	m_scalarVelocitySquared(0.0),
	m_aoaDot(0.0),
	m_aoaPrevious(0.0),

	m_k(0.0),
	m_q(0.0),
	m_p(0.0),

	m_cockpitShake(0.0),
	m_shakeDuration(0.1),

	//-----"init" Tables AeroData_1.h + FlightModel.h-----------
	//-----------------Pitch------------------------------------
	Cmalpha(DAT_Cma_SL, CON_Cma_SL_min, CON_Cma_SL_max),
	CmalphaNEW(DAT_Cma_full, CON_Cma_full_min, CON_Cma_full_max),
	Cmde(DAT_Cmde_SL, CON_Cmde_SL_min, CON_Cmde_SL_max),
	CmdeNEW(DAT_Cmde_full, CON_Cmde_full_min, CON_Cmde_full_max),
	Cmq(DAT_Cmq, CON_Cmq_min, CON_Cmq_max),
	CmadotNEW(DAT_CmaDOT_Full, CON_CmaDOT_Full_Min, CON_CmaDOT_Full_Max),
	CmM(DAT_CmM, CON_Cmq_min, CON_Cmq_max),
	CmFlap(DAT_CmFlap, CON_CmFlap_min, CON_CmFlap_max),
	CmqStAg(DAT_CmqStAg, CON_CmqStAg_Min, CON_CmqStAg_Max),
	CmaDOTStAg(DAT_CmaDOTStAg, CON_CmaDOTStAg_Min, CON_CmaDOTStAg_Max),
	//----------------DRAG---------------------------------------
	CDmin(DAT_CDmin, CON_CDminmin, CON_CDminmax),
	CDmach(DAT_CDmach_SL, CON_CDmach_SLmin, CON_CDmach_SLmax),
	CDa(DAT_CDa_SL, CON_CDa_SLmin, CON_CDa_SLmax),
	CDeng(DAT_CDeng, CON_CDengmin, CON_CDengmax),
	CDOM(DAT_CD_OM, CON_CD_OM_Min, CON_CD_OM_Max),
	CDminAD(DAT_CDminAD, CON_CDminAD_Min, CON_CDminAD_Max),
	CDOK(DAT_CD_OK, CON_CD_OK_Min, CON_CD_OK_Max),
	//---------------LIFT----------------------------------------
	CLmax(DAT_CLmax, CON_CLmaxmin, CON_CLmaxmax),
	CLmach(DAT_CLmach_SL, CON_CLmach_SLmin, CON_CLmach_SLmax),
	CLa(DAT_CLa, CON_CLamin, CON_CLamax),
	CLds(DAT_CLds, CON_CLdsmin, CON_CLdsmax),
	//CLa_FL1(DAT_CLa_FL1, CON_CLa_FL1_Min, CON_CLa_FL1_Max),
	CLa_FL2(DAT_CLa_FL2, CON_CLa_FL2_Min, CON_CLa_FL2_Max),
	CL_FlStat(DAT_CL_FlStat, CON_CL_FlStat_Min, CON_CL_FlStat_Max), //Static Flap Lift "base-lift"
	//--------------ROLL----------------------------------------
	Clb(DAT_Clb_SL, CON_Clb_SLmin, CON_Clb_SLmax),
	Clp(DAT_Clp, CON_Clp_min, CON_Clp_max),
	Clda(DAT_Clda, CON_Cldamin, CON_Cldamax),
	Clr(DAT_Clr, CON_Clr_min, CON_Clr_max),
	Cldr(DAT_Cldr_full, CON_Cldr_min, CON_Cldr_max),
	ClpStab(DAT_ClpStab, CON_ClpStab_Min, CON_ClpStab_Max),
	ClrStab(DAT_ClrStab, CON_ClrStab_Min, CON_ClrStab_Max),
	//---------------YAW---------------------------------------
	CnbNEW(DAT_Cnb_FULL, CON_Cnb_Full_Min, CON_Cnb_FULL_Max),
	Cndr(DAT_Cndr, CON_Cndrmin, CON_Cndrmax),
	Cnr(DAT_Cnr, CON_Cnrmin, CON_Cnrmax),
	Cnp(DAT_Cnp, CON_Cnpmin, CON_Cnpmax),
	Cnda(DAT_Cnda, CON_Cndamin, CON_Cndamax),
	CnrStab(DAT_CnrStab, CON_CnrStab_Min, CON_CnrStab_Max),
	Cyb(DAT_Cyb, CON_Cybmin, CON_Cybmax),
	Cydr(DAT_Cydr, CON_Cydrmin, CON_Cydrmax),
	
	//---------------Thrust------------------------------------
	//PMax(DAT_PMax, CON_PMaxmin, CON_PMaxmax)
	//PFor(DAT_PFor, CON_PFormin, CON_PFormax)
	ThinAM(DAT_ThinAM, CON_ThinAM_Min, CON_ThinAM_Max),
	AdThrLAlt(DAT_AdThrLAlt, CON_AdThrLAlt_Min, CON_AdThrLAlt_Max),
	AdThrLAltMulti(DAT_AdThrLaltMulti, CON_AdThrLAltMulti_Min, CON_AdThrLAltMulti_Max),
	//---------------Misc-------------------------------------
	//--------------PitchUP and Stall------------------------
	PitAoA(DAT_PitchAoA, CON_PitAoAMin, CON_PitAoAMax),
	PitMult(DAT_PitchMult, CON_PitMulMin, CON_PitMulMax),
	StAoA(DAT_StallAoA, CON_StAoAMin, CON_StAoAMax),
	StAoAMulti(DAT_StAoAMulti, CON_StAoAMulti_Min, CON_StAoAMulti_Max),
	CLzero(DAT_CLzero, CON_CLzeroMin, CON_CLzeroMax),
	CLaCorr(DAT_CLaCorr, CON_CLaCorr_min, CON_CLaCorr_max)
	
	//der letzte Eintrag darf KEIN Komma haben...



	//genau so für jede DATA Table (DATA, min , max)
{
	//printf("Hello\n");
}

void FlightModel::zeroInit()
{
	m_q = 0.0;
	m_p = 0.0;
	m_k = 0.0;
	CLblc = 0.0;

	//----------NEU TESTWEISE-----------------
	//----------TESTWEISE um Spin Probleme zu testen bei Rotation der Forces-------
	//----------HIER Rotation der Momente von der Stability- ind die Body-Axis----
	//----------Siehe auch CR-2144 Appendix B am Anfang--------------------------
	//----------Verwednung in der Formel von Allerton in der rottierten Form zum Testen--
	Clb_b = 0.0;
	Clp_b = 0.0;
	Clr_b = 0.0;
	Clda_b = 0.0;
	Cldr_b = 0.0;

	Cnb_b = 0.0;
	Cnp_b = 0.0;
	Cnr_b = 0.0;
	Cnda_b = 0.0;
	Cndr_b = 0.0;

	CosAoA = 0.0;
	SinusAoA = 0.0;
	CosAoA2 = 0.0;
	SinusAoA2 = 0.0;

	m_corrAoA = 0.0;
	m_corrBeta = 0.0;
	//-------------Nach dem Test ggf. auskommentieren oder entfernen---------------
	//------------ENDE NEU--------------------------------------------------------

	m_thinAirMulti = 0.0;
	m_addThrust = 0.0;

	m_scalarVelocitySquared = 0.0;
	m_scalarVelocity = 0.0;
	m_aoaPrevious = 0.0;
	//m_aoaPrevious = 0.0;
	m_aoaDot = 0.0;

	m_ailDeflection = 0.0;
	m_rudDeflection = 0.0;
	m_elevDeflection = 0.0;
	
	//m_state.m_mach = 0.0;
	//m_state.m_beta = 0.0;
	//m_state.m_omega = 0.0;
	
	m_pitchup = 0.0;
	m_stallMult = 0.0;

	m_zeroLift = 0.0;
	m_setLiftZero = 0.0;
	m_stallIndRoll = 0.0;
	m_stallIndDrag = 0.0;
	m_wingStalling = false;
	m_CLaCorrMulti = 0.0;

	//------PitStabSystem----
	m_CmqStAg = 0.0;
	m_CmaDOTStAg = 0.0;
	m_StabAugSys = 0.0;
	m_pitchHydroForce = 0.0;

	//------RollStabSystem---
	m_ClpStab = 0.0;
	m_ClrStab = 0.0;
	m_RollStabSys = 0.0;
	Clp_S = 0.0;
	Clr_S = 0.0;
	m_ClrMulti = 0.0;
	m_ClpMulti = 0.0;
	m_rollHydroForce = 0.0;

	//------YawStabSystem-----
	m_CnpStab = 0.0;
	m_CnrStab = 0.0;
	m_YawStabSys = 0.0;
	Cnr_S = 0.0;
	m_CnrMulti = 0.0;
	m_yawHydroForce = 0.0;

	M_mcrit = 0.0;
	M_mcrit_b = 0.0;

	//-----Drag Variable----
	CDwave = 0.0;
	CDi = 0.0;
	
	CD_OverMach = 0.0;
	m_cdminADD = 0.0;

	CD_brFlap = 0.0;
	m_flapBroken = false;

	CDGear = 0.0;
	CDFlaps = 0.0;
	
	CDBrk = 0.0;
	CDBrkCht = 0.0;

	//---Lift Variable---
	CLFlaps = 0.0;
	CLblc = 0.0;

	m_rWingDamageCL = 0.0;
	m_rWingDamageCD = 0.0;
	m_lWingDamageCL = 0.0;
	m_lWingDamageCD = 0.0;
	m_ailDamage = 0.0;
	m_flapDamage = 0.0;
	m_rSpdBrkDamage = 0.0;
	m_rSpdBrkDamage = 0.0;
	m_hStabDamage = 0.0;
	m_vStabDamage = 0.0;
	
	
	m_moment = Vec3();
	m_force = Vec3();
	
	gearShake = false;
	prevGearShake = false;

	//-----------NUR ZUM TETEN--------------------
	m_thrustForce = 0.0;
}

void FlightModel::coldInit()
{
	zeroInit();
}

void FlightModel::hotInit()
{
	zeroInit();
}

void FlightModel::airborneInit()
{
	zeroInit();
}

void FlightModel::calculateAeroRotateMoments()
{
	
	//---------------AoA Begrenzungsfunktion für WeightOnWheels-----------------
	if ((m_airframe.getWeightOnWheels() != 0.0) && (m_state.m_mach < 0.07))
	{
		if (m_state.m_aoa > 0.35)
		{
			m_corrAoA = 0.35;
		}
		if (m_state.m_aoa < -0.09)
		{
			m_corrAoA = -0.09;
		}
	}
	else
	{
		m_corrAoA = m_state.m_aoa;
	}

	if ((m_airframe.getWeightOnWheels() != 0.0) && (m_state.m_mach < 0.07))
	{
		if (m_state.m_beta > 0.10)
		{
			m_corrBeta = 0.10;
		}
		if (m_state.m_beta < -0.10)
		{
			m_corrBeta = -0.10;
		}
	}
	else
	{
		m_corrBeta = m_state.m_beta;
	}
	
	
	//----------TESTWEISE um Spin Probleme zu testen bei Rotation der Forces-------
	//----------HIER Rotation der Momente von der Stability- ind die Body-Axis----
	//----------Verwednung in der Formel von Allerton in der rottierten Form zum Testen--
	//----------Yaw und Roll inklusive Stabilitäts-System-------------------------
	Clp_S = Clp(m_state.m_mach);//  
	// Clp ist der Wiederstand beim Rollen NICHT die Dämpfung!! daher mal so zum testen 
	// ggf. ändern in so :-) -> m_ClpStab;// so wird das unten berechnet (Clp(m_state.m_mach) + ClpStab(m_state.m_mach));
	Clr_S = m_ClrStab;// so wird das unten berechnet (Clr(m_state.m_mach) + ClrStab(m_state.m_mach));

	Cnr_S = m_CnrStab;




	//-----------Neue Funktion an den corrected AOA angebunden---------------------------
	CosAoA = cos(m_corrAoA);
	SinusAoA = sin(m_corrAoA);

	CosAoA2 = CosAoA * CosAoA;
	SinusAoA2 = SinusAoA * SinusAoA;


	//----------Konvertiertung der Momente von der Stabilitäts zu der KörperAchse----------
	//----------Siehe auch CR-2144 Appendix B am Anfang--------------------------
	/* //----------ohne Yaw und Roll Stabilitätssystem--------------------------
	Cnb_b = CnbNEW(m_state.m_mach) * CosAoA + Clb(m_state.m_mach) * SinusAoA;
	Cnp_b = Cnp(m_state.m_mach) * CosAoA2 - (Cnr(m_state.m_mach) - (Clp(m_state.m_mach))) * SinusAoA * CosAoA - (-Clr(m_state.m_mach)) * SinusAoA2;
	Cnr_b = Cnr(m_state.m_mach) * CosAoA2 + ((-Clr(m_state.m_mach)) + Cnp(m_state.m_mach)) * SinusAoA * CosAoA + (Clp(m_state.m_mach)) * SinusAoA2;
	Cnda_b = Cnda(m_state.m_mach) * CosAoA * Clda(m_state.m_mach) * SinusAoA;
	Cndr_b = Cndr(m_state.m_mach) * CosAoA - Cldr(m_state.m_mach) * SinusAoA;

	Clb_b = Clb(m_state.m_mach) * CosAoA - CnbNEW(m_state.m_mach) * SinusAoA;
	Clp_b = (Clp(m_state.m_mach)) * CosAoA2 - ((-Clr(m_state.m_mach)) - Cnp(m_state.m_mach)) * SinusAoA * CosAoA + Cnr(m_state.m_mach) * SinusAoA2;
	
	Clr_b = (-Clr(m_state.m_mach)) * CosAoA2 - (Cnr(m_state.m_mach) - (Clp(m_state.m_mach))) * SinusAoA * CosAoA - Cnp(m_state.m_mach) * SinusAoA2;
	Clda_b = Clda(m_state.m_mach) * CosAoA - Cnda(m_state.m_mach) * SinusAoA;
	Cldr_b = Cldr(m_state.m_mach) * CosAoA - Cndr(m_state.m_mach) * SinusAoA;
	*/

	//------------------Mit Roll- und Yaw-Stabilitätssystem----------------------

	Cnb_b = CnbNEW(m_state.m_mach) * CosAoA + Clb(m_state.m_mach) * SinusAoA;
	Cnp_b = Cnp(m_state.m_mach) * CosAoA2 - (Cnr_S - Clp_S) * SinusAoA * CosAoA - (-Clr_S) * SinusAoA2;
	Cnr_b = Cnr_S * CosAoA2 + ((-Clr_S) + Cnp(m_state.m_mach)) * SinusAoA * CosAoA + (Clp_S) * SinusAoA2;
	Cnda_b = Cnda(m_state.m_mach) * CosAoA * Clda(m_state.m_mach) * SinusAoA;
	Cndr_b = Cndr(m_state.m_mach) * CosAoA - Cldr(m_state.m_mach) * SinusAoA;

	Clb_b = Clb(m_state.m_mach) * CosAoA - CnbNEW(m_state.m_mach) * SinusAoA;
	Clp_b = (Clp_S) * CosAoA2 - ((-Clr_S) - Cnp(m_state.m_mach)) * SinusAoA * CosAoA + Cnr_S * SinusAoA2;

	Clr_b = (-Clr_S) * CosAoA2 - (Cnr_S - Clp_S) * SinusAoA * CosAoA - Cnp(m_state.m_mach) * SinusAoA2;
	Clda_b = Clda(m_state.m_mach) * CosAoA - Cnda(m_state.m_mach) * SinusAoA;
	Cldr_b = Cldr(m_state.m_mach) * CosAoA - Cndr(m_state.m_mach) * SinusAoA;


}

void FlightModel::L_stab()
{
	//set roll moment -- 
	//Neu eingefügt am 14.02.2021 PJ-- "-" vor Clr eingefügt, da Clr Daten positiv waren und negativ sein müssten da Dämpfung
	//m_moment.x-- "2 *" vor Clda eingefügt für stärkere Ailerons = schon besser-- "2*" vor Clp eingefügt -- "0,5 *" vor Clb eingefügt
	//m_ailDamage als multiplikator eingefügt; (m_lWingDamageCD + m_rWingDamageCD) bzgl. WingDamageRoll-Effekt eingefügt;
	
	//-------------------------ALTE Version ohne Beschränkung des Querruder-Ausschlags-------------------------------------------------
	/*m_moment.x += m_q * (Clb(m_state.m_mach) * m_state.m_beta + Clda(m_state.m_mach) * ((m_input.getRoll() + m_input.getTrimmAilR() - m_input.getTrimmAilL()) * m_ailDamage ) + (m_lWingDamageCD + m_rWingDamageCD) + (0.55 * Cldr(m_state.m_mach)) * m_input.getYaw() )
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_b * CON_b * (2.0 * Clp(m_state.m_mach) * m_state.m_omega.x + (1.5 * -Clr(m_state.m_mach)) * m_state.m_omega.y);
	*/

	//-------------------------NEUE Versíon MIT Beschränkung des Max-Ausschalgs-------------------zum testen der Rotation auskommentiert-------------------------------------
	/*m_moment.x += m_q * (Clb(m_state.m_mach) * m_state.m_beta + Clda(m_state.m_mach) * (((m_input.getRoll() * m_ailDeflection) + m_input.getTrimmAilR() - m_input.getTrimmAilL()) * m_ailDamage) + (m_lWingDamageCD + m_rWingDamageCD) + (0.55 * Cldr(m_state.m_mach)) * (m_input.getYaw() * m_rudDeflection) + m_stallIndRoll)
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_b * CON_b * (2.0 * Clp(m_state.m_mach) * m_state.m_omega.x + (1.5 * -Clr(m_state.m_mach)) * m_state.m_omega.y);
		*/
	
	//-----------Input Clr aud -Clr in der Rotationsformel geändert und "-" vor Clr hier entfernt (sehr gut)------
	//-----------Multiplikator Clp in der Rotationsformel eingefügt und entfernt wegen Blödheit-----------------------------------
	//-----------Multiplikator in der Moment Formel für Clp_b von 2.0 auf 1.2 und auf 1.25 auf 1.35 auf 1.45 auf 2.05 auf 2.15 auf 2.35 auf 1.25 geändert, weil Clp eigentlich Rollresistenz ist, die soll gar nicht soo hoch...
	//-----------Multiplikator vor Clr_b von 1.5 auf 1.1 und auf 1.15 auf 1.25 auf 1.40 auf 1.35 auf 1.40 auf 1.50 auf 1.65 auf 2.55 zurück auf 1.5 und Multi in RollStabFunktion verschoben------------------------------------------------------
	//----------m_stallIndRoll verringert auf (s.u.)-----------------------------------------------------------------------------------
	//-----------anstatt m_state.m_beta m_corrBeta zum Ausgleich für WeightOnWheels----------------------------------------------------
	//----------1.15 Multi vor Clda eingefügt; zu 1.35 zu 1.55
	m_moment.x += m_q * (Clb_b * m_corrBeta + ((1.55 * m_rollHydroForce) * Clda_b * (((m_input.getRoll() * m_ailDeflection) + m_input.getTrimmAilR() - m_input.getTrimmAilL()) * m_ailDamage)) + (m_lWingDamageCD + m_rWingDamageCD) + (0.55 * Cldr_b) * (m_input.getYaw() * m_rudDeflection) + m_stallIndRoll)
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_b * CON_b * ((((1.25 - m_stallMult) + m_ClpMulti) * Clp_b) * m_state.m_omega.x + (((1.5 - m_stallMult) + m_ClrMulti) * Clr_b) * m_state.m_omega.y);
}

void FlightModel::M_stab()
{
	//set pitch moment-- 
	//"-" vor Cmde eingefügt, da positiver Wert erwartet--//---Cmde von 0.9 auf 0.8 und Cmalpha von 1.15 auf 1.25 auf 1.35 
	//m_pitchup ist Pitch-Up-Moment durch AoA > 15°; m_airframe.autoPilotAltH() ist Pitch due to auto-Pilot Altitude-hold; m_hStabDamage ist horizontal stabilizer integrity in %  
	
	//---------------Alte Version OHNE Beschränkung des Pitch-Inputs auf maximalen Hoehenruder-ausschlag----------------------------------------------------------------------------------
	/*m_moment.z += m_k * CON_mac * (1.35 * (CmalphaNEW(m_state.m_mach) * m_state.m_aoa) + (0.80 * -CmdeNEW(m_state.m_mach)) * (((m_input.getPitch() + m_pitchup) + m_input.getTrimmUp() - m_input.getTrimmDown() + m_airframe.getAutoPilotAltH()) * m_hStabDamage )) 
			+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_mac * CON_mac * ((1.75 * Cmq(m_state.m_mach))*m_state.m_omega.z + (1.45 * Cmadot(m_state.m_mach)) * m_aoaDot);
	*/
	//1.35 * Cmalpha; 1.75 * cmq; 1.45 * cmadot //Werte werden verändert für geringere Resistenz gegenüber Pitch
	// "+ m_CmqStAG" eingefügt

	//----------------NEUE Version mit Ausschlagsbeschränkung auf max Ausschlag Backstick--------------Cm bleibt unberhürt von der Rotation-----------------------------------------------------------------------------------
	//Alte Formel mit PitchUp als Anteil des Elevetor-Ausschlags
	/*m_moment.z += m_k * CON_mac * (1.35 * (CmalphaNEW(m_state.m_mach) * m_state.m_aoa) + (-CmdeNEW(m_state.m_mach)) * ((((m_input.getPitch() * m_elevDeflection) + m_pitchup) + m_input.getTrimmUp() - m_input.getTrimmDown() + m_airframe.getAutoPilotAltH()) * m_hStabDamage))
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_mac * CON_mac * (((1.75 - m_stallMult) * Cmq(m_state.m_mach) + m_CmqStAg) * m_state.m_omega.z + (((1.95 - m_stallMult) * CmadotNEW(m_state.m_mach)) + m_CmaDOTStAg ) * m_aoaDot );
	*/
	//---------------NEUE Formel mit Pitchup als separater Funktion für Pitch ohne Anbindung an den Elevator---------------------
	//---------------Alte Funktion mit direkter Anbindung an m_state.m_aoa-------------------------------------------------------
	//m_moment.z += m_k * CON_mac * (1.35 * (CmalphaNEW(m_state.m_mach) * m_state.m_aoa) + (-CmdeNEW(m_state.m_mach)) * (((m_input.getPitch() * m_elevDeflection) + m_input.getTrimmUp() - m_input.getTrimmDown() + m_airframe.getAutoPilotAltH()) * m_hStabDamage) + m_pitchup)
		//+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_mac * CON_mac * (((1.75 - m_stallMult) * Cmq(m_state.m_mach) + m_CmqStAg) * m_state.m_omega.z + (((1.95 - m_stallMult) * CmadotNEW(m_state.m_mach)) + m_CmaDOTStAg) * m_aoaDot);
	
	//------------CmFlaps eingefügt auf 0.75 und 0.75 zu 0.82 zu 0.95 als Multiplikator vor Cmde eingefügt
	//----------- Multiplikator vor CmAlpha entfernt, da CmAlpha grds. ein negatives Pitchmoment gibt------------
	//------------------------Neue Formel über corrAoA an m_state.m_aoa angebunden und m_corrBeta statt m_state.m_beta-----------------------------------------------------------
	m_moment.z += m_k * CON_mac * ((CmalphaNEW(m_state.m_mach) * m_corrAoA) + (((0.95 * -CmdeNEW(m_state.m_mach) * m_pitchHydroForce)) * (((m_input.getPitch() * m_elevDeflection) + m_input.getTrimmUp() - m_input.getTrimmDown() + m_airframe.getAutoPilotAltH()) * m_hStabDamage)) + m_pitchup + (0.95 * CmFlap(m_state.m_mach) * m_airframe.getFlapsPosition()))
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_mac * CON_mac * ((((1.75 - m_stallMult) * Cmq(m_state.m_mach) + m_CmqStAg) * m_state.m_omega.z) + (((1.95 - m_stallMult) * CmadotNEW(m_state.m_mach)) + m_CmaDOTStAg) * m_aoaDot);

}

void FlightModel::N_stab()
{
	//set yaw moment-- 
	//"Cnda * da" ausgelassen, da wegen gegenläufiger ailerons geringfügig (Buch Seite 114) "Cnp * Pstab" ausgelassen, da ggf. unnötig 
	// "-" vor Cndr eingefügt, da "Rudereffektivität" positiv sein müsste-- "-" vor Cnb eingefügt, da Dämpfung-- "2.5 *" vor Cnr eingefügt für mehr Dämpfung
	// "- (0.75 * m_stallMult)" und "- m_stallMult" eingefügt wegen Stall-Verhalten// statt 0.75 0.95 als m_stallMult eingefügt 
	//moment.y
	
	//----------------------------ALTE Version ohne Beschränkung des Ruder-Ausschlags------------------------------------------------------
	/*m_moment.y += m_q * ((1.5 - ( 0.95 * m_stallMult)) * -Cnb(m_state.m_mach) * m_state.m_beta + -Cndr(m_state.m_mach) * -m_input.getYaw())
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_b * CON_b * ((2.5 - m_stallMult) * Cnr(m_state.m_mach) * m_state.m_omega.y);
	*/


	//----------------------------NEUE Version mit Beschränkung des max-Ruderausschlags-----------------------------------------------------
	// ((1.5 - (0.95 * m_stallMult)) // ((2.5 - m_stallMult) * Cnr(m_state.m_mach) * m_state.m_omega.y) ALT
	//neu eingefügt ist: "+ (Cnda(m_state.m_mach) * (m_input.getRoll() * m_ailDeflection))" und "(Cnp(m_state.m_mach) * m_state.m_omega.x) +"
	//-----------------------auskommentiert zum Testen der rotierten Yaw-Werte----------------------------------------------------------------
	
	/*m_moment.y += m_q * (((1.2 - (0.95 * m_stallMult)) * -CnbNEW(m_state.m_mach) * m_state.m_beta) + (Cnda(m_state.m_mach) * (m_input.getRoll() * m_ailDeflection)) + -Cndr(m_state.m_mach) * (-m_input.getYaw() * m_rudDeflection))
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_b * CON_b * ((Cnp(m_state.m_mach) * m_state.m_omega.x) + ((2.1 - m_stallMult) * Cnr(m_state.m_mach) * m_state.m_omega.y));
	*/

	//---2.1 Multi vor Cnr_b halbiert und verschoben nach YawStabSystem 
	//-------------------m_corrBeta statt m_state.m_beta---------------------------------------------------------------------------------------------------------------------------
	m_moment.y += m_q * (((1.2 - (0.95 * m_stallMult)) * -Cnb_b * m_corrBeta) + (Cnda_b * (m_input.getRoll() * m_ailDeflection)) + (-Cndr_b * m_yawHydroForce) * (-m_input.getYaw() * m_rudDeflection))
		+ 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_b * CON_b * ((Cnp_b * m_state.m_omega.x) + (((1.05 * m_CnrMulti) - m_stallMult) * Cnr_b * m_state.m_omega.y));
}


void FlightModel::lift()
{
	//set lift 
	//-- eingefügt am 16.02. als "Lift = 0.5 * p * V² * s * CL
	//approx m_force.y
	// erster Versuch : m_force.y = m_k * (CLmach(m_state.m_mach) + CLa(m_state.m_aoa)); //Lift ist so schon gut ;-)
	//-------------------ursprüngliche Lift-Formel mit statischem Flap-Lift------------------------------------------
	//m_force.y += m_k * (((CLa(m_state.m_mach) * m_state.m_aoa) + ((CLFlaps + CLblc) * m_flapDamage)) * ((m_lWingDamageCL + m_rWingDamageCL) / 2.0 ) ); //+ CLds(m_state.m_mach)); //aktuell nur Lift due to AoA ohne Stab-Lift 
	
	//------------------neue Lift-Formel mit dynamischem Flap-Lift---------------------------------------------------
	//---------m_state.m_aoa ersetzt durch m_corrAoA-----------------------------------------------------------------
	m_force.y += m_k * (((((CLa(m_state.m_mach) * m_corrAoA) *m_CLaCorrMulti) + ((0.65 * CLds(m_state.m_mach)) * m_elevDeflection) + ((CLFlaps + CLblc) * m_flapDamage)) * ((m_lWingDamageCL + m_rWingDamageCL) / 2.0)) * m_zeroLift);
}

void FlightModel::drag()
{
	//set drag
	//--eingefügt 16.02. es fehlt noch supersonic drag, gear-drag, flap-drag, brake-drag
	//approx m_force.x negative
	//erster Versuch: m_force.x = -(m_k * (CDmach(m_state.m_mach) + CDa(m_state.m_aoa)
		//+ ((CLmach(m_state.m_mach) + CLa(m_state.m_mach)) * (CLmach(m_state.m_mach) + CLa(m_state.m_mach))) / CON_pi * CON_AR * CON_e));
	// statt 0.85 jetzt 0.80 * CDa(etc) um Alpha-Drag anzupassen.
	//jetzt wieder 1.0 vor CDa, da aufgrund der Rotation der Drag anders "angreift"
	//----------------------------------m_state.m_aoa durch m_corrAoA ersetzt--------------------------------------------------------------
	m_force.x += -m_k * ((CDmin(m_state.m_mach)) + (1.00 * (CDa(m_state.m_mach) * m_corrAoA)) + (CDeng(m_state.m_mach)) + CDGear + CDFlaps + CDBrk + CDBrkCht + CD_OverMach + m_cdminADD + CD_brFlap + m_stallIndDrag); // +CDwave + CDi); CDwave und CDi wieder dazu, wenn DRAG geklärt.
}

void FlightModel::sideForce()
{	
	//set side force
	//m_force.z
	//vor m_input.getYaw() ein "-" eingefügt, da eigentlich "-"Yaw richtig-herum ist.
	//------------m_corrBeta statt m_state.m_beta zum Ausgleich bei WeightOnWheels
	m_force.z += m_k * ((Cydr(m_state.m_mach) * (m_input.getYaw() * m_rudDeflection)) + (Cyb(m_state.m_mach) * m_corrBeta)); //neu eingefügt 28Mar21
}

void FlightModel::thrustForce()
{
	//set thrust force
	//m_force.x positive
	//m_force = Vec3();
	//m_engine.update(123); //neu eingefügt// und wieder zum testen auskommentiert 
	//--Alte Formel Direkt zu m_force----: m_force.x += abs((m_engine.updateThrust() + m_addThrust) * m_airframe.getEngineDamageMult() * m_thinAirMulti); //ABS eingefügt für nur positiv Schub!! NEU m_thinAirMulti angefügt für Thrustreduktion ab 94.000 ft.
	//Neue Formel, zu m_force_body

	//m_force_boddy.x += abs((m_engine.updateThrust() + m_addThrust) * m_airframe.getEngineDamageMult() * m_thinAirMulti); so geht es, wenn ich thrustForce später aufrufe

	m_thrustForce = abs((m_engine.updateThrust() + m_addThrust) * m_airframe.getEngineDamageMult() * m_thinAirMulti);
	
	
	//m_force.x += abs((m_engine.updateThrust() + m_addThrust) * m_airframe.getEngineDamageMult() * m_thinAirMulti);

}

void FlightModel::calcAeroDeflection()
{
	if (m_airframe.getGearNPosition() > 0.0)
	{
		m_ailDeflection = 2 * CON_aitgu;
	}
	if (m_airframe.getGearNPosition() == 0.0)
	{
		m_ailDeflection = 2 * CON_aitnu;
	}

	if (m_airframe.getGearNPosition() > 0.0)
	{
		m_rudDeflection = CON_RdDefGDR;
	}
	if (m_airframe.getGearNPosition() == 0.0)
	{
		m_rudDeflection = CON_RdDefGUR;
	}

	if (m_input.getPitch() >= 0.0)
	{
		m_elevDeflection = m_input.getPitch() * CON_hstdUP;
	}
	if (m_input.getPitch() < 0.0)
	{
		m_elevDeflection = m_input.getPitch() * CON_hstdDN;
	}

}

void FlightModel::calcLiftFlaps()
{
	//------------------------m_state.m_aoa ersetzt durch m_corrAoA---------------------------------------------------
	CLFlaps = ((CLa_FL2(m_state.m_mach) * m_corrAoA) + CL_FlStat(m_state.m_mach)) * m_airframe.getFlapsPosition();

	CLblc = (m_airframe.BLCsystem() * CLFlaps) * 0.8;//NEU * 0.8 eingefügt
}

void FlightModel::pitchStabAugSystem()
{
	if ((m_airframe.getCompressorDamage() >= 0.35) && (m_input.getElectricSystem() == 1.0))
	{
		m_CmqStAg = CmqStAg(m_state.m_mach);
		m_CmaDOTStAg = CmaDOTStAg(m_state.m_mach);
		m_StabAugSys = 0.5;
	}
	else if ((m_airframe.getCompressorDamage() < 0.35) && (m_input.getElectricSystem() == 1.0))
	{
		m_CmqStAg = 0.0;
		m_CmaDOTStAg = 0.0;
		m_StabAugSys = 1.0;
	}
	else if (m_input.getElectricSystem() == 0.0)
	{
		m_CmqStAg = 0.0;
		m_CmaDOTStAg = 0.0;
		m_StabAugSys = 0.0;
	}

	m_pitchHydroForce = (m_airframe.getHyraulicPumpPower() / 2.0) * 1.25;
}

void FlightModel::yawStabAugSystem()
{
	if ((m_airframe.getCompressorDamage() >= 0.35) && (m_input.getElectricSystem() == 1.0))
	{
		m_CnrStab = (Cnr(m_state.m_mach) + CnrStab(m_state.m_mach));
		m_CnrMulti = 2.0;
		m_YawStabSys = 0.5;
	}
	else if ((m_airframe.getCompressorDamage() < 0.35) && (m_input.getElectricSystem() == 1.0))
	{
		m_CnrStab = Cnr(m_state.m_mach);
		m_CnrMulti = 1.65;
		m_YawStabSys = 1.0;
		
	}
	else if (m_input.getElectricSystem() == 0.0)
	{
		
		m_CnrStab = Cnr(m_state.m_mach);
		m_CnrMulti = 1.65;
		m_YawStabSys = 0.0;
	}

	m_yawHydroForce = (m_airframe.getHyraulicPumpPower() / 2.0) * 1.25;
}


void FlightModel::rollStabAugSystem()
{
	if ((m_airframe.getCompressorDamage() >= 0.35) && (m_input.getElectricSystem() == 1.0))
	{
		m_ClrStab = (Clr(m_state.m_mach) + ClrStab(m_state.m_mach));//1.55 zu 2.25 zu 4.0
		m_ClrMulti = 3.0;
		m_ClpMulti = 2.0;
		m_RollStabSys = 0.5;
	}
	else if ((m_airframe.getCompressorDamage() < 0.35) && (m_input.getElectricSystem() == 1.0))
	{
		m_ClrStab = (Clr(m_state.m_mach));
		m_ClrMulti = 1.65;
		m_ClpMulti = 1.45;
		m_RollStabSys = 1.0;

	}
	else if (m_input.getElectricSystem() == 0.0)
	{

		m_CnrStab = (Clr(m_state.m_mach));
		m_ClrMulti = 1.65;
		m_ClpMulti = 1.45;
		m_RollStabSys = 0.0;
	}

	//Hydraulic-Pump-Multiplyer for AileronEffectiveness
	m_rollHydroForce = (m_airframe.getHyraulicPumpPower() / 2.0) * 1.25; //wir starten mal mit 1.25

	//printf("Clr-Pur %f \n", Clr(m_state.m_mach));
	//printf("Clr-Stab %f \n", ClrStab(m_state.m_mach));
	//printf("m_ClrStab %f \n", m_ClrStab);
}


void FlightModel::calcZeroLift()
{
	double CLaCLzeroQuotient = 0.0;
	m_setLiftZero = CLzero(m_state.m_mach);

	CLaCLzeroQuotient = (m_state.m_aoa / CLzero(m_state.m_mach));
	m_CLaCorrMulti = CLaCorr(CLaCLzeroQuotient);

	//-----------WeightOnWheels-Sensor eingefügt, da bei LiftOff getWeightOnWheels() == 0.0---------------

	if (m_airframe.getWeightOnWheels() == 0.0)
	{
		if (m_state.m_aoa >= m_setLiftZero)
		{
			m_zeroLift = 0.01;
			m_wingStalling = true;
		}
		else if (m_wingStalling == true)
		{
			m_zeroLift = 0.01;
		}
		else
		{
			m_zeroLift = 1.0;
		}

		if ((m_wingStalling == true) && (m_state.m_aoa <= 0.20)) //wenn AoA wieder kleiner als 11° ist
		{
			m_wingStalling = false;
		}

		if ((m_state.m_aoa >= m_setLiftZero) && (m_state.m_angle.x >= 0.0) && ((m_state.m_aoa > 0.42) && (m_state.m_aoa < 1.745))) //
		{
			m_stallIndRoll = 0.10;  //0.25 jetzt mit weniger, weil ich den m_stallIndRoll vor die Klammer gezogen habe und er jetzt nicht mit kleiner 1 multipliziert wird.
								//von 0.25 auf 0.20 wegen Rotation der Momente wieder auf 0.30 wegen stärkerer Dämpfung zurück zu 0.15 zu 0.10
		}
		else if ((m_state.m_aoa >= m_setLiftZero) && (m_state.m_angle.x < 0.0) && ((m_state.m_aoa > 0.42) && (m_state.m_aoa < 1.745))) //
		{
			m_stallIndRoll = -0.10;//-0.25 zurück zu 0.15 zu 0.10
		}
		else
		{
			m_stallIndRoll = 0.0;
		}

		if (m_state.m_aoa > m_setLiftZero)
		{
			m_stallIndDrag = (CDa(m_state.m_mach) * m_state.m_aoa) * 3.0;//war 1.5 jetzt 2.2 jetzt 2.8 jetzt 3.0
		}
		else
		{
			m_stallIndDrag = 0.0;
		}
	}
	else
	{
		m_zeroLift = 1.0;
		m_stallIndDrag = 0.0;
		m_stallIndRoll = 0.0;
		m_wingStalling = false;
	}
}

void FlightModel::addedDrag()
{
	//-----------auskommentiert, da Versuch mit CDmin_FullNEU und TSFC-Thrust-----------------
	/*if ((m_state.m_mach >= 0.0664) && (m_state.m_mach <= 1.4680))
	{
		m_cdminADD = CDminAD(m_state.m_mach);
	}
	else
	{
		m_cdminADD = 0.0;
	}*/
	
	m_cdminADD = 0.0;

}

void FlightModel::brokenFlapDrag()
{
	if ((m_airframe.osFlapDamage() > 0.0) && (m_airframe.getFlapsPosition() > 0.5) && ((m_state.m_mach > 0.85) || (m_flapBroken == true)))
	{
		CD_brFlap = 0.15;
		m_flapBroken = true;
	}
	else if ((m_airframe.osFlapDamage() > 0.0) && ((m_airframe.getFlapsPosition() >= 0.15) && (m_airframe.getFlapsPosition() <= 0.5)) && ((m_state.m_mach > 1.05) || (m_flapBroken == true)))
	{
		CD_brFlap = 0.15;
		m_flapBroken = true;
	}
	else if (m_airframe.osFlapDamage() == 0.0)
	{
		CD_brFlap = 0.0;
		m_flapBroken = false;
	}
}

void FlightModel::addedThrustCalc()
{
	//hier jetzt die Throttle mit eingefügt und als multiplikator für den added-Thrust eingefügt
	
	//-----------hier die alte Variante, die auch bei MilPower Schub addiert--------------------------------
	/*
	m_addThrust = corrThrottle * (AdThrLAlt(m_state.m_mach) * AdThrLAltMulti(m_airframe.getAltInFeet()));
	*/
	//----------neue Variante, die nur bei AB-Power Schub addiert, je nach Schub-Level-----------------------
	
	double corrThrottle = 0.0;


	if (m_input.getThrottle() >= 0.0)
	{
		corrThrottle = (1.0 - CON_ThrotIDL) * m_input.getThrottle() + CON_ThrotIDL;
	}
	else
	{
		corrThrottle = (m_input.getThrottle() + 1.0) / 2.0;
	}

	if (m_engine.updateSpool() >= 0.85)
	{
		m_addThrust = corrThrottle * (AdThrLAlt(m_state.m_mach) * AdThrLAltMulti(m_airframe.getAltInFeet()));
	}
	else
	{
		m_addThrust = 0.0;
	}
}

//-----------------Testweise umd Lift und Drag zu dem Pitch-Moment hinzu zu fügen-----------
//------------------wenn es zu komisch wird, dann fliegt es wieder raus--------------------
/*void FlightModel::addMoment(const Vec3& force, const Vec3& pos)
{
	//Add the force to the overall force
	//m_force_boddy += force;//auskommentiert, da ich zu m_boddy_force nichts hinzufügen möchte, sondern nur momente aus Kräften

	//Calculate the relative position to the centre of mass
	Vec3 relativePos = pos - m_state.m_com;

	//Calculate the "moment" (actually torque)
	Vec3 moment = cross(relativePos, force);

	//Add it on to the moments
	m_moment += moment;

}*/
//-------------------ENDE der testweisen Einfügung-----------------------------------------

void FlightModel::addForce(const Vec3& force, const Vec3& pos)
{
	//Add the force to the overall force
	m_force_boddy += force;//hier will ich auch FORCE haben!!!

	//Calculate the relative position to the centre of mass
	Vec3 relativePos = pos - m_state.m_com;

	//Calculate the "moment" (actually torque)
	Vec3 moment = cross(relativePos, force);

	//Add it on to the moments
	m_moment += moment;

}



void FlightModel::update(double dt)
{
	m_moment = Vec3();
	m_force = Vec3();

	//---------------Alte Formulierung mit direkter Anbindung an m_state.m_aoa----------
	//m_aoaDot = (m_state.m_aoa - m_aoaPrevious) / dt;
	//m_aoaPrevious = m_state.m_aoa;

	//----------------neue Formulierung über m_corrAoA---------------------------------
	m_aoaDot = (m_corrAoA - m_aoaPrevious) / dt;
	m_aoaPrevious = m_corrAoA;

	m_scalarVelocity = magnitude(m_state.m_localAirspeed);
	m_scalarVelocitySquared = m_scalarVelocity * m_scalarVelocity;


	m_k = 0.5 * m_state.m_airDensity * m_scalarVelocitySquared * CON_A;
	m_p = 0.25 * m_state.m_airDensity * m_scalarVelocity * CON_A * CON_b * CON_b;
	m_q = m_k * CON_b;

	m_state.m_mach = m_scalarVelocity / m_state.m_speedOfSound;
	
	M_mcrit = m_state.m_mach / CON_Mcrit; //Mach/Machcrit //neu eingefügt 18.02.2021
	M_mcrit_b = pow(M_mcrit, CON_wdb); //M_mcrit ^ CON_wdb //neu eingefügt 18.02.2021

	CDwave = CON_wda * M_mcrit_b; //neu eingefügt 18.02.2021
	
	CDi = ((CLmach(m_state.m_mach) * CLmach(m_state.m_mach)) / CON_pi * CON_A * CON_e );

	CDGear = CON_GrDD * m_airframe.getGearNPosition();
	CDFlaps = CON_FlpD2 * m_airframe.getFlapsPosition();
	//---OLD CLFlaps---//	CLFlaps = CON_FlpL2 * m_airframe.getFlapsPosition();
	//CLFlaps = (CLa_FL2(m_state.m_mach) * m_state.m_aoa) * m_airframe.getFlapsPosition();
	CDBrk = CON_BrkD * m_airframe.getSpeedBrakePosition();
	CDBrkCht = CON_ChtD * m_airframe.brkChutePosition();
	//CLblc = m_airframe.BLCsystem() * CLFlaps;
	
	calculateAeroRotateMoments();
	L_stab();
	M_stab();
	N_stab();
	lift();
	drag();
	sideForce();
	thrustForce(); 
	calculateShake(dt);
	calcAeroDeflection();
	calcLiftFlaps();

	pitchStabAugSystem();
	yawStabAugSystem();
	rollStabAugSystem();

	addedDrag();
	brokenFlapDrag();
	calcZeroLift();
	addedThrustCalc();

	//printf("Thrust_AND_Drag_Force_Complete %f\n", m_force.x);
	//printf("Engine_Thrust %f\n", m_engine.updateThrust());
	//printf("Added_Thrust %f\n", m_addThrust);
	//printf("Thin_Air_Multi %f\n", m_thinAirMulti);
	//printf("Pitch_Moment_Full %f\n", m_moment.z);
	//printf("Yaw_Moment_Full %f\n", m_moment.y);
	//printf("X_Force_Full %f\n", m_force.x);
	//printf("Engine_Thrust %f\n", (m_engine.updateThrust() + m_addThrust));
	//printf("AoA in Rad %f\n", m_state.m_aoa);
	//printf("CorrectedAoA in RAD %f\n", m_corrAoA);
	//printf("Beta in Rad %f\n", m_state.m_beta);
	//printf("Corrected Beta in Rad %f\n", m_corrBeta);
	//printf("Pitchup_Factor %f\n", m_pitchup);
	//printf("Stall_Multiplier %f\n", m_stallMult);
	//printf("Weight_On_Wheels %f\n", m_airframe.getWeightOnWheels());


	// printf("CD broken Flap %f \n", CD_brFlap);

	//printf("CL Total %f \n", m_force.y);

	//----------------function for Pitchup-Factor, Pitchup-force and pitchup-speed--------------------
	if (m_airframe.getWeightOnWheels() == 0.0)
	{


		if ((m_state.m_aoa >= 0.2617) && (m_airframe.getFlapsPosition() == 0.0) && (m_state.m_mach > 0.26))
		{
			m_pitchup = 1.35 * ((PitAoA(m_state.m_aoa) * PitMult(m_state.m_mach))); //war 0.65 * zu 0.95 zu 1.25 zu 1.35 
		}
		else if ((m_state.m_aoa >= 0.2617) && ((m_airframe.getFlapsPosition() > 0.0) || (m_state.m_mach <= 0.26)))
		{
			m_pitchup = 0.95 * ((PitAoA(m_state.m_aoa) * PitMult(m_state.m_mach))); // war 0.45 * zu 0.65 zu 0.95
		}
		else
		{
			m_pitchup = 0.0;
		}
		//printf("m_pitchup %f \n", m_pitchup);
		//printf("AoA %f \n", m_state.m_aoa);

		//-------------function for Stall-AoA and Stall-Speed and resulting stall-force----------------------------------------------
		if ((m_state.m_aoa >= 0.2533) && (m_airframe.getFlapsPosition() == 0.0))
		{
			m_stallMult = 1.65 * (StAoA(m_state.m_aoa) * StAoAMulti(m_state.m_mach));//von 1.75 zu 2.25 zu 1.95 zu 1.45 zu 2.01 zu 1.85 zu 2.05 zu 2.15//neuer Multiplikator 1.65
		}
		else if ((m_state.m_aoa >= 0.2533) && (m_airframe.getFlapsPosition() > 0.0)) // || (m_state.m_mach <= 0.26)))
		{
			m_stallMult = 0.95 * (StAoA(m_state.m_aoa) * StAoAMulti(m_state.m_mach)); //von 1.25 auf 1.75 auf 1.45 zu 1.15 zu 0.95 zu 0.65//neuer Multiplikator 0.95
		}
		else
		{
			m_stallMult = 0.0;
		}
		//printf("m_stallMult %f \n", m_stallMult);
	}
	else
	{
		m_pitchup = 0.0;
		m_stallMult = 0.0;

	}
	//------------------ThinAir-Multiplyer-------------------------- // NEU-NEU-NEU
	if (m_airframe.getAltInFeet() < 94000.0)
	{
		m_thinAirMulti = 1.0;
	}
	else
	{
		m_thinAirMulti = ThinAM(m_airframe.getAltInFeet());
	}

	//-------------------OverMach Drag-------------------------------
	if ((m_state.m_mach < 2.22) && (m_airframe.getEASinKnots() < 760.0))
	{
		CD_OverMach = 0.0;
	}
	else
	{
		if ((m_state.m_mach >= 2.22) && (m_airframe.getEASinKnots() < 760.0))
		{
			CD_OverMach = CDOM(m_state.m_mach);
		}
		else if ((m_state.m_mach < 2.22) && (m_airframe.getEASinKnots() >= 760.0))
		{
			CD_OverMach = CDOK(m_airframe.getEASinKnots());
		}
		else if ((m_state.m_mach >= 2.22) && (m_airframe.getEASinKnots() >= 760.0))
		{
			CD_OverMach = CDOK(m_airframe.getEASinKnots());
		}
	}


	//-------------damage-stuff--------------------------------------
	if (m_airframe.getAileronDamage() < 1.0)
	{
		m_ailDamage = m_airframe.getAileronDamage();
	}
	else
	{
		m_ailDamage = 1.0;
	}
	//im Foglenden dann noch Flap-Damage durch Overspeed einbauen!!!
	if (m_airframe.getFlapDamage() < 1.0)
	{
		m_flapDamage = m_airframe.getFlapDamage();
	}
	else
	{
		m_flapDamage = 1.0;
	}

	if (m_airframe.getLWingDamage() < 1.0)
	{
		m_lWingDamageCL = m_airframe.getLWingDamage();
		m_lWingDamageCD = (m_airframe.getLWingDamage()) / 10.0; //Roll-Links ist -, Roll-Rechts ist + 
	}
	else
	{
		m_lWingDamageCL = 1.0;
		m_lWingDamageCD = 0.1;
	}

	if (m_airframe.getRWingDamage() < 1.0)
	{
		m_rWingDamageCL = m_airframe.getRWingDamage();
		m_rWingDamageCD = (-(m_airframe.getRWingDamage())) / 10; //Roll-Links ist +, Roll-Rechts ist - ?? 
	}
	else
	{
		m_rWingDamageCL = 1.0;
		m_rWingDamageCD = -0.1;
	}

	if (m_airframe.getHoriStabDamage() < 1.0)
	{
		m_hStabDamage = m_airframe.getHoriStabDamage();
	}
	else
	{
		m_hStabDamage = 1.0;
	}

	//printf("HStabDamage %f \n", m_hStabDamage);
	/*printf("HStabIntegrity %f \n", m_airframe.getHoriStabDamage());
	printf("WingLIntegrity %f \n", m_airframe.getLWingDamage());
	printf("WingRIntegrity %f \n", m_airframe.getRWingDamage());
	printf("AileronIntegrity %f \n", m_airframe.getAileronDamage());
	printf("TurbineIntegrity %f \n", m_airframe.getTurbineDamage());
	printf("CompressorIntegrity %f \n", m_airframe.getCompressorDamage());*/
	//printf("Roll %f \n", m_input.m_roll);

	//--!!!!!---das muss hier hinten hin, damit m_force durch das update der Lift und Drag-Funktionen gefüllt ist. Sonnst ist m_force = 0.0 !!!!-------------
	
	//-------------neue Formulierung mit Anbindung über m_corrAoA und m_corrBeta anstatt m_state.m_aoa und m_state.m_beta----------------
	m_force_boddy = windAxisToBodyAxis(m_force, m_corrAoA, m_corrBeta);

	//------------Testweise damit die Lift und Drag-Forces zu den Pitch-Momenten hinzugefügt werden---------------
	//--------------Wieder auskommentiert, da es hier leider Stall/Spin kaputt macht---------------------------
	
	//addMoment(m_force_boddy, Vec3(-0.25 * CON_mac, 0.0, 0.0));//von -0.25 
	
	//---------------------------------------------------------------------------------------------------------
	//-----------Die folgende lassen wir drin, da damit Thrustforce erst nach der Rotation genau straight eingefügt wird-----------------
	addForce(Vec3(m_thrustForce, 0.0, 0.0), m_state.m_com); 
	
	//die Formel brauch 2x Vec3s addForce( z.B. m_force, m_state.m_com) weil beides Vec3s sind
	//wenn ich nur eine Variable (also eine lineare Force die nicht Vec3 ist nutzen will muss ich sie eben als (x, y, z) eintragen
	//z.B. addForce(Vec3(m_force.x, 0.0, 0.0),Vec3(-0.25, 0.0, 0.0));
	//dann wird als X-Wert die Variable m_force.x gesetzt und diese wirkt als moment 0.25m vor dem Schwerpunkt und verursacht dann ein Drehbewegung
	//addMoment ist die Formel die dann nicht die Force addiert sondern die Force in ein Moment umwandelt ohne die Forces auch noch zu addieren...
	//----------------------------------------------------------------------------------------------------------------------------------------------

	//thrustForce();//so geht es schonmal, jetzt versuch 2

	//printf("boddy_force_X %f \n", m_force_boddy.x);
	//printf("boddy_force_Y %f \n", m_force_boddy.y);
	//printf("boddy_force_Z %f \n", m_force_boddy.z);
}

void FlightModel::calculateShake(double& dt)
{


	// cockpit shake calculations
	double shakeAmplitude{ 0.0 };
	double shakeInstGear = 0.0;
	double buffetAmplitude = 0.6;
	double x{ 0.0 };

	// 20 - 28
	double aoa = toDegrees(std::abs(m_corrAoA));
	if (m_state.m_mach > 0.15)
		shakeAmplitude = clamp((aoa - 10.0) / 15.0, 0.0, 1.0);
	
	shakeAmplitude *= buffetAmplitude;

	// GEAR CONTRIBUTION

	double gearContinousShake = (m_airframe.getGearLPosition() + m_airframe.getGearRPosition() + m_airframe.getGearNPosition()) / 3.0 * 0.8;


	if (m_airframe.getGearLPosition() > 0.99 || m_airframe.getGearLPosition() < 0.01)
	{
		gearShake = true;
	}
	else if (m_airframe.getGearRPosition() > 0.99 || m_airframe.getGearLPosition() < 0.01)
	{
		gearShake = true;
	}
	else if (m_airframe.getGearNPosition() > 0.99 || m_airframe.getGearLPosition() < 0.01)
	{
		gearShake = true;
	}
	else
	{
		gearShake = false;
	}

	if (gearShake && !prevGearShake)
	{
		m_shakeDuration.startTimer();
		prevGearShake = true;
	}
	else if (!gearShake)
	{
		prevGearShake = false;
	}

	// FLAPS CONTRIBUTION
	double flapsContinousShake = m_airframe.getFlapsPosition() * 0.06;


	// SPEED BRAKES CONTRIBUTION
	double speedBrakesContinousShake = m_airframe.getSpeedBrakePosition() * 0.12;

	// AB CONTRIBUTION
	double ReHeatContinousShake = 0.0;

	if (m_engine.updateBurner() >= 0.85)
	{
		ReHeatContinousShake = m_engine.getRPMNorm() * 0.10;
	}
	else
	{
		ReHeatContinousShake = 0.0;
	}



	m_shakeDuration.updateLoop(dt);

	if (m_shakeDuration.getState())
	{
		shakeInstGear += 0.5;
	}
	//printf(gearShake ? "true" : "false");
	//printf(prevGearShake ? "true" : "false");

	double airspeedScale = clamp((1.0 / 50.0) * (m_scalarVelocity - 50.0), 0.0, 1.0);

	double shakeGroupA = airspeedScale * std::min(flapsContinousShake + gearContinousShake, 0.075);
	double shakeGroupB = airspeedScale * speedBrakesContinousShake;
	double shakeGroupC = ReHeatContinousShake;
	double shakeGroupInst = std::min(shakeInstGear, 1.5);

	//printf("shake: %lf\n", shakeAmplitude);

	m_cockpitShake = shakeAmplitude + shakeGroupA + shakeGroupB + shakeGroupC + shakeGroupInst;
	m_cockpitShake *= 1.3; //CockpitShakeMultiplier von 1.5 auf 1.3

}



