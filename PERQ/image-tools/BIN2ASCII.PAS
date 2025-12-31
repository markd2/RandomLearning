program BIN2ASCII;
{ takes the input file, and emits a text file of the bytes of the input file.
  This should allow it to be transmitted out of perqEmu to the Mac, where it
  can be re-hydrated and examined (especially things like picture files,
  cursors, fonts, etc }
  
imports Memory from Memory; { CreateSegment }
imports FileSystem from FileSystem; { FSLookUp }
imports MultiRead from MultiRead; { MultiRead }


const
    filename = '3rcc.pic';
    outputFilename = 'snork.txt';
type
    Byte = 0..255;
    ByteArray = packed array[0..17000] of Byte;
    BytePointer = ^ByteArray;
var
    fid: FileID;
    blocks, bits: Integer;
    seg: Integer;
    totalBytes: Integer;
    byteScan: BytePointer;
    blockPtr: pDirBlk;
    i: Integer;
    outfile: Text;
begin
    fid := FSLookUp(filename, blocks, bits);
    if fid = 0 then begin
        Writeln('oops, no file named ', filename);
    end else begin
        CreateSegment(seg, blocks, 1, blocks);  { allocate }
        blockPtr := MakePtr(seg, 0, pDirBlk);
        MultiRead(fid, blockPtr, 0, blocks);
        Writeln('got stuff?', blocks, bits);
        totalBytes := (blocks - 1) * 512 + (bits div 8);
        Writeln('total bytes ', totalBytes);
        byteScan := recast(blockPtr, BytePointer);
        rewrite(outfile, outputFilename);
        for i := 0 to totalBytes - 1 do begin
            writeln(outfile, byteScan^[i]);
        end;
        close(outfile);
    end;
end.
