Program Seismo;

{ ******************************************
Perq Seismographic Waveform Demo
Copyright (C) 1980
Three Rivers Computer Corporation
Pittsburgh, Pa 15213

  Written by: Ralph Guggenheim6-26-80
  ****************************************** }

Imports Memory from Memory;
Imports Screen from Screen;
Imports WindowLib from WindowLib;
Imports Sleep from Sleep;
Imports IO_Unit from IO_Unit;
Imports IOErrors from IOErrors;

const  MinY=30;   { Blank area at top of screen }
       MinX=40;
       MaxX=768 - 40;
       WaveHeight=50;     { Dimensions of each wave channel }
       WaveWidth=(MaxX - MinX);
       LineSep=10;     { Distance between channels }
       MaxChans=16;

type   Datarray= array [0..MaxChans - 1, 0..1023] of integer;
       ChanInfo=record
Zero : integer;     { Y-posn of zero on waveform }
LastY : integer;     { Last Y-posn drawn }
Index : integer;     { Next Data value in Data[i, Index] }
end;

var    Data : Datarray;
       Info : array [0..MaxChans - 1] of ChanInfo;
       DataCnt : integer;     { total data values in each channel }
       PntSpread : integer;
       PntsPerLine : integer;
       Channels : integer;     { # of channels to show }
       SlewRate : integer;     { # of points to slide at a time }
       Seed : integer;     { for random number generator }
       NapVal : integer;     { sleep time between displays }
       KeyChar : char;     { last char typed at keyboard }
       MaxY : integer;     { y-position below lowest waveform }

Function Random : integer;
  begin
  Seed := (Seed * 25173) + 13849;
  Random := Seed;
  end;
  
Procedure InitData;
  var i, j, HgtDiv2 : integer;
  begin
  HgtDiv2 := WaveHeight div 2;
  for i := 0 to Channels - 1 do
    for j := 0 to DataCnt - 1 do
      begin
      Data[i,j] := (Abs(Random) mod WaveHeight) - HgtDiv2;
      end;
  Writeln('Data generated');
  end;

Procedure ThinData(pnts : integer);
  var i, j, factor : integer;
  begin
  factor := 1024 div pnts;{ get ratio of thinning }
  if factor > 1 then
    begin
    for i := 0 to Channels -1 do
      for j := 0 to pnts -1 do
data[i,j] := data[i, j * factor];
    end;
  end;

{ Generate auxiliary data table w/information about each display }
Procedure InitInfo;
  var i, HgtDiv2 : integer;
  begin
  HgtDiv2 := WaveHeight div 2;
  for i := 0 to Channels - 1 do
    with Info[i] do
      begin
      Zero := MinY + ((LineSep + WaveHeight) * i) + HgtDiv2;
      LastY := Zero;
      Index := 0;
      end;
  MaxY := MinY + ((LineSep + WaveHeight) * Channels);
  end;

{ Display text around the edges of the screen }
Procedure Titles;
  var i : integer;
  begin
  for i := 0 to Channels - 1 do
    with Info[i] do
      begin
      SSetCursor(MaxX + 10, Zero + 8);
      Write((i + 1):2);
      SSetCursor(MinX - 30, Zero + 8);
      Write((i + 1):2);
      end;
  SSetCursor(MinX + 30, MaxY+17);
  Write('Type <space> to pause/continue. Type anything to recreate the display.');
  end;

Procedure ShiftDisp;
  var Val : integer;
  begin
  if SlewRate > 0 then
    begin
    Val := SlewRate * PntSpread;
    MoveWindow(MinX + Val, MinY, WaveWidth - Val, MaxY - MinY, MinX, MinY);
    end;
  end;

Procedure DrawNext;
  var i, j, NextX, NextY, LastX, PntsToShow : integer;
  begin
  if SlewRate > 0 then
    PntsToShow := SlewRate
  else
    PntsToShow := DataCnt;
  for i := 0 to Channels - 1 do
    with Info[i] do
      begin
      if SlewRate = 0 then
LastX := MinX
      else
LastX := MaxX - (1 + (PntsToShow * PntSpread));
      for j := 1 to PntsToShow do
begin
NextX := LastX + PntSpread;
NextY := Zero + Data[i, Index];
Line(DrawLine, LastX, LastY, NextX, NextY,SScreenP);  
Index := (Index + 1) mod DataCnt;
LastX := NextX;
LastY := NextY;
end;
      end;
  end;

Function GetVal(Str : string) : integer;
  var val : integer;
  begin
  Write(Str, ': ');
  Readln(val);
  GetVal := val;
  end;

{ Check for typed chars. return char typed or Chr(0) if none typed. }
Function KeyCheck : char;
  var Status : integer;
      Ch : char;
  begin
  Status := IOCRead(TransKey, Ch);
  if (Status <> IOEIOB) and (Status = IOEIOC) then
    Keycheck := Ch
  else
    KeyCheck := Chr(0);
  end;

{ Main Program }
  begin
  Reset(Input);
  Rewrite(Output);
  Seed := #13205;

  repeat
  Write(Chr(12));
    repeat
      Channels := GetVal('Channels (1-16)');
      SlewRate := GetVal('Slew Rate (1-25)');
      DataCnt := GetVal('Number of Data Samples(1-1024)');
      PntsPerLine := GetVal('Samples displayed per line(1-1024)');
      PntSpread :=  WaveWidth div PntsPerLine;
      if PntSpread <= 1 then PntSpread := 1;
      Writeln('PntSpread = ', PntSpread:3);
      NapVal := GetVal('Jiffies between updates(0-?)');
      Writeln;
    until (Channels <= MaxChans) and (DataCnt <= 1024);
    
    InitData;
    InitInfo;
    Sleep(1);
  
    Write(Chr(12));
    Titles;
    
    repeat
      ShiftDisp;
      DrawNext;
      Nap(NapVal);
      KeyChar := KeyCheck;
      { if a <space> is typed, hold on until another comes along }
      if KeyChar = ' ' then
repeat KeyChar := Keycheck until KeyChar = ' ';
    until (KeyChar <> ' ') and (KeyChar <> Chr(0));
  until false;
  end.

