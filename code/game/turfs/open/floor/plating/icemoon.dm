/turf/open/floor/plating/asteroid/snow
	gender = PLURAL
	name = "snow"
	desc = "Looks cold."
	icon = 'icons/turf/planetary/icemoon.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/icerock
	icon_state = "snow_0"
	icon_plating = null
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	slowdown = 1.5
	base_icon_state = "snow"
	max_icon_states = 3
	floor_variance = 75
	flags_1 = NONE
	planetary_atmos = TRUE
	footstep = FOOTSTEP_SNOW
	barefootstep = FOOTSTEP_SNOW
	clawfootstep = FOOTSTEP_SNOW
	layer = SNOW_TURF_LAYER
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_SNOWED)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_SNOWED)
	digResult = /obj/item/stack/sheet/mineral/snow
	// footprint vars
	var/entered_dirs
	var/exited_dirs
	var/list/smooth_icons =  list('icons/turf/floors/snow.dmi', 'icons/turf/floors/snow_2.dmi')

/turf/open/floor/plating/asteroid/snow/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-19, -19)
		transform = translation
		icon = pick(smooth_icons)
		icon_plating = null
	if(prob(floor_variance))
		add_overlay("snowalt_[rand(1,max_icon_states)]")

/turf/open/floor/plating/asteroid/snow/Entered(atom/movable/AM)
	. = ..()
	if(!iscarbon(AM) || (AM.movement_type & (FLYING|VENTCRAWLING|FLOATING|PHASING)))
		return
	if(!(entered_dirs & AM.dir))
		entered_dirs |= AM.dir
		update_appearance()

/turf/open/floor/plating/asteroid/snow/Exited(atom/movable/AM)
	. = ..()
	if(!iscarbon(AM) || (AM.movement_type & (FLYING|VENTCRAWLING|FLOATING|PHASING)))
		return
	if(!(exited_dirs & AM.dir))
		exited_dirs |= AM.dir
		update_appearance()

// adapted version of footprints' update_icon code
/turf/open/floor/plating/asteroid/snow/update_overlays()
	. = ..()
	for(var/Ddir in GLOB.cardinals)
		if(entered_dirs & Ddir)
			var/image/print = GLOB.bloody_footprints_cache["entered-snow-[Ddir]"]
			if(!print)
				print = image('icons/effects/footprints.dmi', "ice1", layer = TURF_DECAL_LAYER, dir = Ddir, pixel_x = 19, pixel_y = 19)
				GLOB.bloody_footprints_cache["entered-snow-[Ddir]"] = print
			. += print
		if(exited_dirs & Ddir)
			var/image/print = GLOB.bloody_footprints_cache["exited-snow-[Ddir]"]
			if(!print)
				print = image('icons/effects/footprints.dmi', "ice2", layer = TURF_DECAL_LAYER, dir = Ddir, pixel_x = 19, pixel_y = 19)
				GLOB.bloody_footprints_cache["exited-snow-[Ddir]"] = print
			. += print

// pretty much ripped wholesale from footprints' version of this proc
/turf/open/floor/plating/asteroid/snow/setDir(newdir)
	if(dir == newdir)
		return ..()

	var/ang_change = dir2angle(newdir) - dir2angle(dir)
	var/old_entered_dirs = entered_dirs
	var/old_exited_dirs = exited_dirs
	entered_dirs = 0
	exited_dirs = 0

	for(var/Ddir in GLOB.cardinals)
		var/NDir = angle2dir_cardinal(dir2angle(Ddir) + ang_change)
		if(old_entered_dirs & Ddir)
			entered_dirs |= NDir
		if(old_exited_dirs & Ddir)
			exited_dirs |= NDir

	update_appearance()
	return ..()

/turf/open/floor/plating/asteroid/snow/getDug()
	. = ..()
	ScrapeAway()

/turf/open/floor/plating/asteroid/snow/burn_tile()
	ScrapeAway()
	return TRUE

/turf/open/floor/plating/asteroid/snow/ex_act(severity, target)
	. = ..()
	ScrapeAway()

/turf/open/floor/plating/asteroid/snow/lit
	light_range = 2
	light_power = 1
	baseturfs = /turf/open/floor/plating/asteroid/icerock/lit

