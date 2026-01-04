module Events;

exports

imports Geom from Geom;

type
    MouseButton = (LeftButton, MiddleButton, RightButton, BottomButton);
    EventType = (Move, Click, Key);
    
    Event = record
        pointer: GPoint;
        case eType: EventType of
            Click: (button: MouseButton);
            Key: (key: Char);
    end;


procedure InitEvent;
function GetNextEvent: Event;


private

imports IO_Others from IO_Others; { IOReadTablet }
imports IO_Unit from IO_Unit; { IOCRead }
imports IOErrors from IOErrors; { IOEIOC }


var
    lastPoint: GPoint;
    inited: Boolean;

procedure InitEvent;
begin
    lastPoint.x := -1;
    lastPoint.y := -1;
    IOSetModeTablet(RelTable);
    IOCursorMode(TrackCursor);
    inited := True;
end;


function GetNextEvent: Event;
var
    pointer: GPoint;
    lastPoint: GPoint;
    ch: Char;
begin
    if not inited then Writeln('Don''t forget to call InitEvent');

    while True do begin
       IOReadTablet(pointer.x, pointer.y);
       GetNextEvent.pointer := pointer;

       if IOCRead(TransKey, ch) = IOEIOC then begin
            GetNextEvent.eType := Key;
            GetNextEvent.key := ch;
            exit(GetNextEvent);
        end;
        
        
        GetNextEvent.eType := Click;
        if TabWhite then begin
            GetNextEvent.button := LeftButton;
            exit(GetNextEvent);
        end;
        if TabGreen then begin
            GetNextEvent.button := RightButton;
            exit(GetNextEvent);
        end;
        if TabYellow then begin
            GetNextEvent.button := MiddleButton;
            exit(GetNextEvent);
        end;
        if TabBlue then begin
            GetNextEvent.button := BottomButton;
            exit(GetNextEvent);
        end;
        
        if not EqualPoints(pointer, lastPoint) then begin
            GetNextEvent.eType := Move;
            lastPoint := pointer;
            exit(GetNextEvent);
        end;

        lastPoint := pointer;
        
    end;
end. { GetNextEvent }
