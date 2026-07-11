******************************************************************************

	program node 

******************************************************************************
*
*	This is the NODE part of the RING demo Program.
*
*	Node 0 will play the role of "controller" node.
*
*	It waits for a message from the host telling it:
*	  a) the number of times to go around the RING, and
*	  b) the length of the message to send around.
*
*	It then sends a message of the desired length to node 1 and 
*	"controls" how many times the message goes around the RING. 
*
*	At the end, Node 0 reports back to the Host the time it took 
*	the message to go around the RING.
*
*
*	All the other nodes wait for a message and then 
*	pass it on to the next node in the RING.
*
******************************************************************************

******************************************************************************
*
*	DECLARATIONS:
*
*
c	Program CONSTANTS:

	integer*4 HOSTNID
	integer*4 HOSTPID

	integer*4 INITTYPE
	integer*4 NODETYPE
	integer*4 TIMETYPE
	integer*4 COUNTTYPE

	integer*4 INITSIZE 
	integer*4 TIMESIZE
	integer*4 COUNTSIZE
	integer*4 MAXMSGSIZE 

	integer*4 NOTBUSY

c	iPSC System Calls used:

	integer*4 copen, status, mynode, mypid, cubedim
	integer*4 clock

c	Program variables:

	integer*4 hostchan, nodechan
	integer*4 i, count, ringcount
	integer*4 msglen
	integer*4 nextnode, nextpid
	integer*4 msgbuff(4096)
      	integer*4 ownnode, ownpid
	integer*4 numnodes
      	integer*4 rtype, rcnt, rnode, rpid

c	Timing variables:

	integer*4 starttime, ringtime
 
	data HOSTNID   /-32768/
	data HOSTPID	/1/

	data INITTYPE	/10/
	data NODETYPE	/20/
	data TIMETYPE	/30/
	data COUNTTYPE /40/

	data INITSIZE	  /8/
	data TIMESIZE	  /4/
	data COUNTSIZE	  /4/
	data MAXMSGSIZE /16384/

	data NOTBUSY	/0/


******************************************************************************
*
*	MAIN CODE:
*
*
c	Each process identifies the node its running on and its pid:

	ownnode = mynode() 
	ownpid  = mypid()

c	Each process determines the node id & and the pid of the next node 
c	in the RING: 

	numnodes = 2**cubedim()
	nextnode = mod(ownnode + 1, numnodes)
	nextpid  = ownpid

	if(ownnode.eq.0) then

******************************************************************************
*
*	  BEGIN NODE 0 CODE:
*
c	  Open channels for communicating with both the next node in the 
c	  RING (node 1) & the host:

          nodechan = copen(ownpid)
          hostchan = copen(ownpid)

******************************************************************************
*
*	  NODE 0 MAIN LOOP:
*

10	  call recvw(hostchan, INITTYPE, msgbuff, INITSIZE, rcnt, rnode, 
     >	     rpid)

	  ringcount = msgbuff(1)
	  msglen    = msgbuff(2)

	  starttime = clock()

	  do 400 i=1,ringcount
		call sendw(nodechan, NODETYPE, msgbuff, msglen, nextnode,  
     >		     nextpid)

		call recvw(nodechan, NODETYPE, msgbuff, msglen, rcnt, rnode, 
     >		     rpid)

c		As soon as the host channel is not busy report the current 
c		count to the HOST:

200		if (status(hostchan).eq.NOTBUSY) goto 300
		   call flick() 
		   goto 200
300		continue

		count = i

		call send (hostchan, COUNTTYPE, count, COUNTSIZE, HOSTNID, 
     >		     HOSTPID)

400	  continue

	  ringtime = clock() - starttime 

	  call sendw(hostchan, TIMETYPE, ringtime, TIMESIZE, HOSTNID, 
     >             HOSTPID)

	  goto 10
*
*	  END NODE 0 MAIN LOOP.
*
******************************************************************************
*
*	END OF NODE 0 CODE.
*
****************************************************************************** 

	else 

******************************************************************************
*
*	BEGIN OTHER NODES' CODE: 
*
c       All other nodes wait for a value from their left hand neighbor,
c       and pass it to their right hand neighbor.
c   
c	They only have to open one channel for communication:

	nodechan = copen(ownpid)

******************************************************************************
*
*	BEGIN OTHER NODES' MAIN LOOP:
*

20        call recvw(nodechan, NODETYPE, msgbuff, MAXMSGSIZE, rcnt,
     >      rnode, rpid)
          call sendw(nodechan, NODETYPE, msgbuff, rcnt, nextnode,
     >      nextpid)

	  goto 20

*
*	END OTHERS' MAIN LOOP.
*
******************************************************************************
*
*	END OTHERS' CODE.
*
******************************************************************************

      endif 

      end
*
*     ... OF PROGRAM CODE.
*
******************************************************************************
