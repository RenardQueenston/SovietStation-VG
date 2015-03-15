
/area/losttemple
	name = "lost temple"
	icon_state = "away"
	always_unpowered = 1
	var/arealum = 1

	house
		name = "0-house"
		icon_state = "away3"
		arealum = 0
		always_unpowered = 0
		requires_power = 0
	village
		name = "0-village"
		icon_state = "away4"
		arealum = 5
	ground
		name = "0-ground"
		icon_state = "janitor"
		arealum = 5
	forest
		name = "0-forest"
		icon_state = "away2"
		arealum = 2
	darkforest
		name = "0-dark forest"
		icon_state = "away1"
		arealum = 1
	temple
		name = "0-temple"
		icon_state = "dark"
		arealum = 1
	cave
		name = "0-cave"
		icon_state = "party"
		arealum = 0

/obj/daylight
	name = "light"
	desc = "Fuck the TG light system."
	icon = null
	invisibility = INVISIBILITY_LEVEL_TWO
	luminosity = 0
	anchored = 1

/obj/structure/magicfield
	name = "strange field"
	icon = 'icons/special/sprites32.dmi'
	icon_state = "blank"
	anchored = 1
	density = 1

	Bumped()
		icon_state = "blood"
		sleep(7)
		icon_state = "blank"

/obj/item/clothing/head/helmet/explorer
	name = "Explorers helmet"
	desc = ""
	icon_state = "m10hlm"
	flags = FPRINT
	item_state = "helmet"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS
	cold_protection = HEAD
	species_fit = list("Vox")
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECITON_TEMPERATURE
	siemens_coefficient = 0.5
	var/obj/item/device/radio/R = null
	var/obj/machinery/camera/C = null

	New()
		R = new /obj/item/device/radio(src)
		R.frequency = 1411
		R.broadcasting = 1
		R.listening = 1
		C = new /obj/machinery/camera(src)
		C.c_tag = "EXP-[rand(100,999)]"
		C.network = list("explorer")
		C.use_power = 0
		C.idle_power_usage = 0
		C.active_power_usage = 0

	verb/SwitchRadio()
		set name  = "Switch Radio"
		set category = "Object"

		if(R)
			R.broadcasting = !R.broadcasting
			R.listening = !R.listening
			usr << "You switch the radio."

/obj/item/device/tablet
	name = "\improper Tablet"
	desc = "A portable microcomputer by Thinktronic Systems, LTD."
	icon = 'icons/special/tablet.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = 1.0
	flags = FPRINT
	slot_flags = SLOT_BELT
	var/obj/machinery/camera/current = null
	var/last_pic = 1.0
	var/list/network = list("explorer")

	attack_ai(var/mob/user as mob)
		return attack_self(user)
	attack_paw(var/mob/user as mob)
		return attack_self(user)
	check_eye(var/mob/user as mob)
		if ((get_dist(user, src) > 1 || !( user.canmove ) || user.blinded || !( current ) || !( current.status )) && (!istype(user, /mob/living/silicon)))
			return null
		user.reset_view(current)
		return 1
	attack_self(var/mob/user as mob)
		if(!isAI(user))
			user.set_machine(src)
		var/list/L = list()
		for (var/obj/machinery/camera/C in cameranet.cameras)
			L.Add(C)
		camera_sort(L)
		var/list/D = list()
		D["Cancel"] = "Cancel"
		for(var/obj/machinery/camera/C in L)
			var/list/tempnetwork = C.network&network
			if(tempnetwork.len)
				D[text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))] = C
		var/t = input(user, "Which camera should you change to?") as null|anything in D
		if(!t)
			user.unset_machine()
			return 0
		user.set_machine(src)
		var/obj/machinery/camera/C = D[t]
		if(t == "Cancel")
			user.unset_machine()
			return 0
		if(C)
			if ((get_dist(user, src) > 1 || user.machine != src || user.blinded || !( user.canmove ) || !( C.can_use() )) && (!istype(user, /mob/living/silicon/ai)))
				if(!C.can_use() && !isAI(user))
					src.current = null
				return 0
			else
				if(isAI(user))
					var/mob/living/silicon/ai/A = user
					A.eyeobj.setLoc(get_turf(C))
					A.client.eye = A.eyeobj
				else
					src.current = C
				spawn(5)
					attack_hand(user)
		return

/turf/unsimulated/floor/ground
	name = "ground"
	icon = 'icons/special/ground.dmi'
	icon_state = "0"
	var/ground_prev = null
	var/plating_prev = null
	var/obj/daylight/L = null

	New()
		if(istype(loc, /area/losttemple) && loc:arealum)
			L = new /obj/daylight(get_turf(src))
			L.SetLuminosity(loc:arealum)
			L.trueLuminosity = loc:arealum*loc:arealum
			L.UpdateAffectingLights()
			UpdateAffectingLights()
	Del()
		if(L)
			L.SetLuminosity(0)
			L.trueLuminosity = 0
			UpdateAffectingLights()
			del(L)
		..()

/turf/unsimulated/floor/ground/attackby(obj/item/O as obj, mob/user as mob)

	if(!O || !user)
		return 0

	if(istype(O,/obj/item/weapon/storage/bag/ore))
		var/obj/item/weapon/storage/bag/ore/B = O
		if(B.collection_mode)
			for(var/obj/item/weapon/ore/I in contents)
				I.attackby(O,user)
				return

/turf/unsimulated/floor/ground/beach
	name = "beach"
	icon = 'icons/special/beach.dmi'
	icon_state = "desert"

	New()
		icon_state = "desert[rand(0,4)]"
		..()

/turf/unsimulated/floor/ground/water
	name = "water"
	icon = 'icons/special/beach.dmi'
	icon_state = "beach"

	MouseDrop(obj/over_object as obj)
		if(usr.stat || !ishuman(usr) || !usr.canmove || usr.restrained())
			return
		if(istype(over_object, /obj/structure/reagent_dispensers/watertank) && in_range(src, usr) && get_dist(over_object, src) <= 1)
			var/obj/structure/reagent_dispensers/watertank/W = over_object
			usr << "You fill the watertank with [1000-W.reagents.total_volume] water amount."
			W.reagents.add_reagent("water", 1000-W.reagents.total_volume)

