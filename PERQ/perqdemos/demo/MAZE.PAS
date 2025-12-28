Program MazeSolver(input, output);
{---------------------------------------------------------
 A program for drawing and solving mazes.
 
 Written by Brad A. Myers
 
 Copyright (C) 1981 - Brad A. Myers
---------------------------------------------------------}

{//////////////////////////////} EXPORTS {\\\\\\\\\\\\\\\\\\\\\\\\}
imports GenMaze from GenMaze;

TYPE direction = (null, left, right, up, down);
     pListElement = ^listElement;
     listElement = RECORD
               d: direction;
               next: pListElement;
               END;

VAR  pauseTime,x,y, xSize, ySize, yStart, xOffset, yOffset, xEnd: INTEGER;
     Maze: MazeType;
     pHeadList: pListElement;

PROCEDURE Draw(d: Direction; x,y: INTEGER);
Procedure Look(d: Direction);
PROCEDURE Erase(d: Direction; x,y: INTEGER);

Procedure CheckForInput; {raises AbortMaze if should abort}

Exception AbortMaze;
Exception ReStart;

{//////////////////////////////} PRIVATE {\\\\\\\\\\\\\\\\\\\\\\\\}

imports Xscreen from Xscreen;
imports FileSystem from FileSystem;
imports GenMaze from GenMaze;
imports io from io;
imports ioerrors from ioerrors;
imports Arith from Arith;
imports SigUtils from SigUtils;

Const CtrlL = Chr(12);

VAR  win, again: BOOLEAN;
     c: CHAR;
     outFile: Text;
     s: String;
     outFID: fileID;
     mice: ARRAY[left..down] OF CurPatPtr;
     curDir:Direction;
     ans: String[1];
     playing: boolean;
     wind: WinRange;
     i: integer;
     
Const Title = '               The MazeSolver, Version V4.1.       By Brad A. Myers';

{$R+}

{$Include Mice.Incl}        {InitMice procedure}

PROCEDURE OutputStr(s: STRING);
     begin
     SSetCursor(5, StringLine);
     Write('                                                                ');
     SSetCursor(5, StringLine);
     Write(s);
     end; {OutputStr}

Procedure Look(d: Direction);
   begin
   if d = curDir then exit(Look);
   curDir := d;
   Pause(PauseTime);
   if d = null then WriteLn('**ERROR in Look Direction**')
   else IOLoadCursor(mice[d],7,7);
   end; {Look}

Procedure EraseScreen;
   begin
   Write(CtrlL);
   end;
   
PROCEDURE Draw(d: Direction; x,y: INTEGER);
     VAR     pNewElement: pListElement;
             scrX, scrY, i: integer;
     BEGIN
     scrX := xOffset+(x-1)*16+7;
     scrY := yOffset+(y-1)*16+7;
     if d = null Then Look(Down) else Look(d);
     CASE d OF
          Null: for i := 1 to 25 do {end of game}
                     begin
                     IOSetCursorPos(scrX, scrY+i);
                     if (i mod 2 = 1) and (i < 10) then
                       RasterOp(7,1,1,scrX, scrY+i,DestWords,DestPtr,
                                      scrX, scrY+i,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          Left: for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX-i, scrY);
                     if i mod 2 = 1 then
                       RasterOp(7,1,1,scrX-i, scrY,DestWords,DestPtr,
                                      scrX-i, scrY,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          Right: for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX+i, scrY);
                     if i mod 2 = 1 then
                       RasterOp(7,1,1,scrX+i, scrY,DestWords,DestPtr,
                                      scrX+i, scrY,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          Up:    for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX, scrY-i);
                     if i mod 2 = 1 then
                       RasterOp(7,1,1,scrX, scrY-i,DestWords,DestPtr,
                                      scrX, scrY-i,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          Down:  for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX, scrY+i);
                     if i mod 2 = 1 then
                       RasterOp(7,1,1,scrX, scrY+i,DestWords,DestPtr,
                                      scrX, scrY+i,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          END; {case}
     IF d <> null THEN
          BEGIN
          NEW(pNewElement);
          pNewElement^.d := d;
          pNewElement^.next := pHeadList;
          pHeadList:= pNewElement;
          END;
     END;

PROCEDURE Erase(d: Direction; x,y: INTEGER);
     VAR        scrX, scrY, i: integer;
     BEGIN
     scrX := xOffset+(x-1)*16+7;
     scrY := yOffset+(y-1)*16+7;
     Look(d);
     CASE d OF
          Null: WriteLn('***!! Maze erase error !!***');
          Left: for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX-i, scrY);
                     if i mod 2 = 1 then
                       RasterOp(6,1,1,scrX-i, scrY,DestWords,DestPtr,
                                      scrX-i, scrY,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          Right: for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX+i, scrY);
                     if i mod 2 = 1 then
                       RasterOp(6,1,1,scrX+i, scrY,DestWords,DestPtr,
                                      scrX+i, scrY,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          Up:    for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX, scrY-i);
                     if i mod 2 = 1 then
                       RasterOp(6,1,1,scrX, scrY-i,DestWords,DestPtr,
                                      scrX, scrY-i,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          Down:  for i := 1 to 16 do
                     begin
                     IOSetCursorPos(scrX, scrY+i);
                     if i mod 2 = 1 then
                       RasterOp(6,1,1,scrX, scrY+i,DestWords,DestPtr,
                                      scrX, scrY+i,DestWords,DestPtr);
                     Pause(pauseTime div 2);
                     end;
          END; {case}
     END; {Erase}

FUNCTION Search(x,y: Integer): BOOLEAN;
     FUNCTION UpCheck: BOOLEAN;
          BEGIN
          IF ((Maze^[x,y-1]=0) OR (Maze^[x,y-1]=1)) THEN
               BEGIN
               Draw(Up,x,y);
               upCheck:=Search(x,y-1);
               END
          ELSE upCheck:= FALSE;
          END;
     FUNCTION LeftCheck: BOOLEAN;
          BEGIN
          IF ((Maze^[x-1,y]=2) OR (Maze^[x-1,y]=0)) THEN
               BEGIN
               Draw(Left,x,y);
               leftCheck:=Search(x-1,y);
               END
          ELSE leftCheck:= FALSE;
          END;
     FUNCTION RightCheck: BOOLEAN;
          BEGIN
          IF Maze^[x+1,y] <> 4 THEN
               BEGIN
               Draw(Right,x,y);
               RightCheck:=Search(x+1,y);
               END
          ELSE RightCheck:= FALSE;
          END;
     FUNCTION DownCheck: BOOLEAN;
          BEGIN
          IF Maze^[x,y+1] <> 4 THEN
               BEGIN
               Draw(Down,x,y);
               DownCheck:=Search(x,y+1);
               END
          ELSE DownCheck:= FALSE;
          END;
     FUNCTION DeadEnd: BOOLEAN;
          VAR     pTemp: pListElement;
          BEGIN
          CASE pHeadList^.d OF
               Left:     Erase(Right,x,y);
               Right:    Erase(Left,x,y);
               Up:       Erase(Down,x,y);
               Down:     Erase(Up,x,y);
               END; {Case}
          pTemp:=pHeadList;
          pHeadList:=pHeadList^.next;
          Dispose(pTemp);
          DeadEnd:= False;
          END;
     BEGIN {body of function SEARCH}
     CheckForInput;
     CASE Maze^[x,y] OF
          0:   BEGIN
               Maze^[x,y]:=4;
               Search:= TRUE;
               IF y=ySize THEN  {win}
                    BEGIN
                    Draw(Null,x,y);
                    END
               ELSE IF NOT RightCheck THEN
               IF NOT DownCheck THEN
               IF NOT LeftCheck THEN
               IF NOT UpCheck THEN
               Search := DeadEnd;
               END;
          1:   BEGIN
               Maze^[x,y]:=4;
               Search:= TRUE;
               IF y=ySize THEN  {win}
                    BEGIN
                    Draw(Null,x,y);
                    END
               ELSE IF NOT DownCheck THEN
               IF NOT LeftCheck THEN
               IF NOT UpCheck THEN
               Search := DeadEnd;
               END;
          2:   BEGIN
               Maze^[x,y]:=4;
               Search:= TRUE;
               IF NOT RightCheck THEN
               IF NOT LeftCheck THEN
               IF NOT UpCheck THEN
               Search := DeadEnd;
               END;
          3:   BEGIN
               Maze^[x,y]:=4;
               Search:= TRUE;
               IF NOT LeftCheck THEN
               IF NOT UpCheck THEN
               Search := DeadEnd;
               END;
          otherwise : Write('** Maze search ERROR')
          END; {Case}
     END; {Search}

Procedure CalcPause;
   var xy: integer;
   begin
   xy := xSize*ySize;
   if xy < 100 then pauseTime := 1000
     else if xy < 225 then pauseTime := 500
     else if xy < 400 then pauseTime := 200
     else if xy < 625 then pauseTime := 100
     else if xy < 900 then pauseTime := 150
     else if xy < 1225 then pauseTime := 25
     else pauseTime := 0;
   end;

Procedure FixMazeBorders;
     begin
     For y:= 0 TO ySize+1 DO
          BEGIN
          Maze^[0,y]:= 4;
          Maze^[xSize+1,y]:=4;
          END;
     FOR x := 0 TO xSize+1 DO
          BEGIN
          Maze^[x,0]:=4;
          Maze^[x,ySize+1]:=4;
          END;
   {draw top}
     RasterOp(7, xSize*16+2, 2, xOffset-2, yOffset-2, DestWords,DestPtr, 
                xOffset-2, yOffset-2, DestWords, DestPtr);
   {draw left in two pieces to leave opening for yStart}
     RasterOp(7, 2, (yStart-1)*16+2, xOffset-2, yOffset-2, DestWords, DestPtr,
                xOffset-2, yOffset-2, DestWords, DestPtr);
     RasterOp(7, 2, (ySize-yStart)*16+2, xOffset-2, yOffset+yStart*16-2,
                     DestWords, DestPtr, xOffset-2, yOffset+yStart*16-2,
                     DestWords, DestPtr);
     end; {fixMazeBorders}
     
Procedure CheckForInput; {raises signal if should abort}
   var status: integer;
       c: char;
   begin
   {not done in demo}
   end;

Function Nibble(win:boolean): char;
  var cheeseX, cheeseY, x, y, i, stop: integer;
      used: record case boolean of
               true: (i: integer);
               false: (a: packed array [0..15] of boolean);
               end;
      
      turned: boolean;
  label 1;
  begin
  cheeseX := (xEnd-1)*16+xOffset;
  cheeseY := (ySize-1)*16+yOffset+20;
  x := cheeseX;
  used.i := 0;
  IOLoadCursor(mice[right],0,0);
  turned := false;
  if not win then IOCursorMode(trackCursor);
  repeat
    if win then
     if (x <= cheeseX+30) then
       begin
       if used.i = -1 then
           begin
           x := x+2;
           used.i := 0;
           end;
       repeat
         y := RandomRange(0, 15);
         if used.a[y] then stop := 600
         else stop := 1000;
         for i := 1 to stop do;
       until not used.a[y];
       used.a[y] := true;
       IOSetCursorPos(x,cheeseY+y);
       RasterOp(RAndNot, 20, 20, x, cheeseY+y, SScreenW, SScreenP,
                     0, 0, 4, BiteP);
       end
     else if not turned then
         begin
         IOSetTabletPos(x, cheeseY+y);
         IOLoadCursor(mice[down],0,0);
         IOCursorMode(trackCursor);
         turned := true;
         end;
  until turned;
   IOCursorMode(indepCursor);
   Nibble := 'n';
  end;

procedure CleanUp;
   var pTemp : pListElement;
   begin
   while pHeadList <> NIL do {dispose of rest of trace stack}
             begin
             pTemp := pHeadList;
             pHeadList := pHeadList^.next;
             Dispose(pTemp);
             end;
   end;

Procedure Go;
  var again: Boolean;
  begin
  again := false;
  playing := false;
  Draw(right,0,yStart);
  win:= Search(1,yStart);
  end; {Go}

BEGIN {main part}
     
    
     NEW(maze); 

     DestPtr := MakePtr(4,0,RasterPtr);
     
     InitBoxes;
     InitMice;
     

     debug := false;
     curDir := null;
     pHeadList:= NIL;
     
     IOCursorMode(OffCursor);
     
     If ArgCount <> 4 then
       begin
       WriteLn('** Usage: Maze win# xSize, ySize');
       exit(MazeSolver);
       end;
       
     SetUpRandom;
     
     NextArgStr(s);
     NextArgInt(i);
     
    wind := i;
    ChangeWindow(wind);
    XSGetUseWindow(wind, xOffset, yOffset, i, i);
    XSRedrawWindow(wind,'The Maze Solver');
    Write(FF);
    xOffset := xOffset+10;
    yOffset := yOffset+10;
    
     NextArgInt(xSize);
     NextArgInt(ySize);
     
     CalcPause;
     
     yStart:=GenRanMaze(maze, xSize, ySize, xOffset, yOffset, xEnd, pauseTime);
          
     FixMazeBorders; {draw outline}
     IOCursorMode(IndepCursor);
     Go;
     c := Nibble(win);
     IF c = 'n' THEN again:= FALSE
     ELSE begin
          again:=TRUE;
          CleanUp;
          end;
END.
