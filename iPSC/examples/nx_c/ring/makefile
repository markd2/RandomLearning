CFLAGS = -Alfu -K
 
#
#  NOTE:  This makefile uses the default rule for the C compiler for node.c
#

both:	host node

help:
	@echo "make both or make   - makes both the host and node processes"
	@echo "make host   - makes the host process"
	@echo "make node   - makes the node process"
	@echo "make clean  - cleans up"

host:	host.c 
	cc -Alfu -o host host.c /usr/ipsc/lib/chost.a

node:	node.o
	ld -Ml -o node /lib/Lseg.o /usr/ipsc/lib/Lcrtn0.o  \
	node.o \
	/usr/ipsc/lib/Llibcnode.a

clean:
	-rm *.o
