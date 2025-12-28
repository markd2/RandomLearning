Module SigUtils;
{--------------------------------------------------------------------------
 Siggraph Demo Utilities
     
  Three Rivers Computer Corporation
  Pittsburgh, Pa. 15217
  Written by: Ralph Guggenheim 7-2-80
  ReWritten by: Brad Myers 27-Jul-81

  Copyright (C) 1981 - Three Rivers Computer Corporation
------------------------------------------------------------------}

{------------------------------------------------------------------
 Change log
 
 28-Jul-81 Brad Myers V2.1  Added SetUpRandom for FastRandom
 27-Jul-81 Brad Myers V2.0  Added GetFastPicture and moved some routines to
                             the module XScreen.
 1 Apr 81 DCF V0.1 Runs under new system.

------------------------------------------------------------------}


EXPORTS
  Imports Raster from Raster;

Const FF = Chr(12);  {used to clear a window}
  
  Function AsciiToInteger(Str: String): integer;

  Function AsciiToOctal(Str: String): integer;

  Procedure NextArgInt(var IntVal: integer);  {uses UsrCmdLine}
  
  Procedure NextArgStr(var ArgStr: String);   {uses UsrCmdLine}

  Function ArgCount: integer;                 {uses UsrCmdLine}

  Function SavePicture(FileName:string; X, Y, Width, Height: integer): boolean;

  Function GetPicture(FileName: string;
       X, Y: integer; var Width, Height: integer; 
       DestSLine: integer; DestBase: RasterPtr): boolean;

  Function GetFastPicture(FileName: string;
       var Width, Height, ScanLength: integer;
       var DestBase: RasterPtr): boolean;

 
  Function Sqroot( X: Integer ): Integer;

  Procedure SetUpRandom;

PRIVATE
  Imports CmdParse from CmdParse;
  Imports Memory from Memory;
  Imports FileSystem from FileSystem;
  Imports Screen from Screen;
  Imports MultiRead from MultiRead;
  Imports System from System;
  Imports FastRandom from FastRandom;
  
  var HasTitle: boolean;


Procedure SetUpRandom;
   begin
   InitRandom(MakePtr(DemoInt, 0, pRanTable));
   end;
 
{ AsciiToInteger takes a string of numeric characters (0-9)
  and returns its integer value. Conversion ends with the
  first non-numeric character in the string.
  Bugs: The routine will return 0, even if the string is
  comprised entirely of alphabetics.
}
Function AsciiToInteger(Str: String): integer;
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
Function AsciiToOctal(Str: String): integer;
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
Procedure NextArgStr(var ArgStr: String);   {uses UsrCmdLine}
  var Broke: string[1];
  begin
  RemDelimiters(UsrCmdLine, ' ', Broke);
  GetSymbol(UsrCmdLine, ArgStr, ' ', Broke);
  end;

{ NextArgInt strips the next argument from the argument string (Cmdstr)
  and writes its interpreted value into IntVal by reference. CmdStr
  is truncated by one argument upon return.
}
Procedure NextArgInt(var IntVal: integer);  {uses UsrCmdLine}
  var Broke: String[1];
      ArgStr : string;
  begin
  RemDelimiters(UsrCmdLine, ' ', Broke);
  GetSymbol(UsrCmdLine, ArgStr, ' ', Broke);
  IntVal := AsciiToInteger(ArgStr);
  end;

{ ArgCount takes a string and returns the number of text fields
  in Str separated by spaces.
}
Function ArgCount: integer;                 {uses UsrCmdLine}
  var StrLength, i, Count: integer;
      LastWasSpace: boolean;
  begin
  LastWasSpace := true;
  Count := 0;
  StrLength := Length(UsrCmdLine);
  for i := 1 to StrLength do
    begin
    if LastWasSpace and (UsrCmdLine[i] <> ' ') then
      begin
      LastWasSpace := false;
      Count := Count + 1;
      end
    else if UsrCmdLine[i] = ' ' then
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
Function SavePicture(FileName:string; X, Y, Width, Height: integer): boolean;
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
    CreateSegment(SegNum, NumBlocks, 1, NumBlocks + 5);
    New(SegNum, 4, TmpBuf);

    { copy the windowed area to the temp. buffer }
    RasterOp(RRpl, Width, HeigHt,
     0, 0, ScanLength, Recast(TmpBuf, RasterPtr),
     X, Y, SScreenW, SScreenP);
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
Function GetPicture(FileName: string;
       X, Y: integer; var Width, Height: integer; 
       DestSLine: integer; DestBase: RasterPtr): boolean;
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

Function GetFastPicture(FileName: string;
       var Width, Height, ScanLength: integer;
       var DestBase: RasterPtr): boolean;

  var SegNum, BlockCount: integer;
      TmpBuf: pDirBlk;
      fid: FileID;
      dum, zilch, i: integer;
  begin
  GetFastPicture := false;
  fid := FSLookUp(FileName, blockCount, zilch);
  if fid = 0 then
    Writeln('** GetPicture: Lookup failure on ', FileName)
  else
    begin
    CreateSegment(SegNum, blockCount, 1, blockCount);
    TmpBuf := MakePtr(SegNum, 0, pDirBlk);
    MultiRead(fid, TmpBuf, 0, blockCount);
    Width := TmpBuf^.Buffer[0];
    Height := TmpBuf^.Buffer[1];
    ScanLength := LAnd(Width + 63, LNot(#77)) div 16;
    DestBase := MakePtr(SegNum, 256, RasterPtr);
    if ScanLength <> TmpBuf^.Buffer[2] then
      begin
      Writeln('** GetFastPicture: Scanlength error');
      WriteLn('   Width is ',width:1,' so ScanLength should be ',ScanLength:1, ' but is ', TmpBuf^.Buffer[2]:1);
      DecRefCount(SegNum);
      exit(GetFastPicture);
      end;
    if TmpBuf^.Buffer[3] <> blockCount-1 then
      begin
(*******
      Writeln('** GetFastPicture: Expected ', TmpBuf^.Buffer[3]:1, ' blocks. File has ', blockCount-1:1, ' blocks.');
      WriteLn('   Continuing');
********)
      end;

    GetFastPicture := true;
    end;
  end;
  
function Sqroot( X: Integer ): Integer;
  var V, I: integer;
  begin { Sqroot }
    V := 0;
    I := 128;
    while I <> 0 do
      begin
        if (V + I <= 180) and ((V + I) * (V + I) <= X) then V := V + I;
        I := I div 2
      end;
    Sqroot := V
  end { Sqroot }.
