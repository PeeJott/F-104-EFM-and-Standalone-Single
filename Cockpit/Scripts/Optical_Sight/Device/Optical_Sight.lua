dofile(LockOn_Options.script_path .."command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "Systems/weapon_system.lua")


dofile(LockOn_Options.script_path .. "avRadar/Device/radar_api.lua")
dofile(LockOn_Options.script_path.."definitions.lua")
dofile(LockOn_Options.script_path.."ElectricSystems/electric_system_api.lua")

dev = GetSelf()
local update_time_step = 0.02
make_default_activity(update_time_step)
local sensor_data = get_base_data()

dev:listen_command(Keys.GunPipper_Up)
dev:listen_command(Keys.GunPipper_Down)
dev:listen_command(Keys.GunPipper_Center)
dev:listen_command(Keys.GunPipper_Automatic) 

local hud_power = get_param_handle(HUD.POWER)
local hud_manual = get_param_handle(HUD.MANUAL)
local hud_depression = get_param_handle(HUD.DEPRESSION)
local hud_auto = get_param_handle(HUD.AUTO)

local hud_roll = get_param_handle(HUD.ROLL)
local hud_range = get_param_handle(HUD.RANGE)

local target_range_param = get_param_handle("WS_TARGET_RANGE") -- from weaponSystem
local dlz_min_param = get_param_handle("WS_DLZ_MIN") -- from weaponSystem
local dlz_max_param = get_param_handle("WS_DLZ_MAX") -- from weaponSystem
local dlz_max_param = get_param_handle("WS_DLZ_MAX") -- from weaponSystem
local arm_Selector_switch_param = get_param_handle("ARMAMENT_SEL_SWITCH")

local gunpipper_mode = 0
local depression = 0.0
local caged = false

function keys_gunpipper_vertical_up(value)
	depression = depression + 4.0
	
	if depression > 17.45 then
		depression = 17.45
		print_message_to_user("Depression: " .. depression .. " (MRL)")
	elseif depression >= -2 and depression < 2 then
		print_message_to_user("Depression: " .. depression .. " (ADL)")
	else
		print_message_to_user("Depression: " .. depression)	
	end

end

function keys_gunpipper_vertical_down(value)

	depression = depression - 4.0
	if depression < -172.0 then
		depression = -172.0
		print_message_to_user("Depression: " .. depression " (below ADL)")
	elseif depression >= -2 and depression < 2 then
		print_message_to_user("Depression: " .. depression .. " (ADL)")
	else
		print_message_to_user("Depression: " .. depression)
	end

end

function keys_gunpipper_center(value)
	if caged == false then 
		caged = true
		print_message_to_user("Optical sight: Caged")
	else
		caged = false
		print_message_to_user("Optical sight: Uncaged")
	end
end

function keys_gunpipper_automatic(value)

	if (gunpipper_mode ==  0) then 
		gunpipper_mode = 1		
		print_message_to_user("Optical sight: Manual")
	elseif (gunpipper_mode ==  1) then
		gunpipper_mode = 2
		print_message_to_user("Optical sight: Off")
	elseif(gunpipper_mode == 2) then
		gunpipper_mode = 0
		print_message_to_user("Optical sight: Normal")
	end

end

function set_range(range)

	local min_range = 300
	local max_range = 1500

	-- DLZ_max seems to be way to large. 

	-- Range depends on mode:
	--arm_select = arm_Selector_switch_param:get()
	--if arm_select == 0 then
	--	-- MISSILE: DLZ_min to DLZ_max
	--	-- DLZ_min and DLZ_max is way to large.
	--	min_range = dlz_min_param:get()
	--	max_range = dlz_max_param:get()
	--else
	--	-- GUN: 0-1200
	--	-- ROCKETS
	--	min_range = 300
	--	max_range = 1500
	--end


	if range >= (min_range + max_range) then
		hud_range:set(180.1)
	elseif range <= min_range then
		hud_range:set(0.0)
	else
		-- 0°	= 300m
		-- 90°	= 900m
		-- 180° = 1500m
		local degree = ((range-min_range)/(max_range-min_range)) * 180
		hud_range:set(degree)
	end
end


command_table = {
    [Keys.GunPipper_Up] 	= keys_gunpipper_vertical_up,
    [Keys.GunPipper_Down] 	= keys_gunpipper_vertical_down,
    [Keys.GunPipper_Center] 	= keys_gunpipper_center,
    [Keys.GunPipper_Automatic]	= keys_gunpipper_automatic,
}

-------------Hier geht es los mit den laufenden Funktionen. Alles dadrüber ist local-kram und functionen----------------
function post_initialize()

	local dev=GetSelf()
	
	gunpipper_mode = 0 -- TODO: change normal mode to off as default
end


function SetCommand(command,value)	

	if command_table[command] then
        command_table[command](value)
	end
	
end

function update()

	-- No need to set the azimuth and elevation of the gun pipper as it is directly linked to the param_handles of the WeaponSystem
	-- This is not ideal to support different gun pipper modes, but necessary to loose a frame.
	-- Instead the different modes can be realized by having multiple gun pippers that are set invisible depending on the mode. 

	if electric_system_api.no_2_ac_bus:get() == 1.0 and gunpipper_mode ~= 2 then
		-- what about the primary dc bus?

		hud_power:set(1.0)
		
		-- always set the roll
		hud_roll:set(sensor_data.getRoll())

		-- set range
		local radar_mode = radar_api.mode_h:get()
		if radar_mode == 3 --[[and gunpipper_mode == 0]] then -- TODO: verify if there is range bar in manual mode
			local range = target_range_param:get()
			set_range(range)
		else
			set_range(0.0)
		end

		-- set elevation and azimuth
		arm_select = arm_Selector_switch_param:get()
		if arm_select == 0.5 and gunpipper_mode == 0 and radar_mode == 3 and caged == false then -- normal mode, tracking and not caged, gun mode
			hud_auto:set(1.0)
			hud_manual:set(0.0)
		else -- manual or normal mode without lock or in missile or rocket mode
			hud_auto:set(0.0)
			hud_manual:set(1.0)
			
			if arm_select == 0.0 then
				-- In missle mode set depression to MRL (missle reference line) which is +17.45 milliradians (= 1° above ADL)
				--hud_depression:set(17.45) -- this currently doesn't work as it is to high. instead set 0
				hud_depression:set(0.0)
			elseif gunpipper_mode == 0 or caged == true then -- in normal mode without lock or caged
				hud_depression:set(0.0)
			else -- otherwhise it's in manual mode the manually selected depression is set
				hud_depression:set(depression / 1000)
			end

		end
	else
		hud_power:set(0.0)
	end
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