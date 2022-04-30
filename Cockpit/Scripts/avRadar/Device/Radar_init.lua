dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "definitions.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avImprovedRadar')

render_debug_info 		= false
power_bus_handle = ELECTRIC_SYSTEM.NO_2_AC_BUS

range_scale 		  	= 60000.0
TDC_range_carret_size 	= 5000


local BLOB_COUNT = 2500
local NOISE_COUNT = 100



perfomance = 
{
	roll_compensation_limits	= {math.rad(-180.0), math.rad(180.0)},
	pitch_compensation_limits	= {math.rad(-57.0), math.rad(20.0)}, -- according to T.O. 1F-104G-1 p. 4-89
	
	-- NASARR in "A/A Search" mode:
	-- 90° azimuth
	-- 2 lines of 5°
	scan_volume_azimuth 	= math.rad(90),	-- according to T.O. 1F-104G-1 p. 4-89	
	scan_volume_elevation	= math.rad(10),	-- according to T.O. 1F-104G-1 p. 4-89
	scan_beam				= math.rad(5), -- A/A

	-- NASARR in "Terrain Map" mode:
	--scan_volume_elevation	= math.rad(55),	-- A/G	
	--scan_beam				= math.rad(55),  -- A/G



	scan_speed				= math.rad(3*60), -- is not working, confirmed in test
	
	tracking_azimuth   			= { -math.rad(45),math.rad(45)}, -- most likely 90°
	tracking_elevation 			= { -math.rad(38),math.rad(20)}, -- most likely the antenna tilt limits

	max_available_distance  = 40000.0 * 1.852, --/ 0.66, -- to nautical miles
	dead_zone 				= 300.0, -- can't be set via config
	
	ground_clutter =
	{-- spot RCS = A + B * random + C * random 
		sea		   	   = {0,0,0}, -- no return from sea
		land 	   	   = {2,0,0},
		artificial 	   = {3,0,0},
		rays_density   = 0.05, --0.05,
		max_distance   = 40000 * 1.852, --/ 0.66, -- to nautical miles, devide by 0.6666 to compensate reduced range against ground
	}	
}


------------------------------------------------------------------------------

dev 	    	= GetSelf()
DEBUG_ACTIVE 	= true



--update_time_step 	= 0.05
--device_timer_dt		= 0.05
update_time_step 	= 0.05
device_timer_dt		= 0.05

make_default_activity(update_time_step) 


local offset = 0;

local air_elevation = 10
local air_beam = 5
local air_speed = 90

local ground_elevation = 6.2
local ground_beam = 6.2
local ground_speed = 180 -- must be increase for some unknown reason, otherwise nothing is spotted

local spoiled_elevation = 55
local spoiled_beam = 55
local spoiled_speed = 90


-- 0 = A/A
-- 1 = Ground Map
-- 2 = Ground Pencil
-- 3 = Terrain Avoidance
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




	antenna_azimuth_h 		= get_param_handle("ANTENNA_AZIMUTH"),
}

local noise_show = {}
local noise_range = {}
local noise_azimuth = {}

for i = 0,NOISE_COUNT do	
	noise_show[i] = get_param_handle("NOISE_"..i.."_SHOW")
	noise_range[i] = get_param_handle("NOISE_"..i.."_RANGE")
	noise_azimuth[i] = get_param_handle("NOISE_"..i.."_AZIMUTH")
end


local radar_contact_time = {}
local radar_contact_rcs = {}
local radar_contact_range = {}
local radar_contact_azimuth = {}

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

	blob_show[i] = get_param_handle("BLOB"..i.."SHOW")
	blob_opacity[i] = get_param_handle("BLOB"..i.."OPACITY")
	blob_scale[i] = get_param_handle("BLOB"..i.."SCALE")
	blob_range[i] = get_param_handle("BLOB"..i.."RANGE")
	blob_azimuth[i] = get_param_handle("BLOB"..i.."AZIMUTH")
end


