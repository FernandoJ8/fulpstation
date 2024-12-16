/// Tests that cults can convert people with their rune
/datum/unit_test/cult_stun

/datum/unit_test/cult_stun/Run()
	var/mob/living/carbon/human/cultist = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/mob/living/carbon/human/mindshielded_human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)

	cultist.mind_initialize()
	cultist.mock_client = new()
	mindshielded_human.mind_initialize()
	mindshielded_human.mock_client = new()

	var/obj/item/implant/mindshield/mindshield = allocate(/obj/item/implant/mindshield)
	mindshield.implant(mindshielded_human, null, TRUE, TRUE)

	var/datum/antagonist/cult/cult_datum = cultist.mind.add_antag_datum(/datum/antagonist/cult)

	var/datum/action/innate/cult/blood_spell/stuncult_stun = allocate(/datum/action/innate/cult/blood_spell/stun, cultist)
	cult_stun.Grant(cultist)
	cult_stun.Activate()

	cultist.set_combat_mode(TRUE)
	cultist.ClickOn(mindshielded_human)

	TEST_ASSERT(!IsParalyzed(mindshielded_human), "Victim of a cult stun was paralysed despite having a mindshield.")
