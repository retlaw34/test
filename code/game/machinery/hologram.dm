/* Holograms!
 * Contains:
 *		Holopad
 *		Hologram
 *		Other stuff
 */

/*
Revised. Original based on space ninja hologram code. Which is also mine. /N
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Any number of AIs can use a holopad. /Lo6
AI may cancel the hologram at any time by clicking on the holopad once more.

Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effect to disable the unit.
*/


/*
 * Holopad
 */

#define HOLOPAD_PASSIVE_POWER_USAGE 1
#define HOLOGRAM_POWER_USAGE 2

/obj/machinery/holopad
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon_state = "holopad0"
	base_icon_state = "holopad"
	layer = LOW_OBJ_LAYER
	plane = FLOOR_PLANE
	req_access = list(ACCESS_KEYCARD_AUTH) //Used to allow for forced connecting to other (not secure) holopads. Anyone can make a call, though.
	use_power = IDLE_POWER_USE
	idle_power_usage = IDLE_DRAW_MINIMAL
	active_power_usage = ACTIVE_DRAW_MEDIUM
	max_integrity = 300
	armor = list("melee" = 50, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 0)
	circuit = /obj/item/circuitboard/machine/holopad
	/// List of living mobs that use the holopad
	var/list/masters
	/// Holoray-mob link
	var/list/holorays
	/// To prevent request spam. ~Carn
	var/last_request = 0
	/// Change to change how far the AI can move away from the holopad before deactivating
	var/holo_range = 5
	/// Array of /datum/holocalls
	var/list/holo_calls
	/// Currently outgoing holocall, do not modify the datums only check and call the public procs
	var/datum/holocall/outgoing_call
	/// Record disk
	var/obj/item/disk/holodisk/disk
	/// Currently replaying a recording
	var/replay_mode = FALSE
	/// Currently looping a recording
	var/loop_mode = FALSE
	/// Currently recording
	var/record_mode = FALSE
	/// Recording start time
	var/record_start = 0
	/// User that inititiated the recording
	var/record_user
	/// Replay hologram
	var/obj/effect/overlay/holo_pad_hologram/replay_holo
	/// Calls will be automatically answered after a couple rings, here for debugging
	var/static/force_answer_call = FALSE
	var/static/list/holopads = list()
	var/obj/effect/overlay/holoray/ray
	var/ringing = FALSE
	var/offset = FALSE
	var/on_network = TRUE
	/// For pads in secure areas; do not allow forced connecting
	var/secure = FALSE
	/// If we are currently calling another holopad
	var/calling = FALSE
	/// The last holopad that called this one.
	var/caller_history

/obj/machinery/holopad/Initialize()
	. = ..()
	become_hearing_sensitive(ROUNDSTART_TRAIT)

/obj/machinery/holopad/secure
	name = "secure holopad"
	desc = "It's a floor-mounted device for projecting holographic images. This one will refuse to auto-connect incoming calls."
	secure = TRUE

/obj/machinery/holopad/secure/Initialize()
	. = ..()
	var/obj/item/circuitboard/machine/holopad/board = circuit
	board.secure = TRUE
	board.build_path = /obj/machinery/holopad/secure

/obj/machinery/holopad/tutorial
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODECONSTRUCT_1
	on_network = FALSE
	///Proximity monitor associated with this atom, needed for proximity checks.
	var/datum/proximity_monitor/proximity_monitor
	var/proximity_range = 1

/obj/machinery/holopad/tutorial/Initialize(mapload)
	. = ..()
	if(proximity_range)
		proximity_monitor = new(src, proximity_range)
	if(mapload)
		var/obj/item/disk/holodisk/new_disk = locate(/obj/item/disk/holodisk) in src.loc
		if(new_disk && !disk)
			new_disk.forceMove(src)
			disk = new_disk

/obj/machinery/holopad/tutorial/attack_hand(mob/user)
	if(!istype(user))
		return
	if(user.incapacitated() || !is_operational)
		return
	if(replay_mode)
		replay_stop()
	else if(disk && disk.record)
		replay_start()

/obj/machinery/holopad/tutorial/HasProximity(atom/movable/AM)
	if (!isliving(AM))
		return
	if(!replay_mode && (disk && disk.record))
		replay_start()

