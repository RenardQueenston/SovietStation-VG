/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = 0

turf/unsimulated/wall/splashscreen
	name = "Space Station 13"
	icon = 'icons/misc/fullscreen.dmi'
	icon_state = "title1"
	layer = FLY_LAYER

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/unsimulated/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon_state = "cult0"
	opacity = 1
	density = 1

/turf/unsimulated/wall/cultify()
	ChangeTurf(/turf/unsimulated/wall/cult)
	turf_animation('icons/effects/effects.dmi',"cultwall",0,0,MOB_LAYER-1)
	return

/turf/unsimulated/wall/cult/cultify()
	return