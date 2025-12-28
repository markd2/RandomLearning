Program Bounce;

Imports SigUtils from SigUtils;
Imports XScreen from XScreen;
Imports SaveWindow from SaveWindow;
Imports FastRandom from FastRandom;

Const maxBalls = 40;

Procedure bounce3(win: WinRange; N, numTimes: Integer);
  type tcircle = array[0..200] of integer;
  var num, num1, i, j, a, b, d, x0, y0, t: integer;
    x, y, vx, vy:array[0..maxBalls] of integer;
    circle: ^tcircle;
    leftx, topy, rightx, bottomy,w,h: integer;

    begin
    new(0,4,circle);
    rasterop(6, 20, 20, 0, 0, 4, circle, 0, 0, 4, circle);
    for i:=1 to 9 do
        begin
        j:=sqroot(10*10-i*i)+1;
        rasterop(7, 2*i, 2*j, 10-i, 10-j, 4, circle, 10-i, 10-j, 4, circle);
        rasterop(7, 2*j, 2*i, 10-j, 10-i, 4, circle, 10-j, 10-i, 4, circle)
        end;
    ChangeWindow(win);
    XSGetUseWindow(win,leftx, topy, w, h);
    Write(FF);

    rightx := leftx+w;
    bottomY := topy+h;
    
    for i:=0 to N do
        begin
        x[i]:=RandomRange(leftx, rightx-20);
        y[i]:=RandomRange(topy, bottomy-20);
        vx[i]:=RandomRange(-6, 6);
        vy[i]:=RandomRange(-6, 6);
        rasterop(6, 20, 20, x[i], y[i], SScreenW, SScreenP, 0, 0, 4, circle)
        end;
    for num := 1 to numTimes do
        begin
        for i:=0 to N do
            begin
            x0:=x[i];
            y0:=y[i];
            x[i]:=x[i]+vx[i];
            if x[i]<leftx then begin
                               x[i]:=leftX+leftX-x[i];
                               vx[i]:=-vx[i]
                               end
            else if x[i]>rightx-20 then begin
                                        x[i]:=2*(rightx-20)-x[i];
                                        vx[i]:=-vx[i]
                                        end;
            y[i]:=y[i]+vy[i];
            if y[i]<topy then begin
                              y[i]:=topY+topY-y[i];
                              vy[i]:=-vy[i]
                              end
            else if y[i]>bottomy-20 then begin
                                         y[i]:=2*(bottomy-20)-y[i];
                                         vy[i]:=-vy[i]
                                         end;
            rasterop(6, 20, 20, x0, y0, SScreenW, SScreenP, 0, 0, 4, circle);
            rasterop(6, 20, 20, x[i], y[i], SScreenW, SScreenP,0,0,4,circle)
            end;
        for i:=0 to N do
            begin
            for j:=i+1 to N do
                begin
                x0:=x[i]-x[j];
                y0:=y[i]-y[j];
                if (abs(x0)<20) and (abs(y0)<20) and (x0*x0+y0*y0<20*20) then
                    begin
                    if y0<0 then begin
                                 y0:=-y0;
                                 x0:=-x0
                                 end;
                    if 10*abs(x0)>10*y0 then begin
                                             vx[i]:=-vx[i];
                                             vx[j]:=-vx[j]
                                             end
                    else if 10*y0>12*abs(x0) then begin
                                                  vy[i]:=-vy[i];
                                                  vy[j]:=-vy[j]
                                                  end
                    else if y0>0 then begin
                                      t:=vx[i];
                                      vx[i]:=-vy[i];
                                      vy[i]:=-t;
                                      t:=vx[j];
                                      vx[j]:=-vy[j];
                                      vy[j]:=-t
                                      end
                    else begin
                         t:=vx[i];
                         vx[i]:=-vy[i];
                         vy[i]:=t;
                         t:=vx[j];
                         vx[j]:=-vy[j];
                         vy[j]:=t
                         end
                    end
                end {for j}
        end {for i}
    end; {for num}
  end; {Bounce3}

var i, numBalls, numTimes: integer;
    win: WinRange;
    str: String;
    save: Boolean;
    
begin

If ArgCount <> 5 then
   begin
   WriteLn('** Usage: Bounce win# save numBalls numTimes');
   exit(Bounce);
   end;

NextArgStr(str);  {flush bounce}
NextArgInt(i);
win := i;
NextArgInt(i);
save := RECAST(i, boolean);
NextArgInt(numBalls);
if numBalls > 40 then
  begin
  WriteLn('** Only 40 balls allowed.');
  exit(Bounce);
  end;

NextArgInt(numTimes);

if save then SaveAndRestoreWindow(win, 'Bouncing Balls')
else XSRedrawWindow(win, 'Bouncing Balls');

SetUpRandom;
Bounce3(win, numBalls, numTimes);

end.