/obj/machinery/holopad/Initialize()
	. = ..()
	if(on_network)
		holopads += src

/obj/machinery/holopad/Destroy()
	if(outgoing_call)
		outgoing_call.ConnectionFailure(src)

	for(var/I in holo_calls)
		var/datum/holocall/HC = I
		HC.ConnectionFailure(src)

	for (var/I in masters)
		clear_holo(I)

	if(replay_mode)
		replay_stop()
	if(record_mode)
		record_stop()

	QDEL_NULL(disk)

	holopads -= src
	return ..()

/obj/machinery/holopad/power_change()
	. = ..()
	if (!powered())
		if(replay_mode)
			replay_stop()
		if(record_mode)
			record_stop()
		if(outgoing_call)
			outgoing_call.ConnectionFailure(src)

/obj/machinery/holopad/obj_break()
	. = ..()
	if(outgoing_call)
		outgoing_call.ConnectionFailure(src)

/obj/machinery/holopad/RefreshParts()
	var/holograph_range = 4
	for(var/obj/item/stock_parts/capacitor/B in component_parts)
		holograph_range += 1 * B.rating
	holo_range = holograph_range

/obj/machinery/holopad/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Current projection range: <b>[holo_range]</b> units.")
		if(caller_history)
			. += span_notice("The caller history displays the last recieved call to be from: [caller_history].")

/obj/machinery/holopad/attackby(obj/item/P, mob/user, params)
	if(default_deconstruction_screwdriver(user, "holopad_open", "holopad0", P))
		return

	if(default_pry_open(P))
		return

	if(default_unfasten_wrench(user, P))
		return

	if(default_deconstruction_crowbar(P))
		return

	if(istype(P,/obj/item/disk/holodisk))
		if(disk)
			to_chat(user,span_warning("There's already a disk inside [src]!"))
			return
		if (!user.transferItemToLoc(P,src))
			return
		to_chat(user,span_notice("You insert [P] into [src]."))
		disk = P
		return

	return ..()

/obj/machinery/holopad/ui_status(mob/user)
	if(!is_operational)
		return UI_CLOSE
	if(outgoing_call && !calling)
		return UI_CLOSE
	return ..()

/obj/machinery/holopad/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holopad", name)
		ui.open()

/obj/machinery/holopad/ui_data(mob/user)
	var/list/data = list()
	data["calling"] = calling
	data["on_network"] = on_network
	data["on_cooldown"] = last_request + 200 < world.time ? FALSE : TRUE
	data["allowed"] = allowed(user)
	data["disk"] = disk ? TRUE : FALSE
	data["disk_record"] = disk?.record ? TRUE : FALSE
	data["replay_mode"] = replay_mode
	data["loop_mode"] = loop_mode
	data["record_mode"] = record_mode
	data["holo_calls"] = list()
	for(var/I in holo_calls)
		var/datum/holocall/HC = I
		var/list/call_data = list(
			caller = HC.caller_location,
			connected = HC.connected_holopad == src ? TRUE : FALSE,
			ref = REF(HC)
		)
		data["holo_calls"] += list(call_data)
	return data

