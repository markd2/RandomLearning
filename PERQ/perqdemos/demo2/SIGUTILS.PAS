Module SigUtils;

{ ************************************** 
 Siggraph Demo Utilities
     
  Three Rivers Computer Corporation
  Pittsburgh, Pa. 15217
  Written by: Ralph Guggenheim7-2-80
  ************************************** }
{------------------------------------------------------------------
{ Change log
{ 
{ 1 Apr 81 DCF V0.1 Runs under new system.
{
{------------------------------------------------------------------}

EXPORTS
  Imports Raster from Raster;
  Imports Screen from Screen;

  Function AsciiToInteger(Str: String): integer;

  Function AsciiToOctal(Str: String): integer;

  Procedure NextArgInt(var CmdStr: String; var IntVal: integer);
  
  Procedure NextArgStr(var CmdStr, ArgStr: String);

  Function ArgCount(Str: String): integer;

  Function SavePicture(FileName:string; X, Y, Width, Height: integer): boolean;

  Function GetPicture(FileName: string;
       X, Y: integer; var Width, Height: integer; 
       DestSLine: integer; DestBase: RasterPtr): boolean;

  Procedure GetUseWindow(var WIndx: WinRange; var X, Y, Width, Height: integer);

  Procedure GetFullWindow(var WIndx:WinRange; var X, Y, Width, Height: integer);

  Procedure RedrawWindow(WIndx: integer; Title: string);
  
PRIVATE
  Imports CmdParse from CmdParse;
  Imports Memory from Memory;
  Imports FileSystem from FileSystem;
  var HasTitle: boolean;


{ AsciiToInteger takes a string of numeric characters (0-9)
  and returns its integer value. Conversion ends with the
  first non-numeric character in the string.
  Bugs: The routine will return 0, even if the string is
  comprised entirely of alphabetics.
}
Function AsciiToInteger;
  var Value, i: integer;
      neg: boolean;
      Broke: string;
  begin
  Value := 0;
  i := 1;
  neg := false;
  RemDelims(Str, ' ', Broke);  { Strip leading blanks }
  if Str[1] = '-' then
    begin
    neg := true;
    i := 2;
    end;
  while (i <= Length(Str)) do
    begin
       if (Str[i] in ['0'..'9']) then
       begin     
          Value :=  (Ord(Str[i]) - Ord('0')) + (Value * 10);
          i := i + 1;
       end;
    end;
  if neg then Value := -Value;
  AsciiToInteger := Value;
  end;

{ AsciiToOctal takes a string of numeric characters (0-8)
  and returns its octal value. Conversion ends with the
  first non-numeric character in the string.
  Bugs: The routine will return 0, even if the string is
  comprised entirely of alphabetics.
}
Function AsciiToOctal;
  var Value, i: integer;
      neg: boolean;
      Broke: string;
  begin
  Value := 0;
  i := 1;
  neg := false;
  RemDelims(Str, ' ', Broke);  { Strip leading blanks }
  if Str[1] = '-' then
    begin
    neg := true;
    i := 2;
    end;
  while (i <= Length(Str)) and (Str[i] in ['0'..'7']) do
    begin
    Value :=  (Ord(Str[i]) - Ord('0')) + (Value * 8);
    i := i + 1;
    end;
  if neg then Value := -Value;
  AsciiToOctal := Value;
  end;

{ NextArgStr strips the next argument from the trgument string iCmdSTr)
  and wnites it by reference into ArgStr. CmdStr is truncated by one
  argument upon return.
}
Procedure NextArgStr;
  var Broke: string;
  begin
  RemDelims(CmdStr, ' ', Broke);
  GetSymbol(CmdStr, ArgStr, ' ', Broke);
  end;

{ NextArgInt strips the next argument from the argument string (Cmdstr)
  and writes its interpreted value into IntVal by reference. CmdStr
  is truncated by one argument upon return.
}
Procedure NextArgInt;
  var Broke, ArgStr : string;
  begin
  RemDelims(CmdStr, ' ', Broke);
  GetSymbol(CmdStr, ArgStr, ' ', Broke);
  IntVal := AsciiToInteger(ArgStr);
  end;

{ ArgCount takes a string and returns the number of text fields
  in Str separated by spaces.
}
Function ArgCount;
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

{ These types are used by GetPicture and SavePicture }
const BlockSize=256; NumBlocks=64;

type Block=array [0..BlockSize-1] of integer;
     PicBuffer=array [1..NumBlocks] of Block;
     pPicBuffer=^PicBuffer;

{ SavePicture takes a window in the screen and writes it out
  to a file with a header block. The header contains the
  width, height, ScanLineLength (in words) of the picture,
  and the number of blocks of picture that follow the header
  block. The width of the saved picture is typically wider
  than the actual window stored (it's rounded to the next
  64 bit (quadword) boundary). However, the width value
  stored in the header is the actual value the user wanted
  to save.
}
Function SavePicture;
  var SegNum, BlockCount, ScanLength, i: integer;
      TmpBuf: pPicBuffer;
      f: file of Block;
  begin
  { Calculate the length of a scan line rounded to a higher quadword }
  ScanLength := LAnd(Width + 63, LNot(#77)) div 16;
  if ((ScanLength * Height) div NumBlocks) > BlockSize then
    begin
    Writeln('SavePicture: window to save is too large');
    SavePicture := false;
    end
  else
    begin
    { create a segment and allocate a temporary picture buffer }
       { (out)segment number, desired size in blocks, increment size in blocks,
         max size }
    CreateSegment(SegNum, NumBlocks, 1, NumBlocks + 5);
    New(SegNum, 4, TmpBuf);

    { copy the windowed area to the temp. buffer }
    RasterOp(RRpl,   // raster operation (replace)
             Width,  // in bits
             Height, // in scan lines
             // destination
             0, 0,   // (X,Y)
             ScanLength,  // number of words that comprise a line - multiple of 4 from 4..48 - 768 max
             Recast(TmpBuf, RasterPtr),  // destination memory pointer
             // source - which is the screen
             X, Y,   // (X,Y),
             48, // source area line length  - 768
             MakePtr(ScreenSeg, 0, RasterPtr) // source memory pointer
           );
    BlockCount := ((Height * ScanLength) + (BlockSize-1)) div BlockSize;
    Writeln('ScanLength=', ScanLength:1, ' BC=', BlockCount:1);

    { open the file, and write the buffer }
    Rewrite(f, FileName);
    f^[0] := Width;
    f^[1] := Height;
    f^[2] := ScanLength;
    f^[3] := BlockCount;
    put(f);
    for i := 1 to BlockCount do
      begin
      f^ := TmpBuf^[i];
      put(f);
      end;
    Close(f);

    { Return the buffer to free space }
    Dispose(TmpBuf);
    SavePicture := true;
    end;
  end;

{ GetPicture will read a picture file of the format specified by
  SavePicture. It reads the file into a temporary buffer (TmpBuf) and
  then RasterOp's it into the buffer specified by the user. The user
  must specify the ScanLength of the destination buffer and its base
  address.
}
Function GetPicture;
  var SegNum, BlockCount, Expected, ScanLength, i: integer;
      TmpBuf: pPicBuffer;
      f: file of block;
      dum, zilch: integer;
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
  
    { open the requested file }
    Reset(f, FileName);
    Width := f^[0];
    Height := f^[1];
    ScanLength := LAnd(Width + 63, LNot(#77)) div 16;
    if ScanLength <> f^[2] then
      Writeln('GetPicture: Scanlength error: ', ScanLength:1, ' or ', f^[2]:1);
    Expected := f^[3];
    get(f);
    BlockCount := 0;
    while not eof(f) do
      begin
      BlockCount := BlockCount + 1;
      TmpBuf^[BlockCount] := f^;
      get(f);
      end;
    if BlockCount <> Expected then
      Writeln('GetPicture: Expected ', Expected:1, ' blocks. Read ', BlockCount:1, ' blocks.');
  
    { move it out to the user's area }
    RasterOp(Rrpl, Width, Height,
     X, Y, DestSLine, DestBase,
     0, 0, ScanLength, Recast(TmpBuf, RasterPtr));
    Dispose(TmpBuf);
    Close(f);
    GetPicture := true;
    end;
  end;

{ the following routines are supplement missing features in the Screen package }

{ get the useable window area from WinTable }
Procedure GetUseWindow(var WIndx: WinRange; var X, Y, Width, Height: integer);
  begin
  GetWindowParms(WIndx, X, Y, Width, Height, HasTitle);
  X := X+1;
  Width := Width - 2;
  if HasTitle then begin
                   y := y+1;
                   height := height-1;
                   end;
  end;

{ get the outer dimensions of a window }
Procedure GetFullWindow(var WIndx: WinRange; var X, Y, Width, Height: integer);
  begin
  GetWindowParms(WIndx, X, Y, Width, Height, HasTitle);
    X := X - 2;
    Width := Width + 3;
    Y := Y- 3;
    if HasTitle then
      begin
      Y := Y - 10;  
      Height := Height + 15;
      end
    else Height := Height + 6;
  end;

{ Redraw an existing window without changing its contents. 
  If the Title parameter is non-null, issue a ChangeTitle
  On return, WIndx is the current window.
}
Procedure RedrawWindow(WIndx: integer; Title: string);
  var minx, miny, maxx, maxy: integer;
      Scrn: RasterPtr;
  begin
  RefreshWindow(WIndx);
     if Length(Title) > 0 then
      ChangeTitle(Title);
  end.