/turf/unsimulated/floor/ground/fertile
	name = "fertile ground"
	icon_state = "1"
	var/obj/item/device/flashlight/F = null

	New()
		icon_state = "[rand(1,6)]"
		..()

	attackby(obj/item/weapon/O as obj, mob/user as mob)

		if(istype(O, /obj/item/device/flashlight))
			F = O
			O.loc = src

		if(istype(O, /obj/item/weapon/minihoe))
			for(var/obj/S in range(1))
				if(S.x == src.x && S.y == src.y)
					if(istype(S, /obj/structure) || istype(S, /obj/machinery))
						usr << "Clear the ground before making humus."
						return
			ChangeTurf(/turf/unsimulated/floor/ground/humus)
			return

		if(istype(O, /obj/item/stack/sheet/greystone))
			for(var/obj/F in range(1))
				if(F.x == src.x && F.y == src.y)
					if(istype(F, /obj/structure) || istype(F, /obj/machinery))
						usr << "Clear the ground before making road."
						return
			var/turf/T = get_turf(user)
			var/obj/item/stack/sheet/greystone/S = O
			if(S.amount < 2)
				return
			user << "<span class='rose'>You start building greystone road.</span>"
			if(do_after(user,50) && user && (T == get_turf(user)))
				user:nutrition -= 2
				if(user:nutrition < 0)
					user:nutrition = 0
				user << "<span class='notice'>You finish building greystone road.</span>"
				S.use(2)
				var/prev_path = src.type
				ChangeTurf(/turf/unsimulated/floor/ground/stoneroad)
				src.ground_prev = prev_path
			return

		if(istype(O, /obj/item/stack/sheet/whitestone))
			var/turf/T = get_turf(user)
			var/obj/item/stack/sheet/whitestone/S = O
			if(S.amount < 2)
				return
			user << "<span class='rose'>You start building whitestone road.</span>"
			if(do_after(user,50) && user && (T == get_turf(user)))
				user:nutrition -= 2
				if(user:nutrition < 0)
					user:nutrition = 0
				user << "<span class='notice'>You finish building whitestone road.</span>"
				S.use(2)
				var/prev_path = src.type
				ChangeTurf(/turf/unsimulated/floor/ground/stoneroad/white)
				src.ground_prev = prev_path
			return
		..()

/turf/unsimulated/floor/ground/stoneroad
	name = "stone road"
	icon = 'icons/special/brickroad.dmi'
	icon_state = "greystone"
	ground_prev = /turf/unsimulated/floor/ground/fertile
	var/stonetype = /obj/item/stack/sheet/greystone

	white
		icon_state = "sandstone"
		stonetype = /obj/item/stack/sheet/whitestone

/turf/unsimulated/floor/ground/stoneroad/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/P = W
		if(!istype(P))
			return
		var/turf/T = get_turf(user)
		if(T != get_turf(user))
			return //if we aren't in the tile we are located in, return
		user << "<span class='rose'>You start crushing down [name] with [W].</span>"
		if(do_after(user,50) && user && (T == get_turf(user)))
			user:nutrition -= 2
			if(user:nutrition < 0)
				user:nutrition = 0
			user << "<span class='notice'>You finish crushing down [name].</span>"
			new stonetype(user.loc)
			ChangeTurf(ground_prev)
		return

	if(istype(W, /obj/item/stack/sheet/greystone))
		var/turf/T = get_turf(user)
		var/obj/item/stack/sheet/greystone/S = W
		if(S.amount < 5)
			return
		user << "<span class='rose'>You start building greystone wall.</span>"
		if(do_after(user,100) && user && (T == get_turf(user)))
			user:nutrition -= 5
			if(user:nutrition < 0)
				user:nutrition = 0
			user << "<span class='notice'>You finish building greystone wall.</span>"
			S.use(5)
			new /area/losttemple/house(get_turf(src))
			var/prev_path = src.type
			var/ground_path = ground_prev
			ChangeTurf(/turf/unsimulated/wall/greystone)
			src.ground_prev = ground_path
			src.plating_prev = prev_path

		return

	if(istype(W, /obj/item/stack/sheet/whitestone))
		var/turf/T = get_turf(user)
		var/obj/item/stack/sheet/whitestone/S = W
		if(S.amount < 5)
			return
		user << "<span class='rose'>You start building whitestone road.</span>"
		if(do_after(user,100) && user && (T == get_turf(user)))
			user:nutrition -= 5
			if(user:nutrition < 0)
				user:nutrition = 0
			user << "<span class='notice'>You finish building whitestone wall.</span>"
			S.use(5)
			new /area/losttemple/house(get_turf(src))
			var/prev_path = src.type
			var/ground_path = ground_prev
			ChangeTurf(/turf/unsimulated/wall/greystone/whitestone)
			src.ground_prev = ground_path
			src.plating_prev = prev_path
		return

	if(istype(W, /obj/item/stack/sheet/wood))
		var/turf/T = get_turf(user)
		var/obj/item/stack/sheet/whitestone/S = W
		if(S.amount < 2)
			return
		user << "<span class='rose'>You start building wooden floor.</span>"
		if(do_after(user,20) && user && (T == get_turf(user)))
			user:nutrition -= 1
			if(user:nutrition < 0)
				user:nutrition = 0
			user << "<span class='notice'>You finish building wooden floor.</span>"
			S.use(2)
			new /area/losttemple/house(get_turf(src))
			var/prev_path = src.type
			var/ground_path = ground_prev
			ChangeTurf(/turf/unsimulated/floor/ground/wood)
			src.ground_prev = ground_path
			src.plating_prev = prev_path
		return

	..()

/turf/unsimulated/floor/ground/wood
	name = "wood floor"
	icon = 'icons/special/wood.dmi'
	icon_state = "wood"
	ground_prev = /turf/unsimulated/floor/ground/fertile
	plating_prev = /turf/unsimulated/floor/ground/stoneroad

	New()
		..()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/crowbar))
			for(var/obj/F in range(1))
				if(F.x == src.x && F.y == src.y)
					if(istype(F, /obj/structure) || istype(F, /obj/machinery))
						usr << "Clear the floor before deconstruction."
						return
			var/obj/item/weapon/crowbar/P = W
			if(!istype(P))
				return
			var/turf/T = get_turf(user)
			user << "<span class='rose'>You start crushing down [name] with [W].</span>"
			if(do_after(user,20) && user && (T == get_turf(user)))
				user:nutrition -= 1
				if(user:nutrition < 0)
					user:nutrition = 0
				user << "<span class='notice'>You finish crushing down [name].</span>"
				new /area/losttemple/village(get_turf(src))
				new /obj/item/stack/sheet/wood(user.loc)
				var/ground = ground_prev
				ChangeTurf(plating_prev)
				src.ground_prev = ground
			return

/turf/unsimulated/wall/greystone
	name = "greystone wall"
	icon = 'icons/special/brickwall.dmi'
	icon_state = "lightbrown"
	var/stonetype = /obj/item/stack/sheet/greystone
	var/ground_prev = /turf/unsimulated/floor/ground/fertile
	var/plating_prev = /turf/unsimulated/floor/ground/stoneroad

	whitestone
		name = "greystone wall"
		icon_state = "lightsandstone"
		stonetype = /obj/item/stack/sheet/whitestone
		plating_prev = /turf/unsimulated/floor/ground/stoneroad/white

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/pickaxe))
			var/obj/item/weapon/pickaxe/P = W
			if(!istype(P))
				return
			var/turf/T = get_turf(user)
			user << "<span class='rose'>You start crushing down [name] with [W].</span>"
			if(do_after(user,100) && user && (T == get_turf(user)))
				user:nutrition -= 5
				if(user:nutrition < 0)
					user:nutrition = 0
				user << "<span class='notice'>You finish crushing down [name].</span>"
				new stonetype(user.loc)
				new stonetype(user.loc)
				new stonetype(user.loc)
				new /area/losttemple/village(get_turf(src))
				var/ground = ground_prev
				ChangeTurf(plating_prev)
				src.ground_prev = ground
			return

