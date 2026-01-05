module Events;

exports

imports Geom from Geom;

type
    MouseButton = (LeftButton, MiddleButton, RightButton,
                   BottomButton, NoButton);
    EventType = (Move, Click, Release, Key);
    
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
    lastButton: MouseButton;
    inited: Boolean;

procedure InitEvent;
begin
    lastPoint.x := -1;
    lastPoint.y := -1;
    lastButton := NoButton;
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
        if TabWhite and (lastButton <> LeftButton) then begin
            lastButton := LeftButton;
            GetNextEvent.button := LeftButton;
            exit(GetNextEvent);
        end;
        if TabGreen and (lastButton <> RightButton) then begin
            lastButton := RightButton;
            GetNextEvent.button := RightButton;
            exit(GetNextEvent);
        end;
        if TabYellow and (lastButton <> MiddleButton) then begin
            lastButton := MiddleButton;
            GetNextEvent.button := MiddleButton;
            exit(GetNextEvent);
        end;
        if TabBlue and (lastButton <> BottomButton) then begin
            lastButton := BottomButton;
            GetNextEvent.button := BottomButton;
            exit(GetNextEvent);
        end;
        if (lastButton <> NoButton) and (not TabSwitch) then begin
            GetNextEvent.eType := Release;
            GetNextEvent.button := lastButton;
            lastButton := NoButton;
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
