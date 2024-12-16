/// Tests that beefmen can remove their own limbs and get a slab of meat for doing so
/datum/unit_test/beefmen_delimbing

/datum/unit_test/beefmen_delimbing/Run()
	var/mob/living/carbon/human/species/beefman/beefman = allocate(/mob/living/carbon/human/species/beefman, run_loc_floor_bottom_left)

	beefman.mind_initialize()
	beefman.mock_client = new()

	var/datum/species/beefman/species_datum = beefman.dna.species

	beefman.zone_selected = BODY_ZONE_L_LEG

	beefman.attack_hand(beefman, list(RIGHT_CLICK = TRUE))
	sleep(3 SECONDS)

	TEST_ASSERT(!beefman.get_bodypart(BODY_ZONE_L_LEG), "Beefman failed to remove a its own leg.")
	TEST_ASSERT(beefman.is_holding_item_of_type(/obj/item/food/meat/slab), "Beefman did not get a slab of meat after removing its own leg.")