/obj/structure/grass
	name = "grass"
	icon = 'icons/special/grass.dmi'
	icon_state = "longgrass"
	anchored = 1

	attackby(obj/item/weapon/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/pickaxe/shovel))
			visible_message("[user] digs [name].")
			del(src)

	grasspath
		icon = 'icons/special/longgrass.dmi'
		icon_state = "0-0"


/obj/structure/stump
	name = "stump"
	icon = 'icons/special/flora32.dmi'
	icon_state = "stump"
	anchored = 1

/obj/structure/scarecrow
	name = "scarecrow"
	icon = 'icons/special/flora32x64.dmi'
	icon_state = "scarecrow"
	anchored = 1
	density = 1

/obj/structure/tree
	name = "tree"
	icon = 'icons/special/sprites96x128.dmi'
	icon_state = "oak"
	anchored = 1
	density = 1
	pixel_x = -32
	layer = 9
	var/wood = 200
	var/last_act = 0

	examine()
		..()
		usr << "It is cutted on [(wood/initial(wood))*100]%"

/obj/structure/tree/palmtree
	name = "palm"
	icon_state = "palm"

/obj/structure/tree/darktree
	name = "Dark tree"
	icon_state = "grimoak"

/obj/structure/tree/winterpine
	name = "Pine"
	icon_state = "pine"

/obj/structure/tree/smalltree
	name = "small tree"
	icon = 'icons/special/flora64.dmi'
	icon_state = "tree"
	wood = 100
	pixel_x = -16

/obj/structure/tree/smalltree/dead
	name = "dead tree"
	icon = 'icons/special/flora64.dmi'
	icon_state = "1"
	wood = 100
	pixel_x = -16

	New()
		icon_state = "[rand(1,3)]"
		..()

/obj/structure/tree/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "<span class='warning>You don't have the dexterity to do this!</span>"
		return
	if(istype(W, /obj/item/weapon/twohanded/fireaxe) || istype(W, /obj/item/weapon/hatchet))
		var/turf/T = get_turf(user)
		if(T != get_turf(user))
			return //if we aren't in the tile we are located in, return
		if(last_act + 50 > world.time)//prevents message spam
			return
		last_act = world.time
		user << "<span class='rose'>You start cutting down [name] with [W].</span>"
		if(do_after(user,50) && user && (T == get_turf(user)))
			if(istype(W, /obj/item/weapon/hatchet))
				wood -= 1
				user:nutrition -= 1
				if(user:nutrition < 0)
					user:nutrition = 0
			if(istype(W, /obj/item/weapon/twohanded/fireaxe))
				wood -= 2
				new /obj/item/weapon/grown/log(user.loc)
				user:nutrition -= 3
				if(user:nutrition < 0)
					user:nutrition = 0
			user << "<span class='notice'>You finish cutting down [name].</span>"
			new /obj/item/weapon/grown/log(user.loc)
			if(wood <= 0)
				visible_message("<span class='notice'>[name] falls down.</span>")
				new /obj/structure/stump(src.loc)
				del(src)

/obj/structure/stone
	name = "whitestone"
	icon = 'icons/special/rocks.dmi'
	icon_state = "white1"
	anchored = 1
	var/stone = 2
	var/last_act = 0
	var/stonetype = /obj/item/stack/sheet/whitestone

	examine()
		..()
		usr << "It is crushed on [(stone/initial(stone))*100]%"

/obj/structure/stone/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "<span class='warning>You don't have the dexterity to do this!</span>"
		return
	if(istype(W, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/P = W
		if(!istype(P))
			return
		var/turf/T = get_turf(user)
		if(T != get_turf(user))
			return //if we aren't in the tile we are located in, return
		if(last_act + 50 > world.time)//prevents message spam
			return
		last_act = world.time
		user << "<span class='rose'>You start crushing down [name] with [W].</span>"
		if(do_after(user,50) && user && (T == get_turf(user)))
			stone -= 1
			user:nutrition -= 2
			if(user:nutrition < 0)
				user:nutrition = 0
			user << "<span class='notice'>You finish crushing down [name].</span>"
			new stonetype(src.loc)
			if(!stone)
				visible_message("<span class='notice'>[name] falls apart.</span>")
				del(src)

/obj/item/stack/sheet/whitestone
	name = "whitestone"
	singular_name = "whitestone"
	icon = 'icons/special/brickwall.dmi'
	icon_state = "whitestone"

/obj/item/stack/sheet/greystone
	name = "greystone"
	singular_name = "greystone"
	icon = 'icons/special/brickwall.dmi'
	icon_state = "greystone"

/turf/unsimulated/floor/ground/humus
	name = "humus"
	icon_state = "g1"
	var/kill = 0 // for process()
	var/waterlevel = 100 // The amount of water in the tray (max 100)
	var/nutrilevel = 10 // The amount of nutrient in the tray (max 10)
	var/pestlevel = 0 // The amount of pests in the tray (max 10)
	var/weedlevel = 0 // The amount of weeds in the tray (max 10)
	var/yieldmod = 1 //Modifier to yield
	var/mutmod = 1 //Modifier to mutation chance
	var/toxic = 0 // Toxicity in the tray?
	var/age = 0 // Current age
	var/dead = 0 // Is it dead?
	var/health = 0 // Its health.
	var/lastproduce = 0 // Last time it was harvested
	var/lastcycle = 0 //Used for timing of cycles.
	var/cycledelay = 200 // About 10 seconds / cycle
	var/planted = 0 // Is it occupied?
	var/harvest = 0 //Ready to harvest?
	var/obj/item/seeds/seed = null // The currently planted seed
	var/datum/seed/myseed = null
	var/HYDRO_SPEED_MULTIPLIER = 0.1

	New()
		icon_state = "g[rand(1,4)]"
		..()
		process()


/turf/unsimulated/floor/ground/humus/bullet_act(var/obj/item/projectile/Proj) //Works with the Somatoray to modify plant variables.
	if(istype(Proj ,/obj/item/projectile/energy/floramut))
		if(planted)
			mutate()
	else if(istype(Proj ,/obj/item/projectile/energy/florayield))
		if(planted && myseed.yield == 0)
			myseed.yield += 1
		else if (planted && (prob(1/(myseed.yield * myseed.yield) *100)))
			myseed.yield += 1
	else
		..()
		return

/turf/unsimulated/floor/ground/humus/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE) && age <= 3)
		return 1
	else
		return 0

