Program MakeNames;
{----------------------------------------------------------------------------
  Written by Brad Myers  July 24, 1981
  
  Copyright (C) 1981 - The Three Rivers Computer Corporation

  Abstract:
        This program creates a file that can be read directly into memory and
        used as the argument to PopUp
----------------------------------------------------------------------------}

{----------------------------------------------------------------------------
  Change log:
      24-Jul-81  V1.0  Brad Myers  Created
----------------------------------------------------------------------------}

Imports PopUp from PopUp;
Imports FileSystem from FileSystem;
Imports Memory from Memory;

var fn: String;
    f: Text;
    seg: integer;
    fid: fileID;
    i,blkCount: integer;
    names: pNameDesc;
    s: s25;
    
{$R-}
begin
Write('File of names to input: ');
readln(fn);
Reset(f, fn);
CreateSegment(seg, 30, 1, 30); {that's enough room for 589 names}
names := MakePtr(seg, 0, pNameDesc);
ReadLn(f, names^.header);
i := 0;
while not eof(f) do
   begin
   ReadLn(f, s);
   i := i+1;
   names^.commands[i] := s;
   end;
if i > 589 then WriteLn('*** TOO MANY NAMES.  PLEASE BOOT NOW!!! ****');
blkcount := (1 + WordSize(s25) + i*wordSize(s25) + 255) div 256;
WriteLn('Found ',i:1,' names which requires ',blkCount:1,' blocks.');
names^.numCommands := i;

WriteLn;
Write('Output file name: ');
ReadLn(fn);
fid := FSEnter(fn);
for i := 0 to blkCount - 1 do
   FSBlkWrite(fid, i, MakePtr(seg, i*256, pDirBlk));
FSClose(fid, blkCount, 4096);
WriteLn('Done.');
end.