/obj/machinery/holopad/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("AIrequest")
			if(last_request + 200 < world.time)
				last_request = world.time
				to_chat(usr, span_info("You requested an AI's presence."))
				var/area/area = get_area(src)
				for(var/mob/living/silicon/ai/AI in GLOB.silicon_mobs)
					if(!AI.client)
						continue
					to_chat(AI, span_info("Your presence is requested at <a href='?src=[REF(AI)];jumptoholopad=[REF(src)]'>\the [area]</a>."))
				return TRUE
			else
				to_chat(usr, span_info("A request for AI presence was already sent recently."))
				return
		if("holocall")
			if(outgoing_call)
				return
			if(usr.loc == loc)
				var/list/callnames = list()
				for(var/obj/machinery/holopad/pad as anything in holopads)
					if (pad.is_operational)
						var/area/area = get_area(pad)
						if(area)
							LAZYADD(callnames[area], pad)
				callnames -= get_area(src)
				var/result = tgui_input_list(usr, "Choose an area to call", "Holocall", sortNames(callnames))
				if(QDELETED(usr) || !result || outgoing_call)
					return
				var/interference = SSovermap.get_overmap_interference(src)
				if(interference > 10)
					to_chat(usr, span_warning("There is too much interference here to make a call! Move the ship elsewhere!"))
					return
				if(usr.loc == loc)
					var/input = text2num(params["headcall"])
					var/headcall = input == 1 ? TRUE : FALSE
					new /datum/holocall(usr, src, callnames[result], headcall)
					calling = TRUE
					return TRUE
			else
				to_chat(usr, span_warning("You must stand on the holopad to make a call!"))
		if("connectcall")
			var/datum/holocall/call_to_connect = locate(params["holopad"]) in holo_calls
			if(!QDELETED(call_to_connect))
				call_to_connect.Answer(src)
				return TRUE
		if("disconnectcall")
			var/datum/holocall/call_to_disconnect = locate(params["holopad"]) in holo_calls
			if(!QDELETED(call_to_disconnect))
				call_to_disconnect.Disconnect(src)
				return TRUE
		if("disk_eject")
			if(disk && !replay_mode)
				disk.forceMove(drop_location())
				disk = null
				return TRUE
		if("replay_mode")
			if(replay_mode)
				replay_stop()
				return TRUE
			else
				replay_start()
				return TRUE
		if("loop_mode")
			loop_mode = !loop_mode
			return TRUE
		if("record_mode")
			if(record_mode)
				record_stop()
				return TRUE
			else
				record_start(usr)
				return TRUE
		if("record_clear")
			record_clear()
			return TRUE
		if("offset")
			offset++
			if(offset > 4)
				offset = FALSE
			var/turf/new_turf
			if(!offset)
				new_turf = get_turf(src)
			else
				new_turf = get_step(src, GLOB.cardinals[offset])
			replay_holo.abstract_move(new_turf)
			return TRUE
		if("hang_up")
			if(outgoing_call)
				outgoing_call.Disconnect(src)

/**
 * hangup_all_calls: Disconnects all current holocalls from the holopad
 */
/obj/machinery/holopad/proc/hangup_all_calls()
	for(var/I in holo_calls)
		var/datum/holocall/HC = I
		HC.Disconnect(src)

//do not allow AIs to answer calls or people will use it to meta the AI sattelite
/obj/machinery/holopad/attack_ai(mob/living/silicon/ai/user)
	if (!istype(user))
		return
	if (!on_network)
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.eyeobj.loc != src.loc)//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(get_turf(src))
	else if(!LAZYLEN(masters) || !masters[user])//If there is no hologram, possibly make one.
		activate_holo(user)
	else//If there is a hologram, remove it.
		clear_holo(user)

/obj/machinery/holopad/process()
	if(LAZYLEN(masters))
		for(var/I in masters)
			var/mob/living/master = I
			var/mob/living/silicon/ai/AI = master
			if(!istype(AI))
				AI = null

			if(!is_operational || !validate_user(master))
				clear_holo(master)

	if(outgoing_call)
		var/interference = SSovermap.get_overmap_interference(src)
		if(interference > 10)
			say("Call broke up due to electromagnetic interference.")
			outgoing_call.ConnectionFailure(src)
		outgoing_call.Check()

	ringing = FALSE

	for(var/I in holo_calls)
		var/datum/holocall/HC = I
		if(HC.connected_holopad != src)
			caller_history = HC.caller_location
			if(force_answer_call && world.time > (HC.call_start_time + (HOLOPAD_MAX_DIAL_TIME / 2)))
				HC.Answer(src)
				break
			if(outgoing_call)
				HC.Disconnect(src)//can't answer calls while calling
			else
				playsound(src, 'sound/machines/twobeep.ogg', 100)	//bring, bring!
				ringing = TRUE

	update_appearance()

