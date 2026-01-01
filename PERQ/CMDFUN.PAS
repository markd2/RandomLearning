program CmdFun;

{ play with the CmdParser }

imports CmdParse from CmdParse;
imports System from System;  { UsrCmdLine }

const
    programName = 'CmdFun';


procedure Usage;
begin
    Writeln(programName, ': thing1 thing2');
    Writeln('    Greeblebork the flongwazzle from thing1 to thing2');
    Writeln('    Unless it''s a thursday');
    exit(CmdFun);
end; { Usage }


procedure TwoFiles(var thing1, thing2: String);
var
    appname: CString;
    isSwitch: Boolean;  { unused }
    ch: Char;
begin
   ch := NextId(appname, isSwitch);  { consume application name }
   if ch = CCR then Usage; { got app name but no files }
   
   ch := NextId(thing1, isSwitch);
   if ch = CCR then Usage; { got file1, but ran out before getting file2 }
   
   ch := NextId(thing2, isSwitch);
   if ch <> CCR then Usage;  { got file1 and file2, but there's still more }

end; { TwoFiles}


var
    cmdId: CString;
    isSwitch: Boolean;
    ch: Char;
    file1, file2: String;
    
begin {main}
   Writeln(UsrCmdLine);
   TwoFiles(file1, file2);
   
   Writeln('WOOT!  Got ', file1, ' and ', file2);   
end.
