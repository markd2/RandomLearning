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

      PRINT *, 'WE DONE DID READ ', N, 'NUMBERS:'
      DO I = 1, N
         PRINT *, NUMBERS(I)
      END DO

C Now do some searches
      INDEX = BSEARCH(NUMBERS, 42, N)
      PRINT *, INDEX
      END

      INTEGER FUNCTION BSEARCH(ARR, VAL, SIZE)
      INTEGER VAL, SIZE
      REAL ARR(SIZE)

      BSEARCH=44

      END