/obj/machinery/holopad/proc/activate_holo(mob/living/user)
	var/mob/living/silicon/ai/AI = user
	if(!istype(AI))
		AI = null

	if(is_operational && (!AI || AI.eyeobj.loc == loc))//If the projector has power and client eye is on it
		if (AI && istype(AI.current, /obj/machinery/holopad))
			to_chat(user, span_danger("ERROR:</span> \black Image feed in progress."))
			return

		var/obj/effect/overlay/holo_pad_hologram/Hologram = new(loc)//Spawn a blank effect at the location.
		if(AI)
			Hologram.icon = AI.holo_icon
		else	//make it like real life
			Hologram.icon = user.icon
			Hologram.icon_state = user.icon_state
			Hologram.copy_overlays(user, TRUE)
			//codersprite some holo effects here
			Hologram.alpha = 100
			Hologram.add_atom_colour("#77abff", FIXED_COLOUR_PRIORITY)
			Hologram.Impersonation = user

		Hologram.mouse_opacity = MOUSE_OPACITY_TRANSPARENT//So you can't click on it.
		Hologram.layer = FLY_LAYER//Above all the other objects/mobs. Or the vast majority of them.
		Hologram.set_anchored(TRUE)//So space wind cannot drag it.
		Hologram.name = "[user.name] (Hologram)"//If someone decides to right click.
		Hologram.set_light(2)	//hologram lighting
		move_hologram(user, loc)

		set_holo(user, Hologram)
		visible_message(span_notice("A holographic image of [user] flickers to life before your eyes!"))

		return Hologram
	else
		to_chat(user, span_danger("ERROR:Unable to project hologram."))

/*This is the proc for special two-way communication between AI and holopad/people talking near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/holopad/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	if(speaker && LAZYLEN(masters) && !radio_freq)//Master is mostly a safety in case lag hits or something. Radio_freq so AIs dont hear holopad stuff through radios.
		for(var/mob/living/silicon/ai/master in masters)
			if(masters[master] && speaker != master)
				master.relay_speech(message, speaker, message_language, raw_message, radio_freq, spans, message_mods)

	for(var/I in holo_calls)
		var/datum/holocall/HC = I
		if(HC.connected_holopad == src && speaker != HC.hologram)
			HC.user.Hear(message, speaker, message_language, raw_message, radio_freq, spans, message_mods)

	if(outgoing_call && speaker == outgoing_call.user)
		if(!outgoing_call.hologram) //This can apparently be null, just panic and hang up.
			hangup_all_calls()
			return
		outgoing_call.hologram.say(raw_message)

	if(record_mode && speaker == record_user)
		record_message(speaker,raw_message,message_language)

/obj/machinery/holopad/proc/SetLightsAndPower()
	var/total_users = LAZYLEN(masters) + LAZYLEN(holo_calls)
	//active_power_usage = initial(active_power_usage) * total_users
	if(total_users || replay_mode)
		set_light(2)
	else
		set_light(0)
	update_appearance()

/obj/machinery/holopad/update_icon_state()
	var/total_users = LAZYLEN(masters) + LAZYLEN(holo_calls)
	if(ringing)
		icon_state = "[base_icon_state]_ringing"
		return ..()
	icon_state = "[base_icon_state][(total_users || replay_mode) ? 1 : 0]"
	return ..()


/obj/machinery/holopad/proc/set_holo(mob/living/user, obj/effect/overlay/holo_pad_hologram/h)
	LAZYSET(masters, user, h)
	LAZYSET(holorays, user, new /obj/effect/overlay/holoray(loc))
	var/mob/living/silicon/ai/AI = user
	if(istype(AI))
		AI.current = src
	SetLightsAndPower()
	update_holoray(user, get_turf(loc))
	return TRUE

/obj/machinery/holopad/proc/clear_holo(mob/living/user)
	qdel(masters[user]) // Get rid of user's hologram
	masters -= user
	unset_holo(user)
	return TRUE

/obj/machinery/holopad/proc/unset_holo(mob/living/user)
	var/mob/living/silicon/ai/AI = user
	if(istype(AI) && AI.current == src)
		AI.current = null
	LAZYREMOVE(masters, user) // Discard AI from the list of those who use holopad
	if(user in holorays)
		QDEL_NULL(holorays[user])
	LAZYREMOVE(holorays, user)
	SetLightsAndPower()
	return TRUE

//Try to transfer hologram to another pad that can project on T
/obj/machinery/holopad/proc/transfer_to_nearby_pad(turf/T,mob/holo_owner)
	var/obj/effect/overlay/holo_pad_hologram/h = masters[holo_owner]
	if(!h || h.HC) //Holocalls can't change source.
		return FALSE
	for(var/pad in holopads)
		var/obj/machinery/holopad/another = pad
		if(another == src)
			continue
		if(another.validate_location(T))
			unset_holo(holo_owner)
			if(another.masters && another.masters[holo_owner])
				another.clear_holo(holo_owner)
			another.set_holo(holo_owner, h)
			return TRUE
	return FALSE

/obj/machinery/holopad/proc/validate_user(mob/living/user)
	if(QDELETED(user) || user.incapacitated() || !user.client)
		return FALSE
	return TRUE

/**Can we display holos on the turf T
 *Area check instead of line of sight check because this is a called a lot if AI wants to move around.
 * *Areacheck for things that need to get into other areas, such as emergency holograms
 */
