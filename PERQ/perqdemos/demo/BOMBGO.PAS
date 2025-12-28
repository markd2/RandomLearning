Program BombGo;
{--------------------------------------------------------------------------
 Written by Brad Myers  27-Jul-81
 
 Copyright (C) 1981 - Three Rivers Computer Corporation
--------------------------------------------------------------------------}

{-------------------------------------------------------------------------
 Change log:
     28-Jul-81 Brad Myers V1.0   Started
-------------------------------------------------------------------------}

imports XScreen from XScreen;
imports IO_Others from IO_Others;
imports MultiRead from MultiRead;
imports Memory from Memory;
imports SigUtils from SigUtils;
imports sleep from sleep;

(*
imports IO_Private from IO_Private;
imports SaveWindow from SaveWindow;
*)

var x,y,w,h,seg,count,rep, bombSeg, bombCnt, blks, bits: Integer;
    i,j,k,time, time2, yPos: integer;
    fid: FileID;
    lighterSeg, temp: integer;
    walkerSeg: integer;
    f: FontPtr;
    s: String;
    
    
procedure error(s: String);
  begin
  changewindow(0);
  writeLn('** ',s);
  exit(BombGo);
  end;

begin

if ArgCount <> 2 then 
   begin
   WriteLn('** Usage: BombGo yPos');
   exit(BombGo);
   end;

NextArgStr(s);
NextArgInt(yPos);

RasterOp(RXNor, 625, 130, 0, yPos-4, SScreenW, SScreenP,
                          0, yPos-4, SScreenW, SScreenP);

for i := 1 to 30000 do;

RasterOp(RXor, 620, 120, 0, yPos+1, SScreenW, SScreenP,
                         0, yPos+1, SScreenW, SScreenP);

f := XSLoadFont('Border2.Kst');
if f = NIL then error('Font not found');
ChangeWindow(10);
SetFont(f);
SSetCursor(5, yPos+20);
Write('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB');
SSetCursor(5, yPos+121);
Write('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB');

fid := FSLookUp('Bomb.Animate', blks, bits);
if fid = 0 then error('bomb.animate not found');
CreateSegment(bombseg,blks,1,blks);
MultiRead(fid, MakePtr(bombSeg,0,pDirBlk), 0, blks);

fid := FSLookUp('Lighter.Animate', blks, bits);
if fid = 0 then error('no lighter');
CreateSegment(lighterSeg,blks,1,blks);
MultiRead(fid, MakePtr(lighterSeg,0,pDirBlk), 0, blks);

fid := FSLookUp('WalkAway.Animate', blks, bits);
if fid = 0 then error('no walkAway');
CreateSegment(walkerSeg,blks,1,blks);
MultiRead(fid, MakePtr(walkerSeg,0,pDirBlk), 0, blks);

RasterOp(RRpl, 64, 64, 540, yPos+26, SScreenW, SScreenP,
                       0, 0, 4, MakePtr(bombSeg, 0, RasterPtr));
                            
IOLoadCursor(MakePtr(lighterSeg, 0, CurPatPtr), 63, 0);
IOSetCursorPos(0, yPos+26);
IOCursorMode(indepCursor);
j := 1;
for i := 1 to 558 do
   begin
   IOSetCursorPos(i, yPos+26);
   for time := 1 to 1500 do; {wait}
   if i mod 5 = 0 then
      begin
      IOLoadCursor(MakePtr(lighterSeg,j*256, CurPatPtr), 63, 0);
      j := (j+1) mod 6;
      end;
   end;

for i := 1 to 40 do
  for j := 1 to 1000 do;
  
RasterOp(RRpl, 64, 64, 540, yPos+26, SScreenW, SScreenP,
                       0, 0, 4, MakePtr(bombSeg, 256, RasterPtr));

IOLoadCursor(MakePtr(walkerSeg, 0, CurPatPtr), 63, 0);
j := 1;
k := 1;
for i := 562 downto 0 do
   begin
   IOSetCursorPos(i, yPos+26);
   for time := 1 to 800 do; {wait}
   if i mod 7 = 0 then
      begin
      IOLoadCursor(MakePtr(walkerSeg,j*256, CurPatPtr), 63, 0);
      j := (j+1) mod 6;
      temp := 256*(k+1);
      RasterOp(RRpl, 64, 64, 540, yPos+26, SScreenW, SScreenP,
                       0, 0, 4, MakePtr(bombSeg, temp, RasterPtr));
      k := (k+1) mod 2;
      end;
   end;

for i := 1 to 26 do
   begin
   RasterOp(RRpl, 64, 64, 540, yPos+26, SScreenW, SScreenP,
                       0, 0, 4, MakePtr(bombSeg, 256*i, RasterPtr));
   for time := 1 to 10000 do;
   end;
   
bombcnt := 27;
for i := 1 to 42 do
  begin
  IOSetFunction(Recast((i mod 2)+4, CursFunction));
  for time := 1 to 5000 do;
  if (i mod 3 = 0) and (bombCnt < 40) then
      begin
      RasterOp(RRpl, 64, 64, 540, yPos+26, SScreenW, SScreenP,
                      0, 0, 4, MakePtr(bombSeg, 256*bombCnt, RasterPtr));
      bombCnt := bombCnt+1;
      end;
  end;

IOSetFunction(RECAST(1, CursFunction));

RasterOp(RXor, 768, 1024, 0, 0, SScreenW, SScreenP,
                           0, 0, SScreenW, SScreenP);

ChangeWindow(0);
Sleep(2);

end.
   


<><><
bombcnt := 30;
for i := 1 to 50 do
  begin
  IOSetFunction(Recast((i mod 2)+4, CursFunction));
  for time := 1 to 5000 do;
  if (i mod 3 = 0) and (bombCnt <= blks) then
      begin
      IOLoadCursor(MakePtr(bombSeg,(bombCnt-1)*256, CurPatPtr), 0, 0);
      bombCnt := bombCnt+1;
      end;
  end;

IOCursorMode(offCursor);
if IOPriv1Unused = FALSE then exit(BlinkGo);
end.

