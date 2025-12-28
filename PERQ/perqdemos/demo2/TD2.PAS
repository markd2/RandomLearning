module td2;
exports
procedure bounce3;
procedure spheres;
procedure testpattern;

private
imports td from td;
procedure bounce3;
const N=20;
type tcircle = array[0..200] of integer;
var i, j, a, b, d, x0, y0, t: integer;
    x, y, vx, vy:array[0..N] of integer;
    circle: ^tcircle;
    l0, VAi, VPi, VAj, VPj: Integer;
    OldVSq: Integer;
begin
    new(0,4,circle);
    rasterop(6, 20, 20, 0, 0, 4, circle, 0, 0, 4, circle);
    for i:=1 to 9 do begin
        j:=sqroot(10*10-i*i)+1;
        rasterop(7, 2*i, 2*j, 10-i, 10-j, 4, circle, 10-i, 10-j, 4, circle);
        rasterop(7, 2*j, 2*i, 10-j, 10-i, 4, circle, 10-j, 10-i, 4, circle)
    end;
    clearscreen;
    for i:=0 to N do begin
        x[i]:=r(0, 767-20);
        y[i]:=r(0, 1023-20);
        vx[i]:=r(-6, 6);
        vy[i]:=r(-6, 6);
        rasterop(6, 20, 20, x[i], y[i], 48, screenp, 0, 0, 4, circle)
    end;
    while not keyhit do begin
        for i:=0 to N do begin
            x0:=x[i];
            y0:=y[i];
            x[i]:=x[i]+vx[i];
            if x[i]<0 then begin
                x[i]:=-x[i];
                vx[i]:=-vx[i]
            end else if x[i]>767-20 then begin
                x[i]:=2*(767-20)-x[i];
                vx[i]:=-vx[i]
            end;
            y[i]:=y[i]+vy[i];
            if y[i]<0 then begin
                y[i]:=-y[i];
                vy[i]:=-vy[i]
            end else if y[i]>1023-20 then begin
                y[i]:=2*(1023-20)-y[i];
                vy[i]:=-vy[i]
            end;
            rasterop(6, 20, 20, x0, y0, 48, screenp, 0, 0, 4, circle);
            rasterop(6, 20, 20, x[i], y[i], 48, screenp, 0, 0, 4, circle)
        end;
        for i:=0 to N do begin
            for j:=i+1 to N do begin
                OldVSq := x[i]*x[i] + y[i]*y[i] + x[j]*x[j] + y[j]*y[j];
                x0:=x[i]-x[j];
                y0:=y[i]-y[j];
                if (abs(x0)<20) and (abs(y0)<20) and (x0*x0+y0*y0<20*20) then
                begin
                    l0 := SqRoot(x0*x0+y0*y0);
                    VAi := (vx[i]*x0 + vy[i]*y0) div l0;
                           { component along axis }
                    VPi := (vx[i]*y0 - vy[i]*x0) div l0;
                           { component perpendicular to axis }
                    VAj := (vx[j]*x0 + vy[j]*y0) div l0;
                           { component along axis }
                    VPj := (vx[j]*y0 - vy[j]*x0) div l0;
                           { component perpendicular to axis }
                    t := VAi;   { bounce }
                    VAi := VAj;
                    VAj := t;
                    vx[i] := (VAi * x0 + VPi * y0) div l0;
                    vy[i] := (VAi * y0 - VPi * x0) div l0;
                    vx[j] := (VAj * x0 + VPj * y0) div l0;
                    vy[j] := (VAj * y0 - VPj * x0) div l0;
                    {
                    repeat
                        t := OldVSq - x[i]*x[i]+y[i]*y[i]+x[j]*x[j]+y[j]*y[j];
                        if t > 0 then
                           begin
                             if vx[i] >= 0 then vx[i] := vx[i] + 1
                             else vx[i] := vx[i] - 1;
                             t := t - 1
                           end;
                        if t > 0 then
                           begin
                             if vy[i] >= 0 then vy[i] := vy[i] + 1
                             else vy[i] := vy[i] - 1;
                             t := t - 1
                           end;
                        if t > 0 then
                           begin
                             if vx[j] >= 0 then vx[j] := vx[j] + 1
                             else vx[j] := vx[j] - 1;
                             t := t - 1
                           end;
                        if t > 0 then
                           begin
                             if vy[j] >= 0 then vy[j] := vy[j] + 1
                             else vy[j] := vy[j] - 1;
                             t := t - 1
                           end
                    until true
                    }
                end
            end
        end
    end
end;
procedure spheres;
const NX=48;
      NY=-36;
      NZ=80;
      {$I TD.Dfs}
type ScreenLine = array[0..47] of packed array[0..15] of Boolean;
     WholeScreen = array[0..0] of ScreenLine;
     pWholeScreen = ^WholeScreen;
var done: boolean;
    Screen: pWholeScreen;

procedure sphere(x0, y0, rad:integer);
var i, x, y, z, zsq, P1, P2: integer;
begin
    for y:=-rad to rad do begin
        if not done then begin
            P1 := Rad*Rad - y*y;
            P2 := Ny * y;
            done:=keyhit;
            for x:=-rad to rad do begin
               zsq:=P1 - x*x;
               if zsq>=0 then begin
                   LoadExpr(ZSq);
                   LoadExpr(LOr(Shift(Sqrt,8),Shift(Sqrt,-8)));
                   InLineByte(191 {JCS});
                   StorExpr(Z);
                   i:=Nx*x+P2+NZ*Z;
                   LoadExpr(r(0,Rad*100)>i);
                   LoadExpr(X + X0);
                   LoadExpr(Y + Y0);
                   LoadAdr(ScreenP);
                   InLineByte(239 {LDDW});
                   LoadExpr(LOr(Shift(SetDot,8),Shift(SetDot,-8)));
                   InLineByte(228 {TLATE1});
                   InLineByte(191 {JCS})
               end
           end
       end
    end
end;

begin
    clearscreen;
    Screen := Recast(ScreenP, pWholeScreen);
    done:=false;
    while not done do
        sphere(r(180, 767-180), r(180, 1023-180), r(50, 180))
end;
procedure testpattern;
var i, j: integer;
begin
    clearscreen;
    i:=1;
    j:=1;
    while i<384 do begin
        rasterop(1, 2*i, 2*i+256, 384-i, 384-i, 48, screenp,
                                  384-i, 384-i, 48, screenp);
        j:=j+1;
        i:=i+j
    end;
    while not keyhit do
end.