/obj/machinery/holopad/proc/validate_location(turf/T, check_los = FALSE, areacheck = TRUE)
	if(T.virtual_z() == virtual_z() && get_dist(T, src) <= holo_range && (T.loc == get_area(src) || !areacheck) && anchored)
		return TRUE
	else
		return FALSE

/obj/machinery/holopad/proc/move_hologram(mob/living/user, turf/new_turf)
	if(LAZYLEN(masters) && masters[user])
		var/obj/effect/overlay/holo_pad_hologram/holo = masters[user]
		var/transfered = FALSE
		if(!validate_location(new_turf))
			if(!transfer_to_nearby_pad(new_turf,user))
				if(holo.HC)
					holo.HC.eye.setLoc(get_turf(src))
					return FALSE
				clear_holo(user)
				return FALSE
			else
				transfered = TRUE
		//All is good.
		holo.forceMove(new_turf)
		if(!transfered)
			update_holoray(user,new_turf)
	return TRUE


/obj/machinery/holopad/proc/update_holoray(mob/living/user, turf/new_turf)
	var/obj/effect/overlay/holo_pad_hologram/holo = masters[user]
	var/obj/effect/overlay/holoray/ray = holorays[user]
	var/disty = holo.y - ray.y
	var/distx = holo.x - ray.x
	var/newangle
	if(!disty)
		if(distx >= 0)
			newangle = 90
		else
			newangle = 270
	else
		newangle = arctan(distx/disty)
		if(disty < 0)
			newangle += 180
		else if(distx < 0)
			newangle += 360
	var/matrix/M = matrix()
	if (get_dist(get_turf(holo),new_turf) <= 1)
		animate(ray, transform = turn(M.Scale(1,sqrt(distx*distx+disty*disty)),newangle),time = 1)
	else
		ray.transform = turn(M.Scale(1,sqrt(distx*distx+disty*disty)),newangle)

// RECORDED MESSAGES

/obj/machinery/holopad/proc/setup_replay_holo(datum/holorecord/record)
	var/obj/effect/overlay/holo_pad_hologram/Hologram = new(loc)//Spawn a blank effect at the location.
	Hologram.add_overlay(record.caller_image)
	Hologram.alpha = 170
	Hologram.add_atom_colour("#77abff", FIXED_COLOUR_PRIORITY)
	Hologram.dir = SOUTH //for now
	var/datum/language_holder/holder = Hologram.get_language_holder()
	holder.selected_language = record.language
	Hologram.mouse_opacity = MOUSE_OPACITY_TRANSPARENT//So you can't click on it.
	Hologram.layer = FLY_LAYER//Above all the other objects/mobs. Or the vast majority of them.
	Hologram.set_anchored(TRUE)//So space wind cannot drag it.
	Hologram.name = "[record.caller_name] (Hologram)"//If someone decides to right click.
	Hologram.set_light(2)	//hologram lighting
	visible_message(span_notice("A holographic image of [record.caller_name] flickers to life before your eyes!"))
	return Hologram

/obj/machinery/holopad/proc/replay_start()
	if(!replay_mode)
		replay_mode = TRUE
		replay_holo = setup_replay_holo(disk.record)
		SetLightsAndPower()
		replay_entry(1)

