program StarFighter;

imports FileSystem from FileSystem;
imports SigUtils from SigUtils;
imports XScreen from XScreen;
imports IO_Others from IO_Others;
imports MultiRead from MultiRead;
imports FastRandom from FastRandom;
imports Memory from Memory;
imports SaveWIndow from Savewindow;
imports IO_Private from IO_Private;


var s, fileOfCurs: string;
    x,y,i,j,k,winx,winy,w,h,blks,srcx, srcy, destx, desty, howMany,
          star, growinc, maxW, maxH, winW, winH, funct, t:integer;
    fid: FileID;
    win: WinRange;

begin

if IOPriv1Unused = False then exit(StarFighter);

if ArgCount <> 3 then
  begin
  WriteLn('** Usage: StarFighter howMany growInc');
  exit(StarFighter);
  end;

NextArgStr(s);

win := RECAST(IOPriv2Unused, WinRange);

NextArgInt(HowMany);
NextArgInt(GrowInc);

ChangeWindow(win);
XSGetUseWindow(win, winx, winy, w, h);
fid := FSLookup('StarFighter.Animate', blks, i);
if fid = 0 then exit(StarFighter);
CreateSegment(star, blks, 1, blks);
MultiRead(fid, MakePtr(star, 0, pDirBlk), 0, blks);

IOLoadCursor(MakePtr(star, 0, curPatPtr), 0, 0);

IOSetCursorPos(1024, 100);
IOCursorMode(IndepCursor);

for i := 0 to 700 do
  begin
  IOSetCursorPos(1024-i, 100);
  for j := 1 to 1200 do;
  end;
  
IOLoadCursor(MakePtr(star, 256, curPatPtr), 0, 0);

k := 0;
for i := 0 to 200 do
  begin
  if (i+1) mod 2 = 0 then k := k+1;
  IOSetCursorPos(1024-(700+i), 100+k);
  for j := 1 to 1200 do;
  end;

IOLoadCursor(MakePtr(star, 512, curPatPtr), 0, 0);

k := 0;
for i := 0 to 100 do
  begin
  if (i+1) mod 2 = 0 then k := k+1;
  IOSetCursorPos(124+i, 200+k);
  for j := 1 to 1200 do;
  end;
   
IOLoadCursor(MakePtr(star, 768, curPatPtr), 0, 0);
for i := 0 to 30 do
  begin
  IOSetCursorPos(224+i, 250);
  for j := 1 to 1200 do;
  end;
   
       maxW := w;
       maxH := h;
       winW := 2;
       winH := 2;
       winX := winX+(maxW div 2);
       winY := winY+(maxH div 2);
destX := winX;
destY := winY;
srcX := 293;
srcY := 276;

SetUpRandom;


for i := 1 to howMany do
  for j := 1 to 200 do
   begin
   
   Line(XorLine, srcX, srcY, destX, destY, SScreenP);

   funct := RandomRange(1,8);
   if funct = 1 then funct := RXor          {dest <- 0}
   else if funct = 2 then funct := RXNor    {dest <- 1}
   else funct := RNot;                      {dest <- not dest}

   t := RandomRange(1, 2);
   if t = 1 then w := RandomRange(1, winW)  {width of box}
   else w := RandomRange(1, winW div 2);

   t := RandomRange(1, 2);
   if t = 1 then h := RandomRange(1, winH) {height of box}
   else h := RandomRange(1, winH div 2);

   x := RandomRange(winX,winX+winW+1-w); {start of box, chosen so box must fit}
   y := RandomRange(winY,winY+winH+1-h); {ditto}
   
   RasterOp(funct, w, h, x, y, SScreenW, SScreenP, x, y, SScreenW, SScreenP);
   

  if (j mod growInc = 0) then
        begin
        if winW+2 < maxW then begin
                              winW := winW + 2;
                              winX := winX - 1;
                              end;
        if winH+2 < maxH then begin
                              winH := winH + 2;
                              winY := winY - 1;
                              end;
        end;

   end;

RemoveWindow;

for i := 0 to 515 do
  begin
  IOSetCursorPos(254+i, 250);
  for j := 1 to 1200 do;
  end;
   
IOCursorMode(offCursor);
end.  
       
