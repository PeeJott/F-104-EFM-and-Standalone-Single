dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "definitions.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avImprovedRadar')

render_debug_info 		= false
power_bus_handle = ELECTRIC_SYSTEM.NO_2_AC_BUS

range_scale 		  	= 60000.0
TDC_range_carret_size 	= 5000

local BLOB_FACTOR = 1
local BLOB_COUNT = 2500 * BLOB_FACTOR
local MAX_RANGE = 40000.0 * 1.852  
local MAX_RANGE_GATE = 20000.0 * 1.852
local NOISE_COUNT = 200
local NOISE_STEPS = 25
local NOISE_AMOUNT = NOISE_COUNT/NOISE_STEPS

perfomance = 
{
	roll_compensation_limits	= {math.rad(-30.0), math.rad(30.0)}, -- according to T.O. 1F-104G-1 p. 4-143 it's fully stabilized for 15° and then narrows down.
	pitch_compensation_limits	= {math.rad(-57.0), math.rad(25.0)}, -- according to T.O. 1F-104G-1 p. 4-123

	scan_volume_azimuth 	= math.rad(90),	-- according to T.O. 1F-104G-1 p. 4-123	
	scan_volume_elevation	= math.rad(10),	-- according to T.O. 1F-104G-1 p. 4-123
	scan_beam				= math.rad(5), -- A/A

	scan_speed				= math.rad(3*60), -- is not working, confirmed in test
	
	tracking_azimuth   			= { -math.rad(45),math.rad(45)}, -- most likely 90°
	tracking_elevation 			= { -math.rad(38),math.rad(20)}, -- most likely the antenna tilt limits

	max_available_distance  = MAX_RANGE / 0.66, -- to compensate range reduction for ground spots
	dead_zone 				= 300.0, -- can't be set via config
	
	ground_clutter =
	{-- spot RCS = A + B * random + C * random 
		sea		   	   = {0,0,0}, -- no return from sea
		land 	   	   = {50,0,0},
		artificial 	   = {100,0,0},
		rays_density   = 0.25 * BLOB_FACTOR,		-- 0.25 all modes except spoiled
		max_distance   = MAX_RANGE / 0.66 -- to compensate range reduction for ground spots
	}
}


------------------------------------------------------------------------------

dev 	    	= GetSelf()
DEBUG_ACTIVE 	= true



--update_time_step 	= 0.05
--device_timer_dt		= 0.05
update_time_step 	= 0.025
device_timer_dt		= 0.025

make_default_activity(update_time_step) 


local offset = 0;

local air_elevation = 10
local air_beam = 5
local air_speed = 90
local air_density = 0.25 * BLOB_FACTOR

local ground_elevation = 6.2
local ground_beam = 6.2
local ground_speed = 90 -- must be increase for some unknown reason, otherwise nothing is spotted
local ground_density = 0.25 * BLOB_FACTOR

local spoiled_elevation = 55
local spoiled_beam = 55
local spoiled_speed = 90
local spoiled_density = 0.05 * BLOB_FACTOR

local current_mode = 0
local modes = {}
modes[0] = "OFF"
modes[1] = "SBY"
modes[2] = "A/A"
modes[3] = "GMP"
modes[4] = "GMS"
modes[5] = "CM"
modes[6] = "TA"
modes[7] = "A/G"

local range_sweep_switch = 2
local ranges = {}
ranges[0] = "10"
ranges[1] = "20"
ranges[2] = "40"


local clearance_plane = 0
local memory = 1.0
local remove_ground_clutter = 0


