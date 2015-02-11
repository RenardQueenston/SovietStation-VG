/*Generator1*/
/proc/Generator1(var/w,var/h,var/intensivity,var/z,var/maxtextures) //D-S точки/сглаживание/интерпол€ци€
	generateNoise(intensivity,z,h,w,maxtextures)
	var/stepSize = intensivity
	var/scale = 1.0 / w
	var/scaleMod = 1
	while (stepSize > 1)
		var/halfStep = stepSize / 2;
		for(var/y = 0; y < h; y += stepSize)
			for(var/x = 0; x < w; x += stepSize)
				if(istype(locate(x+halfStep,y+halfStep,z),/turf/unsimulated/snow))
					var/turf/unsimulated/snow/r = locate(x+halfStep,y+halfStep,z)
					var/turf/unsimulated/snow/a = null
					var/turf/unsimulated/snow/b = null
					var/turf/unsimulated/snow/c = null
					var/turf/unsimulated/snow/d = null
					if(istype(locate(x,y,z),/turf/unsimulated/snow))
						a = locate(x,y,z)
					if(istype(locate(x + stepSize,y,z),/turf/unsimulated/snow))
						b = locate(x + stepSize,y,z)
					if(istype(locate(x,y + stepSize,z),/turf/unsimulated/snow))
						c = locate(x,y + stepSize,z)
					if(istype(locate(x + stepSize,y + stepSize,z),/turf/unsimulated/snow))
						d = locate(x+ stepSize,y+ stepSize,z)
					var/e = multiadd(a,b,c,d,4.0,maxtextures,2,1,stepSize*scale)
					r.tex = e
		stepSize /= 2
		scale *= (scaleMod * 0.8)
		scaleMod *= 0.3
	for (var/y = 0; y < h; y += stepSize)
		for (var/x = 0; x < w; x += stepSize)
			if(istype(locate(x+stepSize,y,z),/turf/unsimulated/snow))
				var/turf/unsimulated/snow/r = locate(x+stepSize,y,z)
				var/a = locate(x,y,z)
				var/b = locate(x+stepSize,y,z)
				var/d = locate(x + stepSize, y + stepSize,z)
				var/e = locate(x + stepSize, y - stepSize,z)
				var/s = multiadd(a,b,d,e,4.0,maxtextures,2,1,stepSize*scale*0.5)
				r.tex = s
			if(istype(locate(x,y+stepSize,z),/turf/unsimulated/snow))
				var/turf/unsimulated/snow/j = locate(x,y+stepSize,z)
				var/a = locate(x,y,z)
				var/c = locate(x, y + stepSize,z)
				var/d = locate(x + stepSize, y + stepSize,z)
				var/f = locate(x - stepSize, y + stepSize,z)
				var/g = multiadd(a,c,d,f,4.0,maxtextures,2,1,stepSize*scale*0.5)
				j.tex = g
	return 1

/*Generator1 начинка*/
/proc/generateNoise(var/intensivity,var/z,var/h,var/w,var/maxtextures)
	for (var/y = 0; y < h; y += intensivity)
		for (var/x = 0; x < w; x += intensivity)
			if(istype(locate(x,y,z),/turf/unsimulated/snow))
				var/turf/unsimulated/snow/r = locate(x,y,z)
				r.tex = rand(0,maxtextures)
	return

/proc/multiadd(var/turf/unsimulated/snow/a,var/turf/unsimulated/snow/b,var/turf/unsimulated/snow/c,var/turf/unsimulated/snow/d,var/divider,var/maxtextures,var/multiper,var/dimiter,var/stepSize_x_scale)
	if(a != null & b != null & c != null & d != null )
		return (a.tex + b.tex + c.tex + d.tex) / divider + (rand(0,maxtextures) * multiper - dimiter) * stepSize_x_scale
	else if(a == null & b == null & c == null & d == null )
		return 0
	else if(a == null || b == null || c == null || d == null )
		return ((a == null ? 0 : a.tex) + (b == null ? 0 : b.tex) + (c == null ? 0 : c.tex) + (d == null ? 0 : d.tex)) / divider + (rand(0,maxtextures) * multiper - dimiter) * stepSize_x_scale
/*~Generator1*/