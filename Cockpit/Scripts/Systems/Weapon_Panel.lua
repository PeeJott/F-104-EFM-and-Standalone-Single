--dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")

local dev = GetSelf()

local update_time_step = 0.05
make_default_activity(update_time_step)--update will be called 20 times per second

local sensor_data = get_base_data()

-------------Params-----------------
local Station_One_Param			= get_param_handle("PYLON_ONE_SELECTOR_LIGHT")
local Station_Two_Param			= get_param_handle("PYLON_TWO_SELECTOR_LIGHT")
local Station_Three_Param		= get_param_handle("PYLON_THREE_SELECTOR_LIGHT")
local Station_Four_Param		= get_param_handle("PYLON_FOUR_SELECTOR_LIGHT")
local Station_Five_Param		= get_param_handle("PYLON_FIVE_SELECTOR_LIGHT")
local Station_Six_Param			= get_param_handle("PYLON_SIX_SELECTOR_LIGHT")
local Station_Seven_Param		= get_param_handle("PYLON_SEVEN_SELECTOR_LIGHT")

-------------Variables and initializing----
local station_ONE 		= 0
local station_TWO 		= 0
local station_THREE 	= 0
local station_FOUR		= 0
local station_FIVE		= 0
local station_SIX 		= 0
local station_SEVEN     = 0

-------------Commands to process----
dev:listen_command(Keys.station_one)
dev:listen_command(Keys.station_two)
dev:listen_command(Keys.station_three)
dev:listen_command(Keys.station_four)
dev:listen_command(Keys.station_five)
dev:listen_command(Keys.station_six)
dev:listen_command(Keys.station_seven)

dev:listen_command(Keys.change_station)

---------Command Functions to excecute something-----
function keys_station_one(value)
	
	if (station_ONE == 0) then
		station_ONE = 1
		Station_One_Param:set(1)
		print_message_to_user("Station 1 AN!")
	else
		station_ONE = 0
		Station_One_Param:set(0)
		print_message_to_user("Station 1 AUS!")
	end
		
end

function keys_station_two(value)
	
	if (station_TWO == 0) then
		station_TWO = 1
		Station_Two_Param:set(1)
		print_message_to_user("Station 2 AN!")
	else
		station_TWO = 0
		Station_Two_Param:set(0)
		print_message_to_user("Station 2 AUS!")
	end
	
end

function keys_station_three(value)
	
	if (station_THREE == 0) then
		station_THREE = 1
		Station_Three_Param:set(1)
		print_message_to_user("Station 3 AN!")
	else
		station_THREE = 0
		Station_Three_Param:set(0)
		print_message_to_user("Station 3 AUS!")
	end
	
end

function keys_station_four(value)
	
	if (station_FOUR == 0) then
		station_FOUR = 1
		Station_Three_Param:set(1)
		Station_Five_Param:set(1)
		print_message_to_user("Station 4 AN!")
	else
		station_FOUR = 0
		Station_Three_Param:set(0)
		Station_Five_Param:set(0)
		print_message_to_user("Station 4 AUS!")
	end
end

function keys_station_five(value)

	if (station_FIVE == 0) then
		station_FIVE = 1
		Station_Five_Param:set(1)
		print_message_to_user("Station 5 AN!")
	else
		station_FIVE = 0
		Station_Five_Param:set(0)
		print_message_to_user("Station 5 AUS!")
	end
	
end

function keys_station_six(value)

	if (station_SIX == 0) then
		station_SIX = 1
		Station_Six_Param:set(1)
		print_message_to_user("Station 6 AN!")
	else
		station_SIX = 0
		Station_Six_Param:set(0)
		print_message_to_user("Station 6 AUS!")
	end
	
end

function keys_station_seven(value)

	if (station_SEVEN == 0) then
		station_SEVEN = 1
		Station_Seven_Param:set(1)
		print_message_to_user("Station 7 AN!")
	else
		station_SEVEN = 0
		Station_Seven_Param:set(0)
		print_message_to_user("Station 7 AUS!")
	end
	
end

function keys_change_station(value)

end


command_table = {
  [Keys.station_one]		= keys_station_one,
  [Keys.station_two]		= keys_station_two,
  [Keys.station_three]		= keys_station_three,
  [Keys.station_four]		= keys_station_four,
  [Keys.station_five]		= keys_station_five,
  [Keys.station_six]		= keys_station_six,
  [Keys.station_seven]		= keys_station_seven,
  --[Keys.change_station]		= keys_change_station,
  
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
--[[Actual_AoA = sensor_data:getAngleOfAttack() * rad_to_deg
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

]]
	
end

need_to_be_closed = false