Radar = 	{
	-- NONE = 0
	-- SCAN = 1
	-- ACQUISITION = 2
	-- TRACKING = 3
	-- BUILT_IN_TEST = 4
	mode_h 		= get_param_handle("RADAR_MODE"),
	--szoe_h 		= get_param_handle("SCAN_ZONE_ORIGIN_ELEVATION"),
	--szoa_h 		= get_param_handle("SCAN_ZONE_ORIGIN_AZIMUTH"),
				
	opt_pb_stab_h 	= get_param_handle("RADAR_PITCH_BANK_STABILIZATION"),				
	opt_bank_stab_h = get_param_handle("RADAR_BANK_STABILIZATION"), -- available?
	opt_pitch_stab_h= get_param_handle("RADAR_PITCH_STABILIZATION"), -- available?
				
				
	tdc_azi_h 		= get_param_handle("RADAR_TDC_AZIMUTH"),
	tdc_range_h 	= get_param_handle("RADAR_TDC_RANGE"),
	tdc_closet_h	= get_param_handle("CLOSEST_RANGE_RESPONSE"),
				
	tdc_rcsize_h	= get_param_handle("RADAR_TDC_RANGE_CARRET_SIZE"),
	tdc_acqzone_h   = get_param_handle("ACQUSITION_ZONE_VOLUME_AZIMUTH"),
				

	stt_range_h 	= get_param_handle("RADAR_STT_RANGE"),
	stt_azimuth_h 	= get_param_handle("RADAR_STT_AZIMUTH"),
	stt_elevation_h = get_param_handle("RADAR_STT_ELEVATION"),
				
	sz_volume_azimuth_h 	= get_param_handle("SCAN_ZONE_VOLUME_AZIMUTH"),
	sz_volume_elevation_h 	= get_param_handle("SCAN_ZONE_VOLUME_ELEVATION"),

	sz_azimuth_h 	= get_param_handle("SCAN_ZONE_ORIGIN_AZIMUTH"),
	sz_elevation_h 	= get_param_handle("SCAN_ZONE_ORIGIN_ELEVATION"),
				
	tdc_ele_up_h 	= get_param_handle("RADAR_TDC_ELEVATION_AT_RANGE_UPPER"),
	tdc_ele_down_h 	= get_param_handle("RADAR_TDC_ELEVATION_AT_RANGE_LOWER"),
				
	--ws_ir_slave_azimuth_h	= get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH"),
	--ws_ir_slave_elevation_h	= get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION"),
				
	iff_status_h			= get_param_handle("IFF_INTERROGATOR_STATUS"),
	bit_h 					= get_param_handle("RADAR_BIT"),


	roll = get_param_handle("RADAR_ROLL"),
	pitch = get_param_handle("RADAR_PITCH"),
}

local radar_contact_time = {}
local radar_contact_rcs = {}
local radar_contact_range = {}
local radar_contact_azimuth = {}
local radar_contact_elevation = {}

local blob_show = {}
local blob_opacity = {}
local blob_scale = {}
local blob_range = {}
local blob_azimuth = {}

for ia = 1,BLOB_COUNT do
	if ia  < 10 then
		i = "_0".. ia .."_"
	else
		i = "_".. ia .."_"
	end

	radar_contact_time[i] = get_param_handle("RADAR_CONTACT"..i.."TIME")
	radar_contact_time[i]:set(-1.0) -- mark invalid

	radar_contact_rcs[i] = get_param_handle("RADAR_CONTACT"..i.."RCS")
	radar_contact_range[i] = get_param_handle("RADAR_CONTACT"..i.."RANGE")
	radar_contact_azimuth[i] = get_param_handle("RADAR_CONTACT"..i.."AZIMUTH")
	radar_contact_elevation[i] = get_param_handle("RADAR_CONTACT"..i.."ELEVATION")

	blob_show[i] = get_param_handle("BLOB"..i.."SHOW")
	blob_opacity[i] = get_param_handle("BLOB"..i.."OPACITY")
	blob_scale[i] = get_param_handle("BLOB"..i.."SCALE")
	blob_range[i] = get_param_handle("BLOB"..i.."RANGE")
	blob_azimuth[i] = get_param_handle("BLOB"..i.."AZIMUTH")
end

local range_gate_show = {}
local range_gate_range = {}
local range_gate_azimuth = {}
local range_gate_opacity = {}

for i = 0,9 do
	range_gate_show[i] = get_param_handle("RANGE_GATE_"..i.."_SHOW")
	range_gate_range[i] = get_param_handle("RANGE_GATE_"..i.."_RANGE")
	range_gate_azimuth[i] = get_param_handle("RANGE_GATE_"..i.."_AZIMUTH")
	range_gate_opacity[i] = get_param_handle("RANGE_GATE_"..i.."_OPACITY")
end


local noise_show = {}
local noise_range = {}
local noise_azimuth = {}
local noise_opacity = {}

for i = 0,NOISE_COUNT do	
	noise_show[i] = get_param_handle("NOISE_"..i.."_SHOW")
	noise_range[i] = get_param_handle("NOISE_"..i.."_RANGE")
	noise_azimuth[i] = get_param_handle("NOISE_"..i.."_AZIMUTH")
	noise_opacity[i] = get_param_handle("NOISE_"..i.."_OPACITY")
end


antenna_azimuth_h 		= get_param_handle("ANTENNA_AZIMUTH")


function post_initialize()

	print_message_to_user("Radar - INIT")
		
