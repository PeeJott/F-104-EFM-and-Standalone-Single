radar_api = 	{
	-- NONE = 0
	-- SCAN = 1
	-- ACQUISITION = 2
	-- TRACKING = 3
	-- BUILT_IN_TEST = 4
	mode_h 		= get_param_handle("RADAR_MODE"),	

	stt_range_h 	= get_param_handle("RADAR_STT_RANGE"),
	stt_azimuth_h 	= get_param_handle("RADAR_STT_AZIMUTH"),
	stt_elevation_h = get_param_handle("RADAR_STT_ELEVATION"),

	roll = get_param_handle("RADAR_ROLL"),
	pitch = get_param_handle("RADAR_PITCH"),
}
