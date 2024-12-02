/turf/open/floor/plating/asteroid/shrouded
	name = "packed sand"
	desc = "Sand that has been packed into solid earth."
	icon = 'icons/turf/planetary/shrouded.dmi'

	icon_state = "sand-255"
	base_icon_state = "sand"

	floor_variance = 20
	max_icon_states = 8
	slowdown = 1.5
	planetary_atmos = TRUE
	initial_gas_mix = SHROUDED_DEFAULT_ATMOS
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND

	has_footsteps = TRUE
	footstep_icon_state = "shrouded"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_ASH)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_ASH)
	smooth_icon = 'icons/turf/floors/shroudedsand.dmi'
