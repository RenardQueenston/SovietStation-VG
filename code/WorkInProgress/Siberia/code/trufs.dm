/var/global/idnax = null
/var/global/adnax = null
/var/global/keynax = null

/turf/unsimulated/snow
	name = "Snow"
	icon = 'code/WorkInProgress/Siberia/textures/snow2.dmi'
	icon_state = "SNOW"
	temperature = T0C - 50
	lighting_lumcount = 55
	var/YCgen = null
	var/tex = null

	New()
		icon_state = "[x - 15 * Floor(x / 15)],[y - 15 * Floor(y / 15)]"
		if(tex == null)
			YCgen = Generator1(255,255,118,src.z,16)
			SetTexture()
		else if(tex != null)
			SetTexture()


/turf/unsimulated/snow/proc/SetTexture()
	if(tex <= 1)
		icon = 'code/WorkInProgress/Siberia/textures/snow2.dmi'
	if(tex>1 & tex<=1.2)
		icon = 'code/WorkInProgress/Siberia/textures/IS5c.dmi'
	if(tex>1.2 & tex<=1.5)
		icon = 'code/WorkInProgress/Siberia/textures/IS15c.dmi'
	if(tex>1.5 & tex<=2)
		icon = 'code/WorkInProgress/Siberia/textures/IS30c.dmi'
	if(tex>2 & tex<= 2.5)
		icon = 'code/WorkInProgress/Siberia/textures/IS50c.dmi'
	if(tex>2.5 & tex <3)
		icon = 'code/WorkInProgress/Siberia/textures/IS70c.dmi'
	if(tex >=3)
		icon = 'code/WorkInProgress/Siberia/textures/ICE.dmi'
		ChangeTurf(/turf/unsimulated/snow/rock)

/turf/unsimulated/snow/proc/TextureMix(var/range = 1)
	var/lock = tex%1*100
	if(lock<=5)
		return 5
	else if(lock<=15)
		return 15
	else if(lock<=30)
		return 30
	else if(lock<=50)
		return 50
	else
		return 70

/turf/unsimulated/snow/rock
	explosion_resistance = 2
	density = 1
	name = "rock"
	icon = 'code/WorkInProgress/Siberia/textures/icerock.dmi'
	icon_state = "rock"
	name = "Rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = 1
	blocks_air = 1
	luminosity = 3
	temperature = T0C - 50
	lighting_lumcount = 55


