dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.75
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local landing_light_switch_param = get_param_handle("LANDING_LIGHT_SWITCH")
local interior_light_param = get_param_handle("INTERIOR_LIGHT")


local formation_light_switch = 0

local navigation_light_switch = 0
local navigation_light_bright = 1

local landing_light_switch = 0
local interior_light_switch = 0

function SetCommand(command,value)	
	if command == Keys.iCommandPlaneLightsOnOff then
		navigation_light_switch = navigation_light_switch+1
		if navigation_light_switch > 2 then
			navigation_light_switch = 0
		end
	end

	if command == Keys.iCommandPlaneHeadLightOnOff then
		landing_light_switch = landing_light_switch+1
		if landing_light_switch > 2 then
			landing_light_switch = 0
		end

		landing_light_switch_param:set(landing_light_switch)
	end

	if command == Keys.iCommandPlaneCockpitIllumination then
		interior_light_switch = interior_light_switch+1
		if interior_light_switch > 1 then
			interior_light_switch = 0
		end

		interior_light_param:set(interior_light_switch)		
	end

end

function post_initialize()

	dev:listen_command(Keys.iCommandPlaneLightsOnOff)
	dev:listen_command(Keys.iCommandPlaneHeadLightOnOff)
	dev:listen_command(Keys.iCommandPlaneCockpitIllumination)
	

	print_message_to_user("Lighting - INIT")
end

local flash = 1

function update()    

	if landing_light_switch == 1 then
		set_aircraft_draw_argument_value(208, 1)
		set_aircraft_draw_argument_value(209, 0)
	elseif landing_light_switch == 2 then
		set_aircraft_draw_argument_value(208, 0)
		set_aircraft_draw_argument_value(209, 1)
	else
		set_aircraft_draw_argument_value(208, 0)
		set_aircraft_draw_argument_value(209, 0)
	end	
	
	set_aircraft_draw_argument_value(200, formation_light_switch)

	if navigation_light_switch > 0 then
		set_aircraft_draw_argument_value(192, navigation_light_bright) -- fuselage

		if navigation_light_switch == 1 or navigation_light_switch == 2 and flash == 1  then
			set_aircraft_draw_argument_value(190, navigation_light_bright) -- left
			set_aircraft_draw_argument_value(191, navigation_light_bright) -- right
			set_aircraft_draw_argument_value(193, navigation_light_bright) -- tail bottom
			set_aircraft_draw_argument_value(194, navigation_light_bright) -- tail top
			flash = 0
		else
			set_aircraft_draw_argument_value(190, 0) -- left
			set_aircraft_draw_argument_value(191, 0) -- right
			set_aircraft_draw_argument_value(193, 0) -- tail bottom
			set_aircraft_draw_argument_value(194, 0) -- tail top
			flash = 1
		end
	else
		set_aircraft_draw_argument_value(192, 0) -- fuselage
		set_aircraft_draw_argument_value(190, 0) -- left
		set_aircraft_draw_argument_value(191, 0) -- right
		set_aircraft_draw_argument_value(193, 0) -- tail bottom
		set_aircraft_draw_argument_value(194, 0) -- tail top
	end

end

need_to_be_closed = false
