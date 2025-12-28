Program Slider2;
{----------------------------------------------------------------------------
 Draw a line or a rectangle at a factor of 8 bigger than regular.  Used by
   Cursdesign and FontEd.
 
 Written by Brad A. Myers   July 22, 1981

 Copyright (C) - 1981 Brad A. Myers
----------------------------------------------------------------------------}

{----------------------------------------------------------------------------
  Change Log:
    22-Jul-81 Brad A. Myers V1.0  Started using LineRect
----------------------------------------------------------------------------}


imports SigUtils from SigUtils;
imports IO_Private from IO_Private;
imports SaveWindow from SaveWindow;
imports XScreen from XScreen;

var win: WinRange;
    auto: boolean;
    amt,x,y,destx,desty,w,h: integer;
    str: String;
    
Type Direction = (bad0, west, bad2, east, south, southwest, bad6,
                  southeast, bad8, bad9, bad10, bad11, north, northwest,
                  bad14, northeast); 

Exception Impossible;

{x,y are OLD location of window}
Procedure MoveOne(amt: integer;var x,y: integer; w,h: integer; dir: direction);
  var ww, seg: integer;
      p: RasterPtr;
  begin
  ww := ((w+maxAmt+63) div 64) * 4;  {round up to nearest quad}
  seg := RECAST(IOPriv1Unused, INTEGER);
  p := MakePtr(seg, 0, RasterPtr);
  seg := RECAST(IOPriv1Unused, INTEGER);

  case dir of
    North: begin
           if (y - amt < 0) then exit(MoveOne);
           RasterOp(RRpl, w, h, 0, amt, ww, p, 0, 0, ww, p);
           RasterOp(RRpl, w, amt, 0, 0, ww, p, x, y-amt, SScreenW, SScreenP);
           RasterOp(RRpl, w, h, x, y-amt, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
           RasterOp(RRpl, w, amt, x, y+h-amt, SScreenW, SScreenP, 0, h, ww, p);
           y := y-amt;
           end;
    NorthEast: begin
         if (y - amt < 0) or (x+w+amt > 768) then exit(MoveOne);
         RasterOp(RRpl, w, h, 0, amt, ww, p, 0, 0, ww, p);
         RasterOp(RRpl, w+amt, amt, 0, 0, ww, p, x, y-amt, SScreenW, SScreenP);
         RasterOp(RRpl, amt,h+amt, w, 0, ww, p, x+w,y-amt, SScreenW, SScreenP);
         RasterOp(RRpl, w, h, x+amt, y-amt, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
         RasterOp(RRpl, amt, h, x, y, SScreenW, SScreenP, 0, amt, ww, p);
         RasterOp(RRpl, w, amt, x, y+h-amt, SScreenW, SScreenP, 0, h, ww, p);
         RasterOp(RRpl, w, h, 0, 0, ww, p, amt, 0, ww, p);
         y := y-amt;
         x := x+amt;
         end;
    East:  begin
           if (x+w+amt > 768) then exit(MoveOne);
           RasterOp(RRpl, amt, h, w, 0, ww, p, x+w, y, SScreenW, SScreenP);
           RasterOp(RRpl, w, h, x+amt, y, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
           RasterOp(RRpl, amt, h, x, y, SScreenW, SScreenP, 0, 0, ww, p);
           RasterOp(RRpl, w, h, 0, 0, ww, p, amt, 0, ww, p);
           x := x+amt;
           end;
    SouthEast: begin
         if (y + h + amt > 1024) or (x+w+amt > 768) then exit(MoveOne);
         RasterOp(RRpl, w+amt, amt, 0, h, ww, p, x, y+h, SScreenW, SScreenP);
         RasterOp(RRpl, amt,h+amt, w, 0, ww, p, x+w,y, SScreenW, SScreenP);
         RasterOp(RRpl, w, h, x+amt, y+amt, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
         RasterOp(RRpl, amt, h, x, y, SScreenW, SScreenP, 0, 0, ww, p);
         RasterOp(RRpl, w, amt, x, y, SScreenW, SScreenP, 0, 0, ww, p);
         RasterOp(RRpl, w, h, 0, 0, ww, p, amt, amt, ww, p);
         y := y+amt;
         x := x+amt;
         end;
    South: begin
           if (y + h + amt > 1024) then exit(MoveOne);
           RasterOp(RRpl, w, amt, 0, h, ww, p, x, y+h, SScreenW, SScreenP);
           RasterOp(RRpl, w, h, x, y+amt, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
           RasterOp(RRpl, w, amt, x, y, SScreenW, SScreenP, 0, 0, ww, p);
           RasterOp(RRpl, w, h, 0, 0, ww, p, 0, amt, ww, p);
           y := y+amt;
           end;
    SouthWest: begin
         if (y + h + amt > 1024) or (x - amt  < 0) then exit(MoveOne);
         RasterOp(RRpl, w, h, amt, 0, ww, p, 0, 0, ww, p);
         RasterOp(RRpl, w+amt, amt, 0, h, ww, p, x-amt, y+h,SScreenW,SScreenP);
         RasterOp(RRpl, amt, h+amt, 0, 0, ww, p, x-amt, y, SScreenW, SScreenP);
         RasterOp(RRpl, w, h, x-amt, y+amt, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
         RasterOp(RRpl, amt, h, x+w-amt, y, SScreenW, SScreenP, w, 0, ww, p);
         RasterOp(RRpl, w, amt, x, y, SScreenW, SScreenP, amt, 0, ww, p);
         RasterOp(RRpl, w, h, 0, 0, ww, p, 0, amt, ww, p);
         y := y+amt;
         x := x-amt;
         end;
    West:  begin
           if (x - amt  < 0) then exit(MoveOne);
           RasterOp(RRpl, w, h, amt, 0, ww, p, 0, 0, ww, p);
           RasterOp(RRpl, amt, h, 0, 0, ww, p, x-amt, y, SScreenW, SScreenP);
           RasterOp(RRpl, w, h, x-amt, y, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
           RasterOp(RRpl, amt, h, x+w-amt, y, SScreenW, SScreenP, w, 0, ww, p);
           x := x-amt;
           end;
    NorthWest: begin
         if (y - amt < 0) or (x - amt  < 0) then exit(MoveOne);
         RasterOp(RRpl, w, h, amt, amt, ww, p, 0, 0, ww, p);
         RasterOp(RRpl, w+amt,amt,0, 0, ww, p, x-amt, y-amt,SScreenW,SScreenP);
         RasterOp(RRpl, amt, h+amt,0,0,ww, p, x-amt, y-amt, SScreenW,SScreenP);
         RasterOp(RRpl, w, h, x-amt, y-amt, SScreenW, SScreenP,
                                x, y, SScreenW, SScreenP);
         RasterOp(RRpl, amt, h, x+w-amt, y, SScreenW, SScreenP, w, amt, ww, p);
         RasterOp(RRpl, w, amt, x,y+h-amt, SScreenW, SScreenP, amt, h, ww, p);
         y := y-amt;
         x := x-amt;
         end;
    otherwise : Raise Impossible;
    end;
  end;

Procedure SlideArea(var x1,y1: integer; x2,y2, step, w, h: integer;
                    stopOnPress: boolean);
   var x,y,t,dx,dy,d,e,f,xstep,ystep: integer;
       dir : Direction;
   begin
   x := x1; y := y1;
   
   dx := x2-x1;  dy := y2-y1;
   
   if dx >= 0 then xstep := 3 {east}
   else begin
        xStep := 1;  {west}
        dx := -dx;
        end;
   if dy >= 0 then ystep := 4 {south}
   else begin
        yStep := 12;  {north}
        dy := -dy;
        end;
   
   t := dy;
   d := dy-dx;
   f := dx+dy;
   if d >= 0 then begin
                  t := dx;
                  d := dx-dy;
                  end;
   e := 0;
   
   {loop}
   
   while f > 0 do
     begin
     f := f-step;
     if d+e+e+t >= 0 then
        begin
        f := f-step;
        e := d+e;
        dir := RECAST(LOr(yStep, xStep), Direction);
        end
     else begin
          e := e+t;
          if dx >= dy then dir := RECAST(xStep, Direction)
          else dir := RECAST(yStep, Direction);
          end;
     MoveOne(step,x1,y1,w,h,dir);
     if tabSwitch and StopOnPress then Exit(SlideArea);
     end;
   end;

Procedure MoveAroundWin(amt: integer);
  var tabx, taby: integer;
      c: char;
      leave : boolean;
      win: WinRange;
  begin
  if IOPriv1Unused = false then
     begin
     Write('Window to move? ');
     ReadLn(win);
     SaveAndRestoreWindow(win, 'Moving window');
     end
  else win := RECAST(IOPriv2Unused, WinRange);

  if win = 0 then begin
                  WriteLn('** Can''t move window 0');
                  exit(Slider2);
                  end;

  IOSetModeTablet(relTablet);
  IOCursorMode(trackCursor);

  ChangeWindow(0);
  WriteLn('Press where to move window to (any key to exit)');
  ChangeWindow(win);
  XSGetFullWindow(Win, x, y, w, h);
  repeat
    repeat
       if IOCRead(transKey, c) = 1 then exit(Slider2);
    until tabswitch;
    IOReadTablet(tabx,taby);
    SlideArea(x,y,tabx,taby,amt,w,h, true);
  until false;
  end;

    
begin
auto := false;
NextArgStr(str);  {flush "Slider2"}
if ArgCount = 0 then amt := 2
else if ArgCount = 1 then NextArgInt(amt)
else if ArgCount = 3 then
      begin
      NextArgInt(Amt);
      NextArgInt(DestX);
      NextArgInt(DestY);
      auto := true;
      end
else begin
       Writeln('** Usage: slider2 [Amount [destx desty]]');
       Exit(Slider2);
       end;

if not auto then
     begin
     MoveAroundWin(amt);
     ChangeWindow(0);
     XSSetWindowParms(win,x,y,w,h);
     end
else begin
     if IOPriv1Unused = FALSE then 
        begin
        WriteLn('** No window saved!');
        exit(Slider2);
        end;
     win := RECAST(IOPriv2Unused, WinRange);
     if win = 0 then begin
                     WriteLn('** Can''t move window 0');
                     exit(Slider2);
                     end;
     ChangeWindow(win);
     XSGetFullWindow(win, x, y, w,h);
     SlideArea(x,y,destx, desty, amt, w, h, false);
     ChangeWindow(0);
     XSSetWindowParms(win,x,y,w,h);
     end;

end.

(*******
Procedure MoveAroundWin(win: WinRange; amt: integer);
  var x,y,w,h, tabx, taby, oldtabx, oldtaby: integer;
      c: char;
  begin
  ChangeWindow(win);
  GetFullWindow(Win, x, y, w, h);
  ChangeWindow(1);
  write('Direction (DEL to exit): ');
  SCurOn;
  repeat
    repeat until IOCRead(Transkey,c) = 1;
    write(c);
    case c of
      '1': MoveOne(amt, x,y,w,h,northeast);
      '2': MoveOne(amt, x,y,w,h,east);
      '3': MoveOne(amt, x,y,w,h,southeast);
      '4': MoveOne(amt, x,y,w,h,south);
      '5': MoveOne(amt, x,y,w,h,southwest);
      '6': MoveOne(amt, x,y,w,h,west);
      '7': MoveOne(amt, x,y,w,h,northwest);
      '8': MoveOne(amt, x,y,w,h,north);
      DEL : Exit(MoveAroundWin);
     end;
  until false;
  end;
******)

CreateWindow(1, 0, 600, 700, 300,'main');
ChangeWindow(0);
for i := 1 to 200 do Write('This is a lot of garbage.  ');
RefreshWindow(1);
ChangeWindow(1);
Write(FF);


Function GetTBit(y,x: integer; p: CurPatPtr): boolean;
   var hack: record case boolean of
               true: (w: integer);
               false: (b: packed array [0..15] of boolean);
              end;
   begin
   hack.w := p^[y, x div 16];
   GetTBit := hack.b[(15-(x mod 16))];
   end;

function Sqrt( X: Integer ): Integer;
  var V, I: integer;
  begin { Sqrt }
    V := 0;
    I := 128;
    while I <> 0 do
      begin
        if (V + I <= 180) and ((V + I) * (V + I) <= X) then V := V + I;
        I := I div 2
      end;
    Sqrt := V
  end { Sqrt };

Procedure MakeCircle(* yBase, xBase, maxW, maxH: integer; curMode: Funct;
                   Procedure CursPt(y,x: integer; mode: Funct)
                    *);
  var r, oldR, x, y, x1, y1,i,j, diameter, tabx, taby, maxR: integer;
      circleP : CurPatPtr;
      got: boolean;
  begin
  Write('ircle:  Specify center');
  while not tabswitch do;
  IOReadTablet(tabx, taby);
  y := ((taby-yBase) div 8);
  x := ((tabx-xBase) div 8);
  if (tabx >= xBase) and (taby >= yBase) and (tabx < xBase+maxW) and
             (taby < yBase+maxH) then {nothing}
    else begin
         Write('  XXX');
         exit(MakeCircle);
         end;
  x1 := x;
  y1 := y;
  CursPt(y1,x1, Toggle);
  Write('  specify radius');
  oldR := 0;
  if x1 < (maxW div 8) - x1 then x := x1 else x := (maxW div 8) - x1;
  if y1 < (maxH div 8) - y1 then y := y1 else y := (maxH div 8) - y1;
  if x < y then maxR := x+1 else maxR := y+1;
  while TabSwitch do; {wait for it to go off}
  repeat
       IOReadTablet(tabx, taby);
       y := (taby-yBase) div 8;
       x := (tabx-xBase) div 8;
       if (tabx >= xBase) and (taby >= yBase) and (tabx <= xBase+maxW) and
             (taby <= yBase+maxH) then 
                begin
                got := true;
                if Abs(x-x1) > Abs(y-y1) then r := Abs(x1-x)
                else r := Abs(y1-y);
                if r > maxR then r := maxR;
                if r < 2 then r := 0;
  {r is new radius; x1, y1 is center; oldR is last radius}
                if (r <> oldR) then
                       begin
                       if oldR <> 0 then
                         DoLineBox(x1-oldR+1,y1-oldR+1,           {erase old}
                                   x1+oldR-1,y1+oldR-1,xBase,yBase);
                       oldR := r;
                       if oldR <> 0 then
                         DoLineBox(x1-oldR+1,y1-oldR+1,           {draw new}
                                   x1+oldR-1,y1+oldR-1,xBase,yBase);
                       end;
                end
       else got := false;
       if tabswitch and not got then Write(Beep);
    until got and tabswitch;
  if oldR <> 0 then DoLineBox(x1-oldR+1,y1-oldR+1,
                              x1+oldR-1,y1+oldR-1,xBase,yBase); {erase old}
  CursPt(y1,x1, Toggle);
  Write('  done, radius is ',r:1);
  
{create circle with correct radius }
  diameter := r * 2;
  New(0,4, circleP);
  RasterOp(RXor, 64,64, 0, 0, 4, circleP, 0, 0, 4, circleP); {Clear out buffer}
    for I := 1 to r-1 do
      begin
        J := Sqrt((r-1)*(r-1) - I*I);
        RasterOp(RXNor, 2*I+1, 2*J+1, (x1-r)+r-I, (y1-r)+r-J, 4, circleP,
                                      (x1-r)+r-i, (y1-r)+r-j, 4, circleP);
        RasterOp(RXNor, 2*J+1, 2*I+1, (x1-r)+r-j, (y1-r)+r-i, 4, circleP,
                                      (x1-r)+r-j, (y1-r)+r-i, 4, circleP)
      end;
  
{merge circle into picture}
  for x := 0 to maxW div 8 do
    for y := 0 to maxH div 8 do
      if GetTBit(y,x,circleP) then
         CursPt(y,x,curMode);

  Dispose(circleP);
  end.
  
  procedure Initialize;
  var I, J: Integer;
  begin { Initialize }
    New(0,4,BallPat);
    RasterOp(RXor, Diameter+1, Diameter+1, 0, 0, 4, BallPat, 0, 0, 4, BallPat);
    for I := 1 to RadMinus1 do
      begin
        J := Sqrt(RadMinus1*RadMinus1 - I*I);
        RasterOp(RXNor, 2*I+1, 2*J+1, Radius-I, Radius-J, 4, BallPat,
                                      Radius-I, Radius-J, 4, BallPat);
        RasterOp(RXNor, 2*J+1, 2*I+1, Radius-J, Radius-I, 4, BallPat,
                                      Radius-J, Radius-I, 4, BallPat)
      end;

><><><><><><><><><>
  
