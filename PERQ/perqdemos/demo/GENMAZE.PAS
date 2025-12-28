Module GenMaze;
{----------------------------------------------------------------------
 This module contains the code to generate a well-formed random maze.  The
   mazes generated have exactly one path through them and no loops.
 
 Algorithm designed by Ed Barton.
 Program written by Brad A. Myers
 
 Copyright (C) 1981 - Brad A. Myers

{>>>>>>>>>>>>>>>>>>>>>>>>> } EXPORTS {<<<<<<<<<<<<<<<<<<<<<<<<<}

Imports Raster from Raster;
imports FastRandom from FastRandom;

CONST   maxXsize = 46;
        maxYsize = 53;
        DestWords = 48;
        StringLine = 960;
        

TYPE    Picture = ^PicArray;
        PicArray = ARRAY [0..63,0..3] of Integer;

VAR     DestPtr: RasterPtr;
        BiteP, CheeseP: Picture;
        
TYPE    MazeAR = ARRAY[0..maxXsize+1] OF ARRAY[0..maxYsize+1] OF INTEGER;
        MazeType = ^MazeAr;

{the return value is yStart}
FUNCTION GenRanMaze(maze: MazeType; xSize, ySize, xOffset, yOffset
                    : integer; var xEnd: integer; pauseLen: INTEGER): INTEGER;
Procedure DrawMaze(maze: MazeType; xSize, ySize, xOffset, yOffset, xEnd, delay
              : INTEGER);
procedure Pause(length: integer);
PROCEDURE InitBoxes;

var Debug: boolean;

{>>>>>>>>>>>>>>>>>>>>>>>>> } PRIVATE {<<<<<<<<<<<<<<<<<<<<<<<<<}

Imports Raster from Raster;
imports screen from screen;
Imports Memory from Memory;

{$R+}

type BoxAr = ARRAY[0..15] OF ARRAY[0..3] OF INTEGER;


var Boxes : ARRAY[0..4] OF ^BoxAr;

TYPE      Spoke = PACKED RECORD
               x: 0..maxXsize;
               y: 0..maxYsize;
               yIncr: 0..1;
               END;
CONST prodSize = maxXsize*maxYsize;
      twiceProdSize = prodSize*2;

TYPE eqTble = ARRAY[0..prodSize] OF INTEGER;
     spkTble = ARRAY[0..twiceProdSize] OF Spoke;

CONST SizeSpkSeg = (WordSize(spkTble)+255) div 256;
      SizeRegSeg = (WordSize(MazeAr)+255) div 256;
      SizeEqvSeg = (WordSize(eqTble)+255) div 256;

VAR       equivTable: ^eqTble;
          spokeTable: ^spkTble;
          region: MazeType;

procedure Pause(length: integer);
   var i, j: integer;
   begin
   for i := 0 to length do
      for j := 0 to 2 do;
   end;

PROCEDURE InitBoxes;
   var i,j,k: INTEGER;
   BEGIN
   FOR i := 0 to 4 do
       NEW (0, 4, Boxes[i]);
   for i := 1 to 3 do
       for j := 0 to 4 do
          for k := 0 to 15 do
              boxes[j]^[k][i] := 0;
   for i := 0 to 13 do
       begin
       Boxes[0]^[i][0] := 0;
       Boxes[1]^[i][0] := #000003;
       Boxes[2]^[i][0] := 0;
       Boxes[3]^[i][0] := #000003;
       Boxes[4]^[i][0] := 0;
       end;
   for i := 14 to 15 do
       begin
       Boxes[0]^[i][0] := 0;
       Boxes[1]^[i][0] := #000003;
       Boxes[2]^[i][0] := #177777;
       Boxes[3]^[i][0] := #177777;
       Boxes[4]^[i][0] := #000003;
       end;
  END;  {InitBoxes}
    
PROCEDURE DrawBox(maze: MazeType; x, y, xOffset, yOffset: INTEGER);
         VAR scrX, scrY, i, mazeVal, tmp: INTEGER;
         BEGIN
         mazeVal := maze^[x,y];
         scrX := xOffset+(x-1)*16;
         scrY := yOffset+(y-1)*16;
         if (mazeVal=0) and ((maze^[x+1,y] =2) OR (maze^[x+1,y] =3) OR
              (maze^[x,y+1] =1) OR (maze^[x,y+1] =3)) then mazeVal := 4;
         if (mazeVal < 0) or (mazeVal > 4) then writeLn('** Maze value error')
         else RasterOp(0, 16, 16, scrX, scrY, DestWords, DestPtr, 0,0, 4,
                    Boxes[mazeVal]);
         END;  {DrawBox}

Procedure FixZeros(maze: MazeType; xSize, ySize, xOffset, yOffset: INTEGER);
      var x, y: integer;
      begin
      for x := 1 to xSize do
         for y := 1 to ySize do
            if maze^[x,y] = 0 then DrawBox(maze,x,y, xOffset, yOffset);
      end;

Procedure DrawMaze(maze: MazeType; xSize,ySize,xOffset,yOffset,xEnd,delay:INTEGER);
     var x, y: INTEGER;
     begin
     for y := 1 to ySize do
        for x := 1 to xSize do
           begin
           DrawBox(maze,x,y,xOffset,yOffset);
           pause(delay);
           end;
     x := (xEnd-1)*16+xOffset+15;
     y := (ySize-1)*16+yOffset+25;
     RasterOp(ROr, 64, 64, x, y, SScreenW, SScreenP,
                           0, 0, 4, CheeseP);
     end;

FUNCTION GenRanMaze(maze: MazeType; xSize,ySize,xOffset,yOffset: integer;
               var xEnd: integer; pauseLen: INTEGER): INTEGER;
     VAR  i,j, numSpokes, yStart, regionCounter, x,y: INTEGER;
          spkSeg, eqvSeg, regSeg: integer;
     PROCEDURE InitMaze;     {initializes all globals}
          VAR x,y,i,j, spokeCounter: INTEGER;
          BEGIN
          spokeCounter:= 0;
          regionCounter:=1;
          For i := 0 TO xSize*ySize DO
               equivTable^[i]:= -1;
          FOR x := 1 TO xSize DO
               FOR y := 1 TO ySize DO
                    BEGIN
                    maze^[x,y]:=0;
                    region^[x,y]:=-1;
                    FOR j := 0 TO 1 DO
                         BEGIN
                         spokeTable^[spokeCounter+j].x := x;
                         spokeTable^[spokeCounter+j].y := y;
                         spokeTable^[spokeCounter+j].yIncr := j;
                         END;                    
                    spokeCounter:=spokeCounter+2;
                    END;
          FOR y := 1 TO ySize DO  {do left and right border}
               BEGIN
               maze^[0,y]:=1;
               maze^[xSize,y]:=1;
               DrawBox(maze, xSize, y, XOffset, YOffset);
               pause(pauseLen);
               END;
          FOR x := 1 TO xSize DO  {do top and bottom}
               BEGIN
               maze^[x,YSize]:=2;
               DrawBox(maze, x, YSize, XOffset, YOffset);
               pause(pauseLen);
               maze^[x,0] :=2; 
               END;
          region^[0,0]:=0;
          maze^[xSize,ySize]:= 3;  
          DrawBox(maze, xSize, YSize, XOffset, YOffset);
          pause(pauseLen);
               {now set up two regions: left + bot; top + rt}
          FOR y:=1 TO ySize+1 DO region^[0,y] :=0;
          FOR x:=0 TO xSize DO region^[x,0] :=0;
          FOR x:=0 TO xSize DO region^[x,ySize] :=1;
          FOR y:=1 TO ySize+1 DO region^[xSize,y] :=1;
          END; {InitMaze}
     PROCEDURE ShuffleSpokes;  {loop numSpoke times swapping spokes}
          VAR     tempSpoke: Spoke;
               c,i,j: INTEGER;
          BEGIN
          FOR c := 1 TO numSpokes DO
               BEGIN
               i := RandomRange(0,numSpokes-1);
               j := RandomRange(0,numSpokes-1);
               tempSpoke:= spokeTable^[i];
               spokeTable^[i] := spokeTable^[j];
               spokeTable^[j]:= tempSpoke;
               END;
          END; {ShuffleSpokes}               
     PROCEDURE SetSpokeBit(s: Spoke);
          VAR     mask: INTEGER;
                  temp: INTEGER;
          BEGIN
          mask:= 2-s.yIncr;
          if debug then temp := maze^[s.x, s.y];
          maze^[s.x, s.y] := LOR (mask, maze^[s.x, s.y]);
          DrawBox(maze, s.x, s.y, xOffset, yOffset);
          Pause(PauseLen);
          END;          
     FUNCTION GetNewRegion: INTEGER;
          BEGIN
          regionCounter:= regionCounter+1;
          GetNewRegion:= regionCounter;
          END;
     PROCEDURE SetNodeRegion(x,y,r: INTEGER);
          VAR     storedRegion: INTEGER;
          BEGIN
          storedRegion:= region^[x,y];
          IF storedRegion > -1 THEN equivTable^[storedRegion] := r;
          region^[x,y] := r;
          END;
     PROCEDURE SmashEquivalences(equivIndex, baseIndex: INTEGER);
          VAR     temp: INTEGER;
          BEGIN
          WHILE (equivIndex <> baseIndex) DO
               BEGIN
               temp:= equivTable^[equivIndex];
               equivTable^[equivIndex]:= baseIndex;
               equivIndex:= temp;
               END;
          END;
     FUNCTION GetNodeRegion(x,y: INTEGER): INTEGER;
          VAR EquivIndex, baseIndex, oldEquivIndex: INTEGER;
          BEGIN
          equivIndex:=region^[x,y];
          baseIndex:=equivIndex;
          oldEquivIndex:= equivIndex;
          WHILE (equivIndex > -1) DO
               BEGIN
               baseIndex:=equivIndex;
               equivIndex:=equivTable^[equivIndex];
               END;
          SmashEquivalences(oldEquivIndex,baseIndex);
          region^[x,y]:=baseIndex;
          GetNodeRegion:=baseIndex;
          END;
     PROCEDURE MaybeAddSpoke(s: Spoke);
          VAR      pRegion, qRegion, pX, pY, qX, qY, newRegion: INTEGER;
          BEGIN
          pX := s.x;
          pY := s.y;
          qX := s.x + s.yIncr - 1;
          qY := s.y - s.yIncr;
          pRegion := GetNodeRegion(pX, pY);
          qRegion := GetNodeRegion(qX, qY);
          IF ((pRegion = -1 ) AND (qRegion = -1)) THEN
               BEGIN
               newRegion:= GetNewRegion;
               SetNodeRegion(pX, pY, newRegion);
               SetNodeRegion(qX, qY, newRegion);
               SetSpokeBit(s);
               END
          ELSE IF pRegion <> qRegion THEN 
               BEGIN
               IF pRegion = -1 THEN
                    BEGIN
                    SetNodeRegion(pX,pY,qRegion);
                    SetSpokeBit(s);
                    END
               ELSE IF ((qRegion<>0) AND (qRegion<>1)) THEN
                    BEGIN
                    SetNodeRegion(qX, qY, pRegion);
                    SetSpokeBit(s);
                    END;
               END;
          END;


     BEGIN
     CreateSegment(spkSeg, SizeSpkSeg, 1, 256);
     CreateSegment(regSeg, SizeRegSeg, 1, 256);
     CreateSegment(eqvSeg, SizeEqvSeg, 1, 256);
     NEW(spkSeg, 0, SpokeTable);
     NEW(regSeg, 0, Region);
     NEW(eqvSeg, 0, EquivTable);
     yStart:=RandomRange(1, ySize);
     if xSize > 50 then xEnd := RandomRange(1, 50)
     else xEnd:= RandomRange(1, xSize);
     numSpokes:=2*xSize*ySize;
     InitMaze;
     ShuffleSpokes;
     For i:=0 TO numSpokes-1 DO
          MaybeAddSpoke(spokeTable^[i]);
     CASE Maze^[xEnd,ySize] OF
          2:     Maze^[xEnd,ySize] := 0;
          3:     Maze^[xEnd,ySize] := 1;
          otherwise : Write('** Maze generate error')
          END; {case}
     FixZeros(maze, xSize, ySize, xOffset, yOffset);
     DrawBox(maze, xEnd, ySize, xOffset, yOffset);
     x := (xEnd-1)*16+xOffset+15;
     y := (ySize-1)*16+yOffset+25;
     RasterOp(ROr, 64, 64, x, y, SScreenW, SScreenP,
                           0, 0, 4, CheeseP);
     GenRanMaze:= yStart;
     DecRefCount(spkSeg);
     DecRefCount(regSeg);
     DecRefCount(eqvSeg);
     END. {Function GenRanMaze}
