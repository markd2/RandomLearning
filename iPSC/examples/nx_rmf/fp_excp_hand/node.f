c
c    Test program to demostrate the floating point exception handler.
c	
c	This program is designed to run on the node.  There is nothing
c	special done to get the exception handler installed, it is part
c	of the standard node operating system.  If floating point 
c	exceptions are genereated the exception handler performs the
c	proper fixup and the your code will continue executing as
c	normal.
     
      program test
      double precision x,y,z

c
c	Test the out routine (dhex)
c
      call syslog(0,'test dhex')
      x = 1.0d0
      do 01 k = 1, 13
         x = 16.0d0*x + k
   01 continue
      call out(x)     

c
c	-1/0
c
      call syslog(0,'-1/0')
      y = -1.0d0
      z = 0.0d0
      x = y/z
      call out(x)

c
c	denormal
c
      call syslog(0,'denormal')
      y = 1.0d-305
      z = y / 1.d10
      call out(z)

c
c	tiny + denormal
c
      call syslog(0,'tiny + denormal')
      x = y + z
      call out(x)

c
c	promote denormal
c
      call syslog(0,'promote denormal')
      x = z * 1.d10
      call out(x)

c
c	1.0 + promoted denormal
c
      call syslog(0,'1.0 + promoted denormal')
      y = 1.0d0 + x
      call out(y)

c
c	sqrt(denormal)
c
      call syslog(0,'sqrt(denormal)')
      x = sqrt(z)
      call out(x)

c
c	overflow
c
      call syslog(0,'overflow')
      y = 1.0d+250
      z = y*y
      call out(z)

c
c	sqrt(overflow)
c
      call syslog(0,'sqrt(overflow)')
      x = sqrt(z)
      call out(x)

c
c	0/0
c
      call syslog(0,'0/0')
      x = 0.0d0
      y = 0.0d0
      z = x/y
      call out(z)

c
c	sqrt(0/0)
c
      call syslog(0,'sqrt(0/0)')
      x = sqrt(z)
      call out(x)
      end


c
c	OUTPUT routine
c
      subroutine out(x)
      double precision x
      character*16 dhex
      character*45 string
      write(string,21) x,dhex(x)
 21   format(' ',d23.15,' ',a18)
      call syslog(0,string)
      return
      end