/turf/unsimulated/floor/ground/humus/proc/process()//like in master controller, but this is a shit --AndyAdjutor
	while(src)
		if(seed && (seed.loc != src.contents))
			seed.loc = src.contents

		if(world.time > (lastcycle + cycledelay))
			lastcycle = world.time
			if(planted && !dead)
				// Advance age
				age += 1 * 0.25 //for balance
	//Nutrients//////////////////////////////////////////////////////////////
				// Nutrients deplete slowly
				if(nutrilevel > 0)
					if(prob(50))
						nutrilevel -= 1 * HYDRO_SPEED_MULTIPLIER

				// Lack of nutrients hurts non-weeds
				if(nutrilevel <= 0 && myseed.requires_nutrients)
					health -= rand(1,3) * HYDRO_SPEED_MULTIPLIER

	//Water//////////////////////////////////////////////////////////////////
				// Drink random amount of water
				waterlevel = max(waterlevel - rand(1,6) * HYDRO_SPEED_MULTIPLIER, 0)

				// If the plant is dry, it loses health pretty fast, unless mushroom
				if(waterlevel <= 10 && myseed.requires_water)
					health -= rand(0,1) * HYDRO_SPEED_MULTIPLIER
					if(waterlevel <= 0)
						health -= rand(0,2) * HYDRO_SPEED_MULTIPLIER

				// Sufficient water level and nutrient level = plant healthy
				else if(waterlevel > 10 && nutrilevel > 0)
					health += rand(1,2) * HYDRO_SPEED_MULTIPLIER
					if(prob(5))  //5 percent chance the weed population will increase
						weedlevel += 1 * HYDRO_SPEED_MULTIPLIER
	//Toxins/////////////////////////////////////////////////////////////////

				// Too much toxins cause harm, but when the plant drinks the contaiminated water, the toxins disappear slowly
				if(toxic >= 40 && toxic < 80)
					health -= 1 * HYDRO_SPEED_MULTIPLIER
					toxic -= rand(1,10) * HYDRO_SPEED_MULTIPLIER
				else if(toxic >= 80) // I don't think it ever gets here tbh unless above is commented out
					health -= 3 * HYDRO_SPEED_MULTIPLIER
					toxic -= rand(1,10) * HYDRO_SPEED_MULTIPLIER
				else if(toxic < 0) // Make sure it won't go overoboard
					toxic = 0

	//Pests & Weeds//////////////////////////////////////////////////////////

				// Too many pests cause the plant to be sick
				if (pestlevel > 10 ) // Make sure it won't go overoboard
					pestlevel = 10

				else if(pestlevel >= 5)
					health -= 1 * HYDRO_SPEED_MULTIPLIER

				// If it's a weed, it doesn't stunt the growth
				if(weedlevel > myseed.weed_tolerance && !myseed.carnivorous && !myseed.parasite)
					health -= 1 * HYDRO_SPEED_MULTIPLIER


	//Health & Age///////////////////////////////////////////////////////////
				// Don't go overboard with the health
				if(health > myseed.endurance)
					health = myseed.endurance

				// Plant dies if health <= 0
				else if(health <= 0)
					dead = 1
					harvest = 0
					weedlevel += 1 * HYDRO_SPEED_MULTIPLIER // Weeds flourish
					pestlevel = 0 // Pests die

				// If the plant is too old, lose health fast
				if(age > myseed.lifespan)
					health -= rand(1,5) * HYDRO_SPEED_MULTIPLIER

				// Harvest code
				if(age > myseed.production && (age - lastproduce) > myseed.production && (!harvest && !dead))
					for(var/i = 0; i < mutmod; i++)
						if(prob(85))
							mutate()
						else if(prob(30))
							hardmutate()
						else if(prob(5))
							mutatespecie()

					if(yieldmod > 0 && myseed.yield != -1) // Unharvestable shouldn't be harvested
						harvest = 1
					else
						lastproduce = age
				if(prob(5))  // On each tick, there's a 5 percent chance the pest population will increase
					pestlevel += 1 * HYDRO_SPEED_MULTIPLIER
			else
				if(waterlevel > 10 && nutrilevel > 0 && prob(10))  // If there's no plant, the percentage chance is 10%
					weedlevel += 1 * HYDRO_SPEED_MULTIPLIER
					if(weedlevel > 10)
						weedlevel = 10

			// Weeeeeeeeeeeeeeedddssss

			if (weedlevel >= 10 && prob(50)) // At this point the plant is kind of fucked. Weeds can overtake the plant spot.
				if(planted)
					if(!myseed.carnivorous && !myseed.parasite) // If a normal plant
						weedinvasion()
				else
					weedinvasion() // Weed invasion into empty tray
		if(age >= 5)
			density = 1
		sleep(cycledelay+1)
		updateicon()
	return



/turf/unsimulated/floor/ground/humus/proc/updateicon()
	//Refreshes the icon and sets the luminosity
	overlays.Cut()
	if(planted)
		if(dead)
			overlays += image('icons/obj/hydroponics.dmi', icon_state="[myseed.name]-dead")
		else if(harvest)
			overlays += image('icons/obj/hydroponics.dmi', icon_state="[myseed.name]-harvest")
		else if(age < myseed.maturation)
			var/t_growthstate = ((age / myseed.maturation) * myseed.growth_stages ) // Make sure it won't crap out due to HERPDERP 6 stages only
			overlays += image('icons/obj/hydroponics.dmi', icon_state="[myseed.name]-grow[round(t_growthstate)]")
			lastproduce = age //Cheating by putting this here, it means that it isn't instantly ready to harvest
		else
			overlays += image('icons/obj/hydroponics.dmi', icon_state="[myseed.name]-grow[myseed.growth_stages]") // Same
	if(istype(seed,/obj/item/seeds/glowshroom))
		SetLuminosity(round(myseed.potency/10))
	else
		SetLuminosity(0)
	return



/turf/unsimulated/floor/ground/humus/proc/weedinvasion() // If a weed growth is sufficient, this happens.
	dead = 0
	if(myseed) // In case there's nothing in the tray beforehand
		del(myseed)
	switch(rand(1,18))		// randomly pick predominative weed
		if(16 to 18)
			seed = new /obj/item/seeds/reishimycelium
		if(14 to 15)
			seed = new /obj/item/seeds/nettleseed
		if(12 to 13)
			seed = new /obj/item/seeds/harebell
		if(10 to 11)
			seed = new /obj/item/seeds/amanitamycelium
		if(8 to 9)
			seed = new /obj/item/seeds/chantermycelium
		if(6 to 7) // implementation for tower caps still kinda missing ~ Not Anymore! -Cheridan
			seed = new /obj/item/seeds/towermycelium
		if(4 to 5)
			seed = new /obj/item/seeds/plumpmycelium
		else
			seed = new /obj/item/seeds/weeds
	myseed = seed.seed
	planted = 1
	age = 0
	health = myseed.endurance
	lastcycle = world.time
	harvest = 0
	weedlevel = 0 // Reset
	pestlevel = 0 // Reset
	updateicon()
	visible_message("\blue [src] has been overtaken by [myseed.seed_name].")

	return