--	-- most likely not used
--	dev:listen_command(100)		--iCommandPlaneChangeLock
--		
--	-- most likely not used
--	dev:listen_command(394)		--change PRF (radar puls freqency)//iCommandPlaneChangeRadarPRF
--	
--	dev:listen_command(509)		--lock start//iCommandPlane_LockOn_start
--	dev:listen_command(510)		--lock finish//iCommandPlane_LockOn_finish
--	
--	-- most likely not used
--	dev:listen_command(285)		--Change radar mode RWS/TWS //iCommandPlaneRadarChangeMode
--		
--
--	-- not used!
--	dev:listen_command(2025)	--iCommandPlaneRadarHorizontal
--	dev:listen_command(2026)	--iCommandPlaneRadarVertical
--
--	-- used!
--	dev:listen_command(2031)	--iCommandPlaneSelecterHorizontal
--	dev:listen_command(2032)	--iCommandPlaneSelecterVertical




	dev:listen_command(Keys.RadarModeToggle)
	
	dev:listen_command(Keys.RadarRangeModeToggle)	
	dev:listen_command(Keys.RadarRangeModeUp)
	dev:listen_command(Keys.RadarRangeModeDown)

	dev:listen_command(Keys.RadarElevUp)
	dev:listen_command(Keys.RadarElevDown)

	dev:listen_command(Keys.RadarClearanceUp)
	dev:listen_command(Keys.RadarClearanceDown)
		
	dev:listen_command(Keys.RadarMemoryUp)
	dev:listen_command(Keys.RadarMemoryDown)

	dev:listen_command(90) -- iCommandPlaneRadarUp     
	dev:listen_command(91) -- iCommandPlaneRadarDown
	dev:listen_command(509) -- iCommandPlane_LockOn_start
	dev:listen_command(510) -- iCommandPlane_LockOn_stop
	
	
		
	Radar.opt_pb_stab_h:set(1)
	--Radar.opt_pitch_stab_h:set(1) -- doesn't work
	--Radar.opt_bank_stab_h:set(1) -- doesn't work
	Radar.sz_elevation_h:set(math.rad(0))
	Radar.sz_azimuth_h:set(math.rad(0))
	Radar.tdc_acqzone_h:set(math.rad(10))
		
	if avImprovedRadar.Setup(dev) == true then
		print_message_to_user("ImprovedRadar setup: succesful")
		avImprovedRadar.set_scan_speed(math.rad(90)) -- degree per second?
	else
		print_message_to_user("ImprovedRadar setup: failed")
	end

	--local err = avImprovedRadar.Hook();
	--print_message_to_user("ImprovedRadar hook: " .. err)
	
end

