module Geom;

exports

type
    GPoint = record
        x: Integer;
        y: Integer;
    end;
    
    GSize = record
        width: Integer;
        height: Integer;
    end;
    
    GRect = record
        origin: GPoint;
        size: GSize;
    end;
    
function PointInRect(point: GPoint; rect: GRect): Boolean;
    
private

function PointInRect(point: GPoint; rect: GRect): Boolean;
begin
    if (point.x >= rect.origin.x)
       and (point.y >= rect.origin.y)
       and (point.x <= rect.origin.x + rect.size.width)
       and (point.y <= rect.origin.y + rect.size.height) then begin
        PointInRect := True;
    end else begin
        PointInRect := False;
    end;
end. { PointInRect }


