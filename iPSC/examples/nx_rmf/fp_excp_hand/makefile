CFLAGS= -Alfu -K -L

.SUFFIXES: .f .o

FFLAGS =

.f.o:
	@echo rmfort $(FFLAGS) $*.f
	@sh -c 'if { rmfort $(FFLAGS) $*.f ; S=$$? ; test "$$S" = "1" ; \
	} then { exit 0 ; } else { exit $$S ; } fi'

#  
#  note:  'b and h' switches are for contiguous huge array support
#         'e' is to list errors
#
#  These are commonly used switches. See the RM/FORTRAN User's Guide 
#  for more details on all compiler switches.
# 
#  The rule to go from .for to .o files is designed to allow make to
#  continue when compiler warnings are issued, but stop on compiler errors.
#  RM/FORTRAN exits with a non-zero status when warnings or errors are
#  issued, and this non-zero status causes make to stop.  It is not always
#  feasible to modify an RM/FORTRAN source program to eliminate the warning
#  messages.  What we would like to do is map warnings to a non-fatal exit
#  status of 0.  The first line of the rule simply echoes the compile command 
#  to the terminal screen in the same display format as if the compiler had 
#  been invoked in a more straightforward way.  The second line of the rule 
#  invokes the compiler in a shell, the status returned by the compiler is 
#  assigned to the variable 'S'.   If 'S' is equal to 1, warnings only, 
#  then the shell exits with a 0, a non-fatal status to make.  If 'S' is 
#  equal to anything else then the value of 'S' is returned.  

NOBJS =		node.o dhex.o
HOBJS =		host.o dhex.o

all:		node host

node:		$(NOBJS)
		ld -Ml -o node -m node.map \
			/lib/Lseg.o \
			/usr/ipsc/lib/Lcrtn0.o \
		        $(NOBJS) \
			/usr/ipsc/lib/Llibfnode.a \
			/usr/ipsc/lib/Llibcnode.a

host:		$(HOBJS)
		cc -Alfu -o host $(HOBJS) \
		/lib/Llibf.a
	
clean:
	-rm *.map *.o
