program WriteIt;

{Written By Brad A. Myers: 27-Jul-81;

Copyright (c) Three Rivers Computer Corporation, 1980
}

imports FastRandom from FastRandom;
imports XScreen from XScreen;
imports FileUtils from FileUtils;
imports SigUtils from SigUtils;
imports PERQ_String from PERQ_String;
imports SaveWindow from SaveWindow;
Imports System from System;
Imports CmdParse from CmdParse;
Imports Memory from Memory;

Const MaxFonts = 20;


var str: String;
    t, numTimes, i, j, numFonts, f, ital, bold, x, y, funct: Integer;
    winX, winY, winH, winW, w, h: integer;
    win: WinRange;
    erase, save: boolean;
    curFont: FontPtr;
    standardFont: FontPtr;
    Brkchr: CString;
    kstfile: TEXT;
    
    fontAr : ARRAY[0..MaxFonts] of 
               record
                  dir: XSDirection;
                  f: FontPtr;
               End;
    
Handler CursOutSide;
Begin
End;

Procedure SetNotSwap(f: FontPtr);
  var hack: record case boolean of
             true: (f: FontPtr);
             false: (seg, ofst: integer);
             end;
  begin
  hack.f := f;
  SetMobility(hack.seg, UnSwappable);
  end;

Procedure GetFonts;
   var fn: PathName;
   begin
   FontAr[0].f := StandardFont;
   FontAr[0].dir := LeftToRight;
   numFonts := 1;
   while NOT eof(kstfile) do
      begin
        Readln(kstfile, fn);
        FontAr[numFonts].f := XSLoadFont(fn);
        SetNotSwap(FontAr[numFonts].f);
        if (fn = 'HBRW35.KST') or (fn = 'ARAB45.KST') then
               FontAr[numFonts].dir := RightToLeft
        else FontAr[numFonts].dir := LeftToRight;
        numFonts := numFonts+1;
      end;
   WriteLn('Found ',numFonts:1,' fonts');
   end;

Function StringWidth(s: String): integer;
   var i,w:integer;
   begin
   w := 0;
   for i := 1 to length(s) do
     w := w + curFont^.Index[ord(s[i])].width;
   StringWidth := w;
   end;

begin

StandardFont := GetFont;

If ArgCount < 7 then
     begin
     WriteLn('** Usage: WriteIt win# save numTimes erase text');
     exit(WriteIt);
     end;

NextArgStr(str); {flush "WriteIt"}

NextArgInt(t);
win := t;
NextArgInt(t);
save := Recast(t, Boolean);
NextArgInt(numTimes);
NextArgInt(t);
erase := Recast(t, Boolean);
NextArgStr(str);  {file name with KST list}
Reset(kstfile, str);
RemDelimiters(UsrCmdLine, ' ',str);
str := UsrCmdLine;

GetFonts;
XScreenInit;

XSChangeWindow(win);
XSSetFont(standardFont);
XSGetUseWindow(win, winX, winY, winW, winH);

if save then SaveAndRestoreWindow(win, str)
else XSRedrawWindow(win, str);

SetUpRandom;

if erase then Write(FF);

for i := 1 to numTimes do
   begin
   f := RandomRange(0, numfonts-1);

   ital := RandomRange(0, 1);
   bold := RandomRange(0, 1);
   
(*
   funct := RandomRange(0, 7);
*) funct := RRpl;
   
   curFont := fontAr[f].f;
   
   XSSetFont(curFont);
   XSSetItalic(RECAST(ital, boolean));
   XSSetBold(RECAST(bold, boolean));
   SChrFunc(funct);
   
   XSSetDirection(fontAr[f].dir);
   
   w := StringWidth(str);
   h := curFont^.height;
   
   if fontAr[f].dir = RightToLeft then
        x := RandomRange(winX+w+roll, winX+winW)
   else x := RandomRange(winX, winX+winW-w-roll);

   y := RandomRange(winY+h, winY+winH-1);
   
   SSetCursor(x,y);
   for j := 1 to length(str) do
     XSPutChr(str[j]);
   end;

XSSetFont(standardFont);
end.

