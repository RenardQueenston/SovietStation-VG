/*
Там, где мечты становятся явью.
Расположение спрайтов Советской Станции.
*/

// Раздел Хоса
// Шинель Хоса. Основа - labcoat

/obj/item/clothing/suit/armor/hoscoat
	name = "Formal Greatcoat"
	desc = "A formal suit, that could be good for HoS, or not."
	var/base_icon_state = "formalcoat"
	var/open=1
	item_state = "jensencoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

	update_icon()
		if(open)
			icon_state="[base_icon_state]_open"
		else
			icon_state="[base_icon_state]"

	verb/toggle()
		set name = "Toggle Greatcoat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(open)
			usr << "You button up the greatcoat."
		else
			usr << "You unbutton the greatcoat."
		open=!open
		update_icon()
		usr.update_inv_wear_suit()

/obj/item/clothing/suit/armor/hoscoat/New()
	. = ..()
	update_icon()

//Формальная одежда

/obj/item/clothing/under/rank/head_of_security/hosformal
	desc = "You never asked for anything that stylish."
	name = "head of security's formal uniform"
	icon_state = "hosformal"
	item_state = "hos"
	_color = "hosformal"
	siemens_coefficient = 0.6

//Фуражки Хоса

/obj/item/clothing/head/helmet/HoS/formal
	name = "head of security's formal cap"
	desc = "Looks nice and cool, show officer who is their BOSS!"
	icon_state = "hosformalhat"
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/HoS/formal2
	name = "head of security's enchanced cap"
	desc = "This hat looks brutal. Seems have been taken from old russian officers."
	icon_state = "hat-hos"
	siemens_coefficient = 0.6


//Коммисарская одежда. Украдено с Анимуса, спасибо за кражу.


/obj/item/clothing/head/helmet/commisarcap
	name = "commisar's cap"
	desc = "A cap of fear and madness."
	icon_state = "comcap"
	flags_inv = 0

/obj/item/clothing/suit/armor/commisarcoat
	name = "commisar's coat"
	desc = "A greatcoat enchanced with a special alloy for some protection and style, looks more brutal."
	icon_state = "commissarcoat"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.6

//Феска. Специально для Kirillwars.

/obj/item/clothing/head/fez
	name = "Fez"
	desc = "Cool looking fez. You see a text under 'KWARS'."
	icon_state = "feska"
	flags = FPRINT
	siemens_coefficient = 0.9

// Военная одежда.

/obj/item/clothing/suit/armor/vest/military
	name = "military armor"
	desc = "An armored vest that protects against some damage. Belongs to Solar Republic, government type of armor."
	icon_state = "M03"
	item_state = "armor"

