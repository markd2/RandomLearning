program Soli;

imports Util from Util;
imports Card from Card;
imports Geom from Geom;
imports GrafUtil from GrafUtil;
imports CardView from CardView;
imports IO_Others from IO_Others; { IOReadTablet }
imports FileUtils from FileUtils; { FSAddToTitleLine }

const
    CardWidth = 40;
    CardHeight = 56;  { 1:1.4 ratio }

type
    MouseButton = (LeftButton, MiddleButton, RightButton, BottomButton);
   

var
    fullDeck: Deck;
    i: Integer;
    views: array[1..5] of CardView;
    shouldQuit: Boolean;


procedure MouseMove(pointer: GPoint);
begin
    Writeln('mouse move to ', pointer.x, pointer.y);
end;


procedure MouseClick(pointer: GPoint; button: MouseButton);
begin
    case button of
        LeftButton: Writeln('Left button');
        MiddleButton: Writeln('Middle button');
        RightButton: Writeln('Right button');
        BottomButton: Writeln('Bottom button');
    end;
end;



procedure EventLoop;
var
    pointer: GPoint;
    lastPoint: GPoint;
begin
    lastPoint.x := -1; lastPoint.y := -1;
    
    shouldQuiet := False;
    while not shouldQuit do begin
        IOReadTablet(pointer.x, pointer.y);
        
        if not EqualPoints(pointer, lastPoint) then begin
            MouseMove(pointer);
            if TabWhite then MouseClick(pointer, LeftButton);
            if TabGreen then MouseClick(pointer, RightButton);
            if TabYellow then MouseClick(pointer, MiddleButton);
            if TabBlue then MouseClick(pointer, BottomButton);
        end;
        lastPoint := pointer;
        
    end;
end; { EventLoop }


    
procedure RenderCards;
var
    i: Integer;
begin
    for i := 1 to 5 do begin
        DrawCard(views[i]);
    end;
end; { RenderCards }
             

begin
    writeln(chr(12));
    FSAddToTitleLine('Soli');
    IOSetModeTablet(RelTablet);
    IOCursorMode(TrackCursor);
    
    fullDeck := MakeFullDeck;
    
    for i := 1 to 5 do begin
        with views[i] do begin
            card := fullDeck[i];
            rect.origin.x := i * 30;
            rect.origin.y := i * 45;
            rect.size.width := CardWidth;
            rect.size.height := CardHeight;
            isHighlighted := i = 3;
        end;
    end;
    
    RenderCards;
    
    EventLoop;
end.
