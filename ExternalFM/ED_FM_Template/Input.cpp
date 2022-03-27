#include "input.h"

//=========================================================================//
//
//		FILE NAME	: Input.cpp
//		AUTHOR		: Paul Stich
//		Copyright	: Paul Stich
//		DATE		: August 2021
//
//		DESCRIPTION	: Reset and update functions for Key-Flightcontrol-Inputs  
//					  and Brake-Inputs.
//					  
//================================ Includes ===============================//
//=========================================================================//

Input::Input()
{

}

void Input::inputUpdate(double dt)
{
	setKeyPitch();
	setKeyRoll();
	setKeyYaw();
	setBrake();

	resetCrossHairs();

	ThrottleKeysValue();
	throttleUpGO();
	throttleDownGO();
	throttleSTOP();

	throttleDecision();

	qnhDOWN();
	qnhUP();
	qnhSTOP();
	qnhValue();


}

void Input::setKeyPitch()
{
	if ((m_elev_up_go > 0.0) || (m_elev_down_go > 0.0))
	{
		if (m_elev_up_go == 1.0)
		{
			if (m_elev_up_stop == 1.0)
			{
				m_elev_up_go = 0.0;
				m_elev_up_stop = 0.0;
				//m_pitch = 0.0; alte Variante
				//m_pitch = (m_elevUP / 400.0);
				//m_pitch = ((-m_elevDOWN / 400) + (m_elevUP / 400));
			}
		}
		if (m_elev_up_go == 1.0)
		{
			m_elevUP++;
			//m_pitch = (m_elevUP / 400.0);
			//m_elevDOWN = 0.0;
			//m_pitch = ((-m_elevDOWN / 400) + (m_elevUP / 400));
		}
		/*else
		{
			m_elevUP = 0.0;
		}*/

		if (m_elev_down_go == 1.0)
		{
			if (m_elev_down_stop == 1.0)
			{
				m_elev_down_go = 0.0;
				m_elev_down_stop = 0.0;
				//m_pitch = 0.0; alte Variante
				//m_pitch = (-m_elevDOWN / 400);
				//m_pitch = ((-m_elevDOWN / 400) + (m_elevUP / 400));
			}
		}

		if (m_elev_down_go == 1.0)
		{
			m_elevDOWN++;
			//m_pitch = (-m_elevDOWN / 400); alte variante
			//m_pitch = ((-m_elevDOWN / 400) + (m_elevUP / 400));
			//m_elevUP = 0.0;
		}
		/*else
		{
			m_elevDOWN = 0.0;
		}*/

		m_pitch = ((-m_elevDOWN / 400) + (m_elevUP / 400));

	}

	if (m_elevDOWN == m_elevUP)
	{
		m_elevDOWN = 0.0;
		m_elevUP = 0.0;
	}
}

void Input::setKeyRoll()
{
	if (m_ail_right_go == 1.0)
	{
		if (m_ail_right_stop == 1.0)
		{
			m_ail_right_go = 0.0;
			m_ail_right_stop = 0.0;
			m_roll = 0.0;
		}
	}

	if (m_ail_right_go == 1.0)
	{
		m_ailRIGHT++;
		m_roll = (m_ailRIGHT / 200.0);
		m_ailLEFT = 0.0;
	}
	else
	{
		m_ailRIGHT = 0.0;
	}

	if (m_ail_left_go == 1.0)
	{
		if (m_ail_left_stop == 1.0)
		{
			m_ail_left_go = 0.0;
			m_ail_left_stop = 0.0;
			m_roll = 0.0;
		}
	}

	if (m_ail_left_go == 1.0)
	{
		m_ailLEFT++;
		m_roll = (-m_ailLEFT / 200.0);
		m_ailRIGHT = 0.0;
	}
	else
	{
		m_ailLEFT = 0.0;
	}
}

void Input::setKeyYaw()
{
	if (m_rudder_right_go == 1.0)
	{
		if (m_rudder_right_stop == 1.0)
		{
			m_rudder_right_go = 0.0;
			m_rudder_right_stop = 0.0;
			m_yaw = 0.0;
		}
	}


	if (m_rudder_right_go == 1.0)
	{
		m_rudRIGHT++;
		m_yaw = (m_rudRIGHT / 200.0);
		m_rudLEFT = 0.0;
	}
	else
	{
		m_rudRIGHT = 0.0;
	}

	if (m_rudder_left_go == 1.0)
	{
		if (m_rudder_left_stop == 1.0)
		{
			m_rudder_left_go = 0.0;
			m_rudder_left_stop = 0.0;
			m_yaw = 0.0;
		}
	}

	if (m_rudder_left_go == 1.0)
	{
		m_rudLEFT++;
		m_yaw = (-m_rudLEFT / 200.0);
		m_rudRIGHT = 0.0;
	}
	else
	{
		m_rudLEFT = 0.0;
	}
}

