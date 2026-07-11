
FFLAGS = -bhe

.SUFFIXES: .f .o .e

.f.o:
	rmfort $(FFLAGS) $<

.o.e:
	ld -Ml -o $@ /lib/Lseg.o /usr/ipsc/lib/Lcrtn0.o \
	$*.o \
	/usr/ipsc/lib/veclib287.a /usr/ipsc/lib/vxnodesim.a \
	/usr/ipsc/lib/Llibfnode.a /usr/ipsc/lib/Llibcnode.a
	size $@

all:	dlinpack.e slinpack.e

dlinpack.e:	dmain.o dgefa.o dgesl.o seconds.o 
	ld -Ml -o $@ /lib/Lseg.o /usr/ipsc/lib/Lcrtn0.o \
	dmain.o dgefa.o dgesl.o seconds.o \
	/usr/ipsc/lib/veclib287.a /usr/ipsc/lib/vxnodesim.a \
	/usr/ipsc/lib/Llibfnode.a /usr/ipsc/lib/Llibcnode.a
	size $@

slinpack.e:	smain.o sgefa.o sgesl.o seconds.o 
	ld -Ml -o $@ /lib/Lseg.o /usr/ipsc/lib/Lcrtn0.o \
	smain.o sgefa.o sgesl.o seconds.o \
	/usr/ipsc/lib/veclib287.a /usr/ipsc/lib/vxnodesim.a \
	/usr/ipsc/lib/Llibfnode.a /usr/ipsc/lib/Llibcnode.a
	size $@

clean:
	rm -f *.o *.L
