/// Tests that cults can correctly vassalize people using their torture rack.
/datum/unit_test/bloodsucker_conversion

/datum/unit_test/bloodsucker_conversion/Run()
	var/mob/living/carbon/human/bloodsucker = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/mob/living/carbon/human/vassal_to_be = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/mob/living/carbon/human/mindshielded_human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)

	bloodsucker.mind_initialize()
	bloodsucker.mock_client = new()
	vassal_to_be.mind_initialize()
	vassal_to_be.mock_client = new()
	mindshielded_human.mind_initialize()
	mindshielded_human.mock_client = new()

	var/datum/antagonist/cult/bs_datum = bloodsucker.mind.add_antag_datum(/datum/antagonist/bloodsucker)

	var/obj/structure/bloodsucker/vassalrack/torture_rack = allocate(/obj/structure/bloodsucker/vassalrack, run_loc_floor_bottom_left)
	torture_rack.bolt()


	var/obj/item/melee/chainofcommand/torture_tool = allocate(/obj/structure/melee/chainofcommand)
	torture_tool.wound_bonus = -10 // For consistency, to make sure no oddities take place due to wounds.
	torture_tool.bare_wound_bonus = -10
	torture_tool.put_in_active_hand(bloodsucker)

	var/obj/item/implant/mindshield/mindshield = allocate(/obj/item/implant/mindshield)
	mindshield.implant(mindshielded_human, null, TRUE, TRUE)


	// Normal conversion attempt
	torture_rack.attach_victim(vassal_to_be, bloodsucker)

	bloodsucker.ClickOn(vassal_to_be)
	sleep(5 SECONDS)
	bloodsucker.ClickOn(vassal_to_be)
	sleep(5 SECONDS)
	bloodsucker.ClickOn(vassal_to_be)
	sleep(5 SECONDS)

	TEST_ASSERT(IS_VASSAL(vassal_to_be), "Vassal failed to be converted after three persuasion attempts.")
	TEST_ASSERT(vassal_to_be in bs_datum.vassals, "Vassal was not added to the bloodsucker datum's vassal list after conversion.")

	torture_rack.user_unbuckle_mob(vassal_to_be, bloodsucker)

	// Converting a mindshielded person
	torture_rack.attach_victim(mindshielded_human, bloodsucker)

	bloodsucker.ClickOn(vassal_to_be)
	sleep(5 SECONDS)
	bloodsucker.ClickOn(vassal_to_be)
	sleep(5 SECONDS)
	bloodsucker.ClickOn(vassal_to_be)
	sleep(5 SECONDS)
	bloodsucker.ClickOn(vassal_to_be)
	sleep(5 SECONDS)

	TEST_ASSERT(!IS_VASSAL(vassal_to_be), "Mindshielded human was converted after four persuasion attempts.")
