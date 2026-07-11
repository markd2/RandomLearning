
FFLAGS = -bhe

.SUFFIXES: .f .o .e

.f.o:
	rmfort $(FFLAGS) $<

.o.e:
	cc -Ml -o $@ \
	$*.o \
	/usr/ipsc/lib/veclib287.a \
	/usr/ipsc/lib/vxnodesim.a \
	/lib/Llibf.a \
	/usr/ipsc/lib/rmfhost.a
	size $@

all:	host

help:	
		@echo "This makefile supports the following:"
		@echo "make, make all, or make host:  creates host program"
		@echo "make clean:  deletes intermediate files"

host:	host.o
		cc -Ml -o host.e \
		host.o \
		/usr/ipsc/lib/veclib287.a \
		/usr/ipsc/lib/vxnodesim.a \
		/lib/Llibf.a \
		/usr/ipsc/lib/rmfhost.a
		size host.e

clean:
	rm -f *.o 
