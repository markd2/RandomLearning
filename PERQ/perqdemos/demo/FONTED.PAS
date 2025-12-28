program FontEd(input, output);
{------------------------------------------------------------------------------
Title: FontEd - Graphical Font Editor
Abstract: FontEd allows the user to design and edit PERQ screen fonts.  The
          editing is entirely graphical using the screen and pen.  Output
          is a font file of the form defined in Screen.pas that can be used
          for any output to the screen.  
Author: Brad A. Myers
------------------------------------------------------------------------------}
{------------------------------------------------------------------------------
Versions:
     21-Jul-81  V3.2    Brad A. Myers  Transcript
     20-Jul-81  V3.1    Brad A. Myers  XScreen
      7-Jul-81  V3.0    Brad A. Myers  Lots of new functions
     22-Apr-81  V2.0    Brad A. Myers  Changed to work with new system
     11-Jan-81  V1.0    Brad A. Myers  Started by modifying Cursdesign
------------------------------------------------------------------------------}

{\\\\\\\\\\\\\\\\\\\\\\\} EXPORTS {///////////////////////}
imports Memory from Memory;
imports Raster from Raster;
imports Screen from Screen;
imports FileSystem from FileSystem;
imports XScreen from XScreen;
imports Transcript from Transcript;

Const NumBits = 51;
      MaxBit = NumBits-1;
      NumWords = (((NumBits div 16) + 3) div 4)*4; {Must be quad word aligned}
      MaxWord = NumWords - 1;
      MaxFontSize = 100;  {blocks}
      CharsPerLine = 768 div NumBits;
      NumLines = (128 + CharsPerLine-1) div CharsPerLine;
      yBaseTop = 30;
       
type Funct = (Black, White, Toggle);
     Quad = 0..MaxBit;
     WB = (word, bit);
     Direction = (Up, down, left, right, NoDir);
     Wordbit = record case wb of
                   word : (w: integer);
                   bit : (b: packed array [0..15] of boolean); {0=rightmost}
                   end;
     CharPicture =  array [0..MaxBit, 0..MaxWord] of WordBit;  {y, x}

{The following variables depend on the current FONT}
  var curFont: String;  {fileName}
      maxWidth: Integer;
      fontHeight: integer;
      curBaseLine: Integer;
      widths: ARRAY[0..127] of integer;   {widths of the characters;
                                           0 means undefined character}
      fixedWidth: boolean;  {false if not, otherwise maxWidth is size}
      curYMax: Integer;  {max Y value in drawing square legal for cur Height}
      yBase: Integer;    {depends on fontHeight}
      
{The following variables depend on the current CHAR}
  var curChar: ^CharPicture;
      curOrd, curWidth: Integer;
      curXMax: Integer;  {max X value in drawing square legal for cur Width}

{Other variables}
  var lastx, lasty: Integer;
      justDown : Boolean;
      curFunction: Integer;
      mode: Funct;
      destPtr: RasterPtr;
      fSeg:SegmentNumber;
      fp: FontPtr;   {area of memory all fonts read into}
      scrFont: FontPtr;
      curDir: XSDirection;
      isNotBold, isNotItalic: Boolean;
      buttons: PressRec;
      
const DestWords = 48;
      CR = Chr(#15);
      xBase = 17;
      CharYStart = 1013-(NumBits*((128+CharsPerLine-1) div CharsPerLine));      
      ScrFOfst = (CharYStart*48) - #404;  { Word offset to start of ScrFont }
      winXStart = NumBits*8+31;
      winWidth = 767-winXStart;
      littleX = 20; {in words}
      littleY = CharYStart-NumBits-20;
      winHeight = littleY-20;

Const FontVersion = 'V3.0';
      FontEdTranscript = 'FontEd.Transcript';
      
Procedure MakeScrFont;
Procedure DotVLine(l: Integer);
Procedure DotHLine(l: Integer);
procedure SetBit(y,x: quad; val: boolean);
function GetBit(y,x: quad): boolean;
procedure DisplayBoard;  {draws the lines separating the squares}
procedure SetDestWord(y: quad; w: integer);
procedure CursPt(y,x: quad; f: Funct);
Procedure SetWidth(newWidth: integer; eraseOld: boolean);
Function ReadFontFile: boolean;
procedure JoinChar;
Procedure WriteFont;
procedure Init;
procedure All(val: Boolean);
procedure InvertAll;
procedure FLine;
procedure MoveOne(d: Direction);
procedure Box;
Procedure CheckBaseLineDot;
Procedure CheckWidthDot;

{\\\\\\\\\\\\\\\\\\\\\\\} PRIVATE {///////////////////////}

imports IO_Others from io_Others;
imports IO_Unit from io_Unit;
imports ioerrors from ioerrors;
imports Font2Ed from Font2Ed;
imports System from System;
imports CmdParse from CmdParse;

{$R+}

Procedure MakeScrFont;
   var i : integer;
   begin
   ScrFont := MakePtr(ScreenSeg, ScrFOfst, FontPtr);
   ScrFont^.Height := fontHeight;
   ScrFont^.base := curBaseLine;
   for i := 0 to 127 do
      begin
      ScrFont^.index[i].Offset := (i mod CharsPerLine) * NumBits;
      ScrFont^.index[i].Line := i div CharsPerLine;
      ScrFont^.index[i].Width := widths[i];
      end;
   end; {MakeScrFont}

Procedure DotVLine(l: Integer);
   var x,y,i: Integer;
   begin
   y := yBase-15;
   x := xBase+(l*8);
   for i := 0 to (fontHeight*8+20) div 2 do
       RasterOp(RNot, 1,1, x, y+i*2, DestWords, DestPtr, x, y+i*2, DestWords, 
                DestPtr);
   RasterOp(RXor, 11,11,x-5, yBase+fontHeight*8+5, DestWords, DestPtr, 
                 0, 0, 4, dotCurs);
   end;  {DotVLine}

Procedure DotHLine(l: Integer);
   var x,y,i: Integer;
   begin
   x := xBase-15;
   y := yBase+(l*8);
   for i := 5 to (NumBits*8+29) div 2 do
       RasterOp(RNot, 1,1, x+i*2, y, DestWords, DestPtr, x+i*2, y, DestWords, 
                DestPtr);
   RasterOp(RXor, 11, 11, 0, y-5, DestWords, DestPtr, 0, 0, 4, dotCurs);
   end;  {DotHLine}

Procedure XorDot(dotwidth: boolean);
   begin
   if dotwidth then RasterOp(RNot,13, 13, xBase+(curWidth*8)-6,
                          yBase+fontHeight*8+4, DestWords, DestPtr,
                          xBase+(curWidth*8)-6, yBase+fontHeight*8+4,
                          DestWords, DestPtr)
   else RasterOp(RNot,12, 13, 0, yBase+curBaseLine*8-6, DestWords, DestPtr,
                              0, yBase+curBaseLine*8-6, DestWords, DestPtr)
   end;

Procedure CheckWidthDot;
   var x,y, old, newWidth: integer;
       doit, press: Boolean;
   begin
   press := GetAction(x,y, TRUE, buttons);
   if (x >= xBase+curWidth*8-5) and (x < xBase+curWidth*8+6) and 
           (y >= yBase+fontHeight*8+5) and (y < yBase+fontHeight*8+16)
      then XorDot(true)
   else exit(CheckWidthDot);
   while (x >= xBase+curWidth*8-5) and (x < xBase+curWidth*8+6) and 
           (y >= yBase+fontHeight*8+5) and (y < yBase+fontHeight*8+16) do
       begin
       press := GetAction(x,y, TRUE, buttons);
       if press then begin
                         ChangeWindow(4);
                         XorDot(true);
                         if fixedWidth then begin
                                            IOBeep;
                                            exit(CheckWidthDot);
                                            end;
                         old := curWidth;
                         while press do
                             begin
                             press := GetAction(x,y, TRUE, buttons);
                             DotVLine(old);
                             newWidth := (x-xBase+4) div 8;
                             if (newWidth < 0) or (newWidth > NumBits) then
                                 newWidth := old;
                             DotVLine(newWidth);
                             if newWidth <> old then begin
                                                    Write(FF,':: ',newWidth:1);
                                                    old := newWidth;
                                                    end;
                             end;
                         if newWidth < curWidth then doit := Confirm 
                         else doit := true;
                         DotVLine(newWidth);  {erase it}
                         if doit then begin
                                      DotVLine(curWidth); {setWidth will erase}
                                      SetWidth(newWidth, true);
                                      end
                         else SetWidth(curWidth, false);
                         exit(CheckWidthDot);
                         end;
      end;
   XorDot(true);
   end;

Procedure CheckBaseLineDot;
   var x,y, old, newLine: integer;
       press: boolean;
   begin
   press := GetAction(x,y, TRUE, buttons);
   if (x < 12) and (y >= yBase+curBaseLine*8-5) and (y < yBase+curBaseLine*8+6)
       then XorDot(false)
   else exit(CheckBaseLineDot);
   while (x<12) and (y>=yBase+curBaseLine*8-5) and (y<yBase+curBaseLine*8+6) do
       begin
       press := GetAction(x,y, TRUE, buttons);
       if press then begin
                         ChangeWindow(7);
                         XorDot(false);
                         old := curBaseLine;
                         while press do
                             begin
                             press := GetAction(x,y, TRUE, buttons);
                             DotHLine(old);
                             newLine := (y-yBase) div 8;
                             if (newLine < 0) or (newLine > fontHeight) then
                                 newLine := old;
                             DotHLine(newLine);
                             if newLine <> old then begin
                                                    Write(FF,':: ',newLine:1);
                                                    old := newLine;
                                                    end;
                             end;
                         DotHLine(newLine);
                         SetBaseLine(newLine, false);
                         exit(CheckBaseLineDot);
                         end;
      end;
   XorDot(false)
   end;

procedure SetBit(y,x: quad; val: boolean);
   begin
   curChar^[y,x div 16].b[(15 - (x mod 16))] := val;
   end; {SetBit}

function GetBit(y,x: quad): boolean;
   begin
   GetBit := curChar^[y,x div 16].b[(15 - (x mod 16))];
   end; {GetBit}

procedure DisplayBoard;  {draws the lines separating the squares}
   var i: integer;
   begin
   for i := 0 to NumBits do  {vert lines}
       RasterOp(7,1,fontHeight*8+1, xBase+i*8, yBase, DestWords, DestPtr,
                                    xBase+i*8, yBase, DestWords, DestPtr);
   for i := 0 to fontHeight do {horiz lines}
       RasterOp(7,NumBits*8+1,1, xBase, i*8+yBase, DestWords, DestPtr,
                                xBase, i*8+yBase, DestWords, DestPtr);
   end;  {DisplayBoard}
   
procedure SetDestWord(y: quad; w: integer);
   var val: integer;
   begin
   val := curChar^[y,w].w;
   if w = 3 then val := LOr(val, #004000); {so side of box doesn't disappear}
  {$R-}
   DestPtr^[(littleY+y)*48+(littleX+w)] := val;
  {$R+}
   end;  {SetDestWord}

procedure CursPt(y,x: quad; f: Funct);
   var rfunct, w: integer;
       val: boolean;
   begin
   val := GetBit(y,x);
   if ((f = black) and val) or ((f = white) and (not val)) then exit(CursPt);
   if (f = white) or ( (f = toggle) and val) then
                       begin
                       SetBit(y,x, false);
                       rfunct := 6;
                       end
   else begin
        SetBit(y,x, true);
        rfunct := 7;
        end;
   RasterOp(rfunct,7,7,xBase+1+x*8,yBase+1+y*8,DestWords, DestPtr, xBase+1+x*8,
         yBase+1+y*8,DestWords, DestPtr);
   w := x div 16;  {word index}
   SetDestWord(y,w);
   end;  {CursPt}
   
Procedure SetWidth(newWidth: integer; eraseOld: boolean);
   var x,y: integer;
   begin
   curXmax := xBase+newWidth*8;
   ChangeWindow(4);
   if fixedWidth and (newWidth <> maxWidth) then 
       begin
       Write(FF,curWidth:3);
       IOBeep;
       exit(SetWidth);
       end;
   if eraseOld then
       begin
       DotVLine(curWidth);
       if newWidth < curWidth then  {erase all bits moved over}
          for x := newWidth to curWidth-1 do
            for y := 0 to fontHeight-1 do
                CursPt(y,x,white);
       end;
   curWidth := newWidth;
   if newWidth > maxWidth then maxWidth := curWidth;
   Write(FF,curWidth:3);
   DotVLine(curWidth);
   end;  {SetWidth}

Procedure SetFontParts(f: FontPtr; newHeight, newWidth: integer);
{if f = NIL, both newHeight and newWidth better be set!!!!}
   var tempPtr : RECORD CASE integer OF
            0: (f: FontPtr);
            1: (seg, ofst: integer);
            END;
       destX, destY, w, i, tempHt: integer;
   begin
{Set globals referring to font}
   if newHeight <= 0 then fontHeight := f^.Height
   else fontHeight := newHeight;
   if fontHeight > NumBits then fontHeight := NumBits;
   if f <> NIL then curBaseLine := f^.Base;
   if curBaseLine > fontHeight then curBaseLine := fontHeight;
   yBase := yBaseTop+ (NumBits-fontHeight)*4;
   curYMax := yBase+fontHeight*8;
   maxWidth := 0;
   fixedWidth := true;
   for i := 0 to 127 do
       begin
       if newWidth <= 0 then w := f^.index[i].Width
       else w := newWidth;
       if w > NumBits then w := NumBits;
       widths[i] := w;
       if (w <> 0) and (maxWidth <> 0) and (maxWidth <> w) then
          fixedWidth := false;
       if w > maxWidth then maxWidth := w;
       end;
{Get the characters}
   EraseScreen;  {uses Font parameters }
   if f <> NIL then
      begin
      tempPtr.f := f;
      tempHt := f^.Height;
      if fontHeight < tempHt then tempHt := fontHeight;  {do MIN}
      for i := 0 to 127 do
         with tempPtr.f^.index[i] do
           if widths[i] > 0 then
             begin
             GetAdr(i, destX, destY);
             RasterOp(RRpl,widths[i], tempHt, destX, destY, DestWords, DestPtr,
                        Offset, Line*f^.Height, DestWords, 
                        MakePtr(tempPtr.seg, tempPtr.ofst+#404, FontPtr));
             end;
      end;
{Start with character 'A'}
   SetCur(Ord('A'));
   ReadChar;
   end;  {SetFontParts}

{reads CurFont}
Function ReadFontFile: boolean;
   var tempPtr : RECORD CASE integer OF
            0: (f: FontPtr);
            1: (p: pDirBlk);
            2: (seg, ofst: integer);
            END;
       i, fontBlockSize, newHeight, newWidth: integer;
       fid: FileId;
   begin
   if curFont = '' then begin
                        IOBeep;
                        ReadFont := false;
                        exit(ReadFontFile);
                        end;
   fid := FSLookUp(curFont, fontBlockSize, i);
   ReadFont := true;
   if fid = 0 then begin
                   newHeight := DoFontHt(fontHeight);
                   newWidth := DoFontWidth(curWidth);
                   SetFontParts(NIL, newHeight, newWidth);
                   exit(ReadFontFile);
                   end;
{Read the font into memory}
   ChangeSize(fSeg,fontBlockSize); {make sure font will fit}
   tempPtr.f := fp;
   for i := 0 to fontBlockSize-1 do
      begin
      FSBLkRead(fid, i, tempPtr.p);
      tempPtr.ofst := tempPtr.ofst+256;
      end;
   newHeight := DoFontHt(fp^.height);
   SetFontParts(fp, newHeight, -1);
   end; {ReadFont}

Procedure WriteFont;
   var i, w, numBlocks, curLine,  curOff, destX, destY: integer;
       fid: FileId;
       tempPtr : RECORD CASE integer OF
            0: (f: FontPtr);
            1: (p: pDirBlk);
            2: (seg, ofst: integer);
            END;
   begin
   fid := FSEnter(curFont);
   if (curFont = '') or (fid = 0) then begin
                                       IOBeep;
                                       exit(WriteFont);
                                       end;
   InvertSel(curOrd);
   tempPtr.f := fp;
   tempPtr.f^ := scrFont^;  {assign widths, baseline, height}
   curLine := 0;
   curOff := 0;
   for i := 0 to 127 do {now write char and offset, line}
       begin
       w := scrFont^.index[i].width;
       if w <> 0 then
            begin
            if w+curOff >=768 then begin
                                   curline := curline+1;
                                   curOff := 0;
                                   end;
            tempPtr.f^.index[i].offset := curOff;
            tempPtr.f^.index[i].line := curLine;
            GetAdr(i, destX, destY);
            RasterOp(RRpl, w, fontHeight, curOff, curline*fontHeight,
                  DestWords, MakePtr(tempPtr.seg, tempPtr.ofst+#404, FontPtr),
                  destX, destY, DestWords, DestPtr);
            curOff := curOff+w;
            end;
      end;
 {white out rest of last line}
   if curOff < 768 then RasterOp(RXor, 768-curOff,fontHeight,
        curOff, curLine*fontHeight, DestWords,
           MakePtr(tempPtr.seg, tempPtr.ofst+#404, FontPtr),
        curOff, curLine*fontHeight, DestWords,
           MakePtr(tempPtr.seg, tempPtr.ofst+#404, FontPtr));
                  
   InvertSel(curOrd);
   numBlocks := (fontHeight*(curLine+1)*48 + #404 + 255) div 256;
   for i := 0 to numBlocks-1 do
      begin
      FSBlkWrite(fid, i, tempPtr.p);
      tempPtr.ofst := tempPtr.ofst+256;
      end;
   FSClose(fid, numBlocks, 4096);
   end;  {WriteFont}

Procedure JoinChar;
   var w, y, val: integer;
       baseX, baseY, newW: integer;
   begin
   newW := widths[curOrd];
   if newW = 0 then exit(JoinChar)
   else if newW > curWidth then SetWidth(newW, true);
   GetAdr(curOrd, baseX, baseY);
   InvertSel(curOrd);
   RasterOp(ROr, curWidth, fontHeight, 0, 0, 4, curChar, 
                     baseX, baseY, DestWords, DestPtr);
   InvertSel(curOrd);
   FixScreen;
   end;  {JoinChar}
   
procedure Init;
   var i, j : integer;
   begin
   DestPtr := MakePtr(ScreenSeg,0,RasterPtr);
   lastx := -1;
   lasty := -1;
   justDown := false;
   mode := toggle;
   curFont := '';
   XScreenReset;
   isNotBold := true;
   isNotItalic := true;
   curDir := LeftToRight;
   for i := 0 to MaxBit do
      for j := 0 to MaxWord do
         curChar^[i,j].w := 0;  {all off}
   IOSetModeTablet(relTablet);
   curFunction := Ord(CTCursCompl);
   IOSetFunction(CTCursCompl);
   SetFontParts(MakePtr(FontSeg, 0, FontPtr), -1, -1); {start with cur font;
                                                        does FixScreen}
   end;  {Init}
   
procedure All(val: Boolean);
  var x,y: quad;
      f: Funct;
  begin
  if val then f := black else f := white;
  for y := 0 to fontHeight-1 do
     for x := 0 to curWidth-1 do
         CursPt(y,x, f);
  end;  {All}

procedure InvertAll;
  var x,y: quad;
      val: boolean;
  begin
  for y := 0 to fontHeight-1 do
     for x := 0 to curWidth-1 do
         CursPt(y,x, Toggle);
  end;  {InvertAll}

procedure FLine;
    var tabx, taby,x,y: integer;
        x1,y1, x2, y2, temp: quad;
        got, press: boolean;
    begin
    repeat
      press := GetAction(tabX, tabY, TRUE, buttons);
    until not press;
    got := false;
    repeat
       if press then
          begin
          press := GetAction(tabx, taby, TRUE, buttons);
          y := (taby-yBase) div 8;
          x := (tabx-xBase) div 8;
          if (tabx >= xBase) and (taby >= yBase) and (tabx < curXMax) and (taby < curYMax) then got := true
          else IOBeep;
          end
    until got;
    x1:= x;
    y1:=y;
    CursPt(y1,x1, Toggle);
    got := false;
    repeat
      press := GetAction(tabX, tabY, TRUE, buttons);
    until not press;
    repeat
       if press then
          begin
          press := GetAction(tabx, taby, TRUE, buttons);
          y := (taby-yBase) div 8;
          x := (tabx-xBase) div 8;
          if (tabx >= xBase) and (taby >= yBase) and (tabx < curXMax) and (taby < curYMax) then got := true
          else IOBeep;
          end
    until got;
    x2:=x;
    y2:=y;
    CursPt(y1,x1,Toggle);  {change back to original state}
    if x1 > x2 then begin {swap}
                    temp := x1;
                    x1:= x2;
                    x2:=temp;
                    end;
    if y1 > y2 then begin
                    temp := y1;
                    y1 := y2;
                    y2:= temp;
                    end;
    if y2-y1 > x2-x1 then for temp := y1 to y2 do CursPt(temp,x1,mode)
    else for temp := x1 to x2 do CursPt(y1, temp,mode);
    repeat
      press := GetAction(tabX, tabY, TRUE, buttons);
    until not press;
    end; {FLine}
   
procedure MoveOne(d: Direction);
   var x,y: quad;
       temp : Boolean;
   begin
   case d of 
     down : begin
            for y := fontHeight-2 downto 0 do
              for x := 0 to curWidth-1 do
                 begin
                 temp := GetBit(y,x);
                 if temp then CursPt(y+1,x, black)
                 else CursPt(y+1,x, white);
                 end;
            for x := 0 to curWidth-1 do 
                 CursPt(0,x, white);
            end;
     up: begin
         for y := 1 to fontHeight-1 do
              for x := 0 to curWidth-1 do
                 begin
                 temp := GetBit(y,x);
                 if temp then CursPt(y-1,x, black)
                 else CursPt(y-1,x, white);
                 end;
         for x := 0 to curWidth-1 do 
                 CursPt(fontHeight-1,x, white);
         end;
     left: begin
           for x := 1 to curWidth-1 do
              for y := 0 to fontHeight-1 do
                 begin
                 temp := GetBit(y,x);
                 if temp then CursPt(y,x-1, black)
                 else CursPt(y,x-1, white);
                 end;
           for y := 0 to fontHeight-1 do 
                 CursPt(y, curWidth-1, white);
           end;
     right: begin
            for x := curWidth-2 downto 0 do
              for y := 0 to fontHeight-1 do
                 begin
                 temp := GetBit(y,x);
                 if temp then CursPt(y,x+1, black)
                 else CursPt(y,x+1, white);
                 end;
            for y := 0 to fontHeight-1 do 
                 CursPt(y, 0, white);
            end;
     otherwise: Write('IMPOSSIBLE IN Move');
     end;
  end; {MoveOne}

procedure Box;
    var tabx, taby,x,y: integer;
        x1,y1, x2, y2, temp, i,j: quad;
        got, press: boolean;
    begin
    repeat
      press := GetAction(tabX, tabY, TRUE, buttons);
    until not press;
    got := false;
    repeat
       if press then
          begin
          press := GetAction(tabX, tabY, TRUE, buttons);
          y := (taby-yBase) div 8;
          x := (tabx-xBase) div 8;
          if (tabx >= xBase) and (taby >= yBase) and (tabx < curXMax) and (taby < curYMax) then got := true
          else IOBeep;
          end
    until got;
    x1:= x;
    y1:=y;
    CursPt(y1,x1, Toggle);
    got := false;
    repeat
      press := GetAction(tabX, tabY, TRUE, buttons);
    until not press;
    repeat
       if press then
          begin
          press := GetAction(tabX, tabY, TRUE, buttons);
          y := (taby-yBase) div 8;
          x := (tabx-xBase) div 8;
          if (tabx >= xBase) and (taby >= yBase) and (tabx < curXMax) and (taby < curYMax) then got := true
          else IOBeep;
          end
    until got;
    x2:=x;
    y2:=y;
    CursPt(y1,x1,Toggle);  {change back to original state}
    if x1 > x2 then begin
                    temp := x1;
                    x1:= x2;
                    x2:=temp;
                    end;
    if y1 > y2 then begin
                    temp := y1;
                    y1 := y2;
                    y2:= temp;
                    end;
    for i := x1 to x2 do
      for j := y1 to y2 do
         CursPt(j,i,mode);
    repeat
      press := GetAction(tabX, tabY, TRUE, buttons);
    until not press;
    end; {Box}

Procedure ReadCmdLine;
   var s: String;
       broke: String[1];
   begin
   RemDelimiters(UsrCmdLine, ' /', broke);
   GetSymbol(UsrCmdLine,s,' /',broke);  {remove "FontEd"}
   RemDelimiters(UsrCmdLine,' /', broke);
   GetSymbol(UsrCmdLine,s,' /',broke);
   CnvUpper(s);
   if s = 'REPLAY' then 
      begin
      WriteLn('Replaying last session.');
      InitTranscript(FontEdTranscript, TRUE);
      end
   else if s <> '' then begin
                        WriteLn('** Unknown parameter ',s);
                        exit(FontEd);
                        end
   else InitTranscript(FontEdTranscript, FALSE);
   end;

begin

{Allocate memory needed}
   NEW(0,4,curChar);
   CreateSegment(fSeg, 10, 1, maxFontSize);
   fp := MakePtr(fSeg, 0, FontPtr);

ReadCmdLine;
XScreenInit;
InitSelect;
Init;
MainLoop;
end.


