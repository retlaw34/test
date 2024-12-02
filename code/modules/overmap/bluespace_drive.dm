#define JUMP_STATE_OFF 0
#define JUMP_STATE_CHARGING 1
#define JUMP_STATE_IONIZING 2
#define JUMP_STATE_FIRING 3
#define JUMP_STATE_FINALIZED 4
#define JUMP_CHARGE_DELAY (7 SECONDS)
#define JUMP_CHARGEUP_TIME (1 MINUTES)

/*
* Unfinished, for now it's nice decor for mappers.
* * Originally I was going to move the bluespace jump behavior otnot this device, then i realized this would require a lot of remapping, so I left it on the
*/

/obj/machinery/bluespace_drive
	name = "AU/W-class bluespace drive"
	desc = "Amazing innovations after studying the solarian sun have now compacted the massive AU-class bluespace rooms of the past into barely a 2 meter big machine. This in turn, vastly reduced vessel sizes, resulitng in a new age of space travel across the cosmos... and here the miracle sits silently, gathering dust as you forgot to clean it last week."
	icon = 'icons/obj/machines/bsdrive.dmi'
	icon_state = "bsdrive_left"
	var/icon_screen = "bsdrive_left_screen"
	circuit = /obj/item/circuitboard/computer/shuttle
	light_color = LIGHT_COLOR_CYAN
	clicksound = null

	/// The ship we reside on for ease of access
	var/datum/overmap/ship/controlled/current_ship
	/// When are we allowed to jump
	var/jump_allowed
	/// Current state of our jump
	var/jump_state = JUMP_STATE_OFF
	///if we are calibrating the jump
	var/calibrating = FALSE
	///holding jump timer ID
	var/jump_timer
	/// where are we jumping to, if null, deletes the ship
	var/datum/overmap_star_system/jump_destination

/datum/config_entry/number/bluespace_jump_wait
	default = 5 MINUTES

/obj/machinery/bluespace_drive/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	jump_allowed = world.time + CONFIG_GET(number/bluespace_jump_wait)

/obj/machinery/bluespace_drive/proc/calibrate_jump(inline = FALSE)
	if(jump_allowed < 0)
		say("Bluespace Jump Calibration offline. Please contact your system administrator.")
		return
	if(current_ship.docked_to || current_ship.docking)
		say("Bluespace Jump Calibration detected interference in the local area.")
		return
	if(world.time < jump_allowed)
		var/jump_wait = DisplayTimeText(jump_allowed - world.time)
		say("Bluespace Jump Calibration is currently recharging. ETA: [jump_wait].")
		return
	if(jump_state != JUMP_STATE_OFF && !inline)
		return // This exists to prefent Href exploits to call process_jump more than once by a client
	message_admins("[ADMIN_LOOKUPFLW(usr)] has initiated a bluespace jump in [ADMIN_VERBOSEJMP(src)]")
	jump_timer = addtimer(CALLBACK(src, PROC_REF(jump_sequence), TRUE), JUMP_CHARGEUP_TIME, TIMER_STOPPABLE)
	if(jump_destination)
		priority_announce("Bluespace jump calibration to destination [jump_destination.name] initialized. Calibration completion in [JUMP_CHARGEUP_TIME/600] minutes.", sender_override="[current_ship.name] Bluespace Pylon", zlevel=virtual_z())
	else
		priority_announce("Bluespace jump calibration initialized. Exitting Frontier. Calibration completion in [JUMP_CHARGEUP_TIME/600] minutes.", sender_override="[current_ship.name] Bluespace Pylon", zlevel=virtual_z())
	calibrating = TRUE
	return TRUE

/obj/machinery/bluespace_drive/proc/cancel_jump()
	priority_announce("Bluespace Pylon spooling down. Jump calibration aborted.", sender_override = "[current_ship.name] Bluespace Pylon", zlevel = virtual_z())
	calibrating = FALSE
	deltimer(jump_timer)

