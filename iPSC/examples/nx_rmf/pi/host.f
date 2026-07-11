	PROGRAM HOST

C***********************************************************************
C
C			Host Program
C
C	Approximate pi with the n-point rectangle quadrature rule
C	applied to the integral from 0 to 1 of 4 / (1+x**2).
C
C***********************************************************************

	INTEGER CID,TYPE,CNT,NID,PID,RNID,RPID,N
        INTEGER INTSIZE,DBLSIZE
        INTEGER COPEN
	DOUBLE PRECISION PI

	PARAMETER (INTSIZE=4,DBLSIZE=8)

C
C	Open communications area
C

	PID = 0
	CID = COPEN(PID)

C
C	Read number of points from user terminal
C 

 10	WRITE(*,*)
	WRITE(*,20)
 20     FORMAT(' Enter n (enter value <= 0 to exit): ') 
	READ(*,*,ERR=10) N

C
C	Send n to all the nodes
C

	TYPE = 1
	NID = -1
	CALL SENDMSG (CID,TYPE,N,INTSIZE,NID,PID)

C
C	Receive the result from one of the nodes
C

	IF (N .GT. 0) THEN
	   CALL RECVMSG (CID,TYPE,PI,DBLSIZE,CNT,RNID,RPID)
	   WRITE(*,30) PI
30	   FORMAT(' Value of PI is ',F20.16)
	   GO TO 10
	END IF

	END
