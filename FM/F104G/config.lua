-- BEGIN -- this part of the file is not intended for an end-user editing
--[[ --------------------------------------------------------------- ]]--

-- damage_omega = 30.0, -- (deg?) speed threshold of jamming during impact of rotation limiter
-- state_angle_0 = 6.131341662, -- (deg?) designed angle of retracted gear with horizontal axis of plane
-- state_angle_1 = -2.995164152, -- (deg?) designed angle of released gear with vertical axis of plane
-- mount_pivot_x = -0.274, -- (m) X-coordinate of attachment to fuselage in body-axis system
-- mount_post_radius = 0.657, -- (m) distance from strut-axis to attachment point of piston to gear stand
-- mount_length = 0.604555117, -- (m) What is the difference between this and the post_radius? length of angle brace in retracted configuration
-- mount_angle_1 = -3.138548523, -- (deg?) length of Position (vector) from attaxhment point
-- post_length = 1.748, -- (m) distance from rotation-axis of strut to wheel-axis
-- wheel_axle_offset = 0.05, -- (m) displacement wheel axis relative to strut
-- self_attitude = false, -- true if gear is self-oriented (Alba or Yak-52 example)

-- amortizer_min_length = 0.0, -- (m) rate of (minimum spring lenght / minimum length of damper)
-- amortizer_max_length = 0.397, -- (m) same as previous but max length
-- amortizer_basic_length = 0.397, -- (m) rate of (spring length in free (without load) condition / damper length in free (without load) condition)
-- amortizer_spring_force_factor = 1.6e+13, -- (??) spring tension factor (see k Wik)
-- amortizer_spring_force_factor_rate = 20.0, -- (??) Степень probably not full comment
-- amortizer_static_force = 80000.0, -- (N?) static reaction force of damper
-- amortizer_reduce_length = 0.377, -- (m) total suspension compression distance in non-load condition
-- amortizer_direct_damper_force_factor = 45000.0, -- (??) damper of positive movement
-- amortizer_back_damper_force_factor = 15000.0, -- (??) damper of negative (reversed) movement

-- wheel_radius = 0.308, -- (m) Tire radius
-- wheel_static_friction_factor = 0.65 , -- (unitless) Static friction factor when wheel not moves
-- wheel_roll_friction_factor = 0.025, -- (unitless) Rolling friction factor when wheel not moves
-- wheel_damage_force_factor = 250.0, --wheel cover (tire) strength force (not sure)
-- wheel_brake_moment_max = 15000, -- (N-m) Max braking moment torque

-- moment_od_inertia (old) =  {38912  ,254758,223845,-705},--Ix,Iy,Iz,Ixy

local mainGear = {
	--amortizer_min_length					= 0.0,
	amortizer_max_length					= 0.291, --3D Modell
	amortizer_basic_length					= 0.291, --3D Modell
	amortizer_spring_force_factor			= 4.8e+6, --F16 = 2.1e+7, F15 = 990000.0,(reduce_length)
	amortizer_spring_force_factor_rate		= 3,
	amortizer_static_force					= 1000,
	amortizer_reduce_length					= 0.10, --0.05,
	amortizer_direct_damper_force_factor	= 60000,
	amortizer_back_damper_force_factor		= 20000,
	allowable_hard_contact_length			= 0.1,

	anti_skid_installed = true,

	crossover_locked_wheel_protection			= true,
	crossover_locked_wheel_protection_speed_min	= 18.0,
	anti_skid_improved							= true,
	anti_skid_gain								= 400.0,

	wheel_radius					= 0.347, -- Ø 0.694 / 2
	wheel_static_friction_factor	= 0.70,
	wheel_glide_friction_factor		= 0.30,
	wheel_side_friction_factor		= 0.43,
	wheel_roll_friction_factor		= 0.04,
	wheel_damage_force_factor		= 500.0, --450.0,
	wheel_brake_moment_max			= 9500.0,
	wheel_kz_factor					= 0.52,
	noise_k							= 0.4,
	wheel_damage_speedX				= 225, --115,
	wheel_damage_delta_speedX		= 22.5, --11.5,
}


