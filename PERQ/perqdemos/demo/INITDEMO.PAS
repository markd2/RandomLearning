Program InitDemo;

{ InitDemo -- initialize windows for Perq SigGraph Demo }

Imports Screen from Screen;
Imports SigUtils from SigUtils;
Imports System from System;
Imports Perq_String from PERQ_String;
Imports Memory from Memory;
Imports IO_Private from IO_Private;
Imports FastRandom from FastRandom;

var seg: integer;
    str: String;

Procedure RasterGrey(grey: CurPatPtr);
  var i,j: integer;
  begin
  for i := 0 to 11 do
    for j := 0 to 15 do
      RasterOp(RRpl, 64, 64, i*64, j*64, SScreenW, SScreenP,
                             0, 0, 4, grey);
  DISPOSE(grey);
  end; {RasterGrey}

Function DarkGrey: CurPatPtr;
  var grey: CurPatPtr;
      i,j: integer;
  begin
  NEW(0,4,grey);
  for i := 0 to 3 do
      for j := 0 to 31 do
         begin
         grey^[j*2,i]   := #125252;
         grey^[j*2+1,i] := #052525;
         end;
  DarkGrey := grey;
  end;

Function LightGrey: CurPatPtr;
  var grey: CurPatPtr;
      i,j: integer;
  begin
  NEW(0,4,grey);
  for i := 0 to 3 do
      for j := 0 to 31 do
         begin
         grey^[j*2,i]   := #104210;
         grey^[j*2+1,i] := #021042;
         end;
  LightGrey := grey;
  end;

Function White: CurPatPtr;
  var grey: CurPatPtr;
  begin
  NEW(0,4,grey);
  RasterOp(RXor, 64, 64, 0, 0, 4, grey, 0, 0, 4, grey);
  White := grey;
  end;

Function Black: CurPatPtr;
  var grey: CurPatPtr;
  begin
  NEW(0,4,grey);
  RasterOp(RXNor, 64, 64, 0, 0, 4, grey, 0, 0, 4, grey);
  Black := grey;
  end;

Procedure DoWindows(grey: CurPatPtr);
  begin
  CreateWindow(1,  65, 180, 630, 420, '  ');
  CreateWindow(2, 200,30, 520, 420, '  ');
  CreateWindow(3, 245, 380, 520, 300, '  ');
  CreateWindow(4,   5, 440, 400, 430, '  ');
  CreateWindow(5, 340, 460, 420, 420, '  ');
  CreateWindow(6, 380, 45, 350, 300, '  ');
  CreateWindow(7,  40, 390, 550, 330, '  ');
  CreateWindow(8,  10, 25, 620, 200, '   ');
  CreateWindow(9,  65, 280, 630, 300, '  ');
  CreateWindow(10,  0, 0, 768, 899, '');
  CreateWindow(11, 10, 630, 525, 260, '   ');
  CreateWindow(12, 288, 385, 480, 510, '   ');
  CreateWindow(13,  40, 257, 550, 130, '  ');
  RasterGrey(grey);
  CreateWindow(0,   0, 900, 768, 123, 'PERQ COMMAND INTERPRETER');
  end;

begin

if ArgCount = 1 then str := 'DARK'
else begin
     NextArgStr(str); {flush "InitDemo"}
     NextArgStr(str);
     ConvUpper(str);
     end;

if str = 'DARK' then DoWindows(DarkGrey)
else if str = 'LIGHT' then DoWindows(LightGrey)
else if str = 'WHITE' then DoWindows(White)
else if str = 'BLACK' then DoWindows(Black)
else if str = 'INIT' then 
         begin
         IOPriv1Unused := false;
         IOPriv2Unused := false;
         CreateSegment(DemoInt, 1, 1, 1);
         IncRefCount(DemoInt);
         RandomTable(MakePtr(DemoInt, 0, pRanTable));
         end
else if (str = 'CLEAR') or (str = 'X') then
         begin
         if IOPriv1Unused <> false then
            begin
            seg := RECAST(IOPriv1Unused, INTEGER);
            DecRefCount(seg);
            DecRefCount(seg);
            DecRefCount(DemoInt);
            DecRefCount(DemoInt);
            IOPriv1Unused := false;
            end;
         ScreenReset;
         end
else begin
    WriteLn('** Usage: InitDemo <parameter>');
    WriteLn('    <parameter> is: ');
    WriteLn(' WHITE, BLACK, GREY, LIGHT to set up demo windows and color screen');
    WriteLn(' INIT should called once at boot');
    WriteLn(' X or CLEAR to remove demo windows and clean up state');
    end;

end.
