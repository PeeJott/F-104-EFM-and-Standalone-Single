#pragma once

#include "BaseComponent.h"
#include "Input.h"
#include "Engine.h"
#include "Airframe.h"
#include "ElectricSystemAPI.h"
#include "State.h"
#include "RamAirTurbine.h"
#include "Actuators.h"


class ElectricSystem : public BaseComponent
{	
private:	
	ElectricSystemAPI& m_electricSystemAPI;
	State& m_state;
	Input& m_input;
	Engine& m_engine;
	Airframe& m_airframe; 
	RamAirTurbine& m_ramAirTurbine;
	

	Actuator m_no1generator;
	Actuator m_no2generator;
	Actuator m_hydraulicDrivenGenerator; 
	Actuator m_groundPower;
	
public:
	ElectricSystem(ElectricSystemAPI& electricSystemAPI, State& state, Input& input, Engine& engine, Airframe& airframe, RamAirTurbine& ramAirTurbine);

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	void update(double dt);	

	bool HasGroundPower();
	bool IsNo1GeneratorNormal();
	bool IsNo2GeneratorNormal();
	bool IsHydraulicDrivenGeneratorNormal();
	bool IsEmergencyGeneratorNormal();
};
