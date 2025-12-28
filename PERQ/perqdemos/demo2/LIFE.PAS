program Life;

imports Raster from Raster;
imports Memory from Memory;
imports IO_Unit from IO_Unit;
imports IO_Others from IO_Others;
imports IOErrors from IOErrors;
imports Screen from Screen;

const
   HHigh = 65;
   Wide = 65;
   BSize = 6;
   TabDivisor = 4;
   
type
   box = array [0..15] of array[0..47] of integer;
   boxptr = ^box;
   row = array[0..Wide-1] of boolean;
   counts = array[-1..HHigh] of integer;
   Picture = array[0..HHigh*BSize-1] of array[0..47] of integer;
   PicPtr = ^Picture;
   Modes = (FillMode,ClearMode,CompMode);{ drawing modes }
   
var
   HLead,VLead: integer;
   Maze: array[0..HHigh-1] of Row;
   PrevRow,CurRow: Row;
   CurTotals,PrevTotals: counts;
   TheBox: boxPtr;
   Model: PicPtr;
   DX,DY,i,j: integer;
   CursorOn,WasDown,Flag: boolean;
   Ch: char;
   LeftMost,RightMost: integer;
   Year, Population: integer;
   LastX,LastY,CurX,CurY,OldX,OldY: integer;
   DrawMode: Modes;
   
Procedure Fill(y,x:integer);
begin
   if not Maze[y][x] then
   begin
      Population:=Population+1;
      CurTotals[y]:=CurTotals[y]+1;
      if x < LeftMost then LeftMost:=x;
      if x > RightMost then RightMost:=x;
      RasterOp(RRpl,BSize,BSize,HLead+x*BSize,y*BSize,48,Model,
               0,0,48,TheBox);
      Maze[y][x]:=true
   end
end { Fill };

Procedure Clear(y,x:integer);
var TmpX,TmpY: integer;
begin
   if Maze[y][x] then
   begin
      Population:=Population-1;
      CurTotals[y]:=CurTotals[y]-1;
      TmpX:=HLead+x*BSize;
      TmpY:=y*BSize;
      RasterOp(RXor,BSize,BSize,TmpX,TmpY,48,Model,TmpX,TmpY,48,Model);
      Maze[y][x]:=false
   end
end { Clear };

Procedure Draw(Y,X: integer);
{ Draw initial patterns in maze - may either fill, clear or complement }
begin
   case DrawMode of
     FillMode: Fill(Y,X);
     ClearMode: Clear(Y,X);
     CompMode: if Maze[Y][X] then
                  Clear(Y,X)
               else
                  Fill(Y,X)
   end { case }
end { Draw };

Procedure Show;
{ Copy the Model to the screen }
begin
   RasterOp(RRpl,Wide*BSize,HHigh*BSize,HLead,VLead,48,MakePtr(ScreenSeg,0,PicPtr),
            HLead,0,48,Model);
   SSetCursor(HLead+9*4,VLead-26);
   Write(Population:6);
   SSetCursor(HLead+Wide*BSize-9*6,VLead-26);
   Write(Year:6)
end { Show };

Procedure PrintMode;
begin
   SSetCursor(HLead,VLead+BSize*HHigh+26);
   write('Drawing Mode: ');
   case DrawMode of
     FillMode:  Write('Fill');
     ClearMode: Write('UnFill');
     CompMode:  Write('Complement')
   end
end { PrintMode };

Procedure Generation;
var R,C,Count,Rightest,Leftest: integer;
begin
   Rightest:=RightMost+1;
   if Rightest >= Wide then Rightest:=Wide-1;
   Leftest:=LeftMost-1;
   if Leftest < 0 then Leftest:=0;
   PrevTotals:=CurTotals;
   LeftMost:=Wide-1;
   RightMost:=0;
   for R:=0 to HHigh-1 do
   begin
      if R = 0 then{ Top Row }
         for C:=0 to Wide-1 do PrevRow[C]:=false
         else
            PrevRow:=CurRow;
      CurRow:=Maze[R];
      if (PrevTotals[R] <> 0) or (PrevTotals[R-1]+PrevTotals[R+1] >= 2) then
         for C:=Leftest to Rightest do
         begin
            Count:=0;
            if C <> 0 then
            begin
               if PrevRow[C-1] then Count:=Count+1;
               if CurRow[C-1] then Count:=Count+1;
               if R <> HHigh-1 then if Maze[R+1][C-1] then Count:=Count+1
            end;
            if PrevRow[C] then Count:=Count+1;
            if R <> HHigh-1 then if Maze[R+1][C] then Count:=Count+1;
            if C <> Wide-1 then
            begin
               if PrevRow[C+1] then Count:=Count+1;
               if CurRow[C+1] then Count:=Count+1;
               if R <> HHigh-1 then if Maze[R+1][C+1] then Count:=Count+1
            end;
            if CurRow[C] then
               if (Count < 2) or (Count > 3) then
                  Clear(R,C)
               else
               begin
                  if C < LeftMost then LeftMost:=C;
                  if C > RightMost then RightMost:=C
               end
         else
            if Count = 3 then
               Fill(R,C)
         end
   end;
   Year:=Year+1;
   Show
