/datum/action/bloodsucker/veil
	name = "Veil of Many Faces"
	desc = "Disguise yourself in the illusion of another identity."
	button_icon_state = "power_veil"
	power_explanation = "<b>Veil of Many Faces</b>:\n\
		Activating Veil of Many Faces will shroud you in smoke and forge you a new identity.\n\
		Your name and appearance will be completely randomized, and turning the ability off again will undo it all.\n\
		Clothes, gear, and Security/Medical HUD status is kept the same while this power is active."
	power_flags = BP_AM_TOGGLE
	check_flags = BP_CANT_USE_IN_FRENZY
	purchase_flags = BLOODSUCKER_CAN_BUY // Testing only, yell at me if I forget to change this
	bloodcost = 15
	constant_bloodcost = 0.1
	cooldown = 10 SECONDS
	// Outfit Vars
//	var/list/original_items = list()
	// Identity Vars
	var/datum/dna/original_dna
	// Forgive me father for what I'm about to do...
	var/mob/living/carbon/human/original_placeholder = new /mob/living/carbon/human
	var/prev_gender
	var/prev_skin_tone
	var/prev_hair_style
	var/prev_facial_hair_style
	var/prev_hair_color
	var/prev_facial_hair_color
	var/prev_underwear
	var/prev_undershirt
	var/prev_socks
	var/prev_disfigured
	var/list/prev_features // For lizards and such

/datum/action/bloodsucker/veil/ActivatePower()
	. = ..()
	cast_effect() // POOF
//	if(blahblahblah)
//		Disguise_Outfit()
	veil_user()
	owner.balloon_alert(owner, "veil turned on.")

/* // Meant to disguise your character's clothing into fake ones.
/datum/action/bloodsucker/veil/proc/Disguise_Outfit()
	return
	// Step One: Back up original items
*/

/datum/action/bloodsucker/veil/proc/veil_user()
	// Change Name/Voice
	var/mob/living/carbon/human/user = owner
	to_chat(owner, span_warning("You mystify the air around your person. Your identity is now altered."))

	// Store Prev Appearance
	original_dna = new user.dna.type
	user.dna.copy_dna(original_dna)
	user.copy_clothing_prefs(original_placeholder)
	prev_disfigured = HAS_TRAIT(user, TRAIT_DISFIGURED) // I was disfigured! //prev_disabilities = user.disabilities

	// Change Appearance
	randomize_human(user)
	if(prev_disfigured)
		REMOVE_TRAIT(user, TRAIT_DISFIGURED, null)

	// Beefmen
	proof_beefman_features(user.dna.features)

	// Apply Appearance
	user.updateappearance(icon_update = TRUE, mutcolor_update = TRUE, mutations_overlay_update = TRUE)

/datum/action/bloodsucker/veil/DeactivatePower()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/user = owner

	// Revert Identity
	original_dna.copy_dna(user.dna)
	original_placeholder.copy_clothing_prefs(user)

	//user.disabilities = prev_disabilities // Restore HUSK, CLUMSY, etc.
	if(prev_disfigured)
		//We are ASSUMING husk. // user.status_flags |= DISFIGURED // Restore "Unknown" disfigurement
		ADD_TRAIT(user, TRAIT_DISFIGURED, TRAIT_HUSK)

	// Apply Appearance
	user.updateappearance()

	cast_effect() // POOF
	user.balloon_alert(owner, "veil turned off.")


// CAST EFFECT // General effect (poof, splat, etc) when you cast. Doesn't happen automatically!
/datum/action/bloodsucker/veil/proc/cast_effect()
	// Effect
	playsound(get_turf(owner), 'sound/magic/smoke.ogg', 20, 1)
	var/datum/effect_system/steam_spread/bloodsucker/puff = new /datum/effect_system/steam_spread/()
	puff.set_up(3, 0, get_turf(owner))
	puff.attach(owner) //OPTIONAL
	puff.start()
	owner.spin(8, 1) //Spin around like a loon.

/obj/effect/particle_effect/fluid/smoke/vampsmoke
	opacity = FALSE
	lifetime = 0

/obj/effect/particle_effect/fluid/smoke/vampsmoke/fade_out(frames = 0.8 SECONDS)
	..(frames)
