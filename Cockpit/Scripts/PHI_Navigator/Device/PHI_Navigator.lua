dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 2.0
make_default_activity(update_time_step)


local sensor_data = get_base_data()
local waypointData = get_mission_route()

local hsi = get_param_handle("HSI_DIAL")

local phi_bearing = get_param_handle("PHI_BEARING")
local phi_range = get_param_handle("PHI_RANGE")

local current_mode = 2
local modes = {}
modes[0] = "DR"
modes[1] = "DR SET"
modes[2] = "IN"
modes[3] = "IN SET"
modes[4] = "TACAN"

local current_waypoint = 0
local max_waypoints = 0
local min_waypoints = 0

dev:listen_command(Keys.PHI_ModeToggle)
dev:listen_command(Keys.PHI_StationSelectorUp)
dev:listen_command(Keys.PHI_StationSelectorDown)

function SetCommand(command,value)	
	if command == Keys.PHI_ModeToggle then
		-- change mode:
		current_mode = current_mode + 1
		if current_mode > 4 then
			current_mode = 0
		end
		print_message_to_user("PHI: " .. modes[current_mode])
    end

    if command == Keys.PHI_StationSelectorUp then
		-- change mode:
		current_waypoint = current_waypoint + 1
		if current_waypoint > max_waypoints then
			current_waypoint = max_waypoints
		end

		if current_waypoint > 0 then
			print_message_to_user("Selected WP: " .. current_waypoint)
		end
    end

	if command == Keys.PHI_StationSelectorDown then
		-- change mode:
		current_waypoint = current_waypoint - 1
		if current_waypoint < min_waypoints then			
			current_waypoint = min_waypoints
		end

		if current_waypoint > 0 then
			print_message_to_user("Selected WP: " .. current_waypoint)
		end
    end
end

function post_initialize()
	print_message_to_user("PHI Navigator - INIT")

	max_waypoints = math.min(table.getn(waypointData), 12)
	if max_waypoints > 0 then
		current_waypoint = 1
		min_waypoints = 1
	else 
		current_waypoint = 0
		min_waypoints = 0
	end
end

function update()
	
	if current_mode == 2 then
		if current_waypoint > 0 then
			local waypoint = waypointData[current_waypoint]

			-- TODO: Use position provided by Air Data Computer instead
			local x, alt, y = sensor_data.getSelfCoordinates()

			local bearing = math.deg(math.atan2((waypoint.y-y),(waypoint.x-x))) -- for some reason z and y is mixed
			if bearing > 360 then
				bearing = bearing - 360
			elseif bearing < 0 then
				bearing = bearing + 360
			end		

			range = math.sqrt((waypoint.x - x)^2 + (waypoint.y - y)^2) / 1000  -- for some reason z and y is mixed
			range = range * 0.53995726994149 -- km to Nm

			--print_message_to_user("WPN" .. current_waypoint .. ": Bearing" .. string.format("%.2f",  bearing) .. " Range: " .. string.format("%.2f",  range))
		end
	end
end

need_to_be_closed = false
