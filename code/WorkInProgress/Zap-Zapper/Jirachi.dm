/mob/living/simple_animal/jirachi
	name = "Jirachi"
	real_name = "Jirachi"
	desc = "Small, white, humanoid creature, with short, stubby legs and comparatively longer arms."
	icon = 'jirachi.dmi'
	icon_state = "Jirachi"
	icon_living = "Jirachi"
	maxHealth = 80
	health = 80
	luminosity = 2	//Jirachi is glowing slightly
	wander = 0
	immune_to_ssd = 1		//Add this to ALL simple_animal
	response_help = "hugs"
	response_disarm = "pokes"
	response_harm = "punches"
	harm_intent_damage = 15
	speed = 0
	unacidable = 1
	status_flags = 1
	pass_flags = PASSTABLE
	languages = ALL
	var/energy = 900
	var/const/max_energy = 900
	var/star_form = 0		//Is S-form enabled?
	var/healing = 0		//Is Jirachi healing somebody?
	var/hypnotizing = 0		//Is Jirachi hypnotizing someone?
	var/hybernating = 0		//Is Jirachi sleeping?
	var/list/startelelocs = list()		//Teleport locations
	heat_damage_per_tick = 0
	cold_damage_per_tick = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/used_star
	var/used_forcewall		//Cooldowns
	var/used_psycho
	var/used_teleport
	var/used_steleport
	var/used_hypno



	Life()
	 ..()
		if(stat == 2)
			new /obj/effect/decal/cleanable/ash(src.loc)
			for(var/mob/M in viewers(src, null))
				if((M.client && !( M.blinded )))
					M.show_message("\red [src] starts burning with bright fire from inside, before turning into ashes") //Poor Jirachi :(
					ghostize()
			del src
			return



/mob/living/simple_animal/jirachi/Process_Spacemove(var/check_drift = 0)//Move freely in space
	return 1


/mob/living/simple_animal/jirachi/Bump(atom/movable/AM as mob|obj, yes)
	now_pushing = 0
	..()

/mob/living/simple_animal/jirachi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		var/damage = O.force
		if (O.damtype == HALLOSS || star_form == 1)
			damage = 0
		adjustBruteLoss(damage)
		for(var/mob/M in viewers(src, null))
			if ((M.client && !( M.blinded )))
				if(star_form == 1)
					M << "\red \b [user] tries to strike [src] with [O], but it shields itself from the attack!"
				else
					M.show_message("\red \b [src] has been attacked with [O] by [user].")

	else
		usr << "\red This weapon is ineffective, it does no damage."
		for(var/mob/M in viewers(src, null))
			if ((M.client && !( M.blinded )))
				M.show_message("\red [user] gently taps [src] with [O]. ")


/mob.living/simple_animal/jirachi/ex_act(severity)
	if(star_form == 1)
		switch(severity)
			if(1)
				..()
			if(2 to 3)
				visible_message("\ red \bold Jirachi protects itself from the explosion!")
				return
/mob/living/simple_animal/jirachi/attack_animal(mob/living/simple_animal/M as mob)
	if(star_form == 1)
		M.melee_damage_upper = 0
		M.melee_damage_lower = 0
		visible_message("\red <b>[M] tries to attack [src], but it deflects the attack!</b>")
	else
		..()

/mob/living/simple_animal/jirachi/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(star_form == 1)
		M << "\green Strange power stops your claws!"
		visible_message("\red <b>[src] shields itself from the [M]'s claws!</b>")
		src.health -= 0
	else
		..()

/mob/living/simple_animal/jirachi/attack_paw(mob/living/carbon/monkey/M as mob)
	if(star_form == 1)
		M << "\red I can't bite that creature, some sort of barrier prevents me to do it"
	else
		..()

/mob/living/simple_animal/jirachi/attack_slime(mob/living/carbon/slime/M as mob)
	if(star_form == 1)
		visible_message("\red <b>[M] tries to glomp [src], but it shields itself from the attack!</b>")
		src.health -= 0
	else
		..()

/mob/living/simple_animal/jirachi/hitby(atom/movable/AM as mob|obj)
	if(star_form == 1)
		visible_message("\red [src] dodges [AM]!")
	else
		..()



