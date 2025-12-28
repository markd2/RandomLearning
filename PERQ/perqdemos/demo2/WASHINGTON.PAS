Program WipeWin;

Imports Raster from Raster;
Imports Memory from Memory;
Imports SigUtils from SigUtils;
Imports Screen from Screen;
Imports System from System;
Imports Sleep from Sleep;
Imports CmdParse from CmdParse;

const MaskWidth=640;
      MaskHeight=400;
      MaskSLines=(MaskWidth div 16);

type  WipeArray=packed array [1..MaskHeight, 1..MaskWidth] of boolean;
      pWipeArray=^Wipearray;
      
var   WipeMask: pWipeArray;
      FileName, Style: string;
      Width, Height: integer;
      PicWidth, PicHeight: integer;
      X, Y: integer;
      MinX, MinY, MaxX, MaxY: integer;{ window dimensions }
      WinNum: integer;
      Dum: boolean;
      Title: string;
      ClearFlag: boolean;

{ Left-to-right wipe }
Procedure LWipe(X, Y, W, H: integer);
  var i: integer;
  begin
  for i := 1 to W do
    begin
    RasterOp(RRpl, i, H,
     X, Y, 48, MakePtr(ScreenSeg, 0, RasterPtr),
     0, 0, MaskSLines, Recast(WipeMask, RasterPtr));
    end;
  end;

{ Top-to-bottom wipe }
Procedure TWipe(X, Y, W, H: integer);
  var i: integer;
  begin
  for i := 1 to H do
    begin
    RasterOp(RRpl, W, i,
     X, Y, 48, MakePtr(ScreenSeg, 0, RasterPtr),
     0, 0, MaskSLines, Recast(WipeMask, RasterPtr));
    end;
  end;

{ Right-to-left wipe }
Procedure RWipe(X, Y, W, H: integer);
  var i: integer;
  begin
  for i := 1 to W do
    begin
    RasterOp(RRpl, i, H,
     X + (W - i), Y, 48, MakePtr(ScreenSeg, 0, RasterPtr),
     0 + (W - i), 0, MaskSLines, Recast(WipeMask, RasterPtr));
    end;
  end;

{ Bottom-to-top wipe }
Procedure BWipe(X, Y, W, H: integer);
  var i: integer;
  begin
  for i := 1 to H do
    begin
    RasterOp(RRpl, W, i,
     X, Y + (H - i), 48, MakePtr(ScreenSeg, 0, RasterPtr),
     0, 0 + (H - i), MaskSLines, Recast(WipeMask, RasterPtr));
    end;
  end;

{ Horizontal Center-out wipe }
Procedure HOutWipe(X, Y, W, H: integer);
  var i, CtrX: integer;
  begin
  CtrX := X + (W div 2);
  for i := 1 to (W div 2) do
    begin
    RasterOp(RRpl, i * 2, H,
     CtrX - i, Y, 48, MakePtr(ScreenSeg, 0, RasterPtr),
     (W div 2) - i, 0, MaskSLines, Recast(WipeMask, RasterPtr));
    end;
  end;

{ Vertical Center-out wipe }
Procedure VOutWipe(X, Y, W, H: integer);
  var i, CtrY: integer;
  begin
  CtrY := Y + (H div 2);
  for i := 1 to (H div 2) do
    begin
    RasterOp(RRpl, W, i * 2,
     X, CtrY - i, 48, MakePtr(ScreenSeg, 0, RasterPtr),
     0, (H div 2) - i, MaskSLines, Recast(WipeMask, RasterPtr));
    end;
  end;

{ Simultaneous vert. and horiz. Center-out wipe }
Procedure HVOutWipe(X, Y, W, H: integer);
  var i, CtrX, CtrY: integer;
      MaxWH, width, height: integer;
  begin
  CtrX := X + (W div 2);
  CtrY := Y + (H div 2);
  if W > H then MaxWH := W else MaxWH := H;
  for i := 1 to (W div 2) do
    begin
    width := i * 2;
    height := width;
    if width > W then width := W;
    if height > H then height := H;
    RasterOp(RRpl, width, height,
     CtrX - (width div 2), CtrY - (height div 2),
     48, MakePtr(ScreenSeg, 0, RasterPtr),
     (W - width) div 2, (H - height) div 2,
     MaskSLines, Recast(WipeMask, RasterPtr));
    end;
  end;

Procedure PrseCmds;
  var Str, Broke: string;
      ArgC, dum: integer;
  begin
  ArgC := ArgCount(UsrCmdLine);
  WinNum := 0;
  FileName := 'WASHDC.PIC';
  if ArgC = 2 then 
      NextArgStr(UsrCmdLine, Style)
  else
      Style := 'H';
  ClearFlag := false;
  { Force the first letter of Style to upper case }
  Title := '  ';

  { Calculate the size of the window }
  ChangeWindow(Recast(WinNum, WinRange));
  GetUseWindow(Recast(WinNum,WinRange), MinX, MinY, Width, Height);
  MaxX := MinX + Width - 1;
  MaxY := MinY + Height - 1;
  end;

begin
Reset(Input);
Rewrite(Output);
prsecmds;
New(0, 4, WipeMask);
write(chr(#14));

if GetPicture(FileName, 0, 0, PicWidth, PicHeight,
     MaskSlines, Recast(WipeMask, RasterPtr)) then
  begin
  X := MinX; Y := MinY;
  if PicWidth >= Width then PicWidth := Width
    else  X := MinX + ((Width - PicWidth) div 2);
  if PicHeight >= Height then PicHeight := Height
    else  Y := MinY + ((Height - PicHeight) div 2);
  RedrawWindow(WinNum, Title);
  if ClearFlag then
    Write(Chr(#14));

  { It looks better with a slight pause here }
  Nap(30);
  case Style[1] of
    'T':  TWipe(X, Y, PicWidth, PicHeight);
    'B':  BWipe(X, Y, PicWidth, PicHeight);
    'R':  RWipe(X, Y, PicWidth, PicHeight);
    'L':  LWipe(X, Y, PicWidth, PicHeight);
    'O':  HVOutWipe(X, Y, PicWidth, PicHeight);
    'H':  HOutWipe(X, Y, PicWidth, PicHeight);
    'V':  VOutWipe(X, Y, PicWidth, PicHeight);
    otherwise:  LWipe(X, Y, PicWidth, PicHeight);
    end;
  end;
end.

