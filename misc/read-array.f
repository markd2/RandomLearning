C Read array - example to read in a bunch of records from a file
C
C compile with
C     gfortran -o read-array read-array.f
C run with
C     make file "array.txt"
C     ./read-array

      PROGRAM READ_ARRAY
      IMPLICIT NONE

      INTEGER MAXSIZE
      PARAMETER (MAXSIZE = 100)
      REAL NUMBERS(MAXSIZE)
      INTEGER I, IOS, N

      OPEN(UNIT=10, FILE="array.txt", STATUS='OLD', IOSTAT=IOS)

      IF (IOS .NE. 0) THEN
         PRINT *, 'Error: could not open array.txt'
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

      END


