Module XScreen;
{----------------------------------------------------------------------------
 Abstract: Displays a font normally, as fake bold or as fake italic
 
 Written by Brad A. Myers  June 23, 1981
 
 Copyright (C) 1981 - The Three Rivers Computer Corporation
----------------------------------------------------------------------------}

{----------------------------------------------------------------------------
 Change History:
     14 Jul 81  Brad Myers  V2.1  Added cursor to rightToLeft
      7 Jul 81  Brad Myers  V2.0  Changed name to XScreen
                                  Added direction
     23 Jun 81  Brad Myers  V1.0  Started
----------------------------------------------------------------------------}

{///////////////////////} EXPORTS {\\\\\\\\\\\\\\\\\\\\\\\\\\\}

Imports Screen from Screen;

Type XSDirection = (LeftToRight, RightToLeft);

Procedure XSPutChr(ch: Char);
Procedure XSSetBold(bold: boolean);
Procedure XSSetItalic(italic: boolean);
Procedure XSSetDirection(newD: XSDirection);
Procedure XSGetFontParams(var f: FontPtr; var bold, italic: boolean;
                          var dir: XSDirection);
Procedure XSClearChar(ch: Char);
Procedure XSSetFont(NewFont: FontPtr);
Function XSLoadFont(FontName: String): FontPtr;
Procedure XSDestroyFont(var f: FontPtr);
Procedure XSChangeWindow(WIndx: WinRange);
Procedure XSCurChr(c: Char);
Procedure XSCurOn;
Procedure XSCurOff;

Procedure XScreenInit;
Procedure XScreenReset;

{ New procedures not provided by Screen }
Procedure XSGetUseWindow(var WIndx: WinRange;
                            var X, Y, Width, Height: integer);
Procedure XSGetFullWindow(var WIndx:
                            WinRange; var X, Y, Width, Height: integer);
Procedure XSRedrawWindow(WIndx: integer; Title: string);

Procedure XSSetWindowParms(windx: WinRange; x,y,w,h: Integer);

var Roll: Integer;

{///////////////////////} PRIVATE {\\\\\\\\\\\\\\\\\\\\\\\\\\\\}


imports Memory from Memory;
Imports FileUtils from FileUtils;
Imports MultiRead from MultiRead;

Type CharBuffer = Array[0..51,0..3] of integer;

var fbold, fitalic: boolean;
    fontHeight: integer;
    fnt : FontPtr;
    fDir: XSDirection;
    XCrsChr: char;
    cursorOn: boolean;
    
    HomeX, homeY, width, height, rightX: integer;
    
    charBuf: ^CharBuffer;
    
    
Const FF = Chr(12);
      LF = Chr(10);
      CR = Chr(13);
      Bell = Chr(7);
    
Procedure XToggleCursor;
   var curX, curY: integer;
       trik: record case boolean of
                 true: (f: FontPtr);
                 false: (seg, ofst: integer);
                 end;
   begin
   SReadCursor(curx, curY);
   with fnt^.Index[ord(XCrsChr)] do
     if CurX-Width > HomeX then {only show if will fit on the current line}
       with trik do
         begin
         F := fnt;
         RasterOp(RXor,Width,fnt^.height,curX-width-1,curY-fnt^.Base, SScreenW,
                       SScreenP, Offset, Line*fnt^.Height,
                       SScreenW, MakePtr(Seg,Ofst+#404,FontPtr));
         end;
   end;

Procedure DoToggle;
   begin
   if (fDir = RightToLeft) then XToggleCursor
   else ToggleCursor;
   end;

Procedure XSCurOn;
   begin
   SCurOff;
   if not cursorOn then DoToggle;
   cursorOn := true;
   end;

Procedure XSCurOff;
   begin
   SCurOff;
   if cursorOn then DoToggle;
   cursorOn := false;
   end;

Procedure XSCurChr(c: Char);
   begin
   if cursorOn then DoToggle;
   XCrsChr := c;
   SCurChr(c);
   if cursorOn then DoToggle;
   end;

Procedure XScreenReset;
  var hasTitle, turnOnCursor: boolean;
      WIndx: WinRange;
   begin
   cursorOn := false;
   turnOnCursor := SCursorOn;
   XSSetBold(false);
   XSSetItalic(false);
   fdir := leftToRight;
   SCurOff;
   XSSetFont(GetFont);
   XSCurChr('_');
   if turnOnCursor then XSCurOn;
   end;

Procedure XScreenInit;
  begin
  NEW(0,4,charBuf);
  XSChangeWindow(0);  {does a reset}
  end;

Procedure XSSetBold(bold: boolean);
  begin
  if fbold <> bold then
     begin
     fbold := bold;
     if fbold then roll := roll+1
     else roll := roll-1;
     end;
  end;
Procedure XSSetItalic(italic: boolean);
  begin
  fitalic := italic;
  if fitalic then roll := (FontHeight+2) div 3
  else roll := 0;
  if fbold then roll := roll+1;
  end;
Procedure XSSetDirection(newD: XSDirection);
  begin
  if newD = fDir then exit(XSSetDirection);
  if cursorOn then DoToggle;
  fDir := newD;
  if cursorOn then DoToggle;
  end;

Procedure XSGetFontParams(var f: FontPtr; var bold, italic: boolean;
                          var dir: XSDirection);
  begin
  f := fnt;
  bold := fBold;
  italic := fItalic;
  dir := fDir;
  end;

Procedure XSSetFont(NewFont: FontPtr);
   begin
   FontHeight := NewFont^.Height;
   fnt := NewFont;
   if fitalic then roll := (FontHeight+2) div 3
   else roll := 0;
   if fbold then roll := roll+1;
   if cursorOn then DoToggle;
   SetFont(NewFont);
   if cursorOn then DoToggle;
   end;

Function XSLoadFont(FontName: String): FontPtr;
   var fid: FileID;
       seg, blks, bits: Integer;
   begin
   fid := FSExtSearch(FSSysSearchList, ' .KST ',fontName, blks, bits);
   if fid = 0 then begin
                   XSLoadFont := NIL;
                   Exit(XSLoadFont);
                   end;
   CreateSegment(seg, blks, 1, blks);
   XSLoadFont := MakePtr(seg, 0, FontPtr);
   MultiRead(fid, MakePtr(seg,0,pDirBlk), 0, blks);
   end;

Procedure XSDestroyFont(var f: FontPtr);
   var fakePtr: Record case boolean of
                  true: (f: FontPtr);
                  false: (seg, ofst: integer);
                  end;
   begin
   fakePtr.f := f;
   DecRefCount(fakePtr.seg);
   f := NIL;
   end;

Procedure XSChangeWindow(WIndx: WinRange);
  var hasTitle: boolean;
  begin
  ChangeWindow(WIndx);
  GetWindowParms(Windx, HomeX, HomeY, Width, Height, hasTitle);
  RightX := HomeX+Width-3;
  HomeX := HomeX + 3;
  XScreenReset;
  end;
  
Procedure IPutChr(ch: Char);
   var trik: record case boolean of
                 true: (f: FontPtr);
                 false: (seg, ofst: integer);
                 end;
       w, indent,i,x,y: integer;
   begin
   SReadCursor(x,y);
   with fnt^.Index[ord(ch)] do
        begin
        w := width;
        if (x+W+roll) > rightX then begin
                                    NewLine;
                                    SReadCursor(x,y);
                                    SSetCursor(HomeX,y);
                                    x := HomeX;
                                    end;
        with trik do
          begin
          F := fnt;
          RasterOp(RRpl,W,fontHeight,0,0,4,charBuf,
                       Offset, Line*fontHeight,
                       SScreenW, MakePtr(Seg,Ofst+#404,FontPtr));
          end;
        end;
   indent := 0;
   for i := 0 to fontHeight-1 do
       begin
       if (i+1) mod 3 = 0 then indent := indent +1;
       RasterOp(SFunc, w, 1, x+indent, y-fnt^.base+fontHeight-i-1, SScreenW,
                 SScreenP, 0, fontHeight-i-1, 4, charBuf);
       end;
   SSetCursor(x+w,y);
   end;

{if dir is rightToLeft then SReadCursor returns the right edge of where
the character goes}

Procedure XSPutChr(ch: Char);
   var x,y, w, endx, endy, i: integer;
   label 1;
   begin
   if cursorOn then DoToggle;
   if (not (fbold or fitalic)) and (fDir = LeftToRight) then
     begin
     SPutChr(ch);
     if cursorOn then DoToggle;
     exit(XSPutChr);
     end;
   SReadCursor(x,y);
   case ch of
     FF : begin
          SPutChr(ch);
          if fDir = RightToLeft then SSetCursor(rightX, homeY);
          goto 1;
          end;
     Bell, LF: begin
               SPutChr(ch);
               goto 1;
               end;
     CR : begin
          if fDir = RightToLeft then SSetCursor(rightX-roll, y)
          else SPutChr(ch);
          goto 1;
          end;
     end;       
   ch := Chr(LAnd(ord(ch),#177));
   w := fnt^.Index[ord(ch)].width;
   if w = 0 then goto 1;
   if fDir = RightToLeft then 
      begin
      if x-w-roll < homeX then begin
                               SPutChr(LF);
                               SReadCursor(x,y);
                               x := rightX-w-roll;
                               end
      else x := x-w;
      SSetCursor(x,y);
      endx := x;
      endy := y;
      end;
 { x is the left of the character;  endx is the value to set x to when exit }
   if fitalic then IPutChr(ch)
   else SPutChr(ch);
   if fdir = LeftToRight then 
       begin
       SReadCursor(endx, endy);
       x := endx-w;
       end;
   y := endy;
   if fbold then begin
                 SChrFunc(ROr);
                 SSetCursor(x+1,y);
                 roll := roll-1;  {second character doesn't need bold roll}
                 if fItalic then IPutChr(ch)
                 else SPutChr(ch);
                 roll := roll+1;
                 SChrFunc(RRpl);
                 end;
   SSetCursor(endx, endy);
 1: if CursorOn then DoToggle;
   end;
   
Procedure XSClearChar(ch:Char);
   var x,y, endx, endy: integer;
  begin
   SClearChar(ch, RAndNot);
  (*****NIY******)
  end;
  

Procedure XSGetUseWindow(var WIndx: WinRange; var X, Y, Width, Height: integer);
{----------------------------------------------------------------------------
  Abstract:
     Get the specifications of the inside of the current window.
  NOTE:
     This only works if the window was created with the standard font in
     effect (i.e. the title line written with the standard font);
  Parameters:
     Windx - is set to the current window number
     X, Y - are set to the upper left corner of the inside of the current
             window
     Width, Height - are set to the width and height of the inside
--------------------------------------------------------------------------}
  var HasTitle: Boolean;
  begin
  GetWindowParms(WIndx, X, Y, Width, Height, HasTitle);
  X := X+1;
  Width := Width - 2;
  if HasTitle then begin
                   y := y+1;
                   height := height-1;
                   end;
  end;


Procedure XSGetFullWindow(var WIndx: WinRange; var X, Y, Width, Height: integer);
{----------------------------------------------------------------------------
  Abstract:
     Get the specifications of the outside of the current window.
  NOTE:
     This only works if the window was created with the standard font in
     effect (i.e. the title line written with the standard font);
  Parameters:
     Windx - is set to the current window number
     X, Y - are set to the upper left corner of the outside of the current
             window.  (One bit from the lines since the there is a one bit
             border).
     Width, Height - are set to the width and height of the outside
--------------------------------------------------------------------------}
  var HasTitle: Boolean;
  begin
  GetWindowParms(WIndx, X, Y, Width, Height, HasTitle);
    X := X - 2;
    Width := Width + 5;
    Y := Y - 2;
    Height := Height + 5;
    if HasTitle then
      begin
      Y := Y - 15;  
      Height := Height + 15;
      end;
  end;


Procedure XSRedrawWindow(WIndx: integer; Title: string);
{----------------------------------------------------------------------------
  Abstract:
     Changes to the window specified, refreshes the border and types the
         title specified if non-null
  Parameters:
     Windx - window number to set to
     Title - the new title for the window
--------------------------------------------------------------------------}
  var minx, miny, maxx, maxy: integer;
      Scrn: RasterPtr;
  begin
  ChangeWindow(Windx);
  RefreshWindow(WIndx);
  if Length(Title) > 0 then ChangeTitle(Title);
  end;


Procedure XSSetWindowParms(windx: WinRange; x,y,w,h: Integer);
{----------------------------------------------------------------------------
  Abstract:
     Changes the remembered position of a window to the new parameters.
  WARNING:
     THIS WILL NOT WORK FOR THE CURRENT WINDOW (i.e. windx must NOT be the
        current window).
  NOTE:
     This only works if the window was created with the standard font in
     effect (i.e. the title line written with the standard font);
  Parameters:
     Windx - window number to modify area of
     x,y are new positions of the window based on the values returned by
         XSGetFullWindow
     w,h are the width and height of the window.  They should not have been
         changed since the values were returned
--------------------------------------------------------------------------}
  Const Indent = 5;
  begin
(*
  X := X + 2;
  W := W - 5;
  Y := Y + 2;
  H := H - 5;
  With WinTable[windx] do
     begin

     if winHasTitle then
         begin
         Y := Y + 15;  
         H := H - 15;
         end;

     winLX := X;
     winTY := Y;
     winRX := winLX+w;
     winBY := winTY+h;
     
     winHX := winLX+2;
     winHY := winTY+2;
     winMX := winRX-2;
     winMY := winBY-2;
     
     end; 
*)
     
  end.

  
{---------DEBUG---------}

var c: char;
    s: string[255];
    i: integer;
    
imports IO_Unit from IO_Unit;

{$R-}
const Ctrlb = chr(2);
      Ctrle = chr(5);
      CtrlG = chr(7);
      Ctrli = chr(9);
      Ctrln = chr(14);
      Ctrlk = chr(11);
      BS    = chr(8);
      CtrlD = chr(4);
      CtrlU = chr(21);
      
      
begin

XScreenInit;

write('small window? [n] ');
readln(s);
if s = 'y' then begin
                 CreateWindow(1, 100, 100, 300, 300, 'Test');
                 XSChangeWindow(1);
                 end;

Write('Go: ');

XSSetBold(true);
XSCurOn;

s:= '';
repeat
  repeat until IOCRead(Transkey,c) = IOEIOC;
  if c = ctrlb then XSSetBold(true)
  else if c = ctrld then XSSetDirection(RightToLeft)
  else if c = ctrli then XSSetItalic(true)
  else if c = ctrln then begin
                         XSSetBold(false);
                         XSSetItalic(false);
                         XSSetDirection(LeftToRight);
                         end
  else if (c = BS) then
         if (length(s) > 0) then begin
              XSClearChar(s[length(s)]);
              s[0] := chr(length(s)-1);
              end
         else Write(ctrlG)
  else if (c = CtrlU) then
         begin
         for i := length(s) downto 1 do
           XSClearChar(s[i]);
         s[0] := chr(0);
         end
  else begin
       XSPutChr(c);
       if c = CR then s[0] := chr(0)
       else s[0] := chr(length(s)+1);
       s[length(s)] := c;
       end;
  until false;
end.




