#include "PID.h"

void PID::zeroInit()
{
	p_Kp = 0.0; //Present -> Proportional
	p_Ki = 0.0; //Past -> Integral
	p_Kd = 0.0; //Future -> Derivative

	//Derivative Filter Variable for time constant
	p_TAU = 0.0;

	//Output Limits
	p_limMin = 0.0;
	p_limMax = 0.0;

	//Sample Time
	p_time = 0.0;

	//Controler Memory of step and last step
	p_integrator = 0.0;
	p_error = 0.0;
	p_prevError = 0.0;
	p_prevMeasurement = 0.0;
	p_differentiator = 0.0;
	p_proportional = 0.0;

	//Controller Output
	p_output = 0.0;

	//----------ALT PID Controller Variables init
	p_ALT_Kp = 0.0; //Present -> Proportional
	p_ALT_Ki = 0.0; //Past -> Integral
	p_ALT_Kd = 0.0; //Future -> Derivative
	
	p_ALT_TAU = 0.0;
	
	p_ALT_limMin = 0.0;
	p_ALT_limMax = 0.0;

	p_ALT_time = 0.0;
	
	p_ALT_integrator = 0.0;
	p_ALT_error = 0.0;
	p_ALT_prevError = 0.0;
	p_ALT_prevMeasurement = 0.0;
	p_ALT_differentiator = 0.0;
	p_ALT_proportional = 0.0;

	p_ALT_output = 0.0;
}

void PID::coldInit()
{
	zeroInit();
}

void PID::hotInit()
{
	zeroInit();
}

void PID::airborneInit()
{
	zeroInit();
}


double PID::attitudePIDControl(double setpoint, double measurement)
{
	//double Target = 0.0;
	//double Start = 0.0;
	double limMinInt = 0.0;
	double limMaxInt = 0.0;

	
	double Target = setpoint;
	double Start = measurement;
	
	//computing the error signal
	p_error = Target - Start;

	//proportional part -> Present
	p_proportional = p_Kp * p_error;

	//integral part -> past
	p_integrator = p_integrator + 0.5 * p_Ki * p_time * (p_error + p_prevError);

	//Dampening for integral part
	
	if (p_limMax > p_proportional)
	{
		limMaxInt = p_limMax - p_proportional;
	}
	else
	{
		limMaxInt = 0.0;
	}

	if (p_limMin < p_proportional)
	{
		limMinInt = p_limMin - p_proportional;
	}
	else
	{
		limMinInt = 0.0;
	}

	//Clamp the integrator
	if (p_integrator > limMaxInt)
	{
		p_integrator = limMaxInt;
	}
	else if (p_integrator < limMinInt)
	{
		p_integrator = limMinInt;
	}

	//Derivative -> future (band-limited differentiator)
	p_differentiator = (2.0 * p_Kd * (Start - p_prevMeasurement) + (2.0 * p_TAU - p_time) * p_differentiator) / (2.0 * p_TAU + p_time);

	//compute output and enjoy
	p_output = p_proportional + p_integrator + p_differentiator;

	//limitation on controller output
	if (p_output > p_limMax)
	{
		p_output = p_limMax;
	}
	else if (p_output < p_limMin)
	{
		p_output = p_limMin;
	}
	//store error and measurement for next frame
	p_prevError = p_error;
	p_prevMeasurement = Start;

	// return what should happen
	return p_output;

}

double PID::altitudePIDControl(double setpoint, double measurement)
{
	double limMinInt = 0.0;
	double limMaxInt = 0.0;


	double Target = setpoint;
	double Start = measurement;

	//computing the error signal
	p_ALT_error = Target - Start;

	//proportional part -> Present
	p_ALT_proportional = p_ALT_Kp * p_ALT_error;

	//integral part -> past
	p_ALT_integrator = p_ALT_integrator + 0.5 * p_ALT_Ki * p_ALT_time * (p_ALT_error + p_ALT_prevError);

	//Dampening for integral part

	if (p_ALT_limMax > p_ALT_proportional)
	{
		limMaxInt = p_ALT_limMax - p_ALT_proportional;
	}
	else
	{
		limMaxInt = 0.0;
	}

	if (p_ALT_limMin < p_ALT_proportional)
	{
		limMinInt = p_ALT_limMin - p_ALT_proportional;
	}
	else
	{
		limMinInt = 0.0;
	}

	//Clamp the integrator
	if (p_ALT_integrator > limMaxInt)
	{
		p_ALT_integrator = limMaxInt;
	}
	else if (p_ALT_integrator < limMinInt)
	{
		p_ALT_integrator = limMinInt;
	}

	//Derivative -> future (band-limited differentiator)
	p_ALT_differentiator = (2.0 * p_ALT_Kd * (Start - p_ALT_prevMeasurement) + (2.0 * p_ALT_TAU - p_ALT_time) * p_ALT_differentiator) / (2.0 * p_ALT_TAU + p_ALT_time);

	//compute output and enjoy
	p_ALT_output = p_ALT_proportional + p_ALT_integrator + p_ALT_differentiator;

	//limitation on controller output
	if (p_ALT_output > p_ALT_limMax)
	{
		p_ALT_output = p_ALT_limMax;
	}
	else if (p_ALT_output < p_ALT_limMin)
	{
		p_ALT_output = p_ALT_limMin;
	}
	//store error and measurement for next frame
	p_ALT_prevError = p_ALT_error;
	p_ALT_prevMeasurement = Start;

	// return what should happen
	return p_ALT_output;
}