/obj/item/clothing/under/olivecamouflage
	name = "olive jumpsuit"
	desc = "An olive jumpsuit, that have Solar Republic mark."
	icon_state = "bdu_olive"
	icon_state = "bl_suit"
	_color = "bdu_olive"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/military
	name = "military helmet"
	desc = "An olive colored helmet. Belongs to Solar Republic, government type of armor."
	icon_state = "m10hlm"
	item_state = "helmet"
	flags = FPRINT|HEADCOVERSEYES
	armor = list(melee = 80, bullet = 45, laser = 35 ,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/militarycoat
	name = "military coat"
	desc = "Olive-colored coat that have armored plates. Belongs to Solar Republic, government type of armor."
	icon_state = "milcoat"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/olivehelmet
	name = "olive-colored helmet"
	desc = "An olive colored helmet. Have a red star on front side."
	icon_state = "helmet_sum"
	item_state = "helmet"
	flags = FPRINT|HEADCOVERSEYES
	armor = list(melee = 80, bullet = 45, laser = 35 ,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/ushankahelmet
	name = "Ushanka"
	desc = "An ushanka. Have armored plates."
	icon_state = "shapka_win"
	item_state = "helmet"
	flags = FPRINT|HEADCOVERSEYES
	armor = list(melee = 80, bullet = 45, laser = 35 ,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7


// Одежда спецвойск Солнечной Республики

/obj/item/clothing/suit/armor/vest/earthgov
	name = "enchanced helmet"
	desc = "An armored helmet that protects against some damage. This one have Earth interface, seems belongs to Solar Republic."
	icon_state = "earthgov-armor"
	item_state = "armor"

/obj/item/clothing/head/helmet/earthgov
	name = "military helmet"
	desc = "An armored helmet that protects againts some damage. This one have Earth interface, seems belongs to Solar Republic."
	icon_state = "earthgov-helmet"
	item_state = "helmet"
	flags = FPRINT|HEADCOVERSEYES
	armor = list(melee = 80, bullet = 45, laser = 35 ,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/gloves/earthgov
	name = "enchanced gloves"
	desc = "An armored gloves that protects against some damage. They have Earth mark, seems belongs to Solar Republic."
	icon_state = "earthgov-gloves"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECITON_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECITON_TEMPERATURE

/obj/item/clothing/shoes/earthgov
	name = "enchanced boots"
	desc = "An armored boots that protects against some damage. They have Earth mark, seems belongs to Solar Republic."
	icon_state = "earthgov_boots"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags = NOSLIP
	siemens_coefficient = 0.6

/obj/item/clothing/under/earthgov
	desc = "It's a jumpsuit worn by solar government representives."
	name = "Earth Military jumpsuit"
	icon_state = "earthgov_uniform"
	item_state = "bl_suit"
	_color = "earthgov_uniform"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.6


// Звёздные войны: Война Смоллгеев

/obj/item/clothing/suit/armor/vader
	name = "dark-colored suit"
	desc = "A bulky, heavy-duty piece of black armor. Peace is a lie, there is only passion."
	icon_state = "vader"
	item_state = "death_commando_suit"
	w_class = 4
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags = FPRINT  | STOPSPRESSUREDMAGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy, /obj/item/weapon/gun/projectile, /obj/item/ammo_storage, /obj/item/ammo_casing, /obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_nitrogen,/obj/item/weapon/melee/energy/sword/red)
	slowdown = 1.5
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECITON_TEMPERATURE
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/space/vader
	name = "dark-colored vader"
	icon_state = "vaderhelm"
	item_state = "helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Through passion, I gain strength.."
	flags = FPRINT  | HEADCOVERSEYES | STOPSPRESSUREDMAGE
	flags_inv = HIDEFACE
	permeability_coefficient = 0.01
	armor = list(melee = 65, bullet = 50, laser = 50,energy = 25, bomb = 50, bio = 100, rad = 50)

/obj/item/clothing/head/helmet/space/rig/clonesoldier
	name = "white helmet"
	desc = "A special helmet designed for work in a hazardous low pressure environment. Vode An."
	icon_state = "clonehlm"
	_color = "clonehlm"
	species_restricted = list("exclude","Vox")
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/rig/clonesoldier
	icon_state = "clonesld"
	name = "white hardsuit"
	desc = "A special suit that protects against hazardous low pressure environments. Vode An."
	species_restricted = list("exclude","Vox")
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/melee/baton)
	siemens_coefficient = 0.7

// Викторианская эпоха

/obj/item/clothing/suit/redcoat
	name = "Redcoat Suit"
	desc = "True royal suit. God, save the King/Queen."
	icon_state = "redcoat_suit"

/obj/item/clothing/head/redcoathat
	name = "Redcoat Tricorne"
	desc = "True royal hat. God, save the King/Queen."
	icon_state = "redcoat-head"

/obj/item/clothing/head/bearskins
	name = "Bearskins Hat"
	desc = "Popular hat, worned by disciplined royal guards only."
	icon_state = "queen"

/obj/item/clothing/suit/cape
	name = "Cape"
	desc = "Executive cape from old England"
	icon_state = "tea_suit"

/obj/item/clothing/under/musketeer
	desc = "It's a uniform worned by russian musketeers in XIX century."
	name = "musketeer uniform"
	icon_state = "musketeer_uniform"
	item_state = "bl_suit"
	_color = "musketeer_uniform"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.6

/obj/item/clothing/head/musketeer
	name = "Hussar hat"
	desc = "Russian hussar hat, approved by Tsar."
	icon_state = "gusarhat"

// Одежда гражданской обороны

/obj/item/clothing/under/metrocop
	desc = "Strange jumpsuit, seems have many injecting ports and implants."
	name = "armored jumpsuit"
	icon_state = "mpfuni"
	item_state = "bl_suit"
	_color = "mpfuni"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.6

/obj/item/clothing/mask/gas/metrocop
	name = "\improper armored mask"
	desc = "Strange mask, looks can change voice."
	icon_state = "mpfmask"
	siemens_coefficient = 0.7

// Барни!

/obj/item/clothing/suit/armor/vest/blackmesa
	name = "blue armor"
	desc = "Blue armor, have a strange symbol on front side - Lambda"
	icon_state = "bluevest"
	item_state = "armor"

/obj/item/clothing/head/helmet/blackmesa
	name = "Blue helmet"
	desc = "Just a simple blue helmet."
	icon_state = "bluehelmet"
	item_state = "helmet"
	flags = FPRINT|HEADCOVERSEYES
	armor = list(melee = 80, bullet = 45, laser = 35 ,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/under/blackmesa
	name = "blue security jumpsuit"
	desc = "Strange jumpsuit, there is no mark of NanoTrasen. Lambda sign at the front"
	icon_state = "blueuni"
	item_state = "bl_suit"
	_color = "blueuni"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.6

// Llegoman clothes

/obj/item/clothing/under/leeunder
	name = "casual uniform with jacket"
	desc = "Good looking uniform with jacket. You see a label 'Made by Rorschash Ind.'."
	icon_state = "blueuni"
	item_state = "bl_suit"
	_color = "blueuni"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.6

/obj/item/clothing/under/leeunder2
	name = "casual uniform"
	desc = "Good looking uniform. You see a label 'Made by Rorschash Ind.'."
	icon_state = "lee_short2"
	item_state = "bl_suit"
	_color = "lee_short2"

/obj/item/clothing/under/ajaxunder
	name = "ajax uniform"
	desc = "Black half-uniform. You see a label 'Made by Rorschash Ind.'."
	icon_state = "ajax_wear"
	item_state = "bl_suit"
	_color = "ajax_wear"

/obj/item/clothing/suit/leejacket
	name = "Black Jacket"
	desc = "Black Jacket. You see a label 'Made by Rorschash Ind.'."
	icon_state = "leejacket"
	item_state = "bl_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.6

/obj/item/clothing/suit/warvest
	name = "Red Jacket"
	desc = "Red Jacket. You see a label 'Made by Rorschash Ind.'."
	var/base_icon_state = "warvest"
	var/open =1
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

	update_icon()
		if(open)
			icon_state="[base_icon_state]_open"
		else
			icon_state="[base_icon_state]"

	verb/toggle()
		set name = "Toggle Red Jacket Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(open)
			usr << "You button up the jacket."
		else
			usr << "You unbutton the jacket."
		open=!open
		update_icon()
		usr.update_inv_wear_suit()

/obj/item/clothing/suit/warvest/New()
	. = ..()
	update_icon()


// Прочее

/obj/item/clothing/mask/gas/joker
	name = "joker mask"
	desc = "Why so serious?"
	icon_state = "jokermask"
	siemens_coefficient = 0.7

