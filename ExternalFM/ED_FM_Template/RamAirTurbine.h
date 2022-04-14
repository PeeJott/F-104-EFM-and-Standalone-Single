#pragma once

#include "BaseComponent.h"
#include "Input.h"
#include "Actuators.h"
#include "State.h"

class RamAirTurbine : public BaseComponent
{
private:
	State& m_state;
	Input& m_input;

	Actuator m_ramAirTurbine;

public:
	RamAirTurbine(State& state, Input& input);

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	void update(double dt);

	bool IsRamAirTurbineExteneded();
};