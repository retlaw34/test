/// from /obj/structure/telephone_transmitter/update_icon()
#define COMSIG_TRANSMITTER_UPDATE_ICON "transmitter_update_icon"

#define PHONE_RENAME_CAT "category"
#define PHONE_RENAME_ID "phone_id"

/obj/structure/telephone_transmitter/internal
	name = "\improper internal telephone receiver"
	desc = "A telephone box compacted enough to fit inside a bag, while the phone lies outside on a handle. Unfortunately, this and the heavy duty battery leave less space for items."

	phone_type = /obj/item/telephone_receiver

	var/atom/relay_obj

/obj/structure/telephone_transmitter/internal/ui_host(mob/user, datum/tgui/ui)
	if(!relay_obj)
		return ..()
	return relay_obj

/obj/structure/telephone_transmitter/internal/Destroy()
	relay_obj = null
	return ..()

GLOBAL_LIST_EMPTY_TYPED(radio_packs, /obj/item/storage/backpack/radio)

/obj/item/storage/backpack/radio
	name = "Telephone Pack"
	desc = "A heavy-duty pack, used for telecommunications between crew in orbit and crew on ground. The radio components and industrial battery leave less space for storage. Control click to toggle auto-tagging when equpping it."
	icon = 'modular_thabes/modules/phonestuff/icons/obj.dmi'
	mob_overlay_icon = 'modular_thabes/modules/phonestuff/icons/mob.dmi'
	icon_state = "radiopack"
	base_icon_state = "radiopack"
	item_state = "radiopack"


	var/tag_name

	var/autotag = TRUE

	var/obj/structure/telephone_transmitter/internal/internal_transmitter

/obj/item/storage/backpack/radio/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 20
	STR.max_items = 20

/obj/item/storage/backpack/radio/Initialize()
	. = ..()
	internal_transmitter = new(src)
	internal_transmitter.relay_obj = src
	internal_transmitter.phone_category = "Telephone Packs"
	internal_transmitter.enabled = FALSE
	RegisterSignal(internal_transmitter, COMSIG_TRANSMITTER_UPDATE_ICON, .proc/check_for_ringing)
	GLOB.radio_packs += src

	tag_name = name

/obj/item/storage/backpack/radio/proc/check_for_ringing()
	SIGNAL_HANDLER
	update_icon()

/obj/item/storage/backpack/radio/CtrlClick(mob/user)
	. = ..()
	autotag = !autotag
	playsound(get_turf(user), 'sound/machines/click.ogg', 50, TRUE)
	if(autotag)
		to_chat(user, "<span class='notice'>You turn on the [src]'s autotag systems.</span>")
	else
		to_chat(user, "<span class='notice'>You turn off the [src]'s autotag systems.</span>")

/obj/item/storage/backpack/radio/proc/rename_phone(mob/living/user)
	var/choices = list(
	PHONE_RENAME_CAT,
	PHONE_RENAME_ID,
	)
	var/picked = input(user, "Rename which field?", , sortList(choices))

	if(isnull(picked))
		return
	switch(picked)
		if(PHONE_RENAME_CAT)
			var/input = stripped_input(user,"What category do you want to set [src.name] to?", ,"", MAX_NAME_LEN)
			internal_transmitter.phone_category = input
			to_chat(user, "<span class='notice'>You set the phone category to [input].</span>")

		if(PHONE_RENAME_ID)
			var/input = stripped_input(user,"What do you want to name [src.name]?", ,"", MAX_NAME_LEN)
			tag_name = input
			to_chat(user, "<span class='notice'>You set the radiopack name to [input].</span>")

/obj/item/storage/backpack/radio/update_icon()
	. = ..()
	if(!internal_transmitter)
		return

	if(!internal_transmitter.attached_to \
		|| internal_transmitter.attached_to.loc != internal_transmitter)
		icon_state = "[base_icon_state]_ear"
		return

	if(internal_transmitter.caller)
		icon_state = "[base_icon_state]_ring"
	else
		icon_state = base_icon_state

/obj/item/storage/backpack/radio/item_action_slot_check(mob/user, slot)
	if(slot == ITEM_SLOT_BACKPACK)
		return TRUE
	return FALSE

/obj/item/storage/backpack/radio/Destroy()
	GLOB.radio_packs -= src
	qdel(internal_transmitter)
	return ..()

/obj/item/storage/backpack/radio/pickup(mob/user)
	. = ..()
	internal_transmitter.enabled = TRUE
	if(!autotag)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		internal_transmitter.phone_id = "[tag_name]: [H]"
	else
		internal_transmitter.phone_id = "[tag_name]: [user]"

/obj/item/storage/backpack/radio/dropped(mob/user)
	. = ..()
	internal_transmitter.phone_id = tag_name
	internal_transmitter.enabled = FALSE

/obj/item/storage/backpack/radio/attack_hand(mob/user)
	var/mob/living/carbon/human/human_user = user
	if(human_user.backpack == src)
		internal_transmitter.attack_hand(user)
	else if(internal_transmitter.get_calling_phone())
		if(internal_transmitter.attached_to && internal_transmitter.attached_to.loc != internal_transmitter)
			return . = ..()
		internal_transmitter.attack_hand(user)
	else
		. = ..()

/obj/item/storage/backpack/radio/attackby(obj/item/weapon, mob/user)
	if(internal_transmitter && internal_transmitter.attached_to == weapon)
		internal_transmitter.attackby(weapon, user)
	if(istype(weapon, /obj/item/multitool))
		rename_phone(user)
	else
		return ..()

