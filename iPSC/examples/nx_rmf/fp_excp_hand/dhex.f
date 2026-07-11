      character*16 function dhex(x)
      double precision x
c
c     Convert double precision value to hex string
c     Suitable for output with format A16
c
      double precision xx
      integer*4 ix(2),nohi,m
      integer sig,i,j,k,l
      character*1 d(16)
      character*16 s
      equivalence (xx,ix)
      data d/'0','1','2','3','4','5','6','7',
     >       '8','9','A','B','C','D','E','F'/
      data nohi /2147483647/
c
      xx = x
      k = 16
      do 20 i = 1, 2
         m = ix(i)
         if (m .lt. 0) then
            sig = 1
            m = iand(m,nohi)
         else
            sig = 0
         endif
         do 20 j = 1, 8
            l = mod(m,16)+1
            m = m/16
            if (j.eq.8 .and. sig.eq.1) l = l+8
            s(k:k) = d(l)
            k = k-1
   20 continue
      dhex = s
      end