function SetCommand(command,value)
	

	------------------------------------- ANTENNA ELEVATION -------------------------------	
	
	if command == Keys.RadarElevUp then
		local new_elevation = Radar.sz_elevation_h:get() + math.rad(2)
		if new_elevation > math.rad(20) then
			new_elevation = math.rad(20)
		end
		Radar.sz_elevation_h:set(new_elevation)
		print_message_to_user("Antenna elevation: " .. math.deg(new_elevation))

		---- offset discovery
		--offset = offset - 1
		--if offset < 0 then
		--	offset = 0
		--end
		--avImprovedRadar.SetOffset(offset)
	end
	
	if command == Keys.RadarElevDown then
		local new_elevation = Radar.sz_elevation_h:get() - math.rad(2)
		if new_elevation < -(math.rad(38)) then
			new_elevation = -(math.rad(38))
		end
		Radar.sz_elevation_h:set(new_elevation)
		print_message_to_user("Antenna elevation: " .. math.deg(new_elevation))

		---- offset discovery
		--offset = offset + 1		
		--avImprovedRadar.SetOffset(offset)
	end
	
	------------------------------------- RANGE MODE -------------------------------	
	local updateRangeGateScale = false
	if command == Keys.RadarRangeModeToggle then
		if range_sweep_switch == 0 then
			range_sweep_switch = range_sweep_switch + 1			
		elseif range_sweep_switch == 1 then
			range_sweep_switch = range_sweep_switch + 1
		elseif range_sweep_switch == 2 then
			range_sweep_switch = 0
		end

		print_message_to_user("Range: " .. ranges[range_sweep_switch])
	end

	if command == Keys.RadarRangeModeDown then		
		if range_sweep_switch > 0 then
			range_sweep_switch = range_sweep_switch - 1
		end
		print_message_to_user("Range: " .. ranges[range_sweep_switch])		
	end

	if command == Keys.RadarRangeModeUp then		
		if range_sweep_switch < 2 then
			range_sweep_switch = range_sweep_switch + 1			
		end
		print_message_to_user("Range: " .. ranges[range_sweep_switch])
	end


	------------------------------------- CLEARANCE PLANE-------------------------------	
	
	if command == Keys.RadarClearanceDown then		
		if clearance_plane > -6000 then
			clearance_plane = clearance_plane - 100
		end
		print_message_to_user("Clearance Plane: " .. clearance_plane)

		local atan = clearance_plane / 10000
		local new_elevation = math.atan(atan)
		Radar.sz_elevation_h:set(new_elevation)
		print_message_to_user("Antenna elevation: " .. math.deg(new_elevation))

	end

	if command == Keys.RadarClearanceUp then		
		if clearance_plane < 0 then
			clearance_plane = clearance_plane + 100			
		end
		print_message_to_user("Clearance Plane: " .. clearance_plane)

		local atan = clearance_plane / 10000
		local new_elevation = math.atan(atan)
		Radar.sz_elevation_h:set(new_elevation)
		print_message_to_user("Antenna elevation: " .. math.deg(new_elevation))
	end

	------------------------------------- MEMORY -------------------------------	
		
	if command == Keys.RadarMemoryDown then		
		if memory > 0.1 then
			memory = memory - 0.1
			if memory < 0.1 then
				memory = 0.1
			end
		end
		print_message_to_user("Memory: " .. memory)
	end

	if command == Keys.RadarMemoryUp then		
		if memory < 10.0 then
			memory = memory + 0.1
			if memory > 10.0 then
				memory = 10.0
			end
		end
		print_message_to_user("Memory: " .. memory)
	end

	------------------------------------- RANGE GATE -------------------------------	

	--if command == 2032  then
	--	Radar.tdc_range_h:set(Radar.tdc_range_h:get()- value*200000)
	--	--print_message_to_user("RadarRangeUP/DOWN")		
	--end
	--
	--if command == 2031  then
	--	Radar.tdc_azi_h:set(Radar.tdc_azi_h:get()+ value*10)
	--	--print_message_to_user("RadarRangeLeftRight")		
	--end
		
	if command == 90 or command == 91 then
	-- limit the range gate
		if Radar.tdc_range_h:get() > MAX_RANGE_GATE then
			Radar.tdc_range_h:set(MAX_RANGE_GATE)
		elseif Radar.tdc_range_h:get() < 0 then
			Radar.tdc_range_h:set(0)
		end
	end

	------------------------------------- SECTOR SCAN -------------------------------	

	if command == 509 then
		local antenna_az = avImprovedRadar.get_antenna_azimuth()
		Radar.tdc_azi_h:set(-antenna_az)
	end

	if command == 510 then
		local antenna_az = avImprovedRadar.get_antenna_azimuth()
		Radar.tdc_azi_h:set(-antenna_az)
	end

	--------------------------------------- RADAR MODE --------------------------
	if command == Keys.RadarModeToggle then
		-- change mode:
		if current_mode == 0 then
			current_mode = current_mode + 1

			-- SBY
			-- Nothing

		elseif current_mode == 1 then
			current_mode = current_mode + 1
				
			-- A/A			
			avImprovedRadar.set_scan_beam(math.rad(air_beam))
			Radar.sz_volume_elevation_h:set(math.rad(air_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(air_speed))
			avImprovedRadar.set_ray_density(air_density)
			remove_ground_clutter = 1

		elseif current_mode == 2 then
			current_mode = current_mode + 1

			-- GMP
			avImprovedRadar.set_scan_beam(math.rad(ground_beam))
			Radar.sz_volume_elevation_h:set(math.rad(ground_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(ground_speed))
			avImprovedRadar.set_ray_density(ground_density)
			remove_ground_clutter = 0

		elseif current_mode == 3 then
			current_mode = current_mode + 1

			-- GMS
			avImprovedRadar.set_scan_beam(math.rad(spoiled_beam))
			Radar.sz_volume_elevation_h:set(math.rad(spoiled_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(spoiled_speed))
			avImprovedRadar.set_ray_density(spoiled_density)
			remove_ground_clutter = 0

		elseif current_mode == 4 then
			current_mode = current_mode + 1

			-- CM
			avImprovedRadar.set_scan_beam(math.rad(ground_beam))
			Radar.sz_volume_elevation_h:set(math.rad(ground_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(ground_speed))
			avImprovedRadar.set_ray_density(ground_density)
			remove_ground_clutter = 0

		elseif current_mode == 5 then
			current_mode = current_mode + 1

			-- TA
			avImprovedRadar.set_scan_beam(math.rad(ground_beam))
			Radar.sz_volume_elevation_h:set(math.rad(ground_elevation))
			Radar.opt_pb_stab_h:set(0)
			avImprovedRadar.set_scan_speed(math.rad(ground_speed))
			avImprovedRadar.set_ray_density(ground_density)
			remove_ground_clutter = 0

		elseif current_mode == 6 then
			current_mode = current_mode + 1

			-- A/G
			-- Nothing for CEP 2015

		elseif current_mode == 7 then
			current_mode = 0

			-- OFF
			-- Nothing

		end

		print_message_to_user("Radar: " .. modes[current_mode])
	end
end

function update()

	---- offset discovery
	--local uintValue = avImprovedRadar.GetUnsignedInt()	
	--local floatValue = avImprovedRadar.GetFloat()	
	--print_message_to_user("Offset: " .. offset .. " uint: " .. uintValue .. " float: " .. floatValue)

	--local wsType = avImprovedRadar.get_last_type()
	--local wsPosition = avImprovedRadar.get_last_position()
	--local wsName = avImprovedRadar.get_last_name()
	--print_message_to_user("Offset: " .. offset .. " name: " .. wsName .. " last type: " .. wsType .. " position: " .. wsPosition)
	
	local antenna_az = avImprovedRadar.get_antenna_azimuth()
	local antenna_el = avImprovedRadar.get_antenna_elevation()	

	antenna_azimuth_h:set(-antenna_az)	
	
	
	if current_mode == 2 then -- A/A		
		if Radar.mode_h:get() == 2 then
			-- scan speed is reduced during ACQUISITION
			avImprovedRadar.set_scan_speed(math.rad(air_speed * 0.25))
		else
			avImprovedRadar.set_scan_speed(math.rad(air_speed))
		end
	end

	if current_mode == 0 or current_mode == 1 or current_mode == 7 then
		-- disable radar in OFF, SBY or A/G

		for r=0,9 do
			range_gate_show[r]:set(0)
		end

		for ia = 1,BLOB_COUNT do
			if ia  < 10 then
			i = "_0".. ia .."_"
			else
				i = "_".. ia .."_"
			end
			
			local blob_show_handle = blob_show[i]			
			blob_show_handle:set(0)
		end
	else

		for r=9,1,-1 do
			range_gate_show[r]:set(range_gate_show[r-1]:get())
			range_gate_range[r]:set(range_gate_range[r-1]:get())
			range_gate_azimuth[r]:set(range_gate_azimuth[r-1]:get())
			range_gate_opacity[r]:set(1.0-(0.1*r))
		end
		
		local range = Radar.tdc_range_h:get()
		if range_sweep_switch == 0 then
			range = range * 4
		elseif range_sweep_switch == 1 then
			range = range * 2
		end

		range_gate_show[0]:set(1)
		range_gate_range[0]:set(range)
		range_gate_azimuth[0]:set(-antenna_az)
		range_gate_opacity[0]:set(1.0)


		----------------- NOISE START -------------

		for s=NOISE_STEPS-1,1,-1 do			
			for n = s*NOISE_AMOUNT,s*NOISE_AMOUNT+NOISE_AMOUNT do
				noise_show[n]:set(noise_show[n-NOISE_AMOUNT]:get())
				noise_range[n]:set(noise_range[n-NOISE_AMOUNT]:get())
				noise_azimuth[n]:set(noise_azimuth[n-NOISE_AMOUNT]:get())
				noise_opacity[n]:set(1.0-((1.0/NOISE_STEPS)*s))
			end
		end
		
		if current_mode == 2 and Radar.mode_h:get() == 2 then -- A/A		
			if math.deg(-antenna_az) < (math.deg(Radar.tdc_azi_h:get())-1) or math.deg(-antenna_az) > (math.deg(Radar.tdc_azi_h:get())+1) then
				for n = 0,NOISE_AMOUNT do
					local noise_show_handle = noise_show[n]
					local noise_range_handle = noise_range[n]
					local noise_azimuth_handle = noise_azimuth[n]
					local noise_opacity_handle = noise_opacity[n]
	
					local base_range = 40000.0 * 1.852
					local range = math.random(0, base_range)
					noise_show_handle:set(1)
					noise_range_handle:set(range)
					noise_azimuth_handle:set(-antenna_az)
					noise_opacity_handle:set(1.0)
				end
			else
				for n = 0,NOISE_AMOUNT do
					local noise_show_handle = noise_show[n]
					noise_show_handle:set(0)
				end
			end
		else
			if math.deg(-antenna_az) < (math.deg(Radar.sz_azimuth_h:get())-40) or math.deg(-antenna_az) > (math.deg(Radar.sz_azimuth_h:get())+40) then
				for n = 0,NOISE_AMOUNT do
					local noise_show_handle = noise_show[n]
					local noise_range_handle = noise_range[n]
					local noise_azimuth_handle = noise_azimuth[n]
					local noise_opacity_handle = noise_opacity[n]
	
					local base_range = 40000.0 * 1.852
					local range = math.random(0, base_range)
					noise_show_handle:set(1)
					noise_range_handle:set(range)
					noise_azimuth_handle:set(-antenna_az)
					noise_opacity_handle:set(1.0)
				end
			else
				for n = 0,NOISE_AMOUNT do
					local noise_show_handle = noise_show[n]
					noise_show_handle:set(0)
				end
			end
		end

		----------------- NOISE END -------------
	
		Sensor_Data_Raw = get_base_data()
		
		Radar.tdc_ele_up_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() + (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))
		Radar.tdc_ele_down_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() - (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))	

		Radar.roll:set(Sensor_Data_Raw.getRoll())
		-- I don't think pitch is displayed in radar scope
		--Radar.pitch:set(Sensor_Data_Raw.getPitch())


		local contact_count = 0
		local skip_count = 0
		local skipped_distances = ""

		local aircraft_pitch = Sensor_Data_Raw.getPitch()
		local clearance_plane_metric = (clearance_plane / 3.28084)

		for ia = 1,BLOB_COUNT do

			if ia  < 10 then
			i = "_0".. ia .."_"
			else
				i = "_".. ia .."_"
			end

			local radar_contact_time_handle = radar_contact_time[i]
			local radar_contact_rcs_handle = radar_contact_rcs[i]
			local radar_contact_range_handle = radar_contact_range[i]
			local radar_contact_azimuth_handle = radar_contact_azimuth[i]
			local radar_contact_elevation_handle = radar_contact_elevation[i]

			local blob_show_handle = blob_show[i]
			local blob_opacity_handle = blob_opacity[i]
			local blob_scale_handle = blob_scale[i]
			local blob_range_handle = blob_range[i]
			local blob_azimuth_handle = blob_azimuth[i]

			local time = radar_contact_time_handle:get()		
			local rcs = radar_contact_rcs_handle:get()
			local range = radar_contact_range_handle:get()
			local azimuth = radar_contact_azimuth_handle:get()
			local elevation = radar_contact_elevation_handle:get()

			if time >= 0 and time <= memory then

				if remove_ground_clutter == 1 and rcs > 49.0 then
					blob_show_handle:set(0)
				else
					--local base_opacity = rcs/3 -- means 0...1
					local base_opacity = 1.0
					local opacity = base_opacity - (base_opacity * (time/memory))
					blob_opacity_handle:set(opacity)
			
					local scaled_range = range
					if range_sweep_switch == 0 then
						scaled_range = range * 4
					elseif range_sweep_switch == 1 then
						scaled_range = range * 2
					end
					blob_scale_handle:set(scaled_range / MAX_RANGE)
					blob_range_handle:set(scaled_range)

					blob_azimuth_handle:set(azimuth)

					if current_mode == 5 or current_mode == 6 then -- CM or TA
						-- check clearance plane
						local blob_elevation = elevation
						--if current_mode == 5 then
						--	-- TODO: use air data computer instead
						--	blob_elevation = blob_elevation - aircraft_pitch
						--end
						local vertical_distance = math.sin(blob_elevation) * range
						if vertical_distance < clearance_plane_metric then
							blob_show_handle:set(0)
							--skip_count = skip_count + 1
							--skipped_distances = skipped_distances .. ", " .. (vertical_distance *  3.28084)
						else
							blob_show_handle:set(1)
						end
					else
						blob_show_handle:set(1)
					end

					contact_count = contact_count + 1
				end
			else
				blob_show_handle:set(0)

				blob_opacity_handle:set(0.0)

				blob_range_handle:set(0.0)
				blob_azimuth_handle:set(0.0)
			end
		end

		--print_message_to_user("Below clearance: " .. skip_count .. ": " .. skipped_distances )
	end
end


