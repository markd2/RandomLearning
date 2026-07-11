	PROGRAM NODE

C***********************************************************************
C
C			Node Program
C
C	Approximate pi with the n-point rectangle quadrature rule
C	applied to the integral from 0 to 1 of 4 / (1+x**2)
C
C	pi = h * sum from i = 1 to n of f(xi)
C
C	where  h = 1 / n
C	       xi = (i - 1 / 2)*
C	       f(x) = 4/ (1+ x**2)
C
C***********************************************************************

	INTEGER PID,CID,ID,DIM,TYPE,CNT,ROOT,RNID,RPID
	INTEGER COPEN, CUBEDIM, MYNODE
	INTEGER N,P,I,INTSIZE
	DOUBLE PRECISION F,X,SUM,PI,H,WORK

	PARAMETER (INTSIZE=4)

	F(X) = 4.D0/(1.D0 + X*X)

C
C	Open communications area
C
C	Find node number, cube dimension, number of processors
C

	PID = 0
	CID = COPEN(PID)
	ID = MYNODE()
	DIM = CUBEDIM()
	P = 2**DIM

C
C	Use global receive to get n from the host
C

10	TYPE = 1
	CALL RECVW (CID,TYPE,N,INTSIZE,CNT,RNID,RPID)

C
C	Compute this node's partial sum
C	Partial sums are interleaved
C

	IF (N .GT. 0) THEN
	   H = 1.0D0 / N
	   SUM = 0.0D0
	   DO 20 I = ID + 1, N , P
	      X = (I - 0.5D0)*H
	      SUM = SUM + F(X)
20	   CONTINUE

	   PI = H * SUM

C
C	   Use global sum to assemble partial sums and send result to host
C

	   TYPE = 2
	   ROOT = -32768
	   CALL GOP (CID,TYPE,PI,1,'+',ROOT,DIM,WORK)

	   GO TO 10

	END IF

	END
