#include "RamAirTurbine.h"

RamAirTurbine::RamAirTurbine(State& state, Input& input) : 
	m_state(state),
	m_input(input)
{

}

void RamAirTurbine::zeroInit()
{
	m_ramAirTurbine.groundInit(0.0, 0.0);
}

void RamAirTurbine::coldInit()
{
	m_ramAirTurbine.groundInit(0.0, 0.0);
}

void RamAirTurbine::hotInit()
{
	m_ramAirTurbine.groundInit(0.0, 0.0);
}

void RamAirTurbine::airborneInit()
{
	m_ramAirTurbine.groundInit(0.0, 0.0);
}

void RamAirTurbine::update(double dt)
{
	// Note: Ram Air Turbine can't be retracted.
	// TODO: Consider to require a rotation of the handle before it can be pulled.
	if (m_input.getRamAirTurbineExtensionHandle() == 1.0) // Pulled
	{
		m_ramAirTurbine.inputUpdate(1.0, dt);
	}
	else
	{
		m_ramAirTurbine.physicsUpdate(dt);
	}
}

bool RamAirTurbine::IsRamAirTurbineExteneded()
{
	if (m_ramAirTurbine.getPosition() == 1.0)
	{
		return true;
	}
	else
	{
		return false;
	}
}