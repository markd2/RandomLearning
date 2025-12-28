Program Snooze;

Imports Sleep from Sleep;
Imports SigUtils from SigUtils;

var SleepVal: integer;

Procedure ParseCmds;
  var Str: string;
  begin
  if ArgCount < 2 then
    begin
    Writeln('Usage: snooze seconds');
    Exit(Snooze);
    end;
  NextArgStr(Str);
  NextArgInt(SleepVal);
  end;

begin

ParseCmds;
Sleep(SleepVal);

end.
