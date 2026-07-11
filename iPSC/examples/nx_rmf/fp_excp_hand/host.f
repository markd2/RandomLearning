c
c    Test program to demostrate the floating point exception handler.
c	
c	This program is designed to run on the host.  There is nothing
c	special done to get the exception handler installed, it is part
c	of the standard fortran runtime library.  If floating point 
c	exceptions are genereated the exception handler performs the
c	proper fixup and the your code will continue executing as
c	normal.
     
      program test
      double precision x,y,z

c
c	Test the out routine (dhex)
c
      x = 1.0d0
      do 01 k = 1, 13
         x = 16.0d0*x + k
   01 continue
      write(*,*)' Test DHEX'
      call out(x)     

c
c	-1/0
c
      y = -1.0d0
      z = 0.0d0
      x = y/z
      write(*,*)' -1/0'
      call out(x)

c
c	denormal
c
      y = 1.0d-305
      z = y / 1.d10
      write(*,*)' denormal'
      call out(z)

c
c	tiny + denormal
c
      x = y + z
      write(*,*)' tiny + denormal'
      call out(x)

c
c	promote denormal
c
      x = z * 1.d10
      write(*,*)' promote denormal'
      call out(x)

c
c	1.0 + promoted denormal
c
      y = 1.0d0 + x
      write(*,*)' 1.0 + promote denormal'
      call out(y)

c
c	sqrt(denormal)
c
      x = sqrt(z)
      write(*,*)' sqrt(denormal)'
      call out(x)

c
c	overflow
c
      y = 1.0d+250
      z = y*y
      write(*,*)' overflow'
      call out(z)

c
c	sqrt(overflow)
c
      x = sqrt(z)
      write(*,*)' sqrt(overflow)'
      call out(x)

c
c	0/0
c
      x = 0.0d0
      y = 0.0d0
      z = x/y
      write(*,*)' 0/0'
      call out(z)

c
c	sqrt(0/0)
c
      x = sqrt(z)
      write(*,*)' sqrt(0/0)'
      call out(x)
      end

c
c	OUTPUT routine
c
      subroutine out(x)
      double precision x
      character*16 dhex
      character*45 string
      write(*,21) x,dhex(x)
 21   format(' ',d23.15,' ',a18)
      return
      end
