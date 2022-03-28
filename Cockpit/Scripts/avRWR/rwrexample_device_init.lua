--put this line into your device_init.lua
--dofile(LockOn_Options.script_path.."avRWR_example/rwrexample_device_init.lua")

--[[
in the part where you define your AC, you need to specify the radar:


Sensors = {
		RADAR = "N-019", -- Radar type
		--RADAR = "AN/APQ-159",
		},

]]--

		


		
	creators[130]	= 	{"avSimpleElectricSystem",
						 LockOn_Options.script_path.."avRWR/miscSystems/simple_electric_system.lua"}

							
	creators[140]	  = {"avSimpleRWR",
						 LockOn_Options.script_path.."avRWR/device/RWR_init.lua"}						
------------------------------------------------------------------------------------------------------------								  
-- INDICATORS ----------------------------------------------------------------------------------------------
----
indicators[#indicators + 1] = 	{
								"ccIndicator",
								LockOn_Options.script_path.."avRWR/indicator/init.lua",
								nil,
								{	
									--{},
									{"TEWS-PLASHKA-CENTER", "TEWS-PLASHKA-DOWN", "TEWS-PLASHKA-RIGHT"},   -- initial geometry anchor , triple of connector names. Mal zunächst nur 3 statt 4 ILS-PLASHKE-UP mal ausgelassen
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
						
		
								
								