/turf/unsimulated/floor/ground/humus/proc/mutate() // Mutates the current seed

	myseed.lifespan += rand(-2,2)
	if(myseed.lifespan < 10)
		myseed.lifespan = 10
	else if(myseed.lifespan > 30)
		myseed.lifespan = 30

	myseed.endurance += rand(-5,5)
	if(myseed.endurance < 10)
		myseed.endurance = 10
	else if(myseed.endurance > 100)
		myseed.endurance = 100

	myseed.production += rand(-1,1)
	if(myseed.production < 2)
		myseed.production = 2
	else if(myseed.production > 10)
		myseed.production = 10

	if(myseed.yield != -1) // Unharvestable shouldn't suddenly turn harvestable
		myseed.yield += rand(-2,2)
		if(myseed.yield < 0)
			myseed.yield = 0
		else if(myseed.yield > 10)
			myseed.yield = 10
		if(istype(myseed,/datum/seed/mushroom))
			myseed.yield = 1 // Mushrooms always have a minimum yield of 1.

	if(myseed.potency != -1) //Not all plants have a potency
		myseed.potency += rand(-25,25)
		if(myseed.potency < 0)
			myseed.potency = 0
		else if(myseed.potency > 100)
			myseed.potency = 100
	return



/turf/unsimulated/floor/ground/humus/proc/hardmutate() // Strongly mutates the current seed.

	myseed.lifespan += rand(-4,4)
	if(myseed.lifespan < 10)
		myseed.lifespan = 10
	else if(myseed.lifespan > 30 && !istype(seed,/obj/item/seeds/glowshroom)) //hack to prevent glowshrooms from always resetting to 30 sec delay
		myseed.lifespan = 30

	myseed.endurance += rand(-10,10)
	if(myseed.endurance < 10)
		myseed.endurance = 10
	else if(myseed.endurance > 100)
		myseed.endurance = 100

	myseed.production += rand(-2,2)
	if(myseed.production < 2)
		myseed.production = 2
	else if(myseed.production > 10)
		myseed.production = 10

	if(myseed.yield != -1) // Unharvestable shouldn't suddenly turn harvestable
		myseed.yield += rand(-4,4)
		if(myseed.yield < 0)
			myseed.yield = 0
		else if(myseed.yield > 10)
			myseed.yield = 10
		if(istype(myseed,/datum/seed/mushroom))
			myseed.yield = 1 // Mushrooms always have a minimum yield of 1.

	if(myseed.potency != -1) //Not all plants have a potency
		myseed.potency += rand(-50,50)
		if(myseed.potency < 0)
			myseed.potency = 0
		else if(myseed.potency > 100)
			myseed.potency = 100
	return



/turf/unsimulated/floor/ground/humus/proc/mutatespecie() // Mutagent produced a new plant!

	if ( istype(seed, /obj/item/seeds/nettleseed ))
		del(seed)
		seed = new /obj/item/seeds/deathnettleseed

	else if ( istype(seed, /obj/item/seeds/amanitamycelium ))
		del(seed)
		seed = new /obj/item/seeds/angelmycelium

	else if ( istype(seed, /obj/item/seeds/ambrosiavulgarisseed ))
		del(seed)
		seed = new /obj/item/seeds/ambrosiadeusseed

	else if ( istype(seed, /obj/item/seeds/plumpmycelium ))
		del(seed)
		seed = new /obj/item/seeds/walkingmushroommycelium

	else if ( istype(seed, /obj/item/seeds/chiliseed ))
		del(seed)
		seed = new /obj/item/seeds/icepepperseed

	else if ( istype(seed, /obj/item/seeds/appleseed ))
		del(seed)
		seed = new /obj/item/seeds/goldappleseed

	else if ( istype(seed, /obj/item/seeds/berryseed ))
		del(seed)
		switch(rand(1,100))
			if(1 to 50)
				seed = new /obj/item/seeds/poisonberryseed
			if(51 to 100)
				seed = new /obj/item/seeds/glowberryseed

	else if ( istype(seed, /obj/item/seeds/poisonberryseed ))
		del(seed)
		seed = new /obj/item/seeds/deathberryseed

	else if ( istype(seed, /obj/item/seeds/tomatoseed ))
		del(seed)
		switch(rand(1,100))
			if(1 to 35)
				seed = new /obj/item/seeds/bluetomatoseed
			if(36 to 70)
				seed = new /obj/item/seeds/bloodtomatoseed
			if(71 to 100)
				seed = new /obj/item/seeds/killertomatoseed

	else if ( istype(seed, /obj/item/seeds/bluetomatoseed ))
		del(seed)
		seed = new /obj/item/seeds/bluespacetomatoseed

	else if ( istype(seed, /obj/item/seeds/grapeseed ))
		del(seed)
		seed = new /obj/item/seeds/greengrapeseed
/*
	else if ( istype(myseed, /obj/item/seeds/tomatoseed ))
		del(myseed)
		myseed = new /obj/item/seeds/gibtomatoseed
*/
	else if ( istype(seed, /obj/item/seeds/eggplantseed ))
		del(seed)
		seed = new /obj/item/seeds/eggyseed

	else
		return
	myseed = seed.seed
	dead = 0
	hardmutate()
	planted = 1
	age = 0
	health = myseed.endurance
	lastcycle = world.time
	harvest = 0
	weedlevel = 0 // Reset

	spawn(5) // Wait a while
	updateicon()
	visible_message("\red[src] has suddenly mutated into \blue [myseed.seed_name]!")

	return



/turf/unsimulated/floor/ground/humus/proc/mutateweed() // If the weeds gets the mutagent instead. Mind you, this pretty much destroys the old plant
	if ( weedlevel > 5 )
		del(myseed)
		var/newWeed = pick(/obj/item/seeds/libertymycelium, /obj/item/seeds/angelmycelium, /obj/item/seeds/deathnettleseed, /obj/item/seeds/kudzuseed)
		myseed = new newWeed
		dead = 0
		hardmutate()
		planted = 1
		age = 0
		health = myseed.endurance
		lastcycle = world.time
		harvest = 0
		weedlevel = 0 // Reset

		spawn(5) // Wait a while
		updateicon()
		visible_message("\red The mutated weeds in [src] spawned a \blue [myseed.seed_name]!")
	else
		usr << "The few weeds in the [src] seem to react, but only for a moment..."
	return



/turf/unsimulated/floor/ground/humus/proc/plantdies() // OH NOES!!!!! I put this all in one function to make things easier
	health = 0
	dead = 1
	harvest = 0
	updateicon()
	visible_message("\red[src] is looking very unhealthy!")
	return

