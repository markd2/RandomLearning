.SUFFIXES: .f .o

FFLAGS = -bhz

.f.o:
	rmfort $(FFLAGS) $*.f

both : host node

help :  
	@echo "make both or make  - makes both the host and node processes"
	@echo "make host   - makes the host process"
	@echo "make node   - makes the node process"
	@echo "make clean  - cleans up"

host:		host.o 
		cc -Ml -o host  host.o \
		/lib/Llibf.a \
     		/usr/ipsc/lib/rmfhost.a 

node:      	node.o
		ld -Ml -o node \
		/lib/Lseg.o \
		/usr/ipsc/lib/Lcrtn0.o \
		node.o \
		/usr/ipsc/protocode/commutl/rmfort/commlib.a \
		/usr/ipsc/lib/Llibfnode.a \
		/usr/ipsc/lib/Llibcnode.a

clean:
		-rm *.o