/*	var/mineral/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find
	var/turf/Ground = null
	New()
		. = ..()
		MineralSpread()
		spawn(1)
			var/turf/T
			if((istype(get_step(src, NORTH), /turf/simulated/floor)) || (istype(get_step(src, NORTH), /turf/space)) || (istype(get_step(src, NORTH), /turf/simulated/shuttle/floor)))
				T = get_step(src, NORTH)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_s")
			if((istype(get_step(src, SOUTH), /turf/simulated/floor)) || (istype(get_step(src, SOUTH), /turf/space)) || (istype(get_step(src, SOUTH), /turf/simulated/shuttle/floor)))
				T = get_step(src, SOUTH)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_n", layer=6)
			if((istype(get_step(src, EAST), /turf/simulated/floor)) || (istype(get_step(src, EAST), /turf/space)) || (istype(get_step(src, EAST), /turf/simulated/shuttle/floor)))
				T = get_step(src, EAST)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_w", layer=6)
			if((istype(get_step(src, WEST), /turf/simulated/floor)) || (istype(get_step(src, WEST), /turf/space)) || (istype(get_step(src, WEST), /turf/simulated/shuttle/floor)))
				T = get_step(src, WEST)
				if (T)
					T.overlays += image('icons/turf/walls.dmi', "rock_side_e", layer=6)
	ex_act(severity)
		switch(severity)
			if(2.0)
				if (prob(70))
					mined_ore = 1 //some of the stuff gets blown up
					GetDrilled()
			if(1.0)
				mined_ore = 2 //some of the stuff gets blown up
				GetDrilled()
	Bumped(AM)
		. = ..()
		if(istype(AM,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = AM
			if((istype(H.l_hand,/obj/item/weapon/pickaxe)) && (!H.hand))
				attackby(H.l_hand,H)
			else if((istype(H.r_hand,/obj/item/weapon/pickaxe)) && H.hand)
				attackby(H.r_hand,H)
		else if(istype(AM,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = AM
			if(istype(R.module_active,/obj/item/weapon/pickaxe))
				attackby(R.module_active,R)
		else if(istype(AM,/obj/mecha))
			var/obj/mecha/M = AM
			if(istype(M.selected,/obj/item/mecha_parts/mecha_equipment/tool/drill))
				M.selected.action(src)
	proc/MineralSpread()
		if(mineral && mineral.spread)
			for(var/trydir in cardinal)
				if(prob(mineral.spread_chance))
					var/turf/simulated/mineral/random/target_turf = get_step(src, trydir)
					if(istype(target_turf) && !target_turf.mineral)
						target_turf.mineral = mineral
						target_turf.UpdateMineral()
						target_turf.MineralSpread()
	proc/UpdateMineral()
		if(!mineral)
			name = "\improper Rock"
			icon_state = "rock"
			return
		name = "\improper [mineral.display_name] deposit"
		icon_state = "rock_[mineral.name]"
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
			usr << "\red You don't have the dexterity to do this!"
			return
		if (istype(W, /obj/item/device/core_sampler))
			geologic_data.UpdateNearbyArtifactInfo(src)
			var/obj/item/device/core_sampler/C = W
			C.sample_item(src, user)
			return
		if (istype(W, /obj/item/device/depth_scanner))
			var/obj/item/device/depth_scanner/C = W
			C.scan_atom(user, src)
			return
		if (istype(W, /obj/item/device/measuring_tape))
			var/obj/item/device/measuring_tape/P = W
			user.visible_message("\blue[user] extends [P] towards [src].","\blue You extend [P] towards [src].")
			if(do_after(user,25))
				user << "\blue \icon[P] [src] has been excavated to a depth of [2*excavation_level]cm."
			return
		if (istype(W, /obj/item/weapon/pickaxe))
			var/turf/T = user.loc
			if (!( istype(T, /turf) ))
				return
			var/obj/item/weapon/pickaxe/P = W
			if(last_act + P.digspeed > world.time)//prevents message spam
				return
			last_act = world.time
			playsound(user, P.drill_sound, 20, 1)
			var/fail_message
			if(finds && finds.len)
				var/datum/find/F = finds[1]
				if(excavation_level + P.excavation_amount > F.excavation_required)
					fail_message = ", <b>[pick("there is a crunching noise","[W] collides with some different rock","part of the rock face crumbles away","something breaks under [W]")]</b>"
			user << "\red You start [P.drill_verb][fail_message ? fail_message : ""]."
			if(fail_message && prob(90))
				if(prob(25))
					excavate_find(5, finds[1])
				else if(prob(50))
					finds.Remove(finds[1])
					if(prob(50))
						artifact_debris()
			if(do_after(user,P.digspeed))
				user << "\blue You finish [P.drill_verb] the rock."
				if(finds && finds.len)
					var/datum/find/F = finds[1]
					if(round(excavation_level + P.excavation_amount) == F.excavation_required)
						if(excavation_level + P.excavation_amount > F.excavation_required)
							excavate_find(100, F)
						else
							excavate_find(80, F)
					else if(excavation_level + P.excavation_amount > F.excavation_required - F.clearance_range)
						excavate_find(0, F)
				if( excavation_level + P.excavation_amount >= 100 )
					var/obj/structure/boulder/B
					if(artifact_find)
						if( excavation_level > 0 || prob(15) )
							B = new(src)
							if(artifact_find)
								B.artifact_find = artifact_find
						else
							artifact_debris(1)
					else if(prob(15))
						//empty boulder
						B = new(src)
					if(B)
						GetDrilled(0)
					else
						GetDrilled(1)
					return
				excavation_level += P.excavation_amount
				if(!archaeo_overlay && finds && finds.len)
					var/datum/find/F = finds[1]
					if(F.excavation_required <= excavation_level + F.view_range)
						archaeo_overlay = "overlay_archaeo[rand(1,3)]"
						overlays += archaeo_overlay
				var/update_excav_overlay = 0
				if(excavation_level >= 75)
					if(excavation_level - P.excavation_amount < 75)
						update_excav_overlay = 1
				else if(excavation_level >= 50)
					if(excavation_level - P.excavation_amount < 50)
						update_excav_overlay = 1
				else if(excavation_level >= 25)
					if(excavation_level - P.excavation_amount < 25)
						update_excav_overlay = 1
				if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
					var/excav_quadrant = round(excavation_level / 25) + 1
					excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
					overlays += excav_overlay
				next_rock += P.excavation_amount * 10
				while(next_rock > 100)
					next_rock -= 100
					var/obj/item/weapon/ore/O = new(src)
					geologic_data.UpdateNearbyArtifactInfo(src)
					O.geologic_data = geologic_data
		else
			return attack_hand(user)
	proc/DropMineral()
		if(!mineral)
			return
		var/obj/item/weapon/ore/O = new mineral.ore (src)
		if(istype(O))
			geologic_data.UpdateNearbyArtifactInfo(src)
			O.geologic_data = geologic_data
		return O
	proc/GetDrilled(var/artifact_fail = 0)
		if (mineral && mineral.result_amount)
			for (var/i = 1 to mineral.result_amount - mined_ore)
				DropMineral()
		if(artifact_find && artifact_fail)
			var/pain = 0
			if(prob(50))
				pain = 1
			for(var/mob/living/M in range(src, 200))
				M << "<font color='red'><b>[pick("A high pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!</b></font>"
				if(pain)
					flick("pain",M.pain)
					if(prob(50))
						M.adjustBruteLoss(5)
				else
					flick("flash",M.flash)
					if(prob(50))
						M.Stun(5)
				M.apply_effect(25, IRRADIATE)
		var/turf/TFFS = ChangeTurf(Ground)
		if(istype(TFFS,/turf/unsimulated/snow))
			var/turf/unsimulated/snow/JJK
			JJK.tex = 7
			ChangeTurf(JJK)
		if(rand(1,500) == 1)
			visible_message("<span class='notice'>An old dusty crate was buried within!</span>")
			new /obj/structure/closet/crate/secure/loot(src)
	proc/excavate_find(var/prob_clean = 0, var/datum/find/F)
		var/obj/item/weapon/X
		if(prob_clean)
			X = new /obj/item/weapon/archaeological_find(src, new_item_type = F.find_type)
		else
			X = new /obj/item/weapon/ore/strangerock(src, inside_item_type = F.find_type)
			geologic_data.UpdateNearbyArtifactInfo(src)
			X:geologic_data = geologic_data
		var/display_name = "something"
		if(!X)
			X = last_find
		if(X)
			display_name = X.name
		if(prob(F.prob_delicate))
			var/obj/effect/suspension_field/S = locate() in src
			if(!S || S.field_type != get_responsive_reagent(F.find_type))
				if(X)
					visible_message("\red<b>[pick("[display_name] crumbles away into dust","[display_name] breaks apart")].</b>")
					del(X)
		finds.Remove(F)
	proc/artifact_debris(var/severity = 0)
		for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
			switch(rand(1,7))
				if(1)
					var/obj/item/stack/rods/R = new(src)
					R.amount = rand(5,25)
				if(2)
					var/obj/item/stack/tile/R = new(src)
					R.amount = rand(1,5)
				if(3)
					var/obj/item/stack/sheet/metal/R = new(src)
					R.amount = rand(5,25)
				if(4)
					var/obj/item/stack/sheet/plasteel/R = new(src)
					R.amount = rand(5,25)
				if(5)
					var/quantity = rand(1,3)
					for(var/i=0, i<quantity, i++)
						new /obj/item/weapon/shard(src)
				if(6)
					var/quantity = rand(1,3)
					for(var/i=0, i<quantity, i++)
						new /obj/item/weapon/shard/phoron(src)
				if(7)
					var/obj/item/stack/sheet/mineral/uranium/R = new(src)
					R.amount = rand(5,25)*/
