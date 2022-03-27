#pragma once
#include "Maths.h"
#include "AeroData_1.h"
#include "State.h"
#include "Input.h"
#include "Vec3.h"
#include "Engine.h"

//=========================================================================//
//
//		FILE NAME	: FuelSystem.h
//		AUTHOR		: Joshua Nelson & Paul Stich
//		Copyright	: Joshua Nelson & Paul Stich
//		DATE		: August 2021
//
//		DESCRIPTION	: Simulation of the Fuelsystem + Indicators and Warnings. 
//					  
//					  
//================================ Includes ===============================//
//=========================================================================//


class Fuelsystem
{
public:
	Fuelsystem(State& state, Input& input, Engine& engine);

	virtual void zeroInit();
	virtual void coldInit();
	virtual void hotInit();
	virtual void airborneInit();

	//---------funktionierte gut mit den 5----------
	/*enum Tank
	{
		INTERNAL,
		LEFT_TIP,
		LEFT_WING,
		RIGHT_WING,
		RIGHT_TIP,
		NUMBER_OF_TANKS,
		UNUSED,
	};*/
	//-------neuer scheiﬂ mit 11ven-----------------
	//-------ge‰ndert auf 5 Tanks + NumberOfTanks + Unused aufgrund StationToTank-----------------
	enum Tank
	{
		INTERNAL,
		LEFT_TIP,
		LEFT_WING,
		RIGHT_WING,
		RIGHT_TIP,
		NUMBER_OF_TANKS,
		UNUSED
	};


	void addFuel(double dm);
	void drawFuel(double dm);
	void update(double dt);

	inline bool hasFuel() const;

	inline double transferFuel(Tank from, Tank to, double dm);
	inline double addFuelToTank(Tank tank, double dm, double min = 0.0);
	//inline double transferRateFactor();//brauchen wir nicht, da der fest ist
	inline bool externalFull() const;

	inline double getFuelQty(Tank tank) const;
	inline double getFuelQtyExternal() const;
	inline double getFuelQtyExternalLeft() const;
	inline double getFuelQtyExternalRight() const;
	inline double getFuelQtyExternalTip() const;
	inline double getFuelQtyExternalWing() const;
	inline double getFuelQtyInternal() const;
	inline double getFuelQtyTotal() const;
	inline double getAdjFuelQtyExternal();
	inline double getAdjFuelQtyInternal();
	inline double lowFuelWarning();
	inline double bingoFuelWarning();
	inline double getFuelQtyDelta(Tank tank) const;
	inline const Vec3& getFuelPos(Tank tank) const;
	inline Tank getSelectedTank() const;

	inline Tank stationToTank(int station) //StationToTank funktion im Public-Bereich gelassen								      
	{									  
		return m_stationToTank[station];
	}

	inline double getTotalCapacity() const;
	
	
	inline void setFuelQty(Tank tank, const Vec3& position, double value);
	inline void setInternal(double value);
	inline void setFuelCapacity(double lt, double lw, double rw, double rt);
	inline void setFuelPrevious(Tank tank);
	inline void setSelectedTank(Tank tank);

private:

	Vec3 m_force;
	State& m_state;
	Input& m_input;
	Engine& m_engine;
	
	//11 Stations mit einer Nummerzuordnung zu den tats‰chlichen Tanks
	Tank m_stationToTank[11] =
	{
		UNUSED,
		LEFT_TIP,
		UNUSED,
		LEFT_WING,
		UNUSED,
		UNUSED,
		UNUSED,
		RIGHT_WING,
		UNUSED,
		RIGHT_TIP,
		UNUSED,
	};

	double m_fuel[NUMBER_OF_TANKS] = { 0.0, 0.0, 0.0, 0.0, 0.0 }; //vorher waren es 5

	double m_fuelPrevious[NUMBER_OF_TANKS] = { 0.0, 0.0, 0.0, 0.0, 0.0 };

	bool m_fuelEmpty[NUMBER_OF_TANKS] = { false, false, false, false, false};

	bool m_fuelSet[NUMBER_OF_TANKS] = { false, false, false, false, false}; //Check, if tank is empty or full

	//										 INTERNAL   TIP_L   WING_L  WING_R  TIP_R 
	double m_fuelCapacity[NUMBER_OF_TANKS] = { 2641.0, 500.0, 500.0, 500.0, 500.0 }; //values from F104g.lua. in kG