/turf/unsimulated/floor/ground/humus/attackby(var/obj/item/O as obj, var/mob/user as mob)

	//Called when mob user "attacks" it with object O
	if (istype(O, /obj/item/weapon/reagent_containers/glass))
		var/b_amount = O.reagents.get_reagent_amount("water")
		if(b_amount > 0 && waterlevel < 100)
			if(b_amount + waterlevel > 100)
				b_amount = 100 - waterlevel
			O.reagents.remove_reagent("water", b_amount)
			waterlevel += b_amount
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			user << "You fill \the [src] with [b_amount] units of water."

			// Toxicity dilutation code. The more water you put in, the lesser the toxin concentration.
			toxic -= round(b_amount/4)
			if (toxic < 0 ) // Make sure it won't go overboard
				toxic = 0

		else if(waterlevel >= 100)
			user << "\red \The [src] is already full."
		else
			user << "\red \The [O] is not filled with water."
		updateicon()

	else if (istype(O, /obj/item/weapon/reagent_containers/glass/fertilizer))
		user.u_equip(O)
		nutrilevel = 10
		user << "You replace the nutrient solution in the [src]."
		del(O)
		updateicon()

	else if(istype(O, /obj/item/weapon/reagent_containers/syringe))  // Syringe stuff
		var/obj/item/weapon/reagent_containers/syringe/S = O
		if (planted)
			if (S.mode == 1)
				if(!S.reagents.total_volume)
					user << "\red \The [O] is empty."
					return
				user << "\red You inject the [myseed.seed_name] with a chemical solution."

				// There needs to be a good amount of mutagen to actually work

				if(S.reagents.has_reagent("mutagen", 5))
					switch(rand(100))
						if (91  to 100)	plantdies()
						if (81  to 90)  mutatespecie()
						if (66	to 80)	hardmutate()
						if (41  to 65)  mutate()
						if (21  to 41)  user << "The plants don't seem to react..."
						if (11	to 20)  mutateweed()
						else 			user << "Nothing happens..."

				// Antitoxin binds shit pretty well. So the tox goes significantly down
				if(S.reagents.has_reagent("anti_toxin", 1))
					toxic -= round(S.reagents.get_reagent_amount("anti_toxin")*2)

				// NIGGA, YOU JUST WENT ON FULL RETARD.
				if(S.reagents.has_reagent("toxin", 1))
					toxic += round(S.reagents.get_reagent_amount("toxin")*2)

				// Milk is good for humans, but bad for plants. The sugars canot be used by plants, and the milk fat fucks up growth. Not shrooms though. I can't deal with this now...
				if(S.reagents.has_reagent("milk", 1))
					nutrilevel += round(S.reagents.get_reagent_amount("milk")*0.1)
					waterlevel += round(S.reagents.get_reagent_amount("milk")*0.9)

				// Beer is a chemical composition of alcohol and various other things. It's a shitty nutrient but hey, it's still one. Also alcohol is bad, mmmkay?
				if(S.reagents.has_reagent("beer", 1))
					health -= round(S.reagents.get_reagent_amount("beer")*0.05)
					nutrilevel += round(S.reagents.get_reagent_amount("beer")*0.25)
					waterlevel += round(S.reagents.get_reagent_amount("beer")*0.7)

				// You're an idiot of thinking that one of the most corrosive and deadly gasses would be beneficial
				if(S.reagents.has_reagent("fluorine", 1))
					health -= round(S.reagents.get_reagent_amount("fluorine")*2)
					toxic += round(S.reagents.get_reagent_amount("flourine")*2.5)
					waterlevel -= round(S.reagents.get_reagent_amount("flourine")*0.5)
					weedlevel -= rand(1,4)

				// You're an idiot of thinking that one of the most corrosive and deadly gasses would be beneficial
				if(S.reagents.has_reagent("chlorine", 1))
					health -= round(S.reagents.get_reagent_amount("chlorine")*1)
					toxic += round(S.reagents.get_reagent_amount("chlorine")*1.5)
					waterlevel -= round(S.reagents.get_reagent_amount("chlorine")*0.5)
					weedlevel -= rand(1,3)

				// White Phosphorous + water -> phosphoric acid. That's not a good thing really. Phosphoric salts are beneficial though. And even if the plant suffers, in the long run the tray gets some nutrients. The benefit isn't worth that much.
				if(S.reagents.has_reagent("phosphorus", 1))
					health -= round(S.reagents.get_reagent_amount("phosphorus")*0.75)
					nutrilevel += round(S.reagents.get_reagent_amount("phosphorus")*0.1)
					waterlevel -= round(S.reagents.get_reagent_amount("phosphorus")*0.5)
					weedlevel -= rand(1,2)

				// Plants should not have sugar, they can't use it and it prevents them getting water/ nutients, it is good for mold though...
				if(S.reagents.has_reagent("sugar", 1))
					weedlevel += rand(1,2)
					pestlevel += rand(1,2)
					nutrilevel+= round(S.reagents.get_reagent_amount("sugar")*0.1)

				// It is water!
				if(S.reagents.has_reagent("water", 1))
					waterlevel += round(S.reagents.get_reagent_amount("water")*1)

				// Holy water. Mostly the same as water, it also heals the plant a little with the power of the spirits~
				if(S.reagents.has_reagent("holywater", 1))
					waterlevel += round(S.reagents.get_reagent_amount("holywater")*1)
					health += round(S.reagents.get_reagent_amount("holywater")*0.1)

				// A variety of nutrients are dissolved in club soda, without sugar. These nutrients include carbon, oxygen, hydrogen, phosphorous, potassium, sulfur and sodium, all of which are needed for healthy plant growth.
				if(S.reagents.has_reagent("sodawater", 1))
					waterlevel += round(S.reagents.get_reagent_amount("sodawater")*1)
					health += round(S.reagents.get_reagent_amount("sodawater")*0.1)
					nutrilevel += round(S.reagents.get_reagent_amount("sodawater")*0.1)

				// Man, you guys are retards
				if(S.reagents.has_reagent("sacid", 1))
					health -= round(S.reagents.get_reagent_amount("sacid")*1)
					toxic += round(S.reagents.get_reagent_amount("sacid")*1.5)
					weedlevel -= rand(1,2)

				// SERIOUSLY
				if(S.reagents.has_reagent("pacid", 1))
					health -= round(S.reagents.get_reagent_amount("pacid")*2)
					toxic += round(S.reagents.get_reagent_amount("pacid")*3)
					weedlevel -= rand(1,4)

				// Plant-B-Gone is just as bad
				if(S.reagents.has_reagent("plantbgone", 1))
					health -= round(S.reagents.get_reagent_amount("plantbgone")*2)
					toxic -= round(S.reagents.get_reagent_amount("plantbgone")*3)
					weedlevel -= rand(4,8)

				// Healing
				if(S.reagents.has_reagent("cryoxadone", 1))
					health += round(S.reagents.get_reagent_amount("cryoxadone")*3)
					toxic -= round(S.reagents.get_reagent_amount("cryoxadone")*3)

				// FINALLY IMPLEMENTED, Ammonia is bad ass.
				if(S.reagents.has_reagent("ammonia", 1))
					health += round(S.reagents.get_reagent_amount("ammonia")*0.5)
					nutrilevel += round(S.reagents.get_reagent_amount("ammonia")*1)

				// FINALLY IMPLEMENTED, This is more bad ass, and pests get hurt by the corrosive nature of it, not the plant.
				if(S.reagents.has_reagent("diethylamine", 1))
					health += round(S.reagents.get_reagent_amount("diethylamine")*1)
					nutrilevel += round(S.reagents.get_reagent_amount("diethylamine")*2)
					pestlevel -= rand(1,2)

				// Compost, effectively
				if(S.reagents.has_reagent("nutriment", 1))
					health += round(S.reagents.get_reagent_amount("nutriment")*0.5)
					nutrilevel += round(S.reagents.get_reagent_amount("nutriment")*1)

				// Poor man's mutagen.
				if(S.reagents.has_reagent("radium", 1))
					health -= round(S.reagents.get_reagent_amount("radium")*1.5)
					toxic += round(S.reagents.get_reagent_amount("radium")*2)
				if(S.reagents.has_reagent("radium", 10))
					switch(rand(100))
						if (91  to 100)	plantdies()
						if (81  to 90)  mutatespecie()
						if (66	to 80)	hardmutate()
						if (41  to 65)  mutate()
						if (21  to 41)  user << "The plants don't seem to react..."
						if (11	to 20)  mutateweed()
						else 			user << "Nothing happens..."

				// The best stuff there is. For testing/debugging.
				if(S.reagents.has_reagent("adminordrazine", 1))
					waterlevel += round(S.reagents.get_reagent_amount("adminordrazine")*1)
					health += round(S.reagents.get_reagent_amount("adminordrazine")*1)
					nutrilevel += round(S.reagents.get_reagent_amount("adminordrazine")*1)
					pestlevel -= rand(1,5)
					weedlevel -= rand(1,5)
				if(S.reagents.has_reagent("adminordrazine", 5))
					switch(rand(100))
						if (66  to 100)  mutatespecie()
						if (33	to 65)  mutateweed()
						else 			user << "Nothing happens..."

				S.reagents.clear_reagents()
				if (weedlevel < 0 ) // The following checks are to prevent the stats from going out of bounds.
					weedlevel = 0
				if (health < 0 )
					health = 0
				if (waterlevel > 100 )
					waterlevel = 100
				if (waterlevel < 0 )
					waterlevel = 0
				if (toxic < 0 )
					toxic = 0
				if (toxic > 100 )
					toxic = 100
				if (pestlevel < 0 )
					pestlevel = 0
				if (nutrilevel > 10 )
					nutrilevel = 10
			else
				user << "You can't get any extract out of this plant."
		else
			user << "There's nothing to apply the solution into."
		updateicon()

	else if ( istype(O, /obj/item/seeds/) )
		if(!planted)
			user.u_equip(O)
			user << "You plant the [O.name]"
			dead = 0
			seed = O
			myseed = seed.seed
			planted = 1
			age = 1
			health = myseed.endurance
			lastcycle = world.time
			O.loc = src.contents
			if((user.client  && user.s_active != src))
				user.client.screen -= O
			O.dropped(user)
			updateicon()

		else
			user << "\red The [src] already has seeds in it!"

	else if (istype(O, /obj/item/device/analyzer/plant_analyzer))
		if(planted && myseed)
			user << "*** <B>[myseed.seed_name]</B> ***" //Carn: now reports the plants growing, not the seeds.
			user << "-Plant Age: \blue [age]"
			user << "-Plant Endurance: \blue [myseed.endurance]"
			user << "-Plant Lifespan: \blue [myseed.lifespan]"
			if(myseed.yield != -1)
				user << "-Plant Yield: \blue [myseed.yield]"
			user << "-Plant Production: \blue [myseed.production]"
			if(myseed.potency != -1)
				user << "-Plant Potency: \blue [myseed.potency]"
			user << "-Weed level: \blue [weedlevel]/10"
			user << "-Pest level: \blue [pestlevel]/10"
			user << "-Toxicity level: \blue [toxic]/100"
			user << "-Water level: \blue [waterlevel]/100"
			user << "-Nutrition level: \blue [nutrilevel]/10"
			user << ""
		else
			user << "<B>No plant found.</B>"
			user << "-Weed level: \blue [weedlevel]/10"
			user << "-Pest level: \blue [pestlevel]/10"
			user << "-Toxicity level: \blue [toxic]/100"
			user << "-Water level: \blue [waterlevel]/100"
			user << "-Nutrition level: \blue [nutrilevel]/10"
			user << ""

	else if (istype(O, /obj/item/weapon/reagent_containers/spray/plantbgone))
		if(planted && myseed)
			health -= rand(5,20)

			if(pestlevel > 0)
				pestlevel -= 2 // Kill kill kill
			else
				pestlevel = 0

			if(weedlevel > 0)
				weedlevel -= 3 // Kill kill kill
			else
				weedlevel = 0
			toxic += 4 // Oops
			visible_message("\red <B>\The [src] has been sprayed with \the [O][(user ? " by [user]." : ".")]")
			playsound(loc, 'sound/effects/spray3.ogg', 50, 1, -6)
			updateicon()

	else if (istype(O, /obj/item/weapon/minihoe))  // The minihoe
		//var/deweeding
		if(weedlevel > 0)
			user.visible_message("\red [user] starts uprooting the weeds.", "\red You remove the weeds from the [src].")
			weedlevel = 0
			updateicon()
			src.updateicon()
		else
			user << "\red This plot is completely devoid of weeds. It doesn't need uprooting."

	else if ( istype(O, /obj/item/weapon/plantspray) )
		var/obj/item/weapon/plantspray/spray = O
		user.drop_item(O)
		toxic += spray.toxicity
		pestlevel -= spray.pest_kill_str
		weedlevel -= spray.weed_kill_str
		if (weedlevel < 0 ) // Make sure it won't go overoboard
			weedlevel = 0
		if (pestlevel < 0 ) // Make sure it won't go overoboard
			pestlevel = 0
		if (toxic > 100 ) // Make sure it won't go overoboard
			toxic = 100
		user << "You spray [src] with [O]."
		playsound(loc, 'sound/effects/spray3.ogg', 50, 1, -6)
		qdel(O)
		updateicon()

	else if (istype(O, /obj/item/weapon/storage/bag/plants))
		attack_hand(user)
		var/obj/item/weapon/storage/bag/plants/S = O
		for (var/obj/item/weapon/reagent_containers/food/snacks/grown/G in locate(user.x,user.y,user.z))
			if(!S.can_be_inserted(G))
				return
			S.handle_item_insertion(G, 1)

	else if(istype(O, /obj/item/weapon/pickaxe/shovel))
		if(!myseed || age <=5)
			user << "You clear up the [src]!"
			ChangeTurf(/turf/unsimulated/floor/ground/fertile)
		else
			user << "Clean the [src] before digging!"
	return

