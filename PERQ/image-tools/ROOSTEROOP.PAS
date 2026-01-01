program Rooster_Oop;

imports Raster from Raster;
imports FileSystem from FileSystem; { pDirBlk, FileID }
imports MultiRead from MultiRead; { MultiRead }
imports Memory from Memory; { CreateSegment, MakePtr }
imports Screen from Screen; { SScreenW, SScreenP }
imports CmdParse from CmdParse; { NextId }
imports System from System; { UsrCmdLine }


{ stuff from SIGUTILS }

const
    BlockSize = 256;
    NumBlocks = 64;

type
    Block = array[0..BlockSize - 1] of Integer;
    PicBuffer = array[1..NumBlocks] of Block;
    pPicBuffer = ^PicBuffer;

{ Adapted by "GetFastPicture" from SIGUTILS.PAS }
function LoadPicture(filename: String;
                     var width, height, scanLength: Integer;
                     var destBase: RasterPtr): Boolean;
var
    segNum, blockCount : Integer;
    tmpBuf: pDirBlk;
    fid: FileID;
    dum, bitsInLastBlock: Integer; { actually unused }
    i : Integer;
begin
    LoadPicture := False;
    fid := FSLookUp(FileName, blockCount, bitsInLastBlock); { actually unused }
    if fid = 0 then begin
        Writeln('** LoadPicture: lookup failure on ', filename);
    end else begin
        CreateSegment(segNum, blockCount, 1, blockCount);
        tmpBuf := MakePtr(segNum, 0, pDirBlk);
        
        {ingest file contents into our buffer}
        MultiRead(fid, tmpBuf, 0, blockCount);
        
        width := tmpBuf^.Buffer[0];
        height := tmpBuf^.Buffer[1];
        
        destBase := MakePtr(segNum, 256, RasterPtr);
        
        { correctness-check scan lenght and file size }
        scanLength := LAnd(width + 63, LNot(#77)) div 16; {63 == #77 == 111111}
        if scanLength <> tmpBuf^.Buffer[2] then begin
            Writeln('** LoadPicture: scanLength error');
            Writeln('   width is ', width:1, ' so scanLength hould be ', scanLength:1, ' but is ', tmpBuf^.Buffer[2]:1);
            DecRefCount(segNum);
            exit(LoadPicture);
        end;
        
        if tmpBuf^.Buffer[3] <> blockCount - 1 then begin
            Writeln('** LoadPicture: expected ', tmpBuf^.Buffer[3]:1, ' blocks. File has ', blockCount-1:1, 'blocks (minus 1)');
            Writeln('   Continuing');
        end;
    
        LoadPicture := True;
    end;
end; { LoadPicture }


procedure DrawRect(x, y, w, h: Integer);
begin
    Line(DrawLine, x, y, x+w, y, SScreenP);
    Line(DrawLine, x, y+h, x+w,   y+h, SScreenP);
    Line(DrawLine, x, y, x, y+h, SScreenP);
    Line(DrawLine, x+w, y, x+w, y+h, SScreenP);
end;

procedure Usage;
begin
    writeln('roosteroop image-file-name');
    Writeln('    displays PIC file');
    exit(Rooster_oop);
end; { Usage }


var
    w, h, scanLen: Integer;
    destination: RasterPtr;  { the stars... }
    imageFilename: String;
    ch: Char;
    isSwitch: Boolean;
    appname: String;

(* MAIN *)
begin
    ch := NextId(appname, isSwitch); { consume application name }
    if ch = CCR then Usage; { got app name, but no file }
    ch := NextId(imageFilename, isSwitch);
    if ch <> CCR then Usage; { got filename, but there's more stuff }
    
    ScreenInit;
    if LoadPicture(imageFilename, w, h, scanLen, destination) then begin
        Writeln('Woo!');
        Writeln('width ', w:1, ' height ', h:1, ' scanlen ', scanLen:1);
    end;
    
    RasterOp(RRpl,
             w, h,
             30, 430,  { destination x/y }
             SScreenW, SScreenP,  { destination line-length and buffer addr }
             0, 0, { source position }
             scanLen, destination);
             
    DrawRect(30-1, 430-1, w+2, h+2);
end.
     
