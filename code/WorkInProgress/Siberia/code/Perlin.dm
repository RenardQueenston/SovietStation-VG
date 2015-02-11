/proc/Linear_Interpolate(var/a, var/b, var/x)
	return  a*(1 - x) + b*x;

/proc/Cosine_Interpolate(var/a, var/b, var/x)
	var/ft = x * 3.1415927
	var/f = (1 - cos(ft)) * 0.5
	return  a*(1-f) + b*f

/proc/Cubic_Interpolate(var/v0, var/v1, var/v2, var/v3,var/x)
	var/P = (v3 - v2) - (v0 - v1)
	var/Q = (v0 - v1) - P
	var/R = v2 - v0
	var/S = v1
	return P*x*3 + Q*x*2 + R*x + S

/proc/SmoothNoise_1D(var/x,var/x1,var/x2)
	return Noise(x)/2  +  Noise(x-1)/4  +  Noise(x+1)/4

/proc/SmoothNoise_2D(var/x, var/y)
	var/corners = ( Noise(x-1, y-1)+Noise(x+1, y-1)+Noise(x-1, y+1)+Noise(x+1, y+1) ) / 16
	var/sides   = ( Noise(x-1, y)  +Noise(x+1, y)  +Noise(x, y-1)  +Noise(x, y+1) ) /  8
	var/center  =  Noise(x, y) / 4
	return corners + sides + center

/proc/Noise(var/x,var/y, var/z = 0)
	return locate(x,y,z)

proc/get_trufs_in_crest(var/x,var/y, var/z = 0,var/range=1)
	var/trufs = list()
	if(x > 1 && x <254)
		for(var/i =0,i<range,i++)
			trufs += locate(x-i,y,z)
			trufs += locate(x+i,y,z)
	if(y > 1 && y <254)
		for(var/i =0,i<range,i++)
			trufs += locate(x,y-i,z)
			trufs += locate(x,y+i,z)
	return trufs

proc/get_trufs_in_crest_chane(var/x,var/y,var/chane, var/z = 0)
	var/trufs = list()
	if(x > 1 && x <254)
		for(var/i =0,i<1,i++)
			if(rand(0,100)>chane)
				trufs += locate(x-i,y,z)
			if(rand(0,100)>chane)
				trufs += locate(x+i,y,z)
	if(y > 1 && y <254)
		for(var/i =0,i<1,i++)
			if(rand(0,100)>chane)
				trufs += locate(x,y-i,z)
			if(rand(0,100)>chane)
				trufs += locate(x,y+i,z)
	return trufs

proc/get_trufs_in_crest_dirchane(var/x,var/y,var/chane,var/dirchane,var/z = 0)
	var/trufs = list()
	if(x > 1 && x <254)
		for(var/i =0,i<1,i++)
			if(dirchane>-100 &&dirchane<100)
				if(rand(0,100)>chane+dirchane)
					trufs += locate(x-i,y,z)
				if(rand(0,100)>chane - dirchane)
					trufs += locate(x+i,y,z)
	if(y > 1 && y <254)
		if((dirchane<-100 && dirchane>-200)||(dirchane>100 && dirchane<200))
			for(var/i =0,i<1,i++)
				if(rand(0,100)>chane+abs(dirchane)-100)
					trufs += locate(x,y-i,z)
				if(rand(0,100)>chane-abs(dirchane)-100)
					trufs += locate(x,y+i,z)
	return trufs

proc/PerlinNoise_2D_layer(var/layer,var/truchane,var/atom/A,var/chane = 1,var/range = 0,var/dcane = 1,var/dircane = 0)
	var/d = rand(0,65025) //перспективно!, генератор послойного "напыления", создает н точек на карте и увеличивает в зависимости от параметров
	if(d > truchane)
		var/B = null
		B = list()
		B += locate(A.x,A.y,A.z)
		if(range == 0)
			if (dcane != 0)
				if(dircane != 0)
					for(var/turf/G in B)
						B += get_trufs_in_crest_chane(G.loc.x,G.y,chane,A.z)
						chane -= dcane
				else
					for(var/turf/unsimulated/G in B)
						B += get_trufs_in_crest_chane(G.x,G.y,chane,A.z)
						chane -= dcane
			B += get_trufs_in_crest(A.x,A.y,A.z,range)
		return B
	return layer

proc/Generator2(var/ch,var/layer,var/atom/A,var/octave) //неперспективно
	var/L = rand(0,65025)
	if(L>ch)
		var/T = list()
		T += locate(A.x,A.y,A.z)
		for(var/i = 0;i< octave;i++)
			T += get_trufs_in_crest_chane(A.x,A.y,90,A.z)
		return T


/*Generator3
/proc/Generator3(var/w,var/h,var/intensivity,var/octave,var/atom/A,var/maxtextures) //D-S точки/сглаживание/интерполяция
	var/z = A.z
	var/L = generateNoise(intensivity,z,h,w,maxtextures)
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
			if(istype(locate(x+halfStep,y,z),/turf/unsimulated/snow))
				var/turf/unsimulated/snow/r = locate(x+halfStep,y,z)
				var/a = locate(x,y,z)
				var/b = locate(x+stepSize,y,z)
				var/d = locate(x + halfStep, y + halfStep,z)
				var/e = locate(x + halfStep, y - halfStep,z)
				var/h = multiadd(a,b,d,e,4.0,maxtextures,2,1,stepSize*scale*0,5)//(a + b + d + e) / 4.0 + (rand(0,maxtextures) * 2 - 1) * stepSize * scale * 0.5
				r.tex = h
			if(istype(locate(x,y+halfStep,z),/turf/unsimulated/snow))
				var/turf/unsimulated/snow/j = locate(x,y+halfStep,z)
				var/a = locate(x,y,z)
				var/c = locate(x, y + stepSize,z)
				var/d = locate(x + halfStep, y + halfStep,z)
				var/f = locate(x - halfStep, y + halfStep,z)
				var/g = multiadd(a,c,d,f,4.0,maxtextures,2,1,stepSize*scale*0,5)//(a + c + d + f) / 4.0 + (random.nextFloat() * 2 - 1) * stepSize * scale * 0.5
				j.tex = g
	return 1

Generator3 начинка
/proc/generateNoise(var/intensivity,var/z,var/h,var/w,var/maxtextures)
	var/T = list()
	for (var/y = 0; y < h; y += intensivity)
		for (var/x = 0; x < w; x += intensivity)
			if(istype(locate(x,y,z),/turf/unsimulated/snow))
				var/turf/unsimulated/snow/r = locate(x,y,z)
				r.tex = rand(0,maxtextures)
				T += r
	return T

/proc/multiadd(var/a,var/b,var/c,var/d,var/divider,var/maxtextures,var/multiper,var/dimiter,var/stepSize_x_scale)
	if(a != null & b != null & c != null & d != null )
		return (a.tex + b.tex + c.tex + d.tex) / divider + (rand(0,maxtextures) * multiper - dimiter) * stepSize_x_scale
	else if(a == null & b == null & c == null & d == null )
		return 0
	else if(a == null || b == null || c == null || d == null )
		return ((a == null ? 0 : a.tex) + (b == null ? 0 : b.tex) + (c == null ? 0 : c.tex) + (d == null ? 0 : d.tex)) / divider + (rand(0,maxtextures) * multiper - dimiter) * stepSize_x_scale
~Generator3*/