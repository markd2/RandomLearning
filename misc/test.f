C program test
C
C -- Test significance and range of the
C -- floating-point operations
C
C From the book "FORTRAN Programs for Scientists And Engineers
C
C compile with:
C     gfortran test.f -o test
C
C run with:
C     ./test

      REAL X
      INTEGER I, N, OUT

      OUT = 6
      N = 75
      X = 1.0E-4 / 3.0
      DO 10 I = 1, N
         X = X / 10.0
         WRITE(OUT, 101) I, X
 10   CONTINUE
      STOP
 101  FORMAT(1x, I4, 1PE15.6)
      END
