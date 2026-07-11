      double precision a(150,150),b(150)
      double precision time(6),vax,ops,total,en,dummy,seconds
      integer ipvt(150)
c-new
      include '/usr/ipsc/lib/rmfnode.def'
      character*120 char
      call attach()
c-new
c-old lda = 100
c
c-old write(*,10)
c-new
      write(char,10)
      call syslog(mynode(),char)
c-new
   10 format(3x,'n',6x,'dgefa',6x,'dgesl',6x,'total',5x,'mflops',
     >   7x,'unit',6x,'ratio')
c-new
      icount = 0
    9 if(icount.eq.0)n=50
      if(icount.eq.1)n=100
      if(icount.eq.2)n=150
      if(icount.eq.3)goto 12
      icount = icount + 1
      lda = n
c-new
      vax = 30.485
      en = n
      ops = (2.0d0*en*en*en)/3.0d0 + 2.0d0*en*en
c
c
         call matgen(a,lda,n,b)
         t1 = seconds(dummy)
         call dgefa(a,lda,n,ipvt,info)
         time(1) = seconds(dummy) - t1
         t1 = seconds(dummy)
         call dgesl(a,lda,n,ipvt,b,0)
         time(2) = seconds(dummy) - t1
         total = time(1) + time(2)
         if (total .eq. 0.0d0) total = 1.0d0
         time(3) = total
         time(4) = ops/(1.0d6*total)
         time(5) = 2.0d0/time(4)
         time(6) = vax/time(5)
c-old    write(*,11) n,(time(i),i=1,6)
c-new
         write(char,11) n,(time(i),i=1,6)
         call syslog(mynode(),char)
c-new
   11    format(i4,3f11.3,f11.6,2f11.3)
         go to 9
c-new
   12 call detach()
      call syslog(mynode(),'END.')
c-new
      end
      subroutine matgen(a,lda,n,b)
      double precision a(lda,1),b(1)
c
      init = 1325
      do 30 j = 1,n
         do 20 i = 1,n
            init = mod(3125*init,65536)
            a(i,j) = (init - 32768.0d0)/16384.0d0
   20    continue
   30 continue
      do 35 i = 1,n
          b(i) = 0.0d0
   35 continue
      do 50 j = 1,n
         do 40 i = 1,n
            b(i) = b(i) + a(i,j)
   40    continue
   50 continue
      return
      end
