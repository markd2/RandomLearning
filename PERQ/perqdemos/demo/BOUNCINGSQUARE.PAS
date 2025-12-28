Program BouncingSquare;

Imports SigUtils from SigUtils;
Imports XScreen from XScreen;
Imports SaveWindow from SaveWindow;
Imports FastRandom from FastRandom;

procedure bounce2(win: WinRange; squareSize, wait: Integer);
var x, y, vx, vy, z: integer;
    leftx, topy, rightx, bottomy,w,h: integer;
    first: boolean;
begin
    first := true;
    ChangeWindow(win);
    XSGetUseWindow(win,leftx, topy, w, h);
    Write(FF);
    x:=leftX;
    y:=topY;
    vx:=4;
    vy:=0;
    while true do
        begin
        rasterop(RNot, squareSize, squareSize, x, y, SScreenW, SScreenP,
                                               x, y, SScreenW, SScreenP);
        x:=x+vx;
        if x>leftX+w-1-squareSize then
            begin
            x:=2*(leftX+w-1-squareSize)-x;
            vx:=-vx
            end
        else if x<leftX then
            begin
            x:=leftX+(leftx-x);
            vx:=-vx
            end;
        vy:=vy+1;
        y:=y+vy;
        if y>topY+h-1-squareSize then
            begin
            y:=topY+h-1-squareSize;
            if vy<20 then vy:=1-vy
            else vy:=vy div 20 - vy;
            if vy=0 then 
               if first then 
                  begin
                  first := false;
                  x:=leftX;
                  y:=topY;
                  vx:=4;
                  vy:=0;
                  end
               else exit(Bounce2)
            end;
        for z:=0 to wait do
        end
end;

var i, wait, squareSize: integer;
    win: WinRange;
    str: String;
    save: Boolean;
    
begin

If ArgCount <> 5 then
   begin
   WriteLn('** Usage: BouncingSquare win# save squareSize wait');
   exit(BouncingSquare);
   end;

NextArgStr(str);  {flush BouncingSquare}
NextArgInt(i);
win := i;
NextArgInt(i);
save := RECAST(i, boolean);
NextArgInt(squareSize);
NextArgInt(wait);

if save then SaveAndRestoreWindow(win, 'Bouncing Square')
else XSRedrawWindow(win, 'Bouncing Square');

SetUpRandom;
Bounce2(win, squareSize, wait);

end.


