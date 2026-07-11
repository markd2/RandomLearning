C ***************************************************************
C
C     host.f 
C
C     This host program shows how to call several of the veclib
C     routines. 
C
C ***************************************************************

      program vx$demo

      include '/usr/ipsc/lib/rmfhost.def'
      include '/usr/ipsc/lib/veclib.def'

      parameter (n = 1000)

      double precision  x(n), y(n), alpha, beta
      integer  i, failed
      
      call attach()
      failed = 0

C
C     Call dfill veclib routine:  x(i) = alpha
C
      alpha = 99.9d0
      call dfill (n, alpha, x, 1)

C
C     Verify that dfill worked correctly
C
      failed = 0
      do 100 i = 1, n
         if (x(i) .NE. alpha)  failed = 1
 100  continue
      if (failed .EQ. 1) then
         call syslog (mypid(), 'dfill: *** Error ***')
      else
         call syslog (mypid(), 'dfill: completed successfully')
      endif               

C
C     Call dswap veclib routine:  y(i) <=> x(i)
C
C     Initialize y to alpha + beta = 100.0
C
      call dcopy (n, x, 1, y, 1)
      beta = 0.1d0
      call dsadd (n, beta, x, 1, y, 1)
      call dswap (n, x, 1, y, 1)

C
C     Verify that dswap worked correctly
C
      failed = 0
      do 200 i = 1, n
         if ((x(i) .NE. (alpha + beta)) .OR. (y(i) .NE. alpha)) then
            failed = 1
         endif               
 200  continue
      if (failed .EQ. 1) then  
         call syslog (mypid(), 'dswap: *** Error ***')
      else
         call syslog (mypid(), 'dswap: completed successfully')
      endif
     
      call syslog (mypid(), 'END.')
      call detach()
      end
      

