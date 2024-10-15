/datum/outfit/job/gezena
	name = "PGF - Base Outfit"
	// faction_icon = "bg_pgf"
	box = /obj/item/storage/box/survival/extended

/datum/outfit/job/gezena/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.faction |= list(FACTION_PLAYER_GEZENA)
	H.grant_language(/datum/language/draconic)

//Playable Roles (put in ships):
/datum/outfit/job/gezena/assistant
	name = "PGF - Crewman"
	id_assignment = "Crewman"
	jobtype = /datum/job/assistant
	job_icon = "assistant"

	uniform = /obj/item/clothing/under/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena

/datum/outfit/job/gezena/assistant/bridge
	name = "PGF - Bridge Bunny"
	id_assignment = "Bridge Bunny"
	jobtype = /datum/job/head_of_personnel

/datum/outfit/job/gezena/engineer
	name = "PGF - Navy Engineer"
	id_assignment = "Naval Engineer"
	jobtype = /datum/job/engineer
	job_icon = "stationengineer"

	uniform = /obj/item/clothing/under/gezena/utility
	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/suit/gezena/engi
	neck = /obj/item/clothing/neck/cloak/gezena/engi

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	courierbag = /obj/item/storage/backpack/messenger/engi

/datum/outfit/job/gezena/doctor
	name = "PGF - Navy Doctor"
	jobtype = /datum/job/doctor
	job_icon = "medicaldoctor"

	uniform = /obj/item/clothing/under/gezena/utility
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/med

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	courierbag = /obj/item/storage/backpack/messenger/med
	box = /obj/item/storage/box/survival/medical

/datum/outfit/job/gezena/security/pilot
	name = "PGF - Navy Pilot"
	id_assignment = "Pilot"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena
	head = /obj/item/clothing/head/helmet/space/gezena/flightsuit
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/command

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

/datum/outfit/job/gezena/security/pilot/marine
	name = "PGF - Marine Pilot"
	id_assignment = "Marine Pilot"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena/marine
	head = /obj/item/clothing/head/helmet/space/gezena/flightsuit/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/command

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

/datum/outfit/job/gezena/security
	name = "PGF - Marine"
	id_assignment = "Marine"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

	backpack_contents = list(/obj/item/clothing/mask/gas/gezena=1)

/datum/outfit/job/gezena/hos
	name = "PGF - Marine Sergeant"
	id_assignment = "Sergeant"
	jobtype = /datum/job/hos
	job_icon = "headofsecurity"

	uniform = /obj/item/clothing/under/gezena/marine
	head = /obj/item/clothing/head/gezena/campaign_marinelead
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/lead

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

	backpack_contents = list(/obj/item/clothing/mask/gas/gezena=1)

/datum/outfit/job/gezena/hos/lieutenant
	name = "PGF - Marine Lieutenant"
	id_assignment = "Lieutenant"
	neck = /obj/item/clothing/neck/cloak/gezena/command

/datum/outfit/job/gezena/hop
	name = "PGF - Bridge Officer"
	jobtype = /datum/job/head_of_personnel
	job_icon = "headofpersonnel"

	uniform = /obj/item/clothing/under/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/command

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com

/datum/outfit/job/gezena/xo
	name = "PGF - Executive Officer"
	jobtype = /datum/job/head_of_personnel
	job_icon = "headofpersonnel"

	uniform = /obj/item/clothing/under/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/xo

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com

/datum/outfit/job/gezena/captain
	name = "PGF - Captain"
	jobtype = /datum/job/captain
	job_icon = "captain"

	uniform = /obj/item/clothing/under/gezena/captain
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/captain

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com

//Adminspawn Roles (for events):

/datum/outfit/job/gezena/assistant/geared
	name = "PGF - Crewman - Equipped"
	jobtype = /datum/job/assistant
	job_icon = "assistant"

	uniform = /obj/item/clothing/under/gezena
	suit = /obj/item/clothing/suit/gezena
	head = /obj/item/clothing/head/gezena
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena

/datum/outfit/job/gezena/engineer/geared
	name = "PGF - Navy Engineer - Equipped"
	jobtype = /datum/job/engineer
	job_icon = "stationengineer"

	uniform = /obj/item/clothing/under/gezena/utility
	suit = /obj/item/clothing/suit/gezena/engi
	head = /obj/item/clothing/head/gezena
	belt = /obj/item/storage/belt/utility/full/engi
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/engi

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	courierbag = /obj/item/storage/backpack/messenger/engi

