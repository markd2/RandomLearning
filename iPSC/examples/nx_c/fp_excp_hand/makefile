
all: host node

# NOTE: It is better for debugging to not use the -K option for host programs,
#       but because one of the object files (dhex.o) is used for both the
#       host and node, -K is used for all compilations.  The use of -K is
#       required for node programs.

CFLAGS= -Alfu -K 

NOBJS =		ldcw87.o dhex.o node.o
HOBJS =		eh287n.o ldcw87.o dhex.o fpeh.o host.o

node : $(NOBJS)
	ld -Ml -o node \
            /usr/ipsc/lib/Lcrtn0.o \
            $(NOBJS) \
	    /usr/ipsc/lib/Llibcnode.a   \
	    /usr/ipsc/lib/Llibmnode.a   

host:  $(HOBJS) 
	cc -Alfu -o host $(HOBJS) \
		/lib/Llibm.a \
		/usr/intel/lib/eh287.a 

dhex.o: dhex.c
	cc $(CFLAGS) -c dhex.c

look.o: look.c
	cc $(CFLAGS) -M2e -c look.c

fpeh.o: fpeh.c
	cc $(CFLAGS) -c fpeh.c

eh287n.o:	eh287n.asm
		asm286 eh287n.asm 
		cmo286 eh287n.obj
		mv eh287n.cmo eh287n.o

ldcw87.o:	ldcw87.asm
		asm286 ldcw87.asm
		cmo286 ldcw87.obj
		mv ldcw87.cmo ldcw87.o

clean:
	-rm *.o *.lst *.obj
