Program StartDemo;

{ StartDemo -- move a window from one position to another.
  
  Three Rivers Computer Corporation
  Pittsburgh, Pa. 15213
  
  Written by: Brad Myers
}

Imports XScreen from XScreen;
Imports SigUtils from SigUtils;
Imports MultiRead from MultiRead;
Imports FileSystem from FileSystem;
Imports Memory from Memory;
Imports IO_Others from IO_Others;
Imports Sleep from Sleep;

var MinX, MinY, Width, Height: integer;
    WinNum: integer;
    i,j,k: integer;
    win: WinRange;
    seg, blks, bits: integer;
    fid: FileID;
    
Procedure ParseCmds;
  var Fn: string;
  begin
  if ArgCount <> 3 then
    begin
    Writeln('** Usage: StartDemo window# fileOfCurs');
    Exit(StartDemo);
    end;
  NextArgStr(Fn); {flush StartDemo}
  NextArgInt(WinNum);
  win := WinNum;
  NextArgStr(Fn);
  
  fid := FSLookUp(Fn,blks, bits);
  if fid = 0 then begin
                  WriteLn('** File not found');
                  exit(StartDemo);
                  end;
  CreateSegment(seg, blks, 1, blks);
  MultiRead(fid, MakePtr(seg, 0, pDirBlk), 0, blks);
  end;


begin

ParseCmds;

ChangeWindow(Win);
XSGetUseWindow(win, MinX, MinY, Width, Height);

MinX := MinX + (Width-56) div 2;
MinY := MinY + (Height-64) div 2;

ChangeWindow(0);

IOLoadCursor(MakePtr(seg, 0, CurPatPtr), 0, 0);
IOSetCursorPos(MinX, MinY);
IOCursorMode(IndepCursor);

Nap(30);

for i := 1 to blks-1 do
  begin
  IOLoadCursor(MakePtr(seg, i*256, CurPatPtr), 0, 0);
  for k := 1 to 15000 do;
  end;

Sleep(2);
IOCursorMode(offCursor);

end.


