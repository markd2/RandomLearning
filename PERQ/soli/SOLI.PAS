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
    CardCount = 5;

type
    MouseButton = (LeftButton, MiddleButton, RightButton, BottomButton);
   

var
    fullDeck: Deck;
    i: Integer;
    views: array[1..CardCount] of CardView;
    shouldQuit: Boolean;
    selectedIndex: Integer; { -1 for unselected }


procedure MouseMove(pointer: GPoint);
var
    i: Integer;
    unhilight: Boolean;
begin
    unhilight := True;
    for i := 1 to CardCount do begin
        if PointInRect(pointer, views[i].rect) then begin
            unhilight := False;
        end;
        if PointInRect(pointer, views[i].rect) and (selectedIndex <> i) then begin
            if selectedIndex <> -1 then begin
                views[selectedIndex].isHighlighted := False;
                DrawCard(views[selectedIndex]);
            end;
            views[i].isHighlighted := True;
            selectedIndex := i;
            DrawCard(views[i]);
        end;
    end;
    if unhilight and (selectedIndex <> -1) then begin
        views[selectedIndex].isHighlighted := False;
        DrawCard(views[selectedIndex]);
    end;
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
    for i := 1 to CardCount do begin
        DrawCard(views[i]);
    end;
end; { RenderCards }
             

begin
    writeln(chr(12));
    FSAddToTitleLine('Soli');
    IOSetModeTablet(RelTablet);
    IOCursorMode(TrackCursor);
    selectedIndex := -1;
    
    fullDeck := MakeFullDeck;
    
    for i := 1 to CardCount do begin
        with views[i] do begin
            card := fullDeck[i];
            rect.origin.x := i * 45;
            rect.origin.y := i * 66;
            rect.size.width := CardWidth;
            rect.size.height := CardHeight;
            isHighlighted := False;
        end;
    end;
    
    RenderCards;
    
    EventLoop;
end.