	Vec3 m_fuelPos[NUMBER_OF_TANKS] = { Vec3(), Vec3(), Vec3(), Vec3(), Vec3() };

	bool m_hasFuel = true; //this is false if the fuel cannot be delivered or all fuel is burned.

	Tank m_selectedTank = INTERNAL;

	double m_lowFuel = 0.0;
	double m_bingoFuel = 0.0;

	float m_adjExtFuelQty = 0.0;
	double m_adjIntFuelQty = 0.0;
};

void Fuelsystem::setFuelQty(Tank tank, const Vec3& position, double value)
{
	m_fuelSet[tank] = true; //To check if there is an external tank, if yes = true
	m_fuel[tank] = value;
	m_fuelPos[tank] = position;
	//m_stationToTank[tank] = tank; //das ist neu, ggf. einfach wieder weg
}

void Fuelsystem::setFuelPrevious(Tank tank)
{
	m_fuelPrevious[tank] = m_fuel[tank];
}

void Fuelsystem::setInternal(double value)
{
	m_fuel[INTERNAL] = value;
	
	m_fuelPos[INTERNAL] = Vec3();
}

void Fuelsystem::setFuelCapacity(double lt, double lw, double rw, double rt)
{
	m_fuelEmpty[LEFT_TIP] = lt < 0.0;
	m_fuelEmpty[LEFT_WING] = lw < 0.0;
	m_fuelEmpty[RIGHT_WING] = rw < 0.0;
	m_fuelEmpty[RIGHT_TIP] = rt < 0.0;

	// Check each of the external tanks for negative fuel capacity.
	// This means it is an empty tank.
	// Empty tanks need to have their fuel removed. They don't start empty so DCS
	// knows how much fuel the aircraft should have when fully fueled (taking fuel from tanker).
	// If the fuel has just been set then we need to jump into action to remove the fuel from the
	// tank if it is an empty tank. We then need to make sure this doesn't happen again so set the fuelSet
	// to false for this specific tank.
	if (m_fuelSet[LEFT_TIP] && lt < 0.0)
	{
		m_fuel[LEFT_TIP] = 0.0;
		m_fuelSet[LEFT_TIP] = false;
	}

	if (m_fuelSet[LEFT_WING] && lw < 0.0)
	{
		m_fuel[LEFT_WING] = 0.0;
		m_fuelSet[LEFT_WING] = false;
	}

	if (m_fuelSet[RIGHT_WING] && rw < 0.0)
	{
		m_fuel[RIGHT_WING] = 0.0;
		m_fuelSet[RIGHT_WING] = false;
	}
	
	if (m_fuelSet[RIGHT_TIP] && rt < 0.0)
	{
		m_fuel[RIGHT_TIP] = 0.0;
		m_fuelSet[RIGHT_TIP] = false;
	}

	m_fuelCapacity[LEFT_TIP] = abs(lt);
	m_fuelCapacity[LEFT_WING] = abs(lw);
	m_fuelCapacity[RIGHT_WING] = abs(rw);
	m_fuelCapacity[RIGHT_TIP] = abs(rt);
}


void Fuelsystem::setSelectedTank(Tank tank)
{
	m_selectedTank = tank;
}

double Fuelsystem::getFuelQtyDelta(Tank tank) const
{
	return m_fuel[tank] - m_fuelPrevious[tank];
}

double Fuelsystem::getFuelQty(Tank tank) const
{
	return m_fuel[tank];
}

double Fuelsystem::getFuelQtyExternal() const
{
	return m_fuel[LEFT_TIP] + m_fuel[LEFT_WING] + m_fuel[RIGHT_WING] + m_fuel[RIGHT_TIP];
}

double Fuelsystem::getAdjFuelQtyExternal()
{
	m_adjExtFuelQty = getFuelQtyExternal() * 0.0005;

	
	/*printf("ExternalFuel %f \n", m_adjExtFuelQty);
	printf("EF_Wing-L %f \n", m_fuel[LEFT_WING]);
	printf("EF_Wing-R %f \n", m_fuel[RIGHT_WING]);
	printf("EF_TIP-L %f \n", m_fuel[LEFT_TIP]);
	printf("EF_TIP-R %f \n", m_fuel[RIGHT_TIP]);*/


	return m_adjExtFuelQty;
}


