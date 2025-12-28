Program ThreeRCC;

Imports SigUtils from SigUtils;
Imports Screen from Screen;

procedure delay;
  var i,j: integer;
  begin
  for i := 1 to 200 do
    for j := 1 to 500 do;
  end;

procedure ef1(numTimes: integer);
var i, k, m, num: integer;
begin
    CreateWindow(0, 0, 0, 768, 1024, '');
    for i:= 1 to 16 do writeln(' ');
    writeln(
'                                         3R
                                         CC');
    delay;
      for m:=1 to numTimes do
        begin
        for k := 1 to 16 do
              begin
              rasterop(6, 510, 510, 128,   1, SScreenW, SScreenP,
                                    127, 512, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128,   1, SScreenW, SScreenP,
                                    129, 512, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128,   1, SScreenW, SScreenP,
                                    128, 511, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128,   1, SScreenW, SScreenP,
                                    128, 513, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128,   1, SScreenW, SScreenP,
                                    128, 512, SScreenW, SScreenP);

              rasterop(6, 510, 510, 128, 512, SScreenW, SScreenP,
                                    127,   1, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128, 512, SScreenW, SScreenP,
                                    129,   1, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128, 512, SScreenW, SScreenP,
                                    128,   0, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128, 512, SScreenW, SScreenP,
                                    128,   2, SScreenW, SScreenP);
              rasterop(6, 510, 510, 128, 512, SScreenW, SScreenP,
                                    128,   1, SScreenW, SScreenP);
              end;
       end;
  delay;
  end;

var numTimes: integer;
    str: String;
    
begin

If ArgCount <> 2 then
   begin
   WriteLn('** Usage: 3RCC numTimes');
   exit(ThreeRCC);
   end;

NextArgStr(str);  {flush 3RCC}
NextArgInt(numTimes);

EF1(numTimes);

SSetCursor(5, 1000);
end.


