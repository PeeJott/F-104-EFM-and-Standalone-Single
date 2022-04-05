dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "Systems/weapon_system.lua")



dev = GetSelf()
local update_time_step = 0.001 --update will be called 1000 times per second
make_default_activity(update_time_step)
local sensor_data = get_base_data()


--Hier kommen spätere funktionen für die Übertragung oder Generierung der Werte für den Gunpipper rein

dev:listen_command(Keys.GunPipper_Up)
dev:listen_command(Keys.GunPipper_Down)
dev:listen_command(Keys.GunPipper_Right)
dev:listen_command(Keys.GunPipper_Left)
dev:listen_command(Keys.GunPipper_Center)
dev:listen_command(Keys.GunPipper_Automatic) 

local gunpipper_horizontal_movement_param = get_param_handle("GUNPIPPER_SIDE")
local gunpipper_vertical_movement_param = get_param_handle("GUNPIPPER_UPDOWN")
local gunpipper_center_param = get_param_handle("GUNPIPPER_CENTER")
local gunpipper_sideways_automatic_param = get_param_handle("WS_GUN_PIPER_AZIMUTH")
local gunpipper_updown_automatic_param = get_param_handle("WS_GUN_PIPER_ELEVATION")
local target_range_param = get_param_handle("WS_TARGET_RANGE")

gunpipper_center_param:set(0.0)
--target_range_param:set(800.0) --Target-Range auf 800m gesetzt

local gunpipper_mode = 0


function keys_gunpipper_vertical_up(value)

	if (gunpipper_mode ==  0)
	then
		gunpipper_vertical_movement_param:set(gunpipper_vertical_movement_param:get() +0.01) --war 0.05
	end

end

function keys_gunpipper_vertical_down(value)

if (gunpipper_mode ==  0)
	then
		gunpipper_vertical_movement_param:set(gunpipper_vertical_movement_param:get() -0.01)
	end

end

function keys_gunpipper_horizontal_right(value)

	if (gunpipper_mode ==  0)
	then
		gunpipper_horizontal_movement_param:set(gunpipper_horizontal_movement_param:get() +0.01)
	end
	
end

function keys_gunpipper_horizontal_left(value)
-- 										das ist der vorherige Wert - den neuen Wert, also ein Schritt.
	if (gunpipper_mode ==  0)
	then
		gunpipper_horizontal_movement_param:set(gunpipper_horizontal_movement_param:get() -0.01)
	end

end

function keys_gunpipper_center(value)
	if (gunpipper_mode ==  0)
	then
	gunpipper_horizontal_movement_param:set(0.0)
	gunpipper_vertical_movement_param:set(0.0)
	end

end

function keys_gunpipper_automatic(value)

	if (gunpipper_mode ==  0) --and  (gunpipper_horizontal_movement_param == 0.0) and (gunpipper_vertical_movement_param == 0.0)) 
	then 
		gunpipper_mode = 1
		--print_message_to_user("Ich bin jetzt eingeschaltet und auf Automatic")
		--print_message_to_user("Wert"..tostring(ir_missile_az_param))
	elseif (gunpipper_mode ==  1)
	then
		gunpipper_mode = 0
	--print_message_to_user("Jetzt bin ich wieder auf manuell.")
	end

end


command_table = {
    [Keys.GunPipper_Up] 	= keys_gunpipper_vertical_up,
    [Keys.GunPipper_Down] 	= keys_gunpipper_vertical_down,
    [Keys.GunPipper_Right] 	= keys_gunpipper_horizontal_right,
    [Keys.GunPipper_Left] 	= keys_gunpipper_horizontal_left,
    [Keys.GunPipper_Center] 	= keys_gunpipper_center,
    [Keys.GunPipper_Automatic]	= keys_gunpipper_automatic,
}

-------------Hier geht es los mit den laufenden Funktionen. Alles dadrüber ist local-kram und functionen----------------
function post_initialize()

	local dev=GetSelf()
	
	--gunpipper_horizontal_movement_param:set(0.0)
	--gunpipper_vertical_movement_param:set(0.0)
	

end


function SetCommand(command,value)	

 if command_table[command] then
        command_table[command](value)
    end
	
end

function update()

	
	
	if (gunpipper_mode == 1) then
		gunpipper_horizontal_movement_param:set(gunpipper_sideways_automatic_param:get())
		gunpipper_vertical_movement_param:set(gunpipper_updown_automatic_param:get())
		end
	
	--if target_range_param:get() > 0.0 then
		--print_message_to_user("Target aquired")
		--print_message_to_user("Target Range  " tostring (target_range_param:get()))
	--else
		--target_range_param:set(800.0)
		--print_message_to_user("Range set to 800m")
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