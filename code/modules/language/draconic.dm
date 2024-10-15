/datum/language/draconic
	name = "Kalixcian Common"
	desc = "The most prevalent language to come out of Kalixcis, and generally understood by all those native to it."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "roars"
	sing_verb = "sings"
	key = "o"
	flags = TONGUELESS_SPEECH | LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD //WS Edit- Language icon hiding
	space_chance = 40
	syllables = list(
		"za", "az", "ze", "ez", "zi", "iz", "zo", "oz", "zu", "uz", "zs", "sz",
		"ha", "ah", "he", "eh", "hi", "ih", "ho", "oh", "hu", "uh", "hs", "sh",
		"la", "al", "le", "el", "li", "il", "lo", "ol", "lu", "ul", "ls", "sl",
		"ka", "ak", "ke", "ek", "ki", "ik", "ko", "ok", "ku", "uk", "ks", "sk",
		"sa", "as", "se", "es", "si", "is", "so", "os", "su", "us", "ss", "ss",
		"ra", "ar", "re", "er", "ri", "ir", "ro", "or", "ru", "ur", "rs", "sr",
		"a",  "a",  "e",  "e",  "i",  "i",  "o",  "o",  "u",  "u",  "s",  "s"
	)
	icon_state = "kalixcian"
	default_priority = 90

/datum/language/draconic/scramble(input, datum/language_holder/viewer_holder)
	if(viewer_holder.has_language(/datum/language/draconic/clip))
		return "(Overly Formal)" + input
	return ..()

/datum/language/draconic/clip
	name = "CLIP Kalixcian"
	desc = "The CLIP dialect of Kalixcian, forming in the CLIP core worlds after around a century of drift."
	default_priority = 80
	key = "2"
	flags = TONGUELESS_SPEECH | LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	icon_state = "clip_kalixcian"

/datum/language/draconic/clip/scramble(input, datum/language_holder/viewer_holder)
	if(viewer_holder.has_language(/datum/language/draconic))
		return "(very rough)" + input
	return ..()