/mob/living/simple_animal/jirachi/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/italics=0, var/message_range = world.view, var/list/used_radios = list())

	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return
		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if(hybernating == 1)
		src << "\red You can't speak while hybernating!"
		return

	if(stat == 2)
		return say_dead(message)

	if(stat)
		return

	if(!message)
		return

	if (copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	message = capitalize(trim_left(message))
	var/ending = copytext(message, length(message))
	if(ending=="!")
		speak_emote = list("telepatically cries")
	else if(ending=="?")
		speak_emote = list("telepatically asks")
	else
		speak_emote = list("telepatically says")


	..(message, speaking, verb, alt_name, italics, message_range, used_radios)

//VERBS

/mob/living/simple_animal/jirachi/MiddleClickOn(var/turf/T as turf)
	if(energy < 100)
		src << "\red Not enough energy!"
		return

	var/Q = round((world.time - used_steleport)/10, 1)
	if(Q<=5 && star_form == 0)
		src << "\red I am not ready to teleport again. Wait for [5-Q] seconds"
		return

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	for(var/obj/O)
		if(T == O)
			T=get_turf(O.loc)


	if(src && src.buckled)
		src.buckled.unbuckle()//On my Jirachi event, I got buckled to the chair, and blink away from it. And then, shit happens

	var/turf/mobloc = get_turf(src.loc)
	if((!T.density)&&istype(mobloc, /turf)&&(!is_blocked_turf(T)))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/effects/sparks2.ogg', 50, 1)

		src.loc = T

		var/datum/effect/effect/system/spark_spread/spark = new /datum/effect/effect/system/spark_spread()
		spark.set_up(5,0, src.loc)
		spark.start()

		used_steleport = world.time

		energy -= 100

	else
		src << "\red I can't teleport into solid matter."
		return

/mob/living/simple_animal/jirachi/verb/forcewall()
	set category = "Jirachi"
	set name = "Forcewall(50)"
	set desc = "Create a forcewall, that lasts for 30 seconds"
	if(energy< 50)
		src << "You don't have enough power!"
		return

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	if(round((world.time - used_forcewall)/10, 1)>= 35 || star_form == 1)
		var/obj/effect/forcefield/my_field = new /obj/machinery/shield(loc)
		my_field.name = "Forcewall"
		my_field.desc = "Wall consisting of pure energy"
		src << "\red I concentrated energy in my hands and shape a wall from it"
		energy-=50
		used_forcewall = world.time
		sleep(300)
		del(my_field)
	else
		src << "I am not ready to conjure another wall. Wait for [35-round((world.time - used_forcewall)/10, 1)] seconds"
		return






/mob/living/simple_animal/jirachi/verb/energyblast(mob/living/carbon/human/M as mob in oview(7))
	set category = "Jirachi"
	set name = "Psystrike(150)"
	set desc = "Stuns target"
	if(energy<150)
		src << "You don't have enough power!"
		return
	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return
	var/Q = round((world.time - used_psycho)/10, 1)
	if(Q>=30)
		if(!M || !src) return

		if(get_dist(src, M) > 7 )
			src << "Target moved too far away"
			return

		if(M.species.flags & IS_SYNTHETIC)
			src << "\red This creature ignores my attempt to influence it's mind"
			return

		used_psycho = world.time

		for(var/mob/K in viewers(src, null))
			if((K.client && !( K.blinded )))
				K << "\red <b>[src] eyes flashes blue as [M] falls to the floor!</b>"

		src << "\red I focus my mind on the [M] brain and send psychic wave to it."

		if(star_form == 0)
			M.Weaken(15)
			M << "\red Your legs become paralyzed for a moment, and you fall to the floor!"
		else		//In S-form it will be more painful...
			M.Weaken(25)
			M.adjustBrainLoss(25)
			M.eye_blurry += 30
			M << "\red <b>You feel powerful psychic impulse penetrating your brain!</b>"
		energy-=150
	else
		src << "I am not ready. Wait for [35-Q] seconds"
		return

/mob/living/simple_animal/jirachi/verb/heal()
	set category = "Jirachi"
	set name = "Heal(25/s)"
	set desc = "Heal wounds of selected target"
	set background = 1
	if(energy<25)
		src << "You don't have enough power!"
		return

	if(src.healing == 1)
		src << "\blue <i>I stopped healing this creature</i>"
		healing = 0
		return

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	var/list/choices = list()
	for(var/mob/living/C in view(1,src))
		if(C != src)
			if(!istype(C, /mob/living/carbon/brain))
				choices += C


	var/mob/living/Z = input(src,"Who do you wish to heal?") in null|choices
	if(!Z)
		src << "There is no creatures near me to heal"
		return

	if(get_dist(src, Z) > 1 )
		src << "Target moves too far away from me"
		return

	if(Z.stat == 2)
		src << "\red I can't heal dead creatures"
		return

	src << "\blue I put my hands on [Z] and let my energy flow through it's body."
	if(istype(Z,/mob/living/simple_animal))
		var/mob/living/simple_animal/I = Z
		if(!I.supernatural)
			I << "\blue <b>You feel immense energy course through you body!</b>"
		else
			I << "\red \bold That power makes you burn from inside! Aaarrgh!!!"
	else
		Z << "\blue <b>You feel immense energy course through you body!</b>"



	if(istype(Z, /mob/living/silicon))
		src << "\red For some reason, I can't heal that creature"
		return
	healing = 1
	for(var/mob/M in viewers(src, null))
		if((M.client && !( M.blinded )))
			M << "\blue <i>[src] puts it's hands on [Z] and closes it's eyes...suddenly waves of white energy starts to envelop [Z] body! </i>"

	var/X1 = src.loc
	var/X2 = Z.loc

	spawn while(1)
		if(healing == 0)
			return

		if(Z.stat == 2 || !Z)
			src << "\red Creature somehow died during healing"
			healing = 0
			return

		if(X1 != src.loc || X2 != Z.loc)
			src << "<span class='warning'>Healing was interrupted, because [Z] moved away from me.</span>"
			healing = 0
			return

		if(istype(Z, /mob/living/carbon))
			if(istype(Z, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = Z

				if(H.species.flags & IS_SYNTHETIC)
					src << "\red For some reason, I can't heal that creature"
					return

				if(star_form == 1)
					H.adjustToxLoss(-20)
					H.adjustOxyLoss(-20)
					H.adjustCloneLoss(-20)
					H.adjustBrainLoss(-20)
					for(var/datum/organ/external/O in H.organs)
						for(var/datum/wound/W in O.wounds)
							W.heal_damage(15, 1)
							if(W.damage == 0)
								O.wounds -=W
						if(!O.wounds.len)
							if(O.status & ORGAN_BROKEN || O.status & ORGAN_SPLINTED)
								O.status &= ~ORGAN_BROKEN
								O.status &= ~ORGAN_SPLINTED
								H << "\blue Energy wave goes through your body, mending bones in your [O.name]"
							if(O.status & ORGAN_BLEEDING)
								O.status &= ~ORGAN_BLEEDING
								H << "\blue You feel energies mending bleeding wounds in your [O.name]"
							if(O.status & ORGAN_CUT_AWAY || O.status & ORGAN_ATTACHABLE || O.status & ORGAN_DESTROYED)
								O.status &= ~ORGAN_CUT_AWAY
								O.status &= ~ORGAN_ATTACHABLE
								O.status &= ~ORGAN_DESTROYED
								H << "\blue You start feeling your severed limbs growing back"
							if(O.status & ORGAN_DEAD)
								O.status &= ~ORGAN_DEAD
								H << "\blue You can feel your [O.name] again..."
							O.amputated = 0
							O.destspawn = 0
							O.perma_injury = 0
							O.stage = 0
							O.update_damages()

					switch(H.health)
						if(0 to 20)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							if(H.jitteriness > 101)
								H.jitteriness = 101
							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()
						if(21 to 40)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							var/datum/organ/external/head/h = H.organs_by_name["head"]
							if(h.disfigured != 0)
								h.disfigured = 0
								H << "\blue Waves of energy goes through your face, restoring it back to normal"

							for(var/datum/organ/internal/I in H.internal_organs)
								if(I.damage != 0)
									I.damage = 0
									H << "\blue Sweet feeling fills your body, as your viscera regenerates"
								I.germ_level = 0
							if(H.jitteriness > 101)
								H.jitteriness = 101
							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()


						if(41 to 69)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							for(var/datum/organ/external/O in H.organs)

							var/datum/organ/external/head/h = H.organs_by_name["head"]
							if(h.disfigured != 0)
								h.disfigured = 0
								H << "\blue Waves of energy goes through your disfigured face...it feels good"

							for(var/datum/organ/internal/I in H.internal_organs)
								if(I.damage != 0)
									I.damage = 0
									H << "\blue Sweet feeling fills your body, as your viscera regenerates"
								I.germ_level = 0

							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()
							H.radiation = 0
							if(H.jitteriness > 101)
								H.jitteriness = 101

						if(70 to INFINITY)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							for(var/datum/organ/internal/I in H.internal_organs)
								I.germ_level = 0
							for(var/datum/organ/external/O in H.organs)
								O.rejuvenate()
							for(var/datum/disease/D in H.viruses)
								D.cure()
							H.revive()
							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()
							if(H.jitteriness > 101)
								H.jitteriness = 101
							H << "\blue <b>You feel much better!</b>"
				else
					H.adjustToxLoss(-10)
					H.adjustOxyLoss(-10)
					H.adjustCloneLoss(-10)
					H.adjustBrainLoss(-10)
					for(var/datum/organ/external/O in H.organs)
						for(var/datum/wound/W in O.wounds)
							W.heal_damage(5, 1)
							if(W.damage == 0)
								O.wounds -=W
						if(!O.wounds.len)
							if(O.status & ORGAN_BROKEN || O.status & ORGAN_SPLINTED)
								O.status &= ~ORGAN_BROKEN
								O.status &= ~ORGAN_SPLINTED
								H << "\blue Energy wave goes through your body, mending bones in your [O.name]"
							if(O.status & ORGAN_BLEEDING)
								O.status &= ~ORGAN_BLEEDING
								H << "\blue You feel energies mending bleeding wounds in your [O.name]"
							if(O.status & ORGAN_CUT_AWAY || O.status & ORGAN_ATTACHABLE || O.status & ORGAN_DESTROYED)
								O.status &= ~ORGAN_CUT_AWAY
								O.status &= ~ORGAN_ATTACHABLE
								O.status &= ~ORGAN_DESTROYED
								H << "\blue You start feeling your severed limbs growing back"
							if(O.status & ORGAN_DEAD)
								O.status &= ~ORGAN_DEAD
								H << "\blue You can feel your [O.name] again..."
							O.amputated = 0
							O.destspawn = 0
							O.perma_injury = 0
							O.stage = 0
							O.update_damages()

					switch(H.health)
						if(50 to 60)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							if(H.jitteriness > 101)
								H.jitteriness = 101
							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()
						if(61 to 70)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							var/datum/organ/external/head/h = H.organs_by_name["head"]
							if(h.disfigured != 0)
								h.disfigured = 0
								H << "\blue Waves of energy goes through your face, restoring it back to normal"

							for(var/datum/organ/internal/I in H.internal_organs)
								if(I.damage != 0)
									I.damage = 0
									H << "\blue Sweet feeling fills your body, as your viscera regenerates"
								I.germ_level = 0
							if(H.jitteriness > 101)
								H.jitteriness = 101
							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()


						if(71 to 89)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							for(var/datum/organ/external/O in H.organs)

							var/datum/organ/external/head/h = H.organs_by_name["head"]
							if(h.disfigured != 0)
								h.disfigured = 0
								H << "\blue Waves of energy goes through your disfigured face...it feels good"

							for(var/datum/organ/internal/I in H.internal_organs)
								if(I.damage != 0)
									I.damage = 0
									H << "\blue Sweet feeling fills your body, as your viscera regenerates"
								I.germ_level = 0

							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()
							H.radiation = 0
							if(H.jitteriness > 101)
								H.jitteriness = 101

						if(90 to INFINITY)
							if(M_HUSK in H.mutations)
								H.mutations.Remove(M_HUSK)
								H << "\blue As the power channels through your damaged skin, it starts to regenerate..."
							for(var/datum/organ/internal/I in H.internal_organs)
								I.germ_level = 0
							for(var/datum/organ/external/O in H.organs)
								O.rejuvenate()
							for(var/datum/disease/D in H.viruses)
								D.cure()
							H.revive()
							H.reagents.reagent_list = null
							H.vessel.reagent_list = list()
							H.vessel.add_reagent("blood",560)
							H.shock_stage = 0
							spawn(1)
								H.fixblood()
							if(H.jitteriness > 101)
								H.jitteriness = 101
							H << "\blue <b>You feel much better!</b>"
				H.update_body()
				H.updatehealth()

			else if(istype(Z, /mob/living/carbon/alien))	//Aliens have different dam.system
				var/mob/living/carbon/alien/A = Z
				if(star_form == 1)
					A.adjustOxyLoss(-20)
					A.adjustBruteLoss(-20)
					A.adjustFireLoss(-20)
					A.adjustCloneLoss(-20)
				else
					A.adjustOxyLoss(-10)
					A.adjustBruteLoss(-10)
					A.adjustFireLoss(-10)
					A.adjustCloneLoss(-10)


			else
				var/mob/living/carbon/E = Z
				if(star_form == 1)
					E.adjustOxyLoss(-20)
					E.adjustBruteLoss(-20)
					E.adjustFireLoss(-20)
					E.adjustCloneLoss(-20)
					E.adjustToxLoss(-20)
					E.adjustBrainLoss(-20)
				else
					E.adjustOxyLoss(-10)
					E.adjustBruteLoss(-10)
					E.adjustFireLoss(-10)
					E.adjustCloneLoss(-10)
					E.adjustToxLoss(-10)
					E.adjustBrainLoss(-10)




		if(istype(Z, /mob/living/simple_animal))	//Constructs and faithlesses are dark creatures. What happens if we channel light energy through dark creature?
			var/mob/living/simple_animal/S = Z
			if(!S.supernatural)
				if(star_form == 1)
					S.health += 40
				else
					S.health += 20
			else
				if(star_form == 1)
					S.health -= 50
				else
					S.health -= 30

		if(src)
			energy-=25
			if(energy<25)
				src << "\red I am too tired to continue healing that creature..."
				energy = 0
				healing = 0
				return

		if(Z.health >= Z.maxHealth)
			Z.health = Z.maxHealth
			src << "\blue I healed all wounds of that creature"
			healing = 0
			return


		sleep(10)







/mob/living/simple_animal/jirachi/verb/telepathy(mob/living/E as mob in player_list)
	set category = "Jirachi"
	set name = "Telepathy"
	set desc = "Send telepathic message to anyone on the station"

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return


	if(E.stat == 2 || istype(E, /mob/living/silicon))
		src << "\red I can't make a telepathic link with this mind for some reason"
		return


	var/msg = sanitize(input("Message:", "Telepathy") as text|null)

	if(msg)
		log_say("Telepathy: [key_name(src)]->[E.key] : [msg]")

		if(star_form == 0)
			E << "\blue <i>You hear a soft voice in your head...</i> \italic [msg]"
		else
			E << "\blue <b><i>You hear soft and powerful voice in your head...</i></b> \italic \bold [msg]"

		for(var/mob/dead/observer/G in player_list)
			G << "\bold TELEPATHY([src] --> [E]): [msg]"

		src << {"\blue You project "[msg]" into [E] mind"}
	return



/mob/living/simple_animal/jirachi/verb/teleport()
	set category = "Jirachi"
	set name = "Teleport(150)"
	set desc = "Teleport yourself or somebody near you to the any location"
	if(energy<150)
		src << "You don't have enough power!"
		return

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	var/Q = round((world.time - used_teleport)/10, 1)
	if(Q<=20 && star_form == 0)
		src << "\red I am not ready to teleport again. Wait for [20-Q] seconds"
		return



	var/list/choices = list()
	if(star_form == 0)
		for(var/mob/living/C in view(7,src))
			choices += C
	else
		for(var/mob/living/C in world)
			choices += C

	choices = sortAssoc(choices)


	if(!startelelocs.len)
		for(var/area/AR in world)
			if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/centcom) || istype(AR, /area/asteroid)) continue
			if(startelelocs.Find(AR.name)) continue
			var/turf/picked = pick(get_area_turfs(AR.type))
			if (picked.z == 1 || picked.z == 5 || picked.z == 3)
				startelelocs += AR.name
				startelelocs[AR.name] = AR

	startelelocs = sortAssoc(startelelocs)	//Jirachi has his own list with locs

	var/mob/living/I = input(src,"Who do you wish to teleport?") in null|choices

	var/A = input("Area to teleport to", "Teleport") in startelelocs

	for(var/mob/S in viewers(src, null))
		if (S.client && !(S.blinded))
			S << "\red [src]'s eyes starts to glow with the blue light..."
	for(var/mob/M in viewers(I, null))
		if (M.client && !(M.blinded) && (M != I))
			M << "\red [I] wanishes in a cerulean flash!"

	for(var/obj/mecha/Z)
		if(Z.occupant == I)
			Z.go_out()

	if(I && I.buckled)
		I.buckled.unbuckle()

	var/area/thearea = startelelocs[A]
	for(var/mob/living/C in choices)
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			if(!T.density)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
					if(clear)
						L+=T

		if(!L.len)
			usr <<"\red I can't teleport [I] into that location"
			return

		var/list/tempL = L
		var/attempt = null
		var/success = 0
		while(tempL.len)
			attempt = pick(tempL)
			success = I.Move(attempt)
			if(!success)
				tempL.Remove(attempt)
			else
				break

		if(!success)
			I.loc = pick(L)

	if(I == src)
		src << "\blue I transfer myself to the [A]"
	else
		src << "\blue I teleport [I] to the [A]"
		I << "\red Suddenly, you've been blinded with a flash of light!"
		flick("e_flash", I.flash)

	used_teleport = world.time


	for(var/mob/M in viewers(I, null))
		if ((M.client && !( M.blinded ) && (M != I)))
			M << "\red [I] suddenly appears out of nowhere!"



	energy-=150


/mob/living/simple_animal/jirachi/verb/hybernate()
	set category = "Jirachi"
	set name = "Hybernation"
	set desc = "Hybernate to regain your health and energy"
	if(star_form == 1)
		src << "\red You can't hybernate while in Star Form!"
		return
	if(hybernating == 1)
		src << "\red I must regain my energy and health to awake from my hybernation"
		return
	if(energy >= 900 && health >=80)
		src << "\red I do not need to hybernate right now"
		return

	if(healing == 1 || hypnotizing == 1)
		src << "\red I can't hybernate while healing or hypnotizing someone"
		return

	src << "\blue \bold I start hybernating, to regain my life and energy..."

	hybernating = 1
	src.icon_state = "Jirachi-Sleep"

	while(hybernating == 1)
		src.ear_deaf = 1
		src.canmove = 0
		src.SetLuminosity(5)


		if(energy < 900)
			energy += 10
			sleep(10)

		if(energy >= max_energy)
			energy = max_energy

		if(health < 80)
			health += 1
			sleep(10)

		if(health >= maxHealth)
			health = maxHealth

		if(health == maxHealth && energy == max_energy)
			src << "\blue I regained my life and energy and awoken from my sleep"
			src.ear_deaf = null
			src.canmove = 1
			src.SetLuminosity(2)
			src.icon_state = "Jirachi"
			hybernating = 0
			return







/mob/living/simple_animal/jirachi/verb/star()
	set category = "Jirachi"
	set name = "Star Form"
	set desc = "Enter your true form"
	if(energy<900)
		if(star_form != 1)
			src << "Your power must be full for that!"
			return
	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return
	var/M = round((world.time - used_star)/10, 1)
	if(M < 600)
		if(star_form !=1)
			src << "I am not ready to enter my true form. Wait for [600-M] seconds"
			return
	var/mob/living/simple_animal/jirachi/C = src
	var/client/W = C.client

	if(star_form == 0)
		if(alert("Are you sure that you want to enter your true form?",,"Yes","No") == "No")
			return
		if(energy<900)
			return
		C << "\blue <i><b>Immense energy starts to flow inside my body, filling every inch of it, as it starts to transform. My True Eye opens, my powers amplifies. I entered Star Form. My powers are now at maximum level, but my energy depletes with time.</b></i>"
		star_form = 1	//Enhances his other abilities
		src.see_invisible = null
		src.sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS	//X-RAY
		src.SetLuminosity(8)		//Glows strongly while in Star Form
		src.response_harm   = "tries to punch"
		src.harm_intent_damage = 0
		src.verbs.Add(/mob/living/simple_animal/jirachi/proc/global_telepathy,/mob/living/simple_animal/jirachi/proc/shockwave, /mob/living/simple_animal/jirachi/proc/starlight)
		for(var/mob/living/carbon/human/patient in world)	//Medhud during S-form
			W.images += patient.hud_list[HEALTH_HUD]
			W.images += patient.hud_list[STATUS_HUD]
		icon_state = "Jirachi-Star"
		name = "Jirachi-S"	//Change it's sprite!

		for(var/mob/living/carbon/P in view(7,src))
			flick("e_flash", P.flash)
			P << "\red <b>Jirachi starts to glow very brightly!</b>"
	else
		if(src.star_form)
			C << "<b>Strange feeling of blindness covered me, as I closed my Third Eye. Energies calms inside me and I revert back to my orginal form.</b>"
			star_form = 0
			src.see_invisible = SEE_INVISIBLE_LIVING
			src.sight = null
			src.SetLuminosity(2)
			response_harm   = "punches"
			harm_intent_damage = 10
			src.verbs -= /mob/living/simple_animal/jirachi/proc/global_telepathy
			src.verbs -= /mob/living/simple_animal/jirachi/proc/shockwave
			src.verbs -=/mob/living/simple_animal/jirachi/proc/starlight
			for(var/mob/living/carbon/human/patient in world)
				W.images -= patient.hud_list[HEALTH_HUD]
				W.images -= patient.hud_list[STATUS_HUD]
			icon_state = "Jirachi"
			name = "Jirachi"

			for(var/mob/living/carbon/L in view(7,src))
				L << "\red <b>Light energy envelops Jirachi-S, as it starts transforming back to it's normal form!</b>"


	while(star_form == 1)
		src.energy -=3
		sleep(10)

		if(energy <= 0)
			C << "\red <b>I am too exhausted...I can't further maintain my true form, I almost ran out of energy...I revert back to my original form.</b>"
			star_form = 0
			energy = 0
			src.sight = null
			src.SetLuminosity(2)
			response_harm   = "punches"
			harm_intent_damage = 10
			src.verbs -= /mob/living/simple_animal/jirachi/proc/global_telepathy
			src.verbs -= /mob/living/simple_animal/jirachi/proc/shockwave
			src.verbs -= /mob/living/simple_animal/jirachi/proc/starlight
			for(var/mob/living/carbon/human/patient in world)
				W.images -= patient.hud_list[HEALTH_HUD]
				W.images -= patient.hud_list[STATUS_HUD]
			icon_state = "Jirachi"
			name = "Jirachi"
			health=health/2 //If it rans out of energy, shit happens.
			used_star = world.time
			for(var/mob/living/carbon/Y in view(7,src))
				Y << "\red <b>Light energy envelops Jirachi-S, as it starts transforming back to it's normal form!</b>"
			return
	used_star = world.time


/mob/living/simple_animal/jirachi/verb/hypnosis()
	set category = "Jirachi"
	set name = "Hypnosis(300)"
	set desc = "Hypnotize selected target cause it to fall asleep"
	if(energy<300)
		src << "You don't have enough power!"
		return
	if(hypnotizing == 1)
		src << "I am already hypnotizing someone"
		return
	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	var/R = round((world.time - used_hypno)/10, 1)
	if(R < 15)
		src << "\red I need to rest for a while, after my unsuccessful hypnosis attempt!"	//Handles some problens, and prevents spam
		return



	var/list/choices = list()
	for(var/mob/living/carbon/human/C in view(1,src))
		choices += C

	var/mob/living/carbon/human/M = input(src,"Who do you wish to hypnotize?") in null|choices

	if(get_dist(src, M) > 1 )
		src << "\red There is no target"
		return

	if(M == null)
		src << "There is no creature near me to hypnotize"
		return
	if(M.stat != CONSCIOUS)
		src << "I can't hypnotize dead or sleeping creatures"
		return

	if(M.species.flags & IS_SYNTHETIC)
		src << "\red I can't hypnotize silicon creatures"
		return

	if(star_form != 1)
		var/safety = M:eyecheck()
		if(safety >= 1)
			src << "I can't make a direct eye contact with that creature."
			return

	var/X1 = src.loc
	var/X2 = M.loc

	hypnotizing = 1

	if(star_form == 1)
		M.canmove = 0
		M.Stun(15)

	M.eye_blurry = 15

	src << "\red I look directly into the [M] eyes, hypnotizing it."
	M << "\red Jirachi gazes directrly into your eyes. Sweet feeling fills your brain, as you start feeling very drowsy."
	var/i
	for(i=1; i<=12; i++)
		sleep (10)
		if(X1 != src.loc || X2 != M.loc)
			M.update_canmove()
			M.SetStunned(0)
			M.eye_blurry = 0
			src << "<span class='warning'>My eye contact with [M] was interrupted.</span>"
			M << "\blue My mind starts feel clear again, as my eye-contact with Jirachi was interrupted"
			used_hypno = world.time		//Only if hypnosis is interrupted
			hypnotizing = 0
			return

	M.update_canmove()
	M.Sleeping(300)
	M.eye_blurry = 0
	src << "\blue I finished hypnotizing this creature, it will be sleeping for approximately 5 minutes"
	hypnotizing = 0
	energy-=300


/mob/living/simple_animal/jirachi/proc/global_telepathy()
	set category = "Jirachi"
	set name = "Global Telepathy(50)"
	set desc = "Send telepathic message to all organic creatures on the station."

	if(energy<50)
		src << "You don't have enough power!"
		return
	if(star_form == 0)
		src << "You can use that power only in Star Form!"
		return
	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	var/msg = sanitize(input("Message:", text("Enter the text you wish to appear to everyone:"))) as text

	if (!msg)
		return

	for(var/mob/living/carbon/human/P in world)
		if(!(P.species.flags & IS_SYNTHETIC))
			P << "\blue <b><i>You hear echoing, powerful voice in your head...</i></b> \italic \bold [msg]"
	for(var/mob/dead/observer/G in player_list)
		G << "\bold GLOBAL TELEPATHY: [msg]"
	log_say("Global Telepathy: [key_name(usr)] : [msg]")
	src << {"\blue You project "[msg]" into mind of every living creature"}

	energy-=50
	return

/mob/living/simple_animal/jirachi/verb/showa()
	set category = "Jirachi"
	set name = "Show Abilities Info"

	var/list/abilities = list()
	abilities += "Star Form"
	abilities += "Psystrike"
	abilities += "Telepathy"
	abilities += "Hypnosis"
	abilities += "Hybernation"
	abilities += "Teleport"
	abilities += "Forcewall"
	abilities += "Heal"
	abilities += "Blink(Middle Mouse Button)"
	abilities += "Global Telepathy(Star Form only ability)"
	abilities += "Light Shockwave(Star Form only ability)"
	abilities += "Starlight(Star Form only ability)"

	var/A = input("What ability do you want to read about?", "Info") in abilities
	switch(A)
		if("Star Form")
			src << ""
			src << "Star Form - Enter your true form. It costs 3 energy per second. You can enter S-form only when your energy bar is full, and it has 10 minute cooldown from the moment Jirachi exited his second form. In S-form Jirachi is completely invunreable. It's other abilites greatly enhances. It also gains a full X-ray, medHUD vision, and three S-form only abilites. Jirachi is glowing brightly, while in it's second form. Briefly blinds nearly people, when it enters S-form. It can cancel it's second form in any time, and it cancels when it's energy drops to 0. In second case, Jirachi's HP will be cut in half."
		if("Psystrike")
			src << ""
			src << "Psystrike - Stuns target for 15 seconds. Jirachi can't stun silicon units. Can be used through right-click on target Cooldown: 30 seconds. S-form upgrade: Stuns target for 25 seconds, makes target's vision blurry for 30 seconds and deals 25 points of brain damage."
		if("Heal")
			src << ""
			src << "Heal - Heals target. Target must remain close to Jirachi, otherwise healing process will be interrupted. For humans: heals 10 points of every dam.type per second. Mends broken bones, grows back severed limbs, heals damaged internal organs and infection(but NOT viruses). It happens not instantly, and only when target's HP is high enough. Not only humans can be healed by Jirachi, it can heal anyone, even slimes, mokeys, mouses. There is three exceptions: Jirachi can't heal itself, IPC's and when it attempts to heal constructs or faithlesses, it will damage them, not heal. S-form upgrade: heals 20 points of every dam.type per second, folowing events will occur much faster."
		if("Telepathy")
			src << ""
			src << "Telepathy - Sends telepathic message to anyone on the station. Jirachi can't send telepathic messages to silicons. S-form upgrade: message will appear in bold and big blue text."
		if("Forcewall")
			src << ""
			src << "Forcewall - Creates a wall, which lasts for 30 seconds, and has 200 HP itself. Cooldown: 35 seconds. S-form upgrade: No cooldown."
		if("Hybernation")
			src << ""
			src << "Hybernation - Jirachi sleeps, to regain it's health and energy. Restores 10 Energy and 1 HP per second. Jirachi is completely helpless while sleeping. Can't be used while if S-form."
		if("Hypnosis")
			src << ""
			src << "Hypnosis - Jirachi starts hypnotizing selected target. If target moves - hypnosis will be interrupted.  If hypnosis was interrupted, Jirachi can't use this ability for 25 seconds, but energy will not be spended. After 12 seconds passed, and neither target, nor Jirachi moved, target will fall asleep for 5 minutes. Jirachi can't hypnotize IPC's, or the one with eye protection. S-form upgrade: Jirachi can hypnotize through eye protection, and target can't move or act while Jirachi hypnotizing it."
		if("Teleport")
			src << ""
			src << "Teleport - Teleports Jirachi itself or anyone Jirachi can see into selected location in the world, it can also teleport you to the different Z-levels. Cooldown: 20 seconds. S-form upgrade: No cooldown, and Jirachi can teleport anyone in the world, not only the one it can see."
		if("Blink(Middle Mouse Button)")
			src << ""
			src << "Blink - Costs 100 energy. Teleports Jirachi to the selected tile via middle mouse button or right-click => turf => Blink(100). Jirachi can't blink into blocked turfs. Cooldown: 5 seconds. S-form upgrade: No cooldown."
		if("Global Telepathy(Star Form only ability)")
			src << ""
			src << "Global Telepathy - Sends telepathic message to everyone who is not dead and not silicon being. Message will appear and big and bold blue text"
		if("Light Shockwave(Star Form only ability)")
			src << ""
			src << "Light Shockwave - Releases powerful shockwave, which stuns everybody from 25 to 15 seconds(depends on the distantion), and sends everything flying from Jirachi."
		if("Starlight(Star Form only ability)")
			src << ""
			src << "Starlight - Revives target, if the soul in the body. When this happens, Jirachi's energy will be dropped to 0, and it will lose it's HP, inversely from it's remaining energy at the moment of using this ability. After that, remaining HP will be cut in half. Jirachi can die from using this ability, if his energy is too low, but the target still be revived. Jirachi can't revive IPC's and changeling victims."

/mob/living/simple_animal/jirachi/verb/showe()
	set category = "Jirachi"
	set name = "Show Energy Points"

	src << "\bold ENERGY: [energy]/900"

/mob/living/simple_animal/jirachi/proc/starlight()
	set category = "Jirachi"
	set name = "Starlight"
	set desc = "Use all of your power to revive selected target"

	if(star_form == 0)
		src << "You can use that power only in Star Form!"
		return

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return


	var/list/choices = list()
	for(var/mob/living/carbon/human/C in view(1,src))
		if(C.stat == 2)
			choices += C
	var/mob/living/carbon/human/M = input(src,"Who do you wish to revive?") in null|choices
	if(M_HUSK in M.mutations)
		src << "\red Even my power useless here..."	//I dont want it to revive changeling victims.
		return
	if((!M.ckey) || (!M.client))
		src << "\red There is no soul in that creature, so I can't revive it."
		return
	if(M.species.flags & IS_SYNTHETIC)
		src << "\red I can't revive silicon creatures"
		return
	if(M == null || M.stat !=2)
		src << "There is no dead creatures near me"
		return
	if(src.health <= round((max_energy - energy)/10, 10))
		if(!src.stat && alert("My energy is too low to revive that creature, and thus I must use my own life to ressurect it. Do I want to sacrifice myself, but save this creature?",,"Yes","No") == "No")
			return
	src << "\blue \bold I start focusing all of my power and channel it through [M] body, as it start to breathe again..."
	M << "\blue <b>You suddenly feel great power channeling through your body, regenerating your vitals. Your heart beat again, your vision becomes clear, as you realized that you were revived and brig back again with the power of Jirachi!</b>"
	for(var/mob/Q in viewers(src, null))
		if((Q.client && !( Q.blinded ) && (Q != src)))
			Q << "\blue \bold [src] body starts to sparkle with energy. It then raises it's hands up into the air as blinding white light starts to shine upon [M] body. After a moment [M] stands up, alive..."
	M.rejuvenate()
	M.reagents.reagent_list = null
	M.restore_blood()
	M.jitteriness = 0
	M.eye_blurry +=20
	src.health -= round((max_energy - energy)/10, 10)
	src.energy = 0
	return






/mob/living/simple_animal/jirachi/proc/shockwave()
	set category = "Jirachi"
	set name = "Light Shockwave(300)"
	set desc = "Release light energy to stun everybody around"
	if(energy<300)
		src << "You don't have enough power!"
		return
	if(star_form == 0)
		src << "You can use that power only in Star Form!"
		return

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	for(var/mob/living/carbon/human/M in view(7,src))
		M.Weaken(27-2*get_dist(M, src))		//Stun time depends on distance
		M << "\red You have been knocked down from your feet!"

	var/list/atoms = list()
	if(isturf(src))
		atoms = range(src,5)	//Everything in 5-tile radius from Jirachi...
	else
		atoms = orange(src,5)

	for(var/atom/movable/A in atoms)
		if(A.anchored) continue
		spawn(0)
			var/iter = 6-get_dist(A, src)		//..will be scattered away from him!
			for(var/i=0 to iter)
				step_away(A,src)
				sleep(2)


	for(var/mob/K in viewers(src, null))
		if((K.client && !( K.blinded )))
			K << "\red <b>[src] claps with it's hands, creating powerful shockwave!</b>"


	energy-=300
	return


/mob/living/simple_animal/jirachi/verb/shortteleport(turf/T in oview())
	set name = "Blink(100)"
	set desc = "Teleportation to a short distantion"
	set category = null
	set src = usr

	if(energy < 100)
		src << "\red Not enough energy!"
		return
	var/Q = round((world.time - used_steleport)/10, 1)
	if(Q<=5 && star_form == 0)
		src << "\red I am not ready to teleport again. Wait for [5-Q] seconds"
		return

	if(hybernating == 1)
		src << "\red I can't use any of my powers, until my hybernation ends."
		return

	for(var/obj/O)
		if(T == O)
			T=get_turf(O.loc)

	if(src && src.buckled)
		src.buckled.unbuckle()//On my Jirachi event, I got buckled to the chair, and blink away from it. And then, shit happens

	var/turf/mobloc = get_turf(src.loc)
	if((!T.density)&&istype(mobloc, /turf)&&(!is_blocked_turf(T)))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/effects/sparks2.ogg', 50, 1)

		src.loc = T

		var/datum/effect/effect/system/spark_spread/spark = new /datum/effect/effect/system/spark_spread()
		spark.set_up(5,0, src.loc)
		spark.start()

		used_steleport = world.time

		energy -= 100

	else
		src << "\red I can't teleport into solid matter."
		return


/mob/living/simple_animal/jirachi/bullet_act(var/obj/item/projectile/P)
	if(istype(P, /obj/item/projectile))
		if(star_form == 1)
			visible_message("<span class='danger'>[src] shields itself from the [P.name]!</span>", \
							"<span class='userdanger'>[src] shields itself from the [P.name]!</span>")
			var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

					// redirect the projectile
			P.original = locate(new_x, new_y, P.z)
			P.loc = get_turf(src)
			P.starting = curloc
			P.current = curloc
			P.firer = src
			P.shot_from = src
			P.yo = new_y - curloc.y
			P.xo = new_x - curloc.x

			return -1

	return (..(P))

/mob/living/simple_animal/jirachi/Stat()
	..()

	statpanel("Status")
	if (client.statpanel == "Status")
		if(istype(src,/mob/living/simple_animal/jirachi))
			stat(null, "Energy: [energy]/900")

	if(ticker && ticker.mode && ticker.mode.name == "AI malfunction")
		if(ticker.mode:malf_mode_declared)
			stat(null, "Time left: [max(ticker.mode:AI_win_timeleft/(ticker.mode:apcs/3), 0)]")
	if(emergency_shuttle)
		if(emergency_shuttle.online && emergency_shuttle.location < 2)
			var/timeleft = emergency_shuttle.timeleft()
			if (timeleft)
				stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")




////////////////////////////////////////ARTIFACT////////////////////////////////////////




/obj/item/device/jirachistone
	name = "Shiny Stone"
	icon = 'jirachi.dmi'
	icon_state = "stone"
	item_state = "stone"
	w_class = 2
	throw_speed = 4
	throw_range = 10
	origin_tech = "powerstorage=6;materials=6;biotech=5;bluespace=5;magnets=5"
	var/searching = 0

	attack_self(mob/user as mob)
		for(var/mob/living/simple_animal/jirachi/K in mob_list)
			if(K)
				user << "\red Stone flickers for a moment, than fades dark."
				return
		if(searching == 0).
			user << "\blue The stone begins to flicker with light!"
			icon_state = "stone"
			src.searching = 1
			spawn(50)
			src.request_player()
			spawn(600)
				src.searching = 0
				user << "\red The stone stops flickering..."

/obj/item/device/jirachistone/proc/request_player()
	for(var/mob/dead/observer/O in player_list)
		if(O.client)
			question(O.client)


/obj/item/device/jirachistone/proc/question(var/client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, "It looks like xenoarcheologists found and activated ancient artifact, which summons Jirachi! Would you like to play as it?", "Jirachi request", "Yes", "No")
		if(!C || 0 == searching || !src)
			return
		for(var/mob/living/simple_animal/jirachi/J in mob_list)
			if(J)
				return
		if(response == "Yes")
			for(var/mob/living/carbon/human/P in view(7,get_turf(src.loc)))
				flick("e_flash", P.flash)
				P << "\red \b Stone starts to glow very brightly, as it starts to transform into some kind of creature..."


			var/mob/living/simple_animal/jirachi = new /mob/living/simple_animal/jirachi
			jirachi.loc = get_turf(src)
			jirachi.key = C.key
			jirachi << "\blue <i><b>Strange feeling...</b></i>"
			jirachi << "\blue <i><b>I feel energy pulsating from every inch of my body</b></i>"
			jirachi << "\blue <i><b>Star power begins to emerge from me, breaking my involucre</b></i>"
			jirachi << "\blue <i><b>My crystalline shell brokens, as I opened my eyes...</b></i>"
			jirachi << ""
			jirachi << "<b>You are now playing as Jirachi - the Child Of The Star!</b> Jirachi is the creature, born by means of Light, Life and Star powers. It is kind to all living beings. That means you ought to protect ordinary crew members, wizards, traitors, aliens, changelings, Syndicate Operatives and others from killing each other. <b><font color=red>Do no harm! Jirachi can't stand pain or suffering of any living creature. Try to use your offensive abilities as little as possible</font></b> In short - you are adorable but very powerful creature, which loves everybody. More information how to RP as Jirachi can be found here: http://tauceti.ru/forums/index.php?topic=3171.0 Have fun!"
			dead_mob_list -= C
			del(src)