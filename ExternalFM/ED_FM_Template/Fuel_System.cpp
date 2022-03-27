#include "Fuel_System.h"

//=========================================================================//
//
//		FILE NAME	: FuelSystem.cpp
//		AUTHOR		: Joshua Nelson & Paul Stich
//		Copyright	: Joshua Nelson & Paul Stich
//		DATE		: August 2021
//
//		DESCRIPTION	: Simulation of the Fuelsystem. 
//					  
//					  
//================================ Includes ===============================//
//=========================================================================//


Fuelsystem::Fuelsystem
(
	State& state,
	Input& input,
	Engine& engine

) :
	m_state(state),
	m_input(input),
	m_engine(engine)


	//jetzt Tables wenn nötig
	//und: DER LETZTE EINTRAG DARF KEIN KOMMA HABEN!!!

{
	//Sülz und Bla....
}

void Fuelsystem::zeroInit()
{
	m_adjExtFuelQty = 0.0;
	m_adjIntFuelQty = 0.0;
	m_lowFuel = 0.0;
	m_bingoFuel = 0.0;

}

void Fuelsystem::coldInit()
{
	zeroInit();
}

void Fuelsystem::hotInit()
{
	zeroInit();
}

void Fuelsystem::airborneInit()
{
	zeroInit();
}

void Fuelsystem::drawFuel(double dm)
{

}

void Fuelsystem::addFuel(double dm)
{
	//If adding fuel add it to the internal tank.
	if (dm > 0.0 )
		dm = addFuelToTank(INTERNAL, dm);

	//If removing fuel remove it from the internal tank.
	if (dm < 0.0)
		dm = addFuelToTank(INTERNAL, dm);
}

void Fuelsystem::update(double dt)
{
	//The factor from the engine for transfer since all transfer relies on bleed,
	//either directly to pressurise the tank or to spin a turbopump.
	double rateFactor = CON_fexch;

	double dm = (m_engine.FuelFlowUpdate() * 0.454 * 0.00028) * dt; //FuelFlowUpdate ist in lbs/h, hier aber kg/s gebraucht

	double enginePower = m_engine.getRPMNorm() > 0.40;

	//Draw from the Fuselage Tank to the engine, minimum usable fuel.
	if (m_fuel[INTERNAL] > 15.0)
	{
		if (dm > 0.0)
			m_fuel[INTERNAL] -= dm;

		m_hasFuel = true;
	}
	else
	{
		m_hasFuel = false;
	}

	m_engine.setHasFuel(m_hasFuel);

	double wingTransferRate = CON_fexch;
	wingTransferRate *= dt;


	double externTipRRate = rateFactor * dt;
	double externWingRRate = rateFactor * dt;
	double externWingLRate = rateFactor * dt;
	double externTipLRate = rateFactor * dt;

	double transferAmount = 0.0;
	transferAmount += m_fuelCapacity[LEFT_TIP] > 15.0 ? externTipLRate : 0.0;
	transferAmount += m_fuelCapacity[LEFT_WING] > 15.0 ? externWingLRate : 0.0;
	transferAmount += m_fuelCapacity[RIGHT_WING] > 15.0 ? externWingRRate : 0.0;
	transferAmount += m_fuelCapacity[RIGHT_TIP] > 15.0 ? externTipRRate : 0.0;

		if (transferAmount <= m_fuelCapacity[INTERNAL] - m_fuel[INTERNAL])
		{
			transferFuel(LEFT_TIP, INTERNAL, externTipLRate);
			transferFuel(LEFT_WING, INTERNAL, externWingLRate);
			transferFuel(RIGHT_WING, INTERNAL, externWingRRate);
			transferFuel(RIGHT_TIP, INTERNAL, externTipRRate);
		}
		else
		{
			//No Transfer here...just wait for the next frame...
		}
}



	