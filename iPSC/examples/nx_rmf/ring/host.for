c******************************************************************************

	program host

c*****************************************************************************
c
c	This is the Host code (in Fortran) for the Ring demo.
c
c	It prompts the user for:
c	  a) the length of a message to send around a RING in the cube, and
c	  b) the number of times the message is to go around the RING.
c
c	It outputs:
c	  a) a ring "count" each time the ring message goes past node 0, 
c	     and 
c	  b) the time it took the message to go around the ring the
c	     specified number of times.
c
c******************************************************************************

c*****************************************************************************
c
c	DECLARATIONS:
c
c
c	Declare & initialize CONSTANTS:
*
	integer*4 NODEPID 
	integer*4 HOSTPID
	integer*4 ALLNODES 
	integer*4 INITTYPE 
	integer*4 TIMEMSGSIZE
	integer*4 CNTMSGSIZE
	integer*4 INITMSGSIZE

c
c	Declare iPSC System Functions used:
c
	integer*4 copen

c
c	Declare program variables:
c
	integer*4 ci,type,cnt,frnode,frpid
	integer*4 msglen
	integer*4 ringcount
	integer*4 msgbuff(2)

c	Declare time variable:
c
	real*4    ringtime

	DATA NODEPID		/1/
	DATA HOSTPID		/1/
	DATA ALLNODES		/-1/
	DATA INITTYPE		/10/
	DATA TIMEMSGSIZE	/4/
	DATA CNTMSGSIZE	/4/
	DATA INITMSGSIZE	/8/

c
c*****************************************************************************

c******************************************************************************
c
c	MAIN CODE: 
c
c
	write (6,51)
51	format(' LOADING RING INTO CUBE ...') 

c	load the cube:

	call load('node', ALLNODES, NODEPID)

c	Open a channel for the host-to-node-0 communications.

	ci = copen(HOSTPID)

c*****************************************************************************
c
c	BEGIN MAIN PROGRAM LOOP:
c 

10	  write (6,100)
100	  format(' ************************** READY *********************
     1********')

c	  get the number of times to go around the ring:
 
	  write(6,101)
101	  format(' Number of times to go around the ring (neg. value quit
     1s): ')
	  read(5,102) ringcount 
102	  format(i7)
c	ringcount = 1

c	  If ringcount is negative exit HOST program:
c
	  if (ringcount .lt. 0) goto 600

c	  Include ringcount in the message to the RING:

	  msgbuff(1) = ringcount

c	  get the message length:

	  write (6,201)
201	  format(' Length of Ring message in bytes (0-16384): ')
	  read (5, 202) msglen
202	  format(i5)
c	msglen = 2

c	  Include msglen in the message to the RING:

	  msgbuff(2) = msglen
  
c	  ship the message buffer off to node 0:

	  call sendmsg(ci, INITTYPE, msgbuff, INITMSGSIZE, 0, NODEPID) 

c	  Get the current ring count from node 0 and report to user:

	  do 400 i=1, ringcount
 
      call recvmsg(ci, type, msgbuff, CNTMSGSIZE, cnt, frnode, frpid)

	    write (6,310) msgbuff(1)
310	    format('+Ring count: ',i5)

400     continue

c	  Get the RING time from node 0 & report to user:

      call recvmsg(ci, type, msgbuff, TIMEMSGSIZE, cnt, frnode, frpid)

	  ringtime = real(msgbuff(1))/1000.00

	  write (6,306) ringtime
306	  format(/,' Ring time :',F9.2,' secs.')

	  goto 10

c
c	  END OF MAIN PROGRAM LOOP.
c
c*****************************************************************************

c*****************************************************************************
c
c	CLEAN UP TIME!
c

600	write (6,601)
601	format(' CLEARING THE CUBE ...') 

c	Kill RING processes in cube
 
	call lkill(-1,-1)
	call lwaitall(-1,-1)

	write (6,701)
701	format(' ************************** DONE ************************
     1******')

	end
c
c*****************************************************************************
