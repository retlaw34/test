// I am not a good programmer, if you can figure out a better way to do... THIS, then please let me know

GLOBAL_VAR_INIT(retro_mode, FALSE) //used in case i need to have a normal round and cant have this untmed
GLOBAL_LIST_EMPTY(things_to_retrofy)

/obj/machinery
	var/retro_icon
	var/can_retroify = FALSE

/obj/machinery/Initialize()
	. = ..()
	if(!can_retroify || !retro_icon)
		return
	GLOB.things_to_retrofy += src
	if(GLOB.retro_mode == TRUE)
		retroify()

/obj/machinery/proc/retroify()
	if(!can_retroify || !retro_icon)
		return
	icon = retro_icon
	cut_overlays()
	update_icon()

/obj/machinery/computer
	retro_icon = 'modular_thabes/modules/icons/oldaesth/computer.dmi'
	can_retroify = TRUE

/obj/machinery/modular_computer/console
	retro_icon = 'modular_thabes/modules/icons/oldaesth/modular_console.dmi'
	can_retroify = TRUE

/obj/machinery/power/smes
	retro_icon = 'modular_thabes/modules/icons/oldaesth/smes.dmi'
	can_retroify = TRUE

/obj/machinery/power/apc
	retro_icon = 'modular_thabes/modules/icons/oldaesth/power.dmi'
	can_retroify = TRUE

/obj/machinery/rnd
	retro_icon = 'modular_thabes/modules/icons/oldaesth/research.dmi'
	can_retroify = TRUE

/obj/machinery/autolathe
	retro_icon = 'modular_thabes/modules/icons/oldaesth/stationobjs.dmi'
	can_retroify = TRUE

/obj/machinery/blackbox_recorder
	retro_icon = 'modular_thabes/modules/icons/oldaesth/stationobjs.dmi'
	can_retroify = TRUE

/obj/machinery/blackbox_recorder/retroify()
	. = ..()
	name = "blackbox recorder"
	desc = "A device used for logging almost everything about a ship. While it is useful for tracking data after a crash, it's main purpose is for storing data for AI flight units."

/obj/item/blackbox/Initialize()
	. = ..()
	if(GLOB.retro_mode == TRUE)
		return
	name = "\proper blackbox"
	desc = "A bulky piece of machinery that contains logs of almost all ship data for the AI flight unit. You hope these bulky things are phased out in the next 100 years as they are a pain to handle."

/datum/admins/proc/toggleretro()
	set name="Enable Retrosthetics"
	set desc="Retrofies machines, meant for events ONLY"
	set category = "Server"

	if(GLOB.retro_mode == TRUE)
		to_chat(usr, span_alert("Retrosthetics is already enabled! If you really need to disable it, restart the server!"), confidential = TRUE)
		return

	var/ask = alert("Are you SURE you want to do this?\nThis cannot be undone without a restart!!!", "Enable Retrosthetics", "Yes", "No")
	if(ask != "Yes")
		return TRUE
	else
		GLOB.retro_mode = TRUE
		message_admins("[key_name(usr)] enabled Retrosthetics.")
		log_admin("[key_name(usr)] enabled Retrosthetics.")
		for(var/obj/machinery/current_machine as anything in GLOB.things_to_retrofy)
			current_machine.retroify()