double Fuelsystem::getFuelQtyExternalLeft() const
{
	return m_fuel[LEFT_TIP] + m_fuel[LEFT_WING];
}

double Fuelsystem::getFuelQtyExternalRight() const
{
	return m_fuel[RIGHT_WING] + m_fuel[RIGHT_TIP];
}

double Fuelsystem::getFuelQtyExternalTip() const
{
	return m_fuel[RIGHT_TIP] + m_fuel[LEFT_TIP];
}

double Fuelsystem::getFuelQtyExternalWing() const
{
	return m_fuel[RIGHT_WING] + m_fuel[LEFT_WING];
}

double Fuelsystem::getFuelQtyTotal() const
{
	return m_fuel[RIGHT_WING] + m_fuel[RIGHT_TIP] + m_fuel[LEFT_WING] + m_fuel[LEFT_TIP] + m_fuel[INTERNAL];
}

double Fuelsystem::getFuelQtyInternal() const
{
	return m_fuel[INTERNAL];
}

double Fuelsystem::getAdjFuelQtyInternal()
{
	m_adjIntFuelQty = getFuelQtyInternal() * 0.0002205;

	return m_adjIntFuelQty;
}

const Vec3& Fuelsystem::getFuelPos(Tank tank) const
{
	return m_fuelPos[tank];
}

Fuelsystem::Tank Fuelsystem::getSelectedTank() const
{
	return m_selectedTank;
}

/*Fuelsystem::Tank Fuelsystem::stationToTank(int station)
{
	return m_stationToTank[station];
}*/

double Fuelsystem::getTotalCapacity() const
{
	double total = 0.0;
	for (int i = 0; i < NUMBER_OF_TANKS; i++)
	{
		total += m_fuelCapacity[i];
	}

	total += 1.0;

	return total;
}

bool Fuelsystem::hasFuel() const
{
	return m_hasFuel;
}

bool Fuelsystem::externalFull() const
{
	return m_fuel[LEFT_TIP] == m_fuelCapacity[LEFT_TIP] &&
		m_fuel[LEFT_WING] == m_fuelCapacity[LEFT_WING] &&
		m_fuel[RIGHT_WING] == m_fuelCapacity[RIGHT_WING] &&
		m_fuel[RIGHT_TIP] == m_fuelCapacity[RIGHT_TIP];
}

double Fuelsystem::transferFuel(Tank from, Tank to, double dm)
{
	double desiredTransfer = dm;

	//15 kg minimum usable should be tank specific but it's not that different.
	double remainingFrom = m_fuel[from] - 15.0;
	//Check there is enough fuel to take.
	if (remainingFrom < dm)
		dm = std::max(remainingFrom, 0.0);

	//Check there is enough room in the to tank.
	double spaceInTo = m_fuelCapacity[to] - m_fuel[to];
	if (spaceInTo < dm)
		dm = std::max(spaceInTo, 0.0);

	//Actually transfer the fuel
	m_fuel[from] -= dm;
	m_fuel[to] += dm;

	return desiredTransfer - dm;
}

double Fuelsystem::addFuelToTank(Tank tank, double dm, double min)
{
	double desiredTransfer = dm;

	double remainingFuel = m_fuel[tank] - min;
	double remainingSpace = m_fuelCapacity[tank] - m_fuel[tank];

	if (dm < 0.0 && remainingFuel + dm < 0.0)
		dm = std::min(-remainingFuel, 0.0);

	if (dm > 0.0 && remainingSpace < dm)
		dm = std::max(remainingSpace, 0.0);

	m_fuel[tank] += dm;

	return desiredTransfer - dm;
}

double Fuelsystem::lowFuelWarning()
{
	if (m_input.getElectricSystem() == 1.0)
	{
		if (getFuelQtyTotal() <= 454.0)
		{
			m_lowFuel = 1.0;
		}
		else
		{
			m_lowFuel = 0.0;
		}
	}
	else
	{
		m_lowFuel = 0.0;
	}

	return m_lowFuel;
}

double Fuelsystem::bingoFuelWarning()
{
	if (m_input.getElectricSystem() == 1.0)
	{

		if (getFuelQtyTotal() <= 908.0)
		{
			m_bingoFuel = 1.0;
		}
		else
		{
			m_bingoFuel = 0.0;
		}
	}
	else
	{
		m_bingoFuel = 0.0;
	}

	return m_bingoFuel;
}
