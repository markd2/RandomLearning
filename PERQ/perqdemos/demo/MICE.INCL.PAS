Procedure InitMice;
   Var i,j: integer;
       k: Direction;
BEGIN
for k:= left to down do
   NEW(Mice[k]);

NEW(0,256,biteP);
NEW(0,256,cheeseP);

for i := 0 to 63 do
   for j := 0 to 3 do
      begin
      for k := left to down do
         mice[k]^[i,j] := 0;
      cheeseP^[i,j] := 0;
      biteP^[i,j] := 0;
      end;

mice[left]^[ 0, 0] := #0;
mice[left]^[ 1, 0] := #0;
mice[left]^[ 2, 0] := #0;
mice[left]^[ 3, 0] := #0;
mice[left]^[ 4, 0] := #1760;
mice[left]^[ 5, 0] := #17770;
mice[left]^[ 6, 0] := #63774;
mice[left]^[ 7, 0] := #177776;
mice[left]^[ 8, 0] := #63775;
mice[left]^[ 9, 0] := #17771;
mice[left]^[10, 0] := #1761;
mice[left]^[11, 0] := #1;
mice[left]^[12, 0] := #6;
mice[left]^[13, 0] := #30;
mice[left]^[14, 0] := #40;
mice[left]^[15, 0] := #0;

mice[right]^[0, 0] := #2000;
mice[right]^[1, 0] := #14000;
mice[right]^[2, 0] := #60000;
mice[right]^[3, 0] := #100000;
mice[right]^[4, 0] := #107700;
mice[right]^[5, 0] := #117770;
mice[right]^[6, 0] := #137746;
mice[right]^[7, 0] := #77777;
mice[right]^[8, 0] := #37746;
mice[right]^[9, 0] := #17770;
mice[right]^[10, 0] := #7700;
mice[right]^[11, 0] := #0;
mice[right]^[12, 0] := #0;
mice[right]^[13, 0] := #0;
mice[right]^[14, 0] := #0;
mice[right]^[15, 0] := #0;

mice[up]^[0, 0] := #400;
mice[up]^[1, 0] := #1600;
mice[up]^[2, 0] := #1600;
mice[up]^[3, 0] := #2500;
mice[up]^[4, 0] := #2500;
mice[up]^[5, 0] := #3700;
mice[up]^[6, 0] := #7740;
mice[up]^[7, 0] := #7740;
mice[up]^[8, 0] := #7740;
mice[up]^[9, 0] := #7740;
mice[up]^[10, 0] := #107740;
mice[up]^[11, 0] := #47740;
mice[up]^[12, 0] := #43700;
mice[up]^[13, 0] := #21600;
mice[up]^[14, 0] := #20400;
mice[up]^[15, 0] := #17000;

mice[down]^[0, 0] := #360;
mice[down]^[1, 0] := #410;
mice[down]^[2, 0] := #1610;
mice[down]^[3, 0] := #3704;
mice[down]^[4, 0] := #7744;
mice[down]^[5, 0] := #7742;
mice[down]^[6, 0] := #7740;
mice[down]^[7, 0] := #7740;
mice[down]^[8, 0] := #7740;
mice[down]^[9, 0] := #7740;
mice[down]^[10, 0] := #3700;
mice[down]^[11, 0] := #2500;
mice[down]^[12, 0] := #2500;
mice[down]^[13, 0] := #1600;
mice[down]^[14, 0] := #1600;
mice[down]^[15, 0] := #400;

biteP^[ 5, 0] := #30;
biteP^[ 6, 0] := #36;
biteP^[ 7, 0] := #37;
biteP^[ 8, 0] := #36;
biteP^[ 9, 0] := #30;

cheeseP^[ 0, 1] := #7000;
cheeseP^[ 1, 1] := #37400;
cheeseP^[ 2, 1] := #177400;
cheeseP^[ 3, 0] := #3;
cheeseP^[ 3, 1] := #173600;
cheeseP^[ 4, 0] := #17;
cheeseP^[ 4, 1] := #161600;
cheeseP^[ 5, 0] := #77;
cheeseP^[ 5, 1] := #33700;
cheeseP^[ 6, 0] := #377;
cheeseP^[ 6, 1] := #37700;
cheeseP^[ 7, 0] := #1777;
cheeseP^[ 7, 1] := #37440;
cheeseP^[ 8, 0] := #7747;
cheeseP^[ 8, 1] := #176340;
cheeseP^[ 9, 0] := #37703;
cheeseP^[ 9, 1] := #171740;
cheeseP^[10, 0] := #173703;
cheeseP^[10, 1] := #147740;
cheeseP^[11, 0] := #161747;
cheeseP^[11, 1] := #37740;
cheeseP^[12, 0] := #173774;
cheeseP^[12, 1] := #176340;
cheeseP^[13, 0] := #77763;
cheeseP^[13, 1] := #114140;
cheeseP^[14, 0] := #77717;
cheeseP^[14, 1] := #116340;
cheeseP^[15, 0] := #77475;
cheeseP^[15, 1] := #177740;
cheeseP^[16, 0] := #36370;
cheeseP^[16, 1] := #177340;
cheeseP^[17, 0] := #31460;
cheeseP^[17, 1] := #76140;
cheeseP^[18, 0] := #27470;
cheeseP^[18, 1] := #177340;
cheeseP^[19, 0] := #17777;
cheeseP^[19, 1] := #177740;
END;