/turf/open/floor/plating/asteroid/snow/lit/whitesands
	baseturfs = /turf/open/floor/plating/asteroid/whitesands/lit
	initial_gas_mix = SANDPLANET_DEFAULT_ATMOS

/turf/open/floor/plating/asteroid/snow/lit/rockplanet
	baseturfs = /turf/open/floor/plating/asteroid/rockplanet/lit
	initial_gas_mix = ROCKPLANET_DEFAULT_ATMOS

/turf/open/floor/plating/asteroid/snow/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plating/asteroid/snow/temperatre
	initial_gas_mix = "o2=22;n2=82;TEMP=255.37"
	baseturfs = /turf/open/floor/plating/asteroid/icerock/temperate

/turf/open/floor/plating/asteroid/snow/atmosphere
	initial_gas_mix = FROZEN_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/plating/asteroid/snow/under
	icon_state = "snow_dug"
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/snow/under/lit
	light_range = 2
	light_power = 1

/turf/open/floor/plating/asteroid/icerock
	gender = PLURAL
	name = "icy rock"
	desc = "The coarse rock that covers the surface."
	icon = 'icons/turf/snow.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/icerock
	icon_state = "icemoon_ground_coarse1"
	icon_plating = null
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	base_icon_state = "icemoon_ground"
	flags_1 = NONE
	footstep = FOOTSTEP_ICE
	barefootstep = FOOTSTEP_ICE
	clawfootstep = FOOTSTEP_ICE
	layer = STONE_TURF_LAYER
	planetary_atmos = TRUE
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	digResult = /obj/item/stack/sheet/mineral/snow
	floor_variance = 0
	max_icon_states = 0
	dug = TRUE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_ASH_ROCKY)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_ASH_ROCKY)
	var/smooth_icon = 'icons/turf/floors/icerock.dmi'

/turf/open/floor/plating/asteroid/icerock/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-19, -19)
		transform = translation
		icon = smooth_icon

/turf/open/floor/plating/asteroid/icerock/lit
	light_range = 2
	light_power = 1

/turf/open/floor/plating/asteroid/icerock/cracked
	floor_variance = 0
	icon_state = "icemoon_ground_cracked"
	base_icon_state = "icemoon_ground_cracked"
	smoothing_flags = null
	layer = MID_TURF_LAYER

/turf/open/floor/plating/asteroid/icerock/smooth
	floor_variance = 0
	icon_state = "icemoon_ground_smooth"
	base_icon_state = "icemoon_ground_smooth"
	smoothing_flags = null
	layer = MID_TURF_LAYER

/turf/open/floor/plating/asteroid/icerock/temperate
	initial_gas_mix = "o2=22;n2=82;TEMP=255.37"

/turf/open/floor/plating/asteroid/iceberg
	gender = PLURAL
	name = "cracked ice floor"
	desc = "A sheet of solid ice. It seems too cracked to be slippery anymore."
	icon = 'icons/turf/planetary/icemoon.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/iceberg
	icon_state = "iceberg"
	icon_plating = "iceberg"
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	base_icon_state = "iceberg_"
	flags_1 = NONE
	footstep = FOOTSTEP_ICE
	barefootstep = FOOTSTEP_ICE
	clawfootstep = FOOTSTEP_ICE
	planetary_atmos = TRUE
	broken_states = list("iceberg")
	burnt_states = list("iceberg")
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	digResult = /obj/item/stack/sheet/mineral/snow
	floor_variance = 100
	max_icon_states = 3
	dug = TRUE

/turf/open/floor/plating/asteroid/iceberg/lit
	light_range = 2
	light_power = 1


/turf/open/floor/plating/asteroid/snow/icemoon
	baseturfs = /turf/open/openspace/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	slowdown = 0

/turf/open/lava/plasma/ice_moon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/lava/plasma/ice_moon
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/snow/ice
	name = "icy snow"
	desc = "Looks colder."
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice
	initial_gas_mix = "o2=0;n2=82;plasma=24;TEMP=120"
	floor_variance = 0
	icon_state = "snow-ice"
	icon_plating = "snow-ice"
	base_icon_state = "snow_cavern"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	max_icon_states = 7

/turf/open/floor/plating/asteroid/snow/ice/icemoon
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	planetary_atmos = TRUE
	slowdown = 0

/turf/open/floor/plating/asteroid/snow/ice/burn_tile()
	return FALSE