/obj/machinery/holopad/proc/replay_stop()
	if(replay_mode)
		replay_mode = FALSE
		offset = FALSE
		QDEL_NULL(replay_holo)
		SetLightsAndPower()

/obj/machinery/holopad/proc/record_start(mob/living/user)
	if(!user || !disk || disk.record)
		return
	disk.record = new
	record_mode = TRUE
	record_start = world.time
	record_user = user
	disk.record.set_caller_image(user)

/obj/machinery/holopad/proc/record_message(mob/living/speaker,message,language)
	if(!record_mode)
		return
	//make this command so you can have multiple languages in single record
	if((!disk.record.caller_name || disk.record.caller_name == "Unknown") && istype(speaker))
		disk.record.caller_name = speaker.name
	if(!disk.record.language)
		disk.record.language = language
	else if(language != disk.record.language)
		disk.record.entries += list(list(HOLORECORD_LANGUAGE,language))

	var/current_delay = 0
	for(var/E in disk.record.entries)
		var/list/entry = E
		if(entry[1] != HOLORECORD_DELAY)
			continue
		current_delay += entry[2]

	var/time_delta = world.time - record_start - current_delay

	if(time_delta >= 1)
		disk.record.entries += list(list(HOLORECORD_DELAY,time_delta))
	disk.record.entries += list(list(HOLORECORD_SAY,message))
	if(disk.record.entries.len >= HOLORECORD_MAX_LENGTH)
		record_stop()

/obj/machinery/holopad/proc/replay_entry(entry_number)
	if(!replay_mode)
		return
	if (!disk.record.entries.len) // check for zero entries such as photographs and no text recordings
		return // and pretty much just display them statically untill manually stopped
	if(disk.record.entries.len < entry_number)
		if(loop_mode)
			entry_number = 1
		else
			replay_stop()
			return
	var/list/entry = disk.record.entries[entry_number]
	var/command = entry[1]
	switch(command)
		if(HOLORECORD_SAY)
			var/message = entry[2]
			if(replay_holo)
				replay_holo.say(message)
		if(HOLORECORD_SOUND)
			playsound(src,entry[2],50,TRUE)
		if(HOLORECORD_DELAY)
			addtimer(CALLBACK(src, PROC_REF(replay_entry),entry_number+1),entry[2])
			return
		if(HOLORECORD_LANGUAGE)
			var/datum/language_holder/holder = replay_holo.get_language_holder()
			holder.selected_language = entry[2]
		if(HOLORECORD_PRESET)
			var/preset_type = entry[2]
			var/datum/preset_holoimage/H = new preset_type
			replay_holo.cut_overlays()
			replay_holo.add_overlay(H.build_image())
		if(HOLORECORD_RENAME)
			replay_holo.name = entry[2] + " (Hologram)"
	.(entry_number+1)

/obj/machinery/holopad/proc/record_stop()
	if(record_mode)
		record_mode = FALSE
		record_user = null

/obj/machinery/holopad/proc/record_clear()
	if(disk && disk.record)
		QDEL_NULL(disk.record)

/obj/machinery/holopad/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock, list/obj/docking_port/mobile/towed_shuttles)
	. = ..()
	for(var/datum/holocall/holocall in holo_calls)
		holocall.eye.setLoc(newT, TRUE)

/obj/effect/overlay/holo_pad_hologram
	initial_language_holder = /datum/language_holder/universal
	var/mob/living/Impersonation
	var/datum/holocall/HC

/obj/effect/overlay/holo_pad_hologram/Destroy()
	Impersonation = null
	if(!QDELETED(HC))
		HC.Disconnect(HC.calling_holopad)
	return ..()

/obj/effect/overlay/holo_pad_hologram/Process_Spacemove(movement_dir = 0)
	return TRUE

/obj/effect/overlay/holo_pad_hologram/examine(mob/user)
	if(Impersonation)
		return Impersonation.examine(user)
	return ..()

/obj/effect/overlay/holoray
	name = "holoray"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "holoray"
	layer = FLY_LAYER
	density = FALSE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -32
	pixel_y = -32
	alpha = 100

#undef HOLOPAD_PASSIVE_POWER_USAGE
#undef HOLOGRAM_POWER_USAGE
