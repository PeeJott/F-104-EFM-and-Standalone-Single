--put this line into your device_init.lua
--dofile(LockOn_Options.script_path.."avRadar_example/radarexample_device_init.lua")

--[[
in the part where you define your AC, you need to specify the radar:


Sensors = {
		RADAR = "N-019", -- Radar type
		--RADAR = "AN/APQ-159",
		},

]]--

		


		
--	creators[130]	= 	{ 
--									"avSimpleElectricSystem",
--									LockOn_Options.script_path.."avRadar/miscSystems/simple_electric_system.lua"
--								}

	creators[131]		= {	"avSimpleRadar"			,
							LockOn_Options.script_path.."avRadar/Device/Radar_init.lua"}
------------------------------------------------------------------------------------------------------------								  
-- INDICATORS ----------------------------------------------------------------------------------------------
----
	indicators[#indicators + 1] = 	{
										"ccIndicator",
										
										LockOn_Options.script_path.."avRadar/indicator/init.lua",
										nil,
									--	devices.avionics,
										{	
											{"RADAR-PLASHKA-CENTER", "RADAR-PLASHKA-DOWN", "RADAR-PLASHKA-RIGHT"},   -- initial geometry anchor , triple of connector names. Mal zunächst nur 3 statt 4 ILS-PLASHKE-UP mal ausgelassen
											{
												sx_l =  0,  -- center position correction in meters (+forward , -backward)
												sy_l =  0,  -- center position correction in meters (+up , -down)
												sz_l =  0,  -- center position correction in meters (-left , +right)
												sh   =  0,  -- half height correction 
												sw   =  0,  -- half width correction 
												rz_l =  0,  -- rotation corrections
												rx_l =  0,
												ry_l =  0
											}
										}
									}			

	



------------------------------------------------------------------------------------------------------------								
------------------------------------------------------------------------------------------------------------								
------------------------------------------------------------------------------------------------------------								
		
								
								