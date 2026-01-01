program BIN2ASCII;
{ takes the input file, and emits a text file of the bytes of the input file.
  This should allow it to be transmitted out of perqEmu to the Mac, where it
  can be re-hydrated and examined (especially things like picture files,
  cursors, fonts, etc }
  
imports Memory from Memory; { CreateSegment }
imports FileSystem from FileSystem; { FSLookUp }
imports MultiRead from MultiRead; { MultiRead }
imports CmdParse from CmdParse; { NextId }
imports System from System; { UsrCmdLine }


const
    filename = '3rcc.pic';
    outputFilename = 'snork.txt';
type
    Byte = 0..255;
    ByteArray = packed array[0..20000] of Byte;
    BytePointer = ^ByteArray;
var
    binaryInputFilename: String;
    asciiOutputFilename: String;
    fid: FileID;
    blocks, bits: Integer;
    seg: Integer;
    totalBytes: Integer;
    byteScan: BytePointer;
    blockPtr: pDirBlk;
    i: Integer;
    outfile: Text;

(* ---------- *)
const programName = 'bin2ascii';

procedure Usage;
begin
    Writeln(programName, ': binary-input ascii-output');
    Writeln('    Converts the binary input file into a byte-per-line ascii file');
    exit(BIN2ASCII);
end; { Usage }

procedure TwoFiles(var thing1, thing2: String);
var
    appname: CString;
    isSwitch: Boolean;  { unused }
    ch: Char;
begin
    ch := NextId(appname, isSwitch);  { consume application name }
    if ch = CCR then Usage;  { got app name, but no files }
    
    ch := NextId(thing1, isSwitch);
    if ch = CCR then Usage;  { got file1, but ran out before getting file2 }
    
    ch := NextId(thing2, isSwitch);
    if ch <> CCR then Usage;  { got file1 and file2m but still more stuff }
    
end; { TwoFiles }

(* ---------- *)


begin
    TwoFiles(binaryInputFilename, asciiOutputFilename);

    fid := FSLookUp(binaryInputFilename, blocks, bits);
    if fid = 0 then begin
        Writeln('** Could not open file named ', binaryInputFilename);
    end else begin
        CreateSegment(seg, blocks, 1, blocks);  { allocate }
        blockPtr := MakePtr(seg, 0, pDirBlk);
        MultiRead(fid, blockPtr, 0, blocks);
        totalBytes := (blocks - 1) * 512 + (bits div 8);
        byteScan := recast(blockPtr, BytePointer);
        rewrite(outfile, asciiOutputFilename);
        for i := 0 to totalBytes - 1 do begin
            writeln(outfile, byteScan^[i]:1);
        end;
        close(outfile);
    end;
end.
