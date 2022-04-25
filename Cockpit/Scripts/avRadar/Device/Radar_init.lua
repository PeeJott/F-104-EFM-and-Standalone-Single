dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "definitions.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avImprovedRadar')

render_debug_info 		= false
power_bus_handle = ELECTRIC_SYSTEM.NO_2_AC_BUS

range_scale 		  	= 60000.0
TDC_range_carret_size 	= 5000

perfomance = 
{
	roll_compensation_limits	= {math.rad(-180.0), math.rad(180.0)},
	pitch_compensation_limits	= {math.rad(-57.0), math.rad(20.0)}, -- according to T.O. 1F-104G-1 p. 4-89
	
	-- NASARR in "A/A Search" mode:
	-- 90° azimuth
	-- 2 lines of 5°
	scan_volume_azimuth 	= math.rad(90),	-- according to T.O. 1F-104G-1 p. 4-89	
	--scan_volume_elevation	= math.rad(10),	-- according to T.O. 1F-104G-1 p. 4-89
	--scan_beam				= math.rad(5), -- A/A

	-- NASARR in "Terrain Map" mode:
	scan_volume_elevation	= math.rad(55),	-- A/G	
	scan_beam				= math.rad(55),  -- A/G



	scan_speed				= math.rad(3*60), -- is not working, confirmed in test
	
	tracking_azimuth   			= { -math.rad(45),math.rad(45)}, -- most likely 90°
	tracking_elevation 			= { -math.rad(38),math.rad(20)}, -- most likely the antenna tilt limits

	max_available_distance  = 40000.0 * 1.852, -- to nautical miles
	dead_zone 				= 300.0, -- can't be set via config
	
	ground_clutter =
	{-- spot RCS = A + B * random + C * random 
		sea		   	   = {0,0,0}, -- no return from sea
		land 	   	   = {2,0,0},
		artificial 	   = {3,0,0},
		rays_density   = 0.1, --0.05,  -- used?
		max_distance   = 40000 * 1.852, -- to nautical miles
	}	
}


------------------------------------------------------------------------------

dev 	    	= GetSelf()
DEBUG_ACTIVE 	= true



update_time_step 	= 0.05
device_timer_dt		= 0.05

make_default_activity(update_time_step) 



local offset = 0;


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
		print_message_to_user("Antenna elevation: " .. new_elevation)
	end
	
	if command == Keys.GunPipper_Down then
		local new_elevation = Radar.sz_elevation_h:get() - math.rad(2)
		if new_elevation < -(math.rad(38)) then
			new_elevation = -(math.rad(38))
		end
		Radar.sz_elevation_h:set(new_elevation)
		print_message_to_user("Antenna elevation: " .. new_elevation)
	end
	
end


function update()
	
	local antenna_az = avImprovedRadar.get_antenna_azimuth()
	local antenna_el = avImprovedRadar.get_antenna_elevation()
	print_message_to_user("antenna_azimuth: " .. math.deg(antenna_az) .. " antenna_elevation: " .. math.deg(antenna_el))

	Radar.antenna_azimuth_h:set(-antenna_az)

	--local value = avImprovedRadar.GetDouble()
	--print_message_to_user("Offset: " .. offset .. " Value: " .. value)

	Sensor_Data_Raw = get_base_data()
		
	Radar.tdc_ele_up_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() + (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))
	Radar.tdc_ele_down_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() - (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))	
end


