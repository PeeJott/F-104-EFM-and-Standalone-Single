dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "definitions.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avImprovedRadar')

local BLOB_COUNT = 2500
local NOISE_COUNT = 100


dev 	    	= devices.RADAR
DEBUG_ACTIVE 	= true

update_time_step 	= 0.025
make_default_activity(update_time_step) 

antenna_azimuth_h 		= get_param_handle("ANTENNA_AZIMUTH")

local noise_show = {}
local noise_range = {}
local noise_azimuth = {}

for i = 0,NOISE_COUNT do	
	noise_show[i] = get_param_handle("NOISE_"..i.."_SHOW")
	noise_range[i] = get_param_handle("NOISE_"..i.."_RANGE")
	noise_azimuth[i] = get_param_handle("NOISE_"..i.."_AZIMUTH")
end

function post_initialize()
		
	if avImprovedRadar.Setup(dev) == true then
		print_message_to_user("Radar scope setup: succesful")
	else
		print_message_to_user("Radar scope setup: failed")
	end
	
end

function SetCommand(command,value)

end

local current_noise_range = 0

function update()
	
	local antenna_az = avImprovedRadar.get_antenna_azimuth()
	local antenna_el = avImprovedRadar.get_antenna_elevation()	

	antenna_azimuth_h:set(-antenna_az)

	-- Add some noise at the current antenna azimuth
	local noise_amount = 20
	
	if current_noise_range + noise_amount >= NOISE_COUNT then
		current_noise_range = 0
	end

	for n = current_noise_range,current_noise_range+noise_amount do
		local noise_show_handle = noise_show[n]
		local noise_range_handle = noise_range[n]
		local noise_azimuth_handle = noise_azimuth[n]

		local base_range = 40000.0 * 1.852
		local range = math.random(0, base_range)
		noise_show_handle:set(1)
		noise_range_handle:set(range)
		noise_azimuth_handle:set(-antenna_az)

		current_noise_range = n
	end	
end


