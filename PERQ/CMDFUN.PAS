program CmdFun;

{ play with the CmdParser }

imports CmdParse from CmdParse;
imports System from System;  { UsrCmdLine }

const
    programName = 'CmdFun';


procedure Error(err: String);
begin
    Writeln(err);
    exit(CmdFun);
end; { Error }



procedure Usage;
begin
    Writeln(programName, ': thing1 thing2');
    Writeln('    Greeblebork the flongwazzle from thing1 to thing2');
    Writeln('    Unless it''s a thursday');
    exit(CmdFun);
end; { Usage }


var
    cmdId: CString;
    isSwitch: Boolean;
    ch: Char;
    file1, file2: String;
    
begin {main}
   Writeln(UsrCmdLine);
   
   ch := NextId(cmdId, isSwitch);  { consume application name }
   if ch = CCR then Usage; { got app name but no files }
   
   ch := NextId(file1, isSwitch);
   if ch = CCR then Usage; { got file1, but ran out before getting file2 }
   
   ch := NextId(file2, isSwitch);
   if ch <> CCR then Usage;  { got file1 and file2, but there's still more }
   
   Writeln('WOOT!  Got ', file1, ' and ', file2);   
end.
