local dev = GetSelf()

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
--dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

local update_time_step = 0.05
make_default_activity(update_time_step)--update will be called 20 times per second

local sensor_data = get_base_data()

local rad_to_deg = 57.2958
local deg_to_rad = 0.0174533
local meters_to_feet = 3.2808399
local mgH_to_pa = 3386.39
local MpS_to_knt = 1.94384


--------------------------------------------------------------------------------------
----------------jetzt geht es in die Avionik------------------------------------------

-----------------Params der Instrumente aus Mainpanel.init zu localen Variablen-------

local AOA_Meter_Param 		= get_param_handle("AOA_INDICATOR")
local G_Meter_Param 		= get_param_handle("G_METER")
local RadAltHunHand_Param 	= get_param_handle("RAD_ALT_HUN_HAND")
local RadAltKHand_Param		= get_param_handle("RAD_ALT_K_HAND")
local RPMPercHand_Param		= get_param_handle("RPM_PERCENT_HAND")
local TempInCHand_Param		= get_param_handle("TEMP_IN_C_HAND")
local HSIKompassDial_Param	= get_param_handle("HSI_DIAL")


-----------------locale variablen für die Instrumente Initialisierung------------------

local Actual_AoA 	= 0 --Initialisierung auf NULL
local Actual_G 		= 0
local RadAltInFeet = 0
local RadAltHun 	= 0
local RadAltK 		= 0
local EngineRPM		= 0
local TempInCelsius = 0
local HSI_Heading 	= 0



------comamnd table function falls noch commands benötigt werden-----------------------
command_table = {
  
}
------------------------Running functions start----------------------------------------
function post_initialize()

	local dev=GetSelf()	

end

function SetCommand(command,value)	
	
	if command_table[command] then
        command_table[command](value)
    end
end

function update()

--AoA-Meter--
Actual_AoA = sensor_data:getAngleOfAttack() * rad_to_deg
AOA_Meter_Param:set(Actual_AoA)
--print_message_to_user("AoA Wert " ..tostring(Actual_AoA))

----G-Meter-------------------------------------------------
Actual_G = sensor_data:getVerticalAcceleration()
G_Meter_Param:set(Actual_G)

-----Radar Altimeter----------------------------------------
RadAltInFeet = sensor_data:getRadarAltitude() * meters_to_feet
--HundredFeetHand--
	if (RadAltInFeet <= 1000.0) then
		RadAltHun = RadAltInFeet
		
	elseif ((RadAltInFeet > 1000.0) and (RadAltInFeet < 10000.0)) then
		RadAltHun = RadAltInFeet % 1000.0
		
	else
		RadAltHun = (RadAltInFeet % 10000.0) % 1000.0 
		
	end 

RadAltHunHand_Param:set(RadAltHun)
--
--ThousandFeetHand--
RadAltKHand_Param:set(RadAltInFeet)

-----RPM Gauge------
EngineRPM = sensor_data:getEngineLeftRPM()
RPMPercHand_Param:set(EngineRPM)
--print_message_to_user("Engine RPM" ..tostring(EngineRPM))

-----Temp-Gauge------
TempInCelsius = sensor_data:getEngineLeftTemperatureBeforeTurbine()
--print_message_to_user("Engine Temperature " ..tostring(TempInCelsius))
TempInCHand_Param:set(TempInCelsius)

----HSI Dial--------
HSI_Heading 	= sensor_data:getHeading()
HSIKompassDial_Param:set(HSI_Heading)
	
end

need_to_be_closed = false

--possible sensor_data 
--called through e.g.: sensor_data.getEngineRPM()
--and cast to a variable like this: GET_ENGINE_RPM = sensor_data.getEngineRPM()
--[[
getAngleOfAttack()
getAngleOfSlide()
getBarometricAltitude()
getCanopyPos()
getCanopyState()
getEngineLeftFuelConsumption()
getEngineLeftRPM()
getEngineLeftTemperatureBeforeTurbine()
getEngineRightFuelConsumption()
getEngineRightRPM()
getEngineRightTemperatureBeforeTurbine()
getFlapsPos()
getFlapsRetracted()
getHeading()
getHorizontalAcceleration()
getIndicatedAirSpeed()
getLandingGearHandlePos()
getLateralAcceleration()
getLeftMainLandingGearDown()
getLeftMainLandingGearUp()
getMachNumber()
getMagneticHeading()
getNoseLandingGearDown()
getNoseLandingGearUp()
getPitch()
getRadarAltitude()
getRateOfPitch()
getRateOfRoll()
getRateOfYaw()
getRightMainLandingGearDown()
getRightMainLandingGearUp()
getRoll()
getRudderPosition()
getSpeedBrakePos()
getSelfAirspeed()
getSelfCoordinates()
getSelfVelocity()
getStickPitchPosition()
getStickRollPosition()
getThrottleLeftPosition()
getThrottleRightPosition()
getTotalFuelWeight()
getTrueAirSpeed()
getVerticalAcceleration()
getVerticalVelocity()
getWOW_LeftMainLandingGear()
getWOW_NoseLandingGear()
getWOW_RightMainLandingGear()
--]]