/turf/unsimulated/snow/rock/New()
	spawn(1)
		var/turf/T
		if(!istype(get_step(src, NORTH), /turf/unsimulated/snow/rock) && !istype(get_step(src, NORTH), /turf/unsimulated/wall))
			T = get_step(src, NORTH)
			if (T)
				T.overlays += image('code/WorkInProgress/Siberia/textures/icerock.dmi', "rock_side_s")
		if(!istype(get_step(src, SOUTH), /turf/unsimulated/snow/rock) && !istype(get_step(src, SOUTH), /turf/unsimulated/wall))
			T = get_step(src, SOUTH)
			if (T)
				T.overlays += image('code/WorkInProgress/Siberia/textures/icerock.dmi', "rock_side_n", layer=6)
		if(!istype(get_step(src, EAST), /turf/unsimulated/snow/rock) && !istype(get_step(src, EAST), /turf/unsimulated/wall))
			T = get_step(src, EAST)
			if (T)
				T.overlays += image('code/WorkInProgress/Siberia/textures/icerock.dmi', "rock_side_w", layer=6)
		if(!istype(get_step(src, WEST), /turf/unsimulated/snow/rock) && !istype(get_step(src, WEST), /turf/unsimulated/wall))
			T = get_step(src, WEST)
			if (T)
				T.overlays += image('code/WorkInProgress/Siberia/textures/icerock.dmi', "rock_side_e", layer=6)

/*
/turf/unsimulated/snow/rock/random
	name = "Mineral deposit"
	var/mineralSpawnChanceList = list("Uranium" = 5, "Iron" = 50, "Diamond" = 1, "Gold" = 5, "Silver" = 5, "Phoron" = 25)//Currently, Adamantine won't spawn as it has no uses. -Durandan
	var/mineralChance = 10  //means 10% chance of this plot changing to a mineral deposit

	New()
		if (prob(mineralChance) && !mineral)
			var/mineral_name = pickweight(mineralSpawnChanceList) //temp mineral name

			if(!name_to_mineral)
				SetupMinerals()

			if (mineral_name && mineral_name in name_to_mineral)
				mineral = name_to_mineral[mineral_name]
				UpdateMineral()
		. = ..()


/turf/unsimulated/snow/rock/random/high_chance
	mineralChance = 25
	mineralSpawnChanceList = list("Uranium" = 10, "Iron" = 30, "Diamond" = 2, "Gold" = 10, "Silver" = 10, "Phoron" = 25)
*/