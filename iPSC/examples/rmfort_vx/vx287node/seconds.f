	real*8 function seconds(r)
	real*8 r
	include '/usr/ipsc/lib/rmfnode.def'
	r = clock()
	r = r / 1000.0d0
	seconds = r
	end
