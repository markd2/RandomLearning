Program PicPuzzle;
{* Peter's Picture Puzzle *}
{* Copyright (c) 1981 Peter H. Feiler *}

Imports Raster from Raster;
Imports Memory from Memory;
Imports Screen from Screen;
Imports System from System;
Imports CmdParse from CmdParse;
Imports IO from IO;
imports ioerrors from ioerrors;
imports randomnumbers from randomnumbers;
imports gettimestamp from gettimestamp;
imports FileSystem from FileSystem;
imports perq_string from Perq_string;
imports rs232baud from rs232baud;


const debug = false;

var   
      FileName: string;
      PicX, PicY: integer;      { size of picture }
      TopX, TopY: integer;      { top left corner of picture }
      OrgX,OrgY: integer;            { original picture coord }
      NumX, NumY: integer;      { number of elements (palettes) in picture }
      PalX, PalY: integer;      { size of one palette in picture }
      HoleXidx, HoleYidx: integer; { idx coord of missing palette }
      PointX,PointY:integer;    { current cursor position }
      IndexX,IndexY:integer;    { index position of current cursor }
      SmallScanlength:integer;   { for eye movement }
      FullScanlength:integer;   { to refresh picture }
      IsGirl:boolean;


const MaskWidth=640;
      MaskHeight=512;
      MaskSLines=(MaskWidth div 16);
      BWidth=MaskWidth div 8;
      BHeight=MaskHeight div 8;

type  WipeArray=packed array [1..MaskHeight, 1..MaskWidth] of boolean;
      pWipeArray=^Wipearray;
      BArray=packed array [1..MaskHeight,1..BWidth] of char;
      pBArray=^BArray;
      
const BlockSize=256; NumBlocks=64; Snumblocks = 32;

type Block=array [0..BlockSize-1] of integer;
     PicBuffer=array [1..NumBlocks] of Block;
     sPicBuffer=array [1..sNumBlocks] of Block;
     pPicBuffer=^PicBuffer;
     spPicBuffer=^sPicBuffer;


var
      TmpBuf: pPicBuffer;
      sTmpBuf: spPicBuffer;


{ Simultaneous vert. and horiz. Center-out wipe }
Procedure HVOutWipe(X, Y, W, H,srcX,srcY,scanlength: integer;wipemask:pwipearray);
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
     srcX + ((W - width) div 2),srcY + ( (H - height) div 2),
     scanlength, Recast(WipeMask, RasterPtr));
    end;
  end;


  Function GetPicture(FileName: string;
       X, Y: integer; var Width, Height: integer;
       DestSLine: integer; DestBase: RasterPtr;
       Xs,Ys:integer; 
       DestsSLine: integer; DestsBase: RasterPtr): boolean;
 { GetPicture will read a picture file of the format specified by
  SavePicture. It reads the file into a temporary buffer (TmpBuf) and
  then RasterOp's it into the buffer specified by the user. The user
  must specify the ScanLength of the destination buffer and its base
  address. The picture consists of a big and a small copy. Xs,Ys specify
  the coordinates for the small copy.
}

  var SegNum, BlockCount, Expected, ScanLength, i: integer;
      f: file of block;
      dum, zilch,wid,hei,split: integer;
  begin
  if FSLookUp(FileName, dum, zilch) = 0 then
    begin
    Writeln('GetPicture: Lookup failure on ', FileName);
    GetPicture := false;
    end
  else
    begin
    { Create a segment and allocate the temporary buffer }
    CreateSegment(SegNum, NumBlocks, 1, NumBlocks + 5);
    New(SegNum, 4, TmpBuf);
    New(0,4,sTmpBuf);
  
    { open the requested file }
    Reset(f, FileName);
    width := f^[0];
    height := f^[1];
    ScanLength := LAnd(width + 63, LNot(#77)) div 16;
    FullScanLength := ScanLength;
    if ScanLength <> f^[2] then
      Writeln('GetPicture: Scanlength error: ', ScanLength:1, ' or ', f^[2]:1);
    Expected := f^[3];
    split := height div expected;
    for BlockCount := 1 to Expected do
      begin
      get(f);
      TmpBuf^[Blockcount] := f^;
      end;
    { move it out to the user's area }                                   
    HVOutWipe(X,Y,width,height,0,0,scanlength,Recast(TmpBuf,Pwipearray));
    get(f);
    wid := f^[0];
    hei := f^[1];
    ScanLength := LAnd(wid + 63, LNot(#77)) div 16;
    SmallScanLength := ScanLength;
    if ScanLength <> f^[2] then
      Writeln('GetPicture: Scanlength error: ', ScanLength:1, ' or ', f^[2]:1);
    Expected := f^[3];
    for BlockCount := 1 to Expected do
      begin
      get(f);
      sTmpBuf^[BlockCount] := f^;
      end;
    { move it out to the user's area }
    HVOutWipe(Xs,Ys,wid,hei,0,0,Scanlength,Recast(sTmpBuf,Pwipearray));
    Close(f);
    GetPicture := true;
    end;
  end;



procedure CopyPicToScreen(w,h,x,y,offx,offy:integer;ll:integer;p:RasterPtr);
begin
        RasterOp(RRpl,w,h,x,y,SScreenW,SScreenP,offx,offy,ll,p);
end;


procedure ClearScreen(x,y,w,h:integer);
begin
        RasterOp(RXor,w,h,x,y,SScreenW,SScreenP,x,y,SScreenW,SScreenP);
end;

procedure FillScreen(x,y,w,h:integer);
begin
        RasterOp(RXNor,w,h,x,y,SScreenW,SScreenP,x,y,SScreenW,SScreenP);
end;

procedure CopyScreen(sx,sy,w,h,dx,dy:integer);
begin
        RasterOp(RRpl,w,h,dx,dy,SScreenW,SScreenP,sx,sy,SScreenW,SScreenP);
end;

procedure CloseEyes;
var i:integer;
begin
    if not IsGirl then exit(CloseEyes);
        for i := 1 to 8 do
            ClearScreen(382,OrgY+122+i,16,1);
        for i := 1 to 4 do
            ClearScreen(382+i,OrgY+122+8+i,16-i,1);
end;


procedure OpenEyes;
var i:integer;
begin
    if not IsGirl then exit(OpenEyes);
        for i := 1 to 11 do
            CopyPicToScreen(16,1,382,OrgY+122+i,126,123+i,SmallScanLength,Recast(sTmpbuf,RasterPtr));
        CopyPicToScreen(10,1,383,OrgY+122+12,127,123+12,SmallScanLength,Recast(sTmpbuf,RasterPtr));
end;

procedure slide(DestX,DestY,SrcX,SrcY,Xsize,Ysize:integer;fast:boolean);
{* fast indicates whether the move is done in one step or slowly per pixel *}
var 
    DX, DX8, DY, DY8: integer;
    Steps: integer;
    NewX, NewY: integer;
    LastX, LastY: integer;
    XInc, YInc: integer;
    i: integer;

begin
if debug then
        writeln('slide dest (x,y):',DestX,DestY,'Src (x,y):',SrcX,SrcY,'size (x,y):',Xsize,Ysize);

if fast then
begin
        CopyScreen(SrcX,SrcY,Xsize,Ysize,DestX,DestY);
        ClearScreen(SrcX,SrcY,Xsize,Ysize);
end
else
begin
{ This is a version of Newman and Sproull's 'Simple DDA' Algorithm }
DX := DestX - SrcX; 
DY := DestY - SrcY; 
if ( DX = 0 ) and ( DY = 0 ) then
        exit(slide);    { nothing to move }
if abs(DX) < Abs(DY) then Steps := Abs(DY) else Steps := Abs(DX);

NewX := SrcX ;
NewY := SrcY ;
LastX := SrcX;
LastY := SrcY;
XInc := DX div steps;
YInc := DY div steps;

for i := 1 to Steps do
  begin
  NewX := NewX + XInc;
  NewY := NewY + YInc;
  CopyScreen(LastX, LastY, Xsize, Ysize, NewX , NewY);
  if ( DX > 0 ) then
      ClearScreen(LastX,LastY, XInc, Ysize)
  else if ( DX < 0 ) then
      ClearScreen(LastX+ (Xsize+XInc),LastY, Abs(XInc), Ysize)
  else if ( DY > 0 ) then
      ClearScreen(LastX,LastY, XSize, YInc)
  else if ( DY < 0 ) then
      ClearScreen(LastX ,LastY+ (YSize+YInc), XSize , Abs(YInc));
  LastX := NewX;
  LastY := NewY;
  end;
end;
end;

function PixToIdx(PX,PY:integer;var IX,IY:integer):boolean;
{* conversion from screen coordinates to palette coordinates. 
   palette coordinates start with 0,0 *}
begin
    if ( TopX <= PX ) and ( PX < (TopX + PicX) ) and
       ( TopY <= PY ) and ( PY < (TopY + PicY) ) then
    begin
        IX := (PX - TopX ) div PalX;
        IY := (PY - TopY ) div PalY;
        if debug then
                writeln('PixToIdx:px,py,ix,iy ',PX,PY,IX,IY);
        PixToIdx := true;
    end
    else
        PixToIdx := false;
end;

Procedure IdxToPix(var PX,PY:integer;IX,IY:integer);
begin
{    if ( 0 <= IX ) and ( IX < NumX ) and
       ( 0 <= IY ) and ( IY < NumY ) then
    begin}
        PX := IX * PalX + TopX;
        PY := IY * PalY + TopY;
        if debug then
                writeln('IdxToPix:px,py,ix,iy ',PX,PY,IX,IY);
{    end
    else
    if debug then
        writeln('IdxToPix:failed:ix,iy',IX,IY);}
end;

Procedure MovePalette(IX,IY:integer;fast:boolean);
{* move palette to hole. assumes palette is neighbouring to hole *}
var
    OPX,OPY:integer;    { old palette pic coord }
    NPX,NPY:integer;    { new palette pic coord }
begin
        IdxToPix(NPX,NPY,HoleXidx,HoleYidx);
        IdxToPix(OPX,OPY,IX,IY);
        slide(NPX,NPY,OPX,OPY,PalX,PalY,fast);
        HoleXidx := IX;
        HoleYidx := IY;
        if debug then
                writeln('Movepalette:Newhole (x,y) ',HoleXidx,HoleYidx);
end;

Procedure DrawBox(ls:LineStyle;x,y,w,h:integer);
begin
        Line(ls,x,y,x+w-1,y,SScreenP);
        Line(ls,x,y,x,y+h-1,SScreenP);
        Line(ls,x,y+h-1,x+w-1,y+h-1,SScreenP);
        Line(ls,x+w-1,y,x+w-1,y+h-1,SScreenP);
end;


Procedure BoxPalette(IX,IY:integer);
var
    OPX,OPY:integer;    { old palette pic coord }
begin
        IdxToPix(OPX,OPY,IX,IY);
        DrawBox(DrawLine,OPX,OPY,PalX,PalY);
        DrawBox(EraseLine,OPX+1,OPY+1,PalX-2,PalY-2);
end;

Function LegalPalette(PX,PY:integer; var IX,IY:integer):boolean;
{* determines whether palette referred to by pixel coord. is legal
   i.e. neighbouring to the hole. Also returns palette coord. *}
begin
    if PixToIdx(PX,PY,IX,IY) then
        if (( IX = HoleXidx ) and 
            ( (IY = (HoleYidx - 1)) or (IY = (HoleYidx + 1 )) )) or
           (( IY = HoleYidx ) and 
            ( (IX = (HoleXidx - 1)) or (IX = (HoleXidx + 1 )) )) then
        begin
                LegalPalette := true;
                exit(LegalPalette);
        end;
    LegalPalette := false;
end;



procedure PicReset;
var i,j:integer;
begin
        HoleXidx := 0;
        HoleYidx := 0;
        CopyPicToScreen(PicX,PicY,TopX,TopY,0,0,FullScanLength,Recast(Tmpbuf,RasterPtr));
        for i:= 0 to NumX-1 do
                for j:= 0 to NumY-1 do
                        BoxPalette(i,j);
        ClearScreen(TopX,TopY,PalX,PalY);

end;

procedure Mixup(n:integer);forward;

{******}

function GetCoord(var PX,PY:integer):boolean;
{* read mouse position and buttons *}
var time:timestamp;
    b:boolean;
    gotcoord:boolean;
    KbdInCh:char;
begin
        b := false;
        gotcoord := false;
        repeat
        begin
                GetTStamp(time);
                if ((time.second mod 2 ) = 0 ) then
                        CloseEyes
                else
                        OpenEyes;
                {* read key board *}
                
            if ( IOCRead(RS232In,KbdInCh) = IOEIOC ) or 
               ( IOCRead(TransKey,KbdInCh) = IOEIOC ) then
            begin
                if KbdInCh = 'r' then
                begin
                    if not b then
                    begin
                        PicReset;
                        b := true;
                    end
                end
                else
                if KbdInCh = 'q' then
                begin
                        GetCoord:=false;
                        exit(GetCoord);
                end
                else if KbdInCh = 'm' then
                begin
                        b := false;
                        MixUp(500);
                end
                else if KbdInCh = 'i' then
                begin
                        IdxToPix(PX,PY,HoleXidx,HoleYidx-1);
                        gotcoord := true;
                end
                else if KbdInCh = ',' then
                begin
                        IdxToPix(PX,PY,HoleXidx,HoleYidx+1);
                        gotcoord := true;
                end
                else if KbdInCh = 'j' then
                begin
                        IdxToPix(PX,PY,HoleXidx-1,HoleYidx);
                        gotcoord := true;
                end
                else if KbdInCh = 'l' then
                begin
                        IdxToPix(PX,PY,HoleXidx+1,HoleYidx);
                        gotcoord := true;
                end
            end
            else
            begin
                    
                IOReadTablet(PX,PY);
                if TabWhite then
                begin
                    if not b then
                    begin
                        PicReset;
                        b := true;
                    end
                end
                else
                if TabBlue then
                begin
                        GetCoord:=false;
                        exit(GetCoord);
                end
                else if TabGreen then
                begin
                        b := false;
                        MixUp(500);
                end
                else if TabYellow or TabSwitch then
                        gotcoord := true;
            end
        end
        until gotcoord;
        GetCoord:=true;
end;


  Procedure NextArgStr(var CmdStr, ArgStr: String);
  var Broke: string;
  begin
  RemDelims(CmdStr, ' ', Broke);
  GetSymbol(CmdStr, ArgStr, ' ', Broke);
  end;


  Function ArgCount(Str: String): integer;
  var StrLength, i, Count: integer;
      LastWasSpace: boolean;
  begin
  LastWasSpace := true;
  Count := 0;
  StrLength := Length(Str);
  for i := 1 to StrLength do
    begin
    if LastWasSpace and (Str[i] <> ' ') then
      begin
      LastWasSpace := false;
      Count := Count + 1;
      end
    else if Str[i] = ' ' then
      LastWasSpace := true;
    end;
  ArgCount := Count;
  end;


Procedure ParsCmd;
  var Str: string;
      ArgC, dum: integer;
  begin
  ArgC := ArgCount(UsrCmdLine);
  if ArgC < 2 then
    begin
          FileName := 'girl.puz';
          IsGirl := true;
    end
    else
    begin
        NextArgStr(UsrCmdLine, Str);
        NextArgStr(UsrCmdLine, FileName);
        AppendString(FileName,'.puz');
        IsGirl := false; 
    end;

  end;


Procedure LoadCurs;
{------------------------------
{ Abstract:
{    Set up the cursor so that we can show compilation in progress
{
{ Calls:
{    New
{    Dispose
{    IOLoadCursor
{    IOCursorMode
{    IOSetCursorPos
{------------------------------}
  var x,y:integer;
      Curs: CurPatPtr;
      funct: integer;
begin
new(0,4,Curs);
for y:=0 to 63 do
    for x:=0 to 3 do
        Curs^[y,x] := 0;
Curs^[ 2, 0] := #700;
Curs^[ 3, 0] := #3100;
Curs^[ 4, 0] := #4200;
Curs^[ 5, 0] := #10200;
Curs^[ 6, 0] := #61740;
Curs^[ 7, 0] := #121040;
Curs^[ 8, 0] := #121776;
Curs^[ 9, 0] := #121001;
Curs^[10, 0] := #121776;
Curs^[11, 0] := #121040;
Curs^[12, 0] := #121700;
Curs^[13, 0] := #61100;
Curs^[14, 0] := #17600;
IOLoadCursor(Curs,0,0);
Dispose(Curs);
IOCursorMode(TrackCursor);
IOSetFunction(CTInvCursCompl);
IOSetModeTablet(relTablet);
end { LoadCurs };


{*******************************************************}
{* set up pictures. read into core, compact, and place *}
{*******************************************************}

var   WipeMask: pWipeArray;
      SmallMask: pWipeArray;

procedure PrintCenter(ypos:integer;msg:string);
var
    ft: FontPtr;
begin
        ft := GetFont;
        SSetCursor((768 - (length(msg) * ft^.Index[ord(' ')].Width)) div 2,ypos);
        write(msg);
end;

const
    ZeroOne  = #052525;
    SWordsP4 = SScreenW + 4; { words/scan line + 4 }

type
    GrayLine     = array [1..SWordsP4] of integer;


procedure PaintGray(x,y,w,h:integer);
var
    i:integer;
    GrayPtr:  ^GrayLine;

begin
    new (0, 4, GrayPtr);
    for i := 1 to SWordsP4 do
        GrayPtr^[i] := ZeroOne;
    for i := y to y + H - 1 do
        RasterOp (RRpl, W, 1, x, i, SScreenW, SScreenP,
            i mod 2, 0, SWordsP4, GrayPtr);
    dispose(GrayPtr);
end;

function PuzzInit( Fname:string):boolean;
var
    time:timestamp;
    i,j,dum,bcnt:integer;
      WipeMask,Swipemask: pWipeArray;
      bp: pBArray;
      tc:char;
      offset:integer;
      oPicX,oPicY:integer;
begin
  SetBaud('4800',true);
  InitRandom;
  {* randomize random number *}
  gettstamp(time);  { randomize random }
  for i := 1 to time.Second do
        dum := random;
  LoadCurs;
  PaintGray(0,0,768,1024);
  PrintCenter(30,'Peter''s Picture Puzzle');
  PrintCenter(60,'Courtesy of Peter H. Feiler (c) 1981');
  NumX := 4;
  NumY := 4;
  HoleXidx := 0;
  HoleYidx := 0;
  PicX := 512;
  PicY := 512;
        TopX := (768 - PicX) div 2;
        TopY := 100;
        OrgX := (768 - (PicX div 2)) div 2;
        OrgY := 732;
        oPicX := PicX div 2;
        oPicY := PicY div 2;
        PalX := PicX div NumX;
        PalY := PicY div NumY;
        ClearScreen(TopX-4,TopY-4,PicX+8,PicY+8);
        FillScreen(TopX-2,TopY-2,PicX+4,PicY+4);
        ClearScreen(OrgX-4,OrgY-4,oPicX+8,oPicY+8);
        FillScreen(OrgX-2,OrgY-2,oPicX+4,oPicY+4);
  if not GetPicture(Fname, TopX, TopY, PicX, PicY, SScreenW,SScreenP,OrgX,OrgY,SScreenW,SScreenP) then
        Puzzinit := false
  else
  begin
        for i:= 0 to NumX-1 do
                for j:= 0 to NumY-1 do
                        BoxPalette(i,j);
        ClearScreen(TopX,TopY,PalX,PalY);
        PrintCenter(650,'<yellow> or i/j/,/l = move piece to hole');
        PrintCenter(670,'<green> or m = mix pieces');
        PrintCenter(690,'<white> or r = reset pieces');
        PrintCenter(710,'<blue> or q = exit/quit');
        Reset(Input);
        PuzzInit := true;
  end;
end;

procedure GetPoints(var ptx,pty:integer);
var
    ran:integer;
    iX,iY:integer;
begin
        ran := Random;
        case ran mod 4 of
        0: begin ix := holeXidx; iy := holeYidx -1; end;
        1: begin ix := holeXidx; iy := holeYidx +1; end;
        2: begin ix := holeXidx -1; iy := holeYidx; end;
        3: begin ix := holeXidx +1; iy := holeYidx; end;
        end;
        IdxToPix(ptx,pty,ix,iy);
end;

procedure Mixup(n:integer);
var
    i:integer;
    pntX,pntY:integer;
    idxX,idxY:integer;
    
  begin
        for i:= 1 to n do
        begin
          repeat
            GetPoints(pntX,pntY);
          until LegalPalette(pntX,pntY,idxX,idxY);
          MovePalette(idxX,idxY,true);
        end;
  end;

begin
Rewrite(Output);
ParsCmd;
if PuzzInit(Filename) then
  begin
        while GetCoord(PointX,PointY) do
        begin
          if LegalPalette(PointX,PointY,IndexX,IndexY) then
                  MovePalette(IndexX,IndexY,false);
        end;
       write(chr(12));
       Dispose(sTmpBuf);
        Dispose(Tmpbuf);
  end;
end.

