

-- global defintions


ELECTRIC_SYSTEM = {
	GROUND_POWER = "GROUND_POWER",
	-- AC
	NO_1_PRIMARY_AC_BUS = "NO_1_PRIMARY_AC_BUS",
	NO_1_SECONDARY_AC_BUS = "NO_1_SECONDARY_AC_BUS",
	NO_2_AC_BUS = "NO_2_AC_BUS",
	EMERGENCY_AC_BUS = "EMERGENCY_AC_BUS", -- AN/ARC-522 UHF COMMAND RADIO
	PRIMARY_FIXED_FEQUENCY_AC_BUS = "PRIMARY_FIXED_FEQUENCY_AC_BUS",
	SECONDARY_FIXED_FEQUENCY_AC_BUS = "SECONDARY_FIXED_FEQUENCY_AC_BUS",
	ENGINE_INSTRUMENTS_AND_INDICATOR_POWER = "ENGINE_INSTRUMENTS_AND_INDICATOR_POWER",
	-- DC
	PRIMARY_DC_BUS = "PRIMARY_DC_BUS",
	NO_1_EMERGENCY_DC_BUS = "NO_1_EMERGENCY_DC_BUS",
	NO_1_BATTERY_BUS = "NO_2_EMERGENCY_DC_BUS", -- EMERGENCY INTERPHONE AND UHF
	NO_2_EMERGENCY_DC_BUS = "NO_2_EMERGENCY_DC_BUS",	
	NO_2_BATTERY_BUS = "NO_2_EMERGENCY_DC_BUS",
}


PYLON = {
	-- Name to station number
	LH_TIP = 1,
	-- 104S = 2
	LH_PYLON = 3,				
	LH_FUS = 4,				
	--CENTERLINE = 5,
	RH_FUS = 6,
	RH_PYLON = 7,
	-- 104S = 8
	RH_TIP = 9,				
}