void Input::setBrake()
{
	if (m_release_brake == 1.0)
	{
		if (m_brake == 1.0)
		{
			m_brake = 0.0;
			m_release_brake = 0.0;
		}
	}
}

void Input::resetCrossHairs()
{
	if ((m_crossHRight > 0.0) && (m_crossHLeft < 0.0))
	{
		m_crossHRight = 0.0;
		m_crossHLeft = 0.0;
	}

	if ((m_crossHUp > 0.0) && (m_crossHDown < 0.0))
	{
		m_crossHUp = 0.0;
		m_crossHDown = 0.0;
	}


}

void const Input::throttleUpGO()
{
	if (m_throttleUP == 0.0)
	{
		m_throttleUP = 1.0;
	
	}
	if (m_throttleUP == 1.0)
	{
		m_throttlePLUS += 0.05;
	}
}

void const Input::throttleDownGO()
{
	if (m_throttleDOWN == 0.0)
	{
		m_throttleDOWN = 1.0;
	}
	if (m_throttleDOWN == 1.0)
	{
		m_throttleMINUS += 0.05;
	}
}

void const Input::throttleSTOP()
{
	if (m_throttleSTOP == 0.0)
	{
		m_throttleSTOP = 1.0;
		m_throttleDOWN = 0.0;
		m_throttleUP = 0.0;
	}
	if (m_throttleSTOP == 1.0)
	{
		m_throttleSTOP = 0.0;
	}
}

void const Input::ThrottleKeysValue()
{
	if (m_throttleKeysValue >= -1.0)
	{
		m_throttleKeysValue = m_throttlePLUS - m_throttleMINUS;
	}
	else
	{
		m_throttleKeysValue = -1.0;
	}

	m_deltaKeysThrottle = m_throttlePLUS - m_throttleMINUS;

	if (m_deltaKeysThrottle > 1.0)
	{
		m_throttlePLUS = 2.0;
		m_throttleMINUS = 1.0;
	}
	else if (m_deltaKeysThrottle < -1.0)
	{
		m_throttlePLUS = 1.0;
		m_throttleMINUS = 2.0;
	}


}

void const Input::throttleDecision()
{
	if ((m_throttle == -1.0) && (m_throttleKeysValue > -1.0))
	{
		m_finalThrottle = m_throttleKeysValue;
	}
	else if (m_throttle > -1.0)
	{
		m_finalThrottle = m_throttle;
	}
}

void const Input::qnhUP()
{
	if (m_qnhUP == 0.0)
	{
		m_qnhUP = 1.0;
	}
	else if (m_qnhUP == 1.0)
	{
		m_qnhPlus += 15.0;
	}
}

void const Input::qnhDOWN()
{
	if (m_qnhDOWN == 0.0)
	{
		m_qnhDOWN = 1.0;
	}
	else if (m_qnhDOWN == 1.0)
	{
		m_qnhMinus += 15.0;
	}
}

void const Input::qnhSTOP()
{
	if (m_qnhSTOP == 0.0)
	{
		m_qnhSTOP = 1.0;
		m_qnhUP = 0.0;
		m_qnhDOWN = 0.0;
	}
	else if (m_qnhSTOP == 1.0)
	{
		m_qnhSTOP = 0.0;
	}
}

void const Input::qnhValue()
{
	if ((m_retQNH >= 95000.0) && (m_retQNH <= 105000.0))
	{
		m_retQNH = 101320.0 + (m_qnhPlus - m_qnhMinus); //zum testen statt 101325.0
	}
	else if (m_retQNH < 95000.0)
	{
		m_retQNH = 95000.0;
		m_qnhPlus = 0.0;
		m_qnhMinus = 6325.0;
	}
	else if (m_retQNH > 105000.0)
	{
		m_retQNH = 105000.0;
		m_qnhPlus = 3675.0;
		m_qnhMinus = 0.0;
	}
}