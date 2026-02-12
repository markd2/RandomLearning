module GrafUtil;

exports

imports Geom from Geom;

procedure StrokeRect(rect: GRect);

{ doesn't erase the interior of the rect, just the stroked frame }
procedure EraseRect(rect: GRect);


private

imports Raster from Raster;
imports Screen from Screen;

procedure EraseRect(rect: GRect);
begin
    RasterOp(RXor, rect.size.width, rect.size.height,
             rect.origin.x, rect.origin.y, SScreenW, SScreenP,
             rect.origin.x, rect.origin.y, SScreenW, SScreenP);
end; { EraseRect }


procedure StrokeRect(rect: GRect);
begin
    with rect do begin
    Line(DrawLine,
         origin.x, origin.y, origin.x + size.width, origin.y,
         SScreenP);
    Line(DrawLine,
         origin.x, origin.y + size.height, origin.x + size.width, origin.y + size.height,
         SScreenP);
    Line(DrawLine,
         origin.x, origin.y, origin.x, origin.y + size.height,
         SScreenP);
    Line(DrawLine,
         origin.x + size.width, origin.y, origin.x + size.width, origin.y + size.height,
         SScreenP);
    end;

end. { StrokeRect }
