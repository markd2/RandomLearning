C Binary-Search - do a simple binary search on an array
C   The goal being to fill out a FORTRAN coding form at
C   the LSSM (https://lssmuseum.org) as an example for
C   guests.
C
C compile with
C     gfortran -o binary-search binary-search.f
C run with
C     make file "search-source.txt"
C     ./binary-search

      PROGRAM READ_ARRAY
      IMPLICIT NONE

C The array to search in. Assumes the source file is sorted
      INTEGER MAXSIZE
      PARAMETER (MAXSIZE = 100)
      REAL NUMBERS(MAXSIZE)

C Read in the file from disk
      INTEGER I, IOS, N

C Binary Search Goodness
      INTEGER BSEARCH
      INTEGER BSEARCH2
      INTEGER INDEX

      OPEN(UNIT=10, FILE="search-source.txt", STATUS='OLD', IOSTAT=IOS)

      IF (IOS .NE. 0) THEN
         PRINT *, 'Error: could not open search-source.txt'
         STOP
      END IF

      N = 0
      DO I = 1, MAXSIZE
         READ(10, *, IOSTAT=IOS) NUMBERS(I)

C        EOF (NEGATIVE IOS) OR ERROR (POSITIVE), EXIT LOOP
         IF (IOS .NE. 0) GOTO 20
         N = N + 1
      END DO

 20   CONTINUE

      CLOSE(10)

C      PRINT *, 'WE DONE DID READ ', N, 'NUMBERS:'
      DO I = 1, N
C         PRINT *, NUMBERS(I)
      END DO

C Now do some searches
      INDEX = BSEARCH2(NUMBERS, 999999, N)
      PRINT *, INDEX
      END


C Binary search, but compactified

      INTEGER FUNCTION BSEARCH(NUMS,VAL,SIZE)
      INTEGER VAL,SIZE,L,R,M
      REAL NUMS(SIZE)
      
      L = 1
      R = SIZE
 10   IF (L. GT. R) GOTO 30
      M = (L+R) / 2
      IF (NUMS(M) - VAL) 11,20,12

 11   L = M + 1
      GOTO 10
 12   R = M - 1
      GOTO 10

 20   BSEARCH = M
      RETURN
 30   BSEARCH = -1
      RETURN
      END

      INTEGER FUNCTION BSEARCH2(NUMS, VAL, SIZE)
      INTEGER VAL, SIZE, L, R, M
      REAL NUMS(SIZE)

      L = 1
      R = SIZE

      DO WHILE (L .LE. R)
         MID = L + (R - L) / 2

         PRINT *, 'MID', MID, NUMS(MID), 'L ', L, 'R ', R

         IF (NUMS(MID) .EQ. VAL) THEN
            BSEARCH = MID
            RETURN
         ELSE IF (VAL .LT. NUMS(MID)) THEN
            R = MID - 1
         ELSE
            L = MID + 1
         END IF
      END DO

      BSEARCH = -1
      END
