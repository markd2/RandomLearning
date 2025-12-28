module td1;
exports
procedure localop;
procedure circle2;
procedure bounce2;
procedure fractal;

private
imports td from td;
procedure localop;
const xs=512;
      ys=512;
      x0=128;
      y0=511;
var mask: integer;
begin
    mask:=param;
    clearscreen;
    rasterop(7, 2, 2, 255, 255, 32, screenp, 255, 255, 32, screenp);
    while not keyhit do begin
        rasterop(0, xs, ys, x0, y0, 48, screenp, 0, 0, 32, screenp);
        rasterop(6, 768, 512, 0, 0, 32, screenp, 0, 0, 32, screenp);
        if 0<>land(mask, shift(1, 0)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0-1, y0  , 48, screenp);
        if 0<>land(mask, shift(1, 1)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0-1, y0-1, 48, screenp);
        if 0<>land(mask, shift(1, 2)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0  , y0-1, 48, screenp);
        if 0<>land(mask, shift(1, 3)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0+1, y0-1, 48, screenp);
        if 0<>land(mask, shift(1, 4)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0+1, y0  , 48, screenp);
        if 0<>land(mask, shift(1, 5)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0+1, y0+1, 48, screenp);
        if 0<>land(mask, shift(1, 6)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0  , y0+1, 48, screenp);
        if 0<>land(mask, shift(1, 7)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0-1, y0+1, 48, screenp);
        if 0<>land(mask, shift(1, 8)) then
           rasterop(6, xs, ys, 0, 0, 32, screenp, x0  , y0  , 48, screenp)
    end
end;
procedure circle2;
var x, y, z:integer;
begin
    while not keyhit do begin
        clearscreen;
        for x:=1 to 20 do begin
            y:=random mod 179;
            if y<=0 then y:=y+179;
            z:=1;
            while y*y+z*z<180*180 do z:=z+1;
            rasterop(1, 4*z,4*y,384-2*z,512-2*y,48,screenp,
                                384-2*z,512-2*y,48,screenp);
            z:=random mod 179;
            if z<=0 then z:=z+179;
            y:=1;
            while y*y+z*z<180*180 do y:=y+1;
            rasterop(1, 4*z,4*y,384-2*z,512-2*y,48,screenp,
                                384-2*z,512-2*y,48,screenp)
        end;
        for x:=1 to 32766 do for y:=1 to 2 do
    end
end;
procedure bounce2;
var x, y, vx, vy, z: integer;
begin
    clearscreen;
    x:=0;
    y:=0;
    vx:=4;
    vy:=0;
    while not keyhit do begin
        rasterop(1, 20, 20, x, y, 48, screenp, x, y, 48, screenp);
        x:=x+vx;
        if x>767-20 then begin
            x:=2*(767-20)-x;
            vx:=-vx
        end
        else if x<0 then begin
            x:=-x;
            vx:=-vx
        end;
        vy:=vy+1;
        y:=y+vy;
        if y>1023-20 then begin
            y:=1023-20;
            if vy<20 then vy:=2-vy
            else vy:=vy div 10 - vy;
            if vy=0 then begin
                x:=0;
                y:=0;
                vx:=4;
                vy:=0
            end
        end;
        for z:=0 to 2000 do
    end
end;
procedure fractal;
var i:integer;
    nums: array[0..1023] of integer;
    done: boolean;
function r(n, a, b:integer): integer;
var v:integer;
begin
    v:=nums[n] mod (b-a+1);
    if v<0 then
        r:=v+b+1
    else
        r:=v+a
end;
procedure surf(x0, y0, size, h0, n0, h1, n1, h2, n2, h3, n3: integer);
var h01, n01, h12, n12, h23, n23, h30, n30, hc, nc: integer;
begin
    if not done then begin
        done:=keyhit;
        if size=1 then begin
            LoadExpr(land((h0+h1+h2+h3) div 4, 64)=0);
            LoadExpr(X0);
            LoadExpr(Y0);
            LoadAdr(ScreenP);
            InLineByte(239 {LDDW});
            LoadExpr(LOr(Shift(SetDot,8),Shift(SetDot,-8)));
            InLineByte(228 {TLATE1});
            InLineByte(191 {JCS})
        end else begin
            n01:=(n0+n1) mod 1024;h01:=(h0+h1) div 2+r(n01, -size, size);
            n12:=(n1+n2) mod 1024;h12:=(h1+h2) div 2+r(n12, -size, size);
            n23:=(n2+n3) mod 1024;h23:=(h2+h3) div 2+r(n23, -size, size);
            n30:=(n3+n0) mod 1024;h30:=(h3+h0) div 2+r(n30, -size, size);
            nc:=(n0+n1+n2+n3)mod 1024;
            hc:=(h01+h12+h23+h30) div 4+r(nc, -size, size);
            size:=size div 2;
            surf(x0     , y0     , size, h0, n0, h01, n01, hc, nc, h30, n30);
            surf(x0+size, y0     , size, h01, n01, h1, n1, h12, n12, hc, nc);
            surf(x0+size, y0+size, size, hc, nc, h12, n12, h2, n2, h23, n23);
            surf(x0     , y0+size, size, h30, n30, hc, nc, h23, n23, h3, n3)
        end
    end
end;
begin
    clearscreen;
    done:=false;
    while not done do begin
        for i:=0 to 1023 do nums[i]:=random;
        surf(128, 256, 512, 0, 0, 0, 1, 0, 2, 0, 3)
    end
end.