F104G = {
center_of_mass		= {-0.172  ,  -0.6,	   0},--x,y,z
moment_of_inertia 	= {4811 , 80900, 79465,-350},--Ix,Iy,Iz,Ixy// Ixy geschätzt
suspension 			= {
	  { -- NOSE WHEEL
			damage_element					= 83,
			wheel_axle_offset				= 0.0,
			self_attitude					= false,
			yaw_limit						= math.rad(32.0),
			moment_limit					= 750.0,
			damper_coeff					= 300.0,
			allowable_hard_contact_length	= 0.25,
			filter_yaw						= false,

			amortizer_min_length						= 0.0,
			amortizer_max_length						= 0.25, -- 3D Modell
			amortizer_basic_length						= 0.25, -- 3D Modell
			amortizer_spring_force_factor				= 5200000,
			amortizer_spring_force_factor_rate			= 3,
			amortizer_static_force						= 1000,
			amortizer_reduce_length						= 0.25, --0.05,
			amortizer_direct_damper_force_factor		= 35000,
			amortizer_back_damper_force_factor			= 15000,

			anti_skid_installed							= false,

			wheel_radius								= 0.22,	-- Ø 0.44 / 2
			wheel_static_friction_factor				= 0.65,
			wheel_side_friction_factor					= 0.72, --0.45,//was 0.60
			wheel_roll_friction_factor					= 0.05,
			wheel_glide_friction_factor					= 0.30,
			wheel_damage_force_factor					= 500.0, --450.0,
			wheel_kz_factor								= 0.3,
			noise_k										= 1.0,
			wheel_damage_speedX							= 225.0, --115,
			wheel_damage_delta_speedX					= 22.5, --11.5,

			arg_post			= 0,
			arg_amortizer		= 1,
			arg_wheel_rotation	= 101,
			arg_wheel_damage	= 134
		},
	  { -- LEFT WHEEL
			damage_element					= 84,

			amortizer_max_length						= mainGear.amortizer_max_length,
			amortizer_basic_length						= mainGear.amortizer_basic_length,
			amortizer_spring_force_factor				= mainGear.amortizer_spring_force_factor, --
			amortizer_spring_force_factor_rate			= mainGear.amortizer_spring_force_factor_rate,
			amortizer_static_force						= mainGear.amortizer_static_force,
			amortizer_reduce_length						= mainGear.amortizer_reduce_length,
			amortizer_direct_damper_force_factor		= mainGear.amortizer_direct_damper_force_factor,
			amortizer_back_damper_force_factor			= mainGear.amortizer_back_damper_force_factor,
			allowable_hard_contact_length				= mainGear.allowable_hard_contact_length,

			anti_skid_installed							= mainGear.anti_skid_installed,

			crossover_locked_wheel_protection			= mainGear.crossover_locked_wheel_protection,
			crossover_locked_wheel_protection_wheel		= 2,
			crossover_locked_wheel_protection_speed_min	= mainGear.crossover_locked_wheel_protection_speed_min,
			anti_skid_improved							= mainGear.anti_skid_improved;
			anti_skid_gain								= mainGear.anti_skid_gain,

			wheel_radius								= mainGear.wheel_radius,
			wheel_static_friction_factor				= mainGear.wheel_static_friction_factor,
			wheel_side_friction_factor					= mainGear.wheel_side_friction_factor,
			wheel_roll_friction_factor					= mainGear.wheel_roll_friction_factor,
			wheel_glide_friction_factor					= mainGear.wheel_glide_friction_factor,
			wheel_damage_force_factor					= mainGear.wheel_damage_force_factor,
			wheel_brake_moment_max						= mainGear.wheel_brake_moment_max,
			wheel_kz_factor								= mainGear.wheel_kz_factor,
			noise_k										= mainGear.noise_k,
			wheel_damage_speedX							= mainGear.wheel_damage_speedX,
			wheel_damage_delta_speedX					= mainGear.wheel_damage_delta_speedX,

			arg_post			= 5,
			arg_amortizer		= 6,
			arg_wheel_rotation	= 102,
			arg_wheel_damage	= 136
		},
		{  -- RIGHT WHEEL
			damage_element					= 85,

			amortizer_max_length						= mainGear.amortizer_max_length,
			amortizer_basic_length						= mainGear.amortizer_basic_length,
			amortizer_spring_force_factor				= mainGear.amortizer_spring_force_factor, --
			amortizer_spring_force_factor_rate			= mainGear.amortizer_spring_force_factor_rate,
			amortizer_static_force						= mainGear.amortizer_static_force,
			amortizer_reduce_length						= mainGear.amortizer_reduce_length,
			amortizer_direct_damper_force_factor		= mainGear.amortizer_direct_damper_force_factor,
			amortizer_back_damper_force_factor			= mainGear.amortizer_back_damper_force_factor,
			allowable_hard_contact_length				= mainGear.allowable_hard_contact_length,

			anti_skid_installed							= mainGear.anti_skid_installed,

			crossover_locked_wheel_protection			= mainGear.crossover_locked_wheel_protection,
			crossover_locked_wheel_protection_wheel		= 1,
			crossover_locked_wheel_protection_speed_min	= mainGear.crossover_locked_wheel_protection_speed_min,
			anti_skid_improved							= mainGear.anti_skid_improved;
			anti_skid_gain								= mainGear.anti_skid_gain,

			wheel_radius								= mainGear.wheel_radius,
			wheel_static_friction_factor				= mainGear.wheel_static_friction_factor,
			wheel_side_friction_factor					= mainGear.wheel_side_friction_factor,
			wheel_roll_friction_factor					= mainGear.wheel_roll_friction_factor,
			wheel_glide_friction_factor					= mainGear.wheel_glide_friction_factor,
			wheel_damage_force_factor					= mainGear.wheel_damage_force_factor,
			wheel_brake_moment_max						= mainGear.wheel_brake_moment_max,
			wheel_kz_factor								= mainGear.wheel_kz_factor,
			noise_k										= mainGear.noise_k,
			wheel_damage_speedX							= mainGear.wheel_damage_speedX,
			wheel_damage_delta_speedX					= mainGear.wheel_damage_delta_speedX,

			arg_post			= 3,
			arg_amortizer		= 4,
			arg_wheel_rotation	= 103,
			arg_wheel_damage	= 135
		},
	}, -- gears suspension
	
disable_built_in_oxygen_system	= true,
--[[ ------------------------------------------------------------- ]]--
-- END -- this part of the file is not intended for an end-user editing

	-- FFB force multiplier
	ffbPitchK	= 0.65,
	ffbRollK	= 0.65,

	-- view shake amplitude
	minor_shake_ampl = 0.07,
	major_shake_ampl = 0.25,


-- view shake amplitude
cs_shakeAoA0 				=   10, -- shake0 start at AoA 17° NEW//NEW 13° // NEW 10
cs_shakeAoA1 				= 	14, -- shake1 start at AoA 19° NEW// NEW 16° // NEW 14
cs_shakeNy0 				= 	5.5, -- shake0 start bei 6,5 Gs NEW//NEW 5,5 Gs
cs_shakeNy1 				= 	6.5, -- shake1 start at 7,5 Gs NEW//NEW 6,5 Gs
cs_shakeAmpl 				=   0.7, -- shake amplitude NEW // NEW 0.7
cs_shakeFreq 				= 	3,--5, -- shake frequency NEW // NEW 5

-- debug
debugLine = "{M}:%1.3f {IAS}:%4.1f {AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {AoS}:%2.1f {mass}:%2.1f {Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
record_enabled = false,
}