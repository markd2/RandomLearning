Program Tetra;

Imports SigUtils from SigUtils;
Imports XScreen from XScreen;
Imports SaveWindow from SaveWindow;
Imports FastRandom from FastRandom;

Const maxBalls = 40;

procedure DoTetra(win: WinRange; n, numTimes: integer);
const MAXN=300;
var dx, dy:array[1..4] of integer;
    x, y:array[1..MAXN] of array[1..4] of integer;
    i, j, k, l, num: integer;
    first: boolean;
    leftX, topy, w, h: integer;
begin
    if n<1 then n:=1 else if MAXN<n then n:=MAXN;

    ChangeWindow(win);
    XSGetUseWindow(win,leftx, topy, w, h);
    Write(FF);

    for i:=1 to 4 do begin
        x[n][i]:=RandomRange(leftx, leftx+w-1);
        y[n][i]:=RandomRange(topy, topy+h-1);
        dx[i]:=RandomRange(3, 6);
        dy[i]:=RandomRange(3, 6)
    end;
    first:=true;
    l:=n;
    for num := 1 to numTimes do begin
        for k:=1 to n do begin
            if not first then for i:=1 to 4 do
                for j:=1 to (i-1) do
                   Line(XorLine, x[k][i], y[k][i], x[k][j], y[k][j], SScreenP);
            for i:=1 to 4 do begin
                x[k][i]:=x[l][i]+dx[i];
                if (x[k][i]<leftX) or (leftX+w-1<=x[k][i]) then begin
                    x[k][i]:=x[k][i]-2*dx[i];
                    dx[i]:=-dx[i]
                end;
                y[k][i]:=y[l][i]+dy[i];
                if (y[k][i]<topY) or (topY+h-1<=y[k][i]) then begin
                    y[k][i]:=y[k][i]-2*dy[i];
                    dy[i]:=-dy[i]
                end;
                for j:=1 to (i-1) do
                   Line(XorLine, x[k][i], y[k][i], x[k][j], y[k][j], SScreenP)
            end;
            l:=k
        end;
        first:=false
    end
end; {DoTetra}

var i, numLines, numTimes: integer;
    win: WinRange;
    str: String;
    save: Boolean;
    
begin

If ArgCount <> 5 then
   begin
   WriteLn('** Usage: Tetra win# save numLine numTimes');
   exit(Tetra);
   end;

NextArgStr(str);  {flush bounce}
NextArgInt(i);
win := i;
NextArgInt(i);
save := RECAST(i, boolean);
NextArgInt(numLines);
if numLines < 4 then
  begin
  WriteLn('** Need at least 4 lines.');
  exit(Tetra);
  end;

NextArgInt(numTimes);

if save then SaveAndRestoreWindow(win, 'Tetra')
else XSRedrawWindow(win, 'Tetra');

SetUpRandom;
DoTetra(win, numLines, numTimes);

end.