function post_initialize()

	print_message_to_user("Radar - INIT")
		
	-- most likely not used
	dev:listen_command(100)		--iCommandPlaneChangeLock
		
	dev:listen_command(139)		--scanzone left // iCommandSelecterLeft
	dev:listen_command(140)		--scanzone right // iCommandSelecterRight
		
	dev:listen_command(141)		--scanzone up//iCommandSelecterUp
	dev:listen_command(142)		--scanzone down//iCommandSelecterDown
		
	-- most likely not used
	dev:listen_command(394)		--change PRF (radar puls freqency)//iCommandPlaneChangeRadarPRF
	
	dev:listen_command(509)		--lock start//iCommandPlane_LockOn_start
	dev:listen_command(510)		--lock finish//iCommandPlane_LockOn_finish
	
	-- most likely not used
	dev:listen_command(285)		--Change radar mode RWS/TWS //iCommandPlaneRadarChangeMode
		

	-- not used!
	dev:listen_command(2025)	--iCommandPlaneRadarHorizontal
	dev:listen_command(2026)	--iCommandPlaneRadarVertical

	-- used!
	dev:listen_command(2031)	--iCommandPlaneSelecterHorizontal
	dev:listen_command(2032)	--iCommandPlaneSelecterVertical




	dev:listen_command(Keys.GunPipper_Up)
	dev:listen_command(Keys.GunPipper_Down)
	dev:listen_command(Keys.GunPipper_Center)
	dev:listen_command(Keys.GunPipper_Automatic) 
		
		
	Radar.opt_pb_stab_h:set(1)
	--Radar.opt_pitch_stab_h:set(1) -- doesn't work
	--Radar.opt_bank_stab_h:set(1) -- doesn't work
	Radar.sz_elevation_h:set(math.rad(0))
		
	if avImprovedRadar.Setup(dev) == true then
		print_message_to_user("ImprovedRadar setup: succesful")
		avImprovedRadar.set_scan_speed(math.rad(90)) -- degree per second?
	else
		print_message_to_user("ImprovedRadar setup: failed")
	end
	
end

function SetCommand(command,value)
	--print_message_to_user(string.format("Radar SetCom: C %i   V%.8f",command,value))
	
---------------------------------------------------------------------
	--
	--if command == 141 and value == 0.0 then
	--	Radar.sz_elevation_h:set(Radar.sz_elevation_h:get() + 0.003)
	--elseif command == 142 and value == 0.0 then
	--	Radar.sz_elevation_h:set(Radar.sz_elevation_h:get() - 0.003)
	--end
	--
	--if command == 139 and value == 0.0 then
	--	Radar.sz_azimuth_h:set(Radar.sz_azimuth_h:get() + 0.003)
	--elseif command == 140 and value == 0.0 then
	--	Radar.sz_azimuth_h:set(Radar.sz_azimuth_h:get() - 0.003)
	--end
	--
----------------------------------------------------------------------	
	
	if Radar.tdc_range_h:get() > 20000 then
		Radar.tdc_range_h:set(20000)
	elseif Radar.tdc_range_h:get() < 0 then
		Radar.tdc_range_h:set(0)
	end
		
	if Radar.tdc_azi_h:get() > 0.5 then
		Radar.tdc_azi_h:set(0.5)
	elseif Radar.tdc_azi_h:get() < -0.5 then
		Radar.tdc_azi_h:set(-0.5)
	end
	
-------------------------------------------------
	
	if command == 2032  then
		Radar.tdc_range_h:set(Radar.tdc_range_h:get()- value*200000)
		--print_message_to_user("RadarRangeUP/DOWN")		
	end
	
	if command == 2031  then
		Radar.tdc_azi_h:set(Radar.tdc_azi_h:get()+ value*10)
		--print_message_to_user("RadarRangeLeftRight")		
	end