/turf/unsimulated/floor/ground/humus/attack_tk(mob/user as mob)
	if(harvest)
		myseed.harvest(src)
	else if(dead)
		planted = 0
		dead = 0
		usr << text("You remove the dead plant from the [src].")
		del(myseed)
		updateicon()

/turf/unsimulated/floor/ground/humus/attack_hand(mob/user as mob)
	if(istype(usr,/mob/living/silicon))		//How does AI know what plant is?
		return
	if(harvest)
		if(!user in range(1,src))
			return
		harvest()
	else if(dead)
		planted = 0
		dead = 0
		usr << text("You remove the dead plant from the [src].")
		del(myseed)
		updateicon()
	else
		if(planted && !dead)
			usr << text("The [src] has \blue [myseed.seed_name] \black planted.")
			if(health <= (myseed.endurance / 2))
				usr << text("The plant looks unhealthy")
		else
			usr << text("The [src] is empty.")
		usr << text("Water: [waterlevel]/100")
		usr << text("Nutrient: [nutrilevel]/10")
		if(weedlevel >= 5) // Visual aid for those blind
			usr << text("The [src] is filled with weeds!")
		if(pestlevel >= 5) // Visual aid for those blind
			usr << text("The [src] is filled with tiny worms!")
		usr << text ("") // Empty line for readability.