end { Generation };

Procedure DoIt;
var R,C,Count:integer; Ch: char;
begin
   while true do
   begin
      if IOCRead(TransKey,Ch) = IOEIOC then
      begin
         if Ch in ['S','s'] then
            exit(DoIt);
         if Ch in ['Q','q'] then
         begin
            write(chr(#14));
            exit(Life)
         end
      end;
      Generation
   end
end { DoIt };

Procedure PutCursor(Y,X: integer);
begin
   IOSetCursorPos(HLead+BSize*X+BSize div 2,VLead+BSize*Y+BSize div 2)
end { PutCursor };

Procedure TgleCursor;
begin
   if CursorOn then
      IOCursorMode(OffCursor)
   else
   begin
      IOCursorMode(IndepCursor);
      PutCursor(dy,dx);
      LastX:=(HLead+BSize*DX+BSize div 2);
      LastY:=(VLead+BSize*DY+BSize div 2)
   end;
   CursorOn:=Not CursorOn
end { TgleCursor };

Procedure Slash;
var x,y: integer;
begin
   x:=DX;
   y:=DY;
   while (y > 0) and (x < (Wide-1)) do
   begin
      y:=y-1;
      x:=x+1
   end;
   repeat
      Draw(Y,X);
      x:=x-1;
      y:=y+1
   until (y = HHigh) or (X < 0);
   Show
end { Slash };

Procedure BackSlash;
var x,y:integer;
begin
   x:=DX;
   y:=DY;
   while (y > 0) and (X > 0) do
   begin
      y:=y-1;
      x:=x-1
   end;
   repeat
      Draw(Y,X);
      x:=x+1;
      y:=y+1
   until (y = hhigh) or (x = Wide);
   Show
end { BackSlash };

Procedure Init;
var i,j:integer; MyCursor: CurPatPtr;

   Procedure PrintKey;

      Procedure PrintLeft(str:string);
      var i:integer;
      begin
         Write(' ',Str);
         if length(Str) < 44 then write(' ':44-Length(Str))
      end;
   
      Procedure PrintRight(str:string);
      begin
         writeln(Str)
      end;
   
   begin
      write(chr(#14));
      writeln;
      writeln('    LIFE    V1.0');
      writeln;
      PrintLeft('F   = Select Fill Draw Mode');
      PrintRight('G    = Start Generations');
      PrintLeft('U   = Select UnFill Draw Mode');
      PrintRight('S    = Stop Generations');
      PrintLeft('X   = Select Complement Draw Mode');
      PrintRight('<space> = Single Step Generations');
      Writeln;
      PrintLeft('Depress Tablet to Draw');
      PrintRight('I,M,J,L = Up, Down, Left, Right');
      Writeln;
      PrintLeft('R   = Draw a Row');
      PrintRight('Z    = Clear Universe');
      PrintLeft('C   = Draw a Column');
      PrintRight('T    = Toggle Cursor');
      PrintLeft('\   = Draw a \ Diagonal');
      PrintRight('Q    = Quit');
      PrintLeft('/   = Draw a / Diagonal')
   end { PrintKey };

begin { Init }
   reset(input);
   rewrite(output);
   writeln(chr(#14),'Welcome to LIFE');
   IOSetModeTablet(relTablet);
   IOCursorMode(IndepCursor);
   new(0,4,MyCursor);
   for i:=0 to 63 do
      for j:=0 to 3 do
         MyCursor^[i,j]:=0;
   for i:=27 to 28 do
   begin
      for j:=0 to 2 do MyCursor^[i,j]:=-1;
      MyCursor^[i,3]:=#177400
   end;
   for i:=0 to 55 do
      MyCursor^[i,1]:=LOr(MyCursor^[i,1],#60);
   IOLoadCursor(MyCursor,27,28);
   PrintKey;
   Dispose(MyCursor);
   HLead := (768 - Wide*BSize) div 2;
   VLead := (1024 - HHigh*BSize) div 2;
   LeftMost:=Wide-1;
   RightMost:=0;
   for i:=0 to HHigh-1 do
   begin
      for j:=0 to Wide-1 do
         Maze[i][j]:=false;
      CurTotals[i]:=0
   end;
   CurTotals[-1]:=0;
   CurTotals[HHigh]:=0;
   new(Model);
   RasterOp(RXor,768,HHigh*BSize,0,0,48,Model,0,0,48,Model);
   WasDown:=false;
   Population:=0;
   Year:=0;
   Show;
   SSetCursor(HLead,VLead-40);
   Write('Population');
   SSetCursor(HLead+Wide*BSize-9*10,VLead-40);
   Write('Generation');
   new(0,4,TheBox);
   for i:=0 to BSize do
      TheBox^[i][0]:=-1;
   Line(DrawLine,HLead-1,VLead-1,HLead-1,VLead+BSize*HHigh,SScreenP);
   Line(DrawLine,HLead-1,VLead-1,HLead+BSize*Wide,VLead-1,SScreenP);
   Line(DrawLine,HLead+BSize*Wide,VLead-1,HLead+BSize*Wide,VLead+BSize*
        HHigh,SScreenP);
   Line(DrawLine,HLead-1,VLead+BSize*HHigh,HLead+BSize*Wide,VLead+
        BSize*HHigh,SScreenP);
   DrawMode:=FillMode;
   PrintMode;
   CursorOn:=True;
   DX:=Wide div 2;
   DY:=HHigh div 2;
   PutCursor(DY,DX);
   LastX:=(HLead+BSize*DX+BSize div 2);
   LastY:=(VLead+BSize*DY+BSize div 2)
end { Init };

begin { Life }
   Init;
   while true do
   begin
      while IOCRead(TransKey,ch) <> IOEIOC do
      begin
         IOReadTablet(CurX,CurY);
         if CurX < HLead then CurX:=HLead
         else if CurX > HLead + BSize*Wide then CurX:=HLead + BSize*Wide;
         if CurY < VLead then CurY:=VLead
         else if CurY > VLead + BSize*HHigh then CurY:=VLead + BSize*Wide;
         if (((CurX-LastX) div TabDivisor) <> 0) or (((CurY-LastY) div TabDivisor) <> 0) then
         begin
            dx:=(CurX-HLead) div BSize;
            dy:=(CurY-VLead) div BSize;
            {
            if dx > Wide-1 then dx:=Wide-1
    else if dx < 0 then dx:=0;
            if dy > HHigh-1 then dy:=HHigh-1
    else if dy < 0 then dy:=0;
            }
            WasDown:=false;
            Flag:=true
         end
      else
         Flag:=false;
         OldX:=LastX;
         OldY:=LastY;
         IOSetCursorPos(CurX,CurY);
         if Flag then
         begin
            LastX:=OldX;
            LastY:=OldY
         end;
         if TabSwitch and (not WasDown) then
         begin
            Draw(dy,dx);
            Show
         end;
         WasDown:=TabSwitch
      end;
      if Ch in ['a'..'z'] then Ch:=chr(ord(Ch) - 32);
      case Ch of

        'G': DoIt;

        ' ': Generation;

        'T': TgleCursor;

        'Q': begin
           IOSetCursorPos(0,-1);
           Write(chr(#14));
           exit(Life)
        end;

        'F': begin DrawMode:=FillMode; PrintMode end;

        'U': begin DrawMode:=ClearMode; PrintMode end;

        'X': begin DrawMode:=CompMode; PrintMode end;

        'C': begin for i:=0 to HHigh-1 do Draw(i,dx); show end;

        'R': begin for i:=0 to Wide-1 do Draw(dy,i); show end;

        '\': BackSlash;

        '/': Slash;

        'I': begin
           if dy > 0 then dy:=dy-1;
           if CursorOn then
           begin
              PutCursor(DY,DX);
              LastX:=(HLead+BSize*DX+BSize div 2);
              LastY:=(VLead+BSize*DY+BSize div 2)
           end
        end;
        
        'M': begin
           if dy < HHigh-1 then dy:=dy+1;
           if CursorOn then
           begin
              PutCursor(DY,DX);
              LastX:=(HLead+BSize*DX+BSize div 2);
              LastY:=(VLead+BSize*DY+BSize div 2)
           end
        end;
        
        'J': begin
           if dx > 0 then dx:=dx-1;
           if CursorOn then
           begin
              PutCursor(DY,DX);
              LastX:=(HLead+BSize*DX+BSize div 2);
              LastY:=(VLead+BSize*DY+BSize div 2)
           end
        end;
        
        'L': begin
           if dx < Wide-1 then dx:=dx+1;
           if CursorOn then
           begin
              PutCursor(DY,DX);
              LastX:=(HLead+BSize*DX+BSize div 2);
              LastY:=(VLead+BSize*DY+BSize div 2)
           end
        end;
        
        'Z': begin
           for i:=0 to HHigh-1 do
              for j:=0 to Wide-1 do
                 clear(i,j);
           Year:=0;
           Show;
           DX:=Wide div 2;
           DY:=HHigh div 2;
           PutCursor(DY,DX);
           LastX:=(HLead+BSize*DX+BSize div 2);
           LastY:=(VLead+BSize*DY+BSize div 2)
        end
        
      end      
   end
end.