-------------------------------------------------	
	
	--[[ NUR EIN TEST
	
	if command == 285 then
		Radar.mode_h:set(Radar.mode_h:get()+ 1)
		print_message_to_user("RadarModeChanged")
	end
	]]




	if command == Keys.GunPipper_Up then
		local new_elevation = Radar.sz_elevation_h:get() + math.rad(2)
		if new_elevation > math.rad(20) then
			new_elevation = math.rad(20)
		end
		Radar.sz_elevation_h:set(new_elevation)
		print_message_to_user("Antenna elevation: " .. math.deg(new_elevation))
	end
	
	if command == Keys.GunPipper_Down then
		local new_elevation = Radar.sz_elevation_h:get() - math.rad(2)
		if new_elevation < -(math.rad(38)) then
			new_elevation = -(math.rad(38))
		end
		Radar.sz_elevation_h:set(new_elevation)
		print_message_to_user("Antenna elevation: " .. math.deg(new_elevation))
	end
	
	
	if command == Keys.GunPipper_Center then
		if range_sweep_switch == 0 then
			range_sweep_switch = range_sweep_switch + 1
			print_message_to_user("Range: " .. ranges[range_sweep_switch])
		elseif range_sweep_switch == 1 then
			range_sweep_switch = range_sweep_switch + 1
			print_message_to_user("Range: " .. ranges[range_sweep_switch])
		elseif range_sweep_switch == 2 then
			range_sweep_switch = 0
			print_message_to_user("Range: " .. ranges[range_sweep_switch])
		end
	end
	
	if command == Keys.GunPipper_Automatic then
		-- change mode:
		if current_mode == 0 then
			current_mode = current_mode + 1
			print_message_to_user("Radar: " .. modes[current_mode])
						
			-- SBY

		elseif current_mode == 1 then
			current_mode = current_mode + 1
			print_message_to_user("Radar: " .. modes[current_mode])
						
			-- A/A			
			avImprovedRadar.set_scan_beam(math.rad(air_beam))
			Radar.sz_volume_elevation_h:set(math.rad(air_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(air_speed))


		elseif current_mode == 2 then
			current_mode = current_mode + 1
			print_message_to_user("Radar: " .. modes[current_mode])

			-- GMP
			avImprovedRadar.set_scan_beam(math.rad(ground_beam))
			Radar.sz_volume_elevation_h:set(math.rad(ground_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(ground_speed))

		elseif current_mode == 3 then
			current_mode = current_mode + 1
			print_message_to_user("Radar: " .. modes[current_mode])

			-- GMS
			avImprovedRadar.set_scan_beam(math.rad(spoiled_beam))
			Radar.sz_volume_elevation_h:set(math.rad(spoiled_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(spoiled_speed))

		elseif current_mode == 4 then
			current_mode = current_mode + 1
			print_message_to_user("Radar: " .. modes[current_mode])

			-- CM
			avImprovedRadar.set_scan_beam(math.rad(ground_beam))
			Radar.sz_volume_elevation_h:set(math.rad(ground_elevation))
			Radar.opt_pb_stab_h:set(1)
			avImprovedRadar.set_scan_speed(math.rad(ground_speed))

		elseif current_mode == 5 then
			current_mode = current_mode + 1
			print_message_to_user("Radar: " .. modes[current_mode])

			-- TA
			avImprovedRadar.set_scan_beam(math.rad(ground_beam))
			Radar.sz_volume_elevation_h:set(math.rad(ground_elevation))
			Radar.opt_pb_stab_h:set(0)
			avImprovedRadar.set_scan_speed(math.rad(ground_speed))

		elseif current_mode == 6 then
			current_mode = current_mode + 1
			print_message_to_user("Radar: " .. modes[current_mode])

			-- A/G

		elseif current_mode == 7 then
			current_mode = 0
			print_message_to_user("Radar: " .. modes[current_mode])

			-- OFF
		end
	end


end

local current_noise_range = 0

function update()
	
	local antenna_az = avImprovedRadar.get_antenna_azimuth()
	local antenna_el = avImprovedRadar.get_antenna_elevation()
	--print_message_to_user("antenna_azimuth: " .. math.deg(antenna_az) .. " antenna_elevation: " .. math.deg(antenna_el))

	Radar.antenna_azimuth_h:set(-antenna_az)

	--local value = avImprovedRadar.GetDouble()
	--print_message_to_user("Offset: " .. offset .. " Value: " .. value)

	Sensor_Data_Raw = get_base_data()
		
	Radar.tdc_ele_up_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() + (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))
	Radar.tdc_ele_down_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() - (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))	

	local contact_count = 0

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

		local blob_show_handle = blob_show[i]
		local blob_opacity_handle = blob_opacity[i]
		local blob_scale_handle = blob_scale[i]
		local blob_range_handle = blob_range[i]
		local blob_azimuth_handle = blob_azimuth[i]

		local time = radar_contact_time_handle:get()		
		local rcs = radar_contact_rcs_handle:get()
		local range = radar_contact_range_handle:get()
		local azimuth = radar_contact_azimuth_handle:get()

		local memory = 3
		if time >= 0 and time <= memory then			

			local base_opacity = ((255/3)*rcs)
			blob_opacity_handle:set(base_opacity-((base_opacity/memory)*time))
			--blob_opacity_handle:set(255)

			local base_range = 40000.0 * 1.852
			if range_sweep_switch == 0 then
				range = range * 4
			elseif range_sweep_switch == 1 then
				range = range * 2
			end
			blob_scale_handle:set(range / base_range)
			blob_range_handle:set(range)

			blob_azimuth_handle:set(azimuth)

			blob_show_handle:set(1)

			contact_count = contact_count + 1
		else
			blob_show_handle:set(0)

			blob_opacity_handle:set(0.0)

			blob_range_handle:set(0.0)
			blob_azimuth_handle:set(0.0)
		end
	end


	-- Add some noise at the current antenna azimuth
	local noise_amount = 25
	if antenna_az > math.rad(35) or antenna_az < math.rad(-35) then
		noise_amount = 50
	else 
		noise_amount = 5
	end

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