/turf/unsimulated/floor/ground/humus/proc/harvest(mob/user = usr)
	var/produce = text2path(myseed.products)
	var/t_amount = 0

	if(istype(seed, /obj/item/seeds/grassseed))
		var/t_yield = round(myseed.yield*yieldmod)
		if(t_yield > 0)
			var/obj/item/stack/tile/grass/new_grass = new/obj/item/stack/tile/grass(user.loc)
			new_grass.amount = t_yield
	else if(istype(seed, /obj/item/seeds/eggyseed))
		while ( t_amount < (myseed.yield * yieldmod ))
			new produce(user.loc)
			t_amount++
	else while( t_amount < (myseed.yield * yieldmod ))
		var/obj/item/weapon/t_prod = new produce(user.loc) // User gets a consumable
		if(!t_prod)	return
		t_prod:plantname = myseed.name
		if((istype(seed, /obj/item/seeds/nettleseed)) && (istype(seed, /obj/item/seeds/deathnettleseed)))
			t_prod:changePotency(myseed.potency)
		else
			t_prod:potency = myseed.potency
		t_amount++
	update_tray()

/turf/unsimulated/floor/ground/humus/proc/update_tray(mob/user = usr)
	harvest = 0
	lastproduce = age
	if((yieldmod * myseed.yield) <= 0 || istype(myseed,/obj/item/seeds/replicapod))
		user << text("\red You fail to harvest anything useful.")
	else
		user << text("You harvest from the [myseed.seed_name].")
	del(myseed)
	del(seed)
	planted = 0
	dead = 0
	updateicon()

/mob/living/simple_animal/hostile/treebeast
	name = "Treebeast"
	icon = 'icons/special/mob64.dmi'
	icon_state = "treebeast"
	icon_living = "treebeast"
	maxHealth = 250
	health = 250
	ranged = 1
	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 20
	retreat_distance = 5
	minimum_distance = 5
	ranged_cooldown = 5
	projectiletype = /obj/item/projectile/energy/neurotoxin
	projectilesound = 'sound/weapons/pierce.ogg'
	pixel_x = -16
	pixel_y = -16
	var/list/T = null
	var/lastbirth = 0

	New()
		var/mob/living/simple_animal/hostile/tribesman/M = new /mob/living/simple_animal/hostile/tribesman(src.loc)
		T = list("[M.id]" = M)
		lastbirth = world.time
		..()

	Life()
		if(health <= 50 && T.len < 2)
			var/mob/living/simple_animal/hostile/tribesman/M = new /mob/living/simple_animal/hostile/tribesman(src.loc)
			T.Add("[M:id]" = M)
			lastbirth = world.time
		for(var/mob/Dead in T)
			if(Dead.stat == 2)
				T.Remove("[T:id]")
		if(T.len < 5 && lastbirth + 300 < world.time)
			var/mob/living/simple_animal/hostile/tribesman/M = new /mob/living/simple_animal/hostile/tribesman(src.loc)
			T.Add("[M:id]" = M)
			lastbirth = world.time
		..()

/mob/living/simple_animal/hostile/tribesman
	name = "Tribesman"
	icon = 'icons/special/jungle.dmi'
	icon_state = "native1"
	icon_living = "native1"
	icon_dead = "native1_dead"
	speed = 5
	maxHealth = 30
	health = 30
	harm_intent_damage = 10
	melee_damage_lower = 20
	melee_damage_upper = 20
	var/id = null

	New()
		id = "[rand(1000,9999)]"
		..()

/mob/living/simple_animal/hostile/shantak
	name = "Shantak"
	icon = 'icons/special/jungle.dmi'
	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	maxHealth = 150
	health = 150
	harm_intent_damage = 20
	melee_damage_lower = 30
	melee_damage_upper = 30

/mob/living/simple_animal/hostile/samak
	name = "Shantak"
	icon = 'icons/special/jungle.dmi'
	icon_state = "samak"
	icon_living = "samak"
	icon_dead = "samak_dead"
	maxHealth = 100
	health = 100
	harm_intent_damage = 20
	melee_damage_lower = 30
	melee_damage_upper = 30

/mob/living/simple_animal/wisp
	name = "Wisp"
	real_name = "Wisp"
	desc = "A spirit"
	icon = 'icons/special/mob64.dmi'
	icon_state = "wisp"
	icon_living = "wisp"
	icon_dead = "blank"
	maxHealth = 100000
	health = 100000
	speak_emote = list("whispers")
	emote_hear = list("wails","screeches")
	response_help  = "puts their hand through"
	response_disarm = "puts their hand through"
	response_harm   = "puts their hand through"
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "taps"
	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	speed = -1
	stop_automated_movement = 1
	status_flags = 0
	faction = "wisp"
	//supernatural = 1
	pixel_x = -16
	pixel_y = -16

	cultify()
		return

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		user.delayNextAttack(8)
		for(var/mob/M in viewers(src, null))
			if ((M.client && !( M.blinded )))
				M.show_message("<span class='warning'> [user] gently taps [src] with [O].</span>")
		return

	verb/kill_magic_field()
		set name = "Destroy Forcefield"
		set category = "Wisp"

		for(var/obj/structure/magicfield/M in world)
			spawn(0)
				M.icon_state = "poof"
				spawn(7)
					del(M)

	verb/hide()
		set name = "Hide(Final Death)"
		set category = "Wisp"

		for(var/i=src.alpha, i>0, i--)
			src.alpha = i
			sleep(1)

/obj/item/gem
	name = "Magic Gem"
	icon = 'icons/special/gems.dmi'
	icon_state = "gem"

/mob/living/simple_animal/hostile/demon
	name = "Demon"
	icon = 'icons/special/demon.dmi'
	icon_state = "demon"
	icon_living = "demon"
	icon_dead = "blank"
	maxHealth = 500
	health = 500
	harm_intent_damage = 30
	melee_damage_lower = 20
	melee_damage_upper = 50

/mob/living/simple_animal/satan
	name = "Head Demon"
	icon = 'icons/obj/narsie.dmi'
	icon_state = "narsie"
	pixel_x = -236
	pixel_y = -256
	luminosity = 1
	l_color = "#3e0000"
	maxHealth = 1000
	health = 1000
	harm_intent_damage = 30
	melee_damage_lower = 20
	melee_damage_upper = 50