/datum/outfit/job/gezena/doctor/geared
	name = "PGF - Navy Doctor - Equipped"
	jobtype = /datum/job/doctor
	job_icon = "medicaldoctor"

	uniform = /obj/item/clothing/under/gezena/utility
	belt = /obj/item/storage/belt/medical/gezena
	head = /obj/item/clothing/head/gezena/medic
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/med

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	courierbag = /obj/item/storage/backpack/messenger/med
	box = /obj/item/storage/box/survival/medical

/datum/outfit/job/gezena/security/pilot/geared
	name = "PGF - Navy Pilot - Equipped"
	id_assignment = "Pilot"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena
	suit = /obj/item/clothing/suit/space/gezena/flightsuit
	head = /obj/item/clothing/head/helmet/space/gezena/flightsuit
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/command

	suit_store = /obj/item/tank/internals/oxygen

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

/datum/outfit/job/gezena/security/pilot/marine/geared
	name = "PGF - Marine Pilot - Equipped"
	id_assignment = "Marine Pilot"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena/marine
	suit = /obj/item/clothing/suit/space/gezena/flightsuit/marine
	head = /obj/item/clothing/head/helmet/space/gezena/flightsuit/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/command

	suit_store = /obj/item/tank/internals/oxygen

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

/datum/outfit/job/gezena/security/geared
	name = "PGF - Marine - Equipped"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena/marine
	suit = /obj/item/clothing/suit/armor/gezena/marine
	head = /obj/item/clothing/head/helmet/gezena
	belt = /obj/item/storage/belt/military/gezena
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena
	r_hand = /obj/item/gun/energy/kalix/pgf/heavy

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

	backpack_contents = list(/obj/item/clothing/mask/gas/gezena=1)

/datum/outfit/job/gezena/security/parade
	name = "PGF - Marine - Ceremonial"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena/marine_formal
	suit = /obj/item/clothing/suit/armor/gezena/marine_parade
	head = /obj/item/clothing/head/gezena/marine_parade
	belt = null
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/workboots
	neck = /obj/item/clothing/neck/cloak/gezena

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

	backpack_contents = list(/obj/item/clothing/mask/gas/gezena=1)

/datum/outfit/job/gezena/hos/geared
	name = "PGF - Marine Sergeant - Equipped"
	jobtype = /datum/job/hos
	job_icon = "headofsecurity"

	uniform = /obj/item/clothing/under/gezena/marine
	suit = /obj/item/clothing/suit/armor/gezena/marine
	head = /obj/item/clothing/head/gezena/marine/lead
	belt = /obj/item/storage/belt/military/gezena
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/lead
	r_hand = /obj/item/gun/energy/kalix/pgf

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	courierbag = /obj/item/storage/backpack/messenger/sec
	box = /obj/item/storage/box/survival/extended

	backpack_contents = list(/obj/item/clothing/mask/gas/gezena=1)

/datum/outfit/job/gezena/paramedic
	name = "PGF - Marine Medic - Equipped"
	jobtype = /datum/job/paramedic
	job_icon = "paramedic"

	uniform = /obj/item/clothing/under/gezena/marine
	suit = /obj/item/clothing/suit/armor/gezena/marine
	head = /obj/item/clothing/head/helmet/gezena
	belt = /obj/item/storage/belt/medical/gezena
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/med
	r_hand = /obj/item/gun/energy/kalix/pgf

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	courierbag = /obj/item/storage/backpack/messenger/para
	box = /obj/item/storage/box/survival/medical

/datum/outfit/job/gezena/hop/geared
	name = "PGF - Naval Bridge Officer - Equipped"
	jobtype = /datum/job/head_of_personnel
	job_icon = "headofpersonnel"

	uniform = /obj/item/clothing/under/gezena
	suit = /obj/item/clothing/suit/armor/gezena
	head = /obj/item/clothing/head/gezena
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/command
	r_hand = /obj/item/gun/energy/kalix/pgf

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com

/datum/outfit/job/gezena/xo/geared
	name = "PGF - Executive Officer - Equipped"
	jobtype = /datum/job/head_of_personnel
	job_icon = "headofpersonnel"

	uniform = /obj/item/clothing/under/gezena
	suit = /obj/item/clothing/suit/armor/gezena
	head = /obj/item/clothing/head/gezena
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/xo
	r_hand = /obj/item/gun/energy/kalix/pgf

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com

/datum/outfit/job/gezena/captain/geared
	name = "PGF - Captain - Equipped"
	jobtype = /datum/job/captain
	job_icon = "captain"

	uniform = /obj/item/clothing/under/gezena/captain
	suit = /obj/item/clothing/suit/armor/gezena/captain
	head = /obj/item/clothing/head/gezena/campaign_captain
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/captain

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com
