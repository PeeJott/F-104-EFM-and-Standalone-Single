dofile(LockOn_Options.script_path.."definitions.lua")

render_debug_info 		= false
power_bus_handle = ELECTRIC_SYSTEM.NO_2_AC_BUS

range_scale 		  	= 60000.0
TDC_range_carret_size 	= 5000

perfomance = 
{
	roll_compensation_limits	= {math.rad(-180.0), math.rad(180.0)},
	pitch_compensation_limits	= {math.rad(-45.0), math.rad(45.0)},

	
	tracking_azimuth   			= { -math.rad(30),math.rad(30)},
	tracking_elevation 			= { -math.rad(30),math.rad(30)},--60° 
	
	scan_volume_azimuth 	= math.rad(60),		--is left+right so 60 is -30,30+
	scan_volume_elevation	= math.rad(30),		
	scan_beam				= math.rad(60),
	scan_speed				= math.rad(3*60),
	
	
	max_available_distance  = 20000.0,--200*60000.0, das ist denke ich in Metern. Das erhöhe ich mal von 20km auf 35nm, also auf 64820
	dead_zone 				= 300.0,
	
	ground_clutter =
	{-- spot RCS = A + B * random + C * random 
		sea		   	   = {0 ,0,0},
		land 	   	   = {0 ,0,0},		
		artificial 	   = {0 ,0,0},
		rays_density   = 0.01,
		max_distance   = 60000,
	}
	
}


------------------------------------------------------------------------------

dev 	    	= GetSelf()
DEBUG_ACTIVE 	= true



update_time_step 	= 0.01666		--0.166 --once every 6 times a sec
device_timer_dt		= 0.01666

make_default_activity(update_time_step) 



Radar = 	{
				-- NONE = 0
				-- SCAN = 1
				-- ACQUISITION = 2
				-- TRACKING = 3
				-- BUILT_IN_TEST = 4
				mode_h 		= get_param_handle("RADAR_MODE"),
				szoe_h 		= get_param_handle("SCAN_ZONE_ORIGIN_ELEVATION"),
				szoa_h 		= get_param_handle("SCAN_ZONE_ORIGIN_AZIMUTH"),
				
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
				
				ws_ir_slave_azimuth_h	= get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH"),
				ws_ir_slave_elevation_h	= get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION"),
				
				iff_status_h			= get_param_handle("IFF_INTERROGATOR_STATUS"),
				bit_h 					= get_param_handle("RADAR_BIT"),

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
		
		
		Radar.opt_pb_stab_h:set(1)
		Radar.opt_pitch_stab_h:set(1)
		Radar.opt_bank_stab_h:set(1)
		
	
end

function SetCommand(command,value)
	--print_message_to_user(string.format("Radar SetCom: C %i   V%.8f",command,value))
	
---------------------------------------------------------------------
	
	if command == 141 and value == 0.0 then
		Radar.sz_elevation_h:set(Radar.sz_elevation_h:get() + 0.003)
	elseif command == 142 and value == 0.0 then
		Radar.sz_elevation_h:set(Radar.sz_elevation_h:get() - 0.003)
	end
	
	if command == 139 and value == 0.0 then
		Radar.sz_azimuth_h:set(Radar.sz_azimuth_h:get() + 0.003)
	elseif command == 140 and value == 0.0 then
		Radar.sz_azimuth_h:set(Radar.sz_azimuth_h:get() - 0.003)
	end
	
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
	
	
end


function update()
	
	Sensor_Data_Raw = get_base_data()
		
	Radar.tdc_ele_up_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() + (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))
	Radar.tdc_ele_down_h:set(((Sensor_Data_Raw.getBarometricAltitude() + math.tan(Radar.sz_elevation_h:get() - (perfomance.scan_volume_elevation/2)  ) * Radar.tdc_range_h:get())))
	
 	mode = Radar.mode_h:get()
	
	if mode == 3 then -- TRACKING
		az = Radar.stt_azimuth_h:get()
		Radar.ws_ir_slave_azimuth_h:set(az)
		el = Radar.stt_elevation_h:get()
		Radar.ws_ir_slave_elevation_h:set(el)
	else
		Radar.ws_ir_slave_azimuth_h:set(0.0)
		Radar.ws_ir_slave_elevation_h:set(0.0)
	end
	
end