/obj/machinery/bluespace_drive/proc/jump_sequence()
	switch(jump_state)
		if(JUMP_STATE_OFF)
			jump_state = JUMP_STATE_CHARGING
			for(var/obj/machinery/computer/helm/currenthelm as anything in current_ship.helms)
				SStgui.close_uis(currenthelm)
		if(JUMP_STATE_CHARGING)
			jump_state = JUMP_STATE_IONIZING
			priority_announce("Bluespace Jump Calibration completed. Ionizing Bluespace Pylon.", sender_override = "[current_ship.name] Bluespace Pylon", zlevel = virtual_z())
		if(JUMP_STATE_IONIZING)
			jump_state = JUMP_STATE_FIRING
			priority_announce("Bluespace Ionization finalized; preparing to fire Bluespace Pylon.", sender_override = "[current_ship.name] Bluespace Pylon", zlevel = virtual_z())
		if(JUMP_STATE_FIRING)
			jump_state = JUMP_STATE_FINALIZED
			priority_announce("Bluespace Pylon launched.", sender_override = "[current_ship.name] Bluespace Pylon", sound = 'sound/magic/lightning_chargeup.ogg', zlevel = virtual_z())
			addtimer(CALLBACK(src, PROC_REF(do_jump)), 10 SECONDS)
			return
	if((machine_stat & NOPOWER))
		return cancel_jump()
	jump_timer = addtimer(CALLBACK(src, PROC_REF(jump_sequence), TRUE), JUMP_CHARGE_DELAY, TIMER_STOPPABLE)

/obj/machinery/bluespace_drive/proc/do_jump()
	if(jump_destination)
		priority_announce("Bluespace Jump Initiated. Welcome to [jump_destination.name]", sender_override = "[current_ship.name] Bluespace Pylon", sound = 'sound/magic/lightningbolt.ogg', zlevel = virtual_z())
	else
		priority_announce("Bluespace Jump Initiated.", sender_override = "[current_ship.name] Bluespace Pylon", sound = 'sound/magic/lightningbolt.ogg', zlevel = virtual_z())
	for(var/obj/machinery/computer/helm/currenthelm as anything in current_ship.helms)
		SStgui.close_uis(currenthelm)
	if(!jump_destination)
		qdel(current_ship)
		return
	current_ship.move_overmaps(jump_destination)
	jump_destination = null
	jump_state = JUMP_STATE_OFF
	calibrating = FALSE

/obj/machinery/bluespace_drive/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	current_ship = port.current_ship
	if(current_ship)
		current_ship.ship_modules[SHIPMODULE_BSDRIVE] = src

/obj/machinery/bluespace_drive/Destroy()
	if(current_ship)
		LAZYREMOVE(current_ship.ship_modules, src)
		current_ship = null
	return ..()

/obj/machinery/bluespace_drive/proc/handle_interact()
	if(calibrating)
		cancel_jump()
		return
	else
		if(length(SSovermap.tracked_star_systems) >= 1)
			var/list/choices = LAZYCOPY(SSovermap.tracked_star_systems)
			LAZYADD(choices, "Out of the Frontier")
			LAZYREMOVE(choices, current_ship.current_overmap)
			var/selected_system = tgui_input_list(usr, "To which system?", "Bluespace Jump", choices)
			if(selected_system == "Out of the Frontier")
				if(tgui_alert(usr, "Do you want to bluespace jump? Your ship and everything on it will be removed from the round.", "Jump Confirmation", list("Yes", "No")) != "Yes")
					return
				calibrate_jump()
				return
			if(!selected_system)
				return
			else
				jump_destination = selected_system
			calibrate_jump()
			return


		else
			if(tgui_alert(usr, "Do you want to bluespace jump? Your ship and everything on it will be removed from the round.", "Jump Confirmation", list("Yes", "No")) != "Yes")
				return
			calibrate_jump()
			return

/obj/machinery/bluespace_drive/power_change(area/A)
	. = ..()
	if((machine_stat & NOPOWER))
		if(calibrating)
			cancel_jump()



#undef JUMP_STATE_OFF
#undef JUMP_STATE_CHARGING
#undef JUMP_STATE_IONIZING
#undef JUMP_STATE_FIRING
#undef JUMP_STATE_FINALIZED
#undef JUMP_CHARGE_DELAY
#undef JUMP_CHARGEUP_TIME
