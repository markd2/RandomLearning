program Soli;

imports Util from Util;
imports Card from Card;
imports Geom from Geom;
imports GrafUtil from GrafUtil;
imports CardView from CardView;
imports IO_Others from IO_Others; { IOReadTablet }
imports IO_Unit from IO_Unit; { IOCRead }
imports IOErrors from IOErrors; { IOEIOC }
imports FileUtils from FileUtils; { FSAddToTitleLine }

const
    CardWidth = 40;
    CardHeight = 56;  { 1:1.4 ratio }
    CardCount = 35;
    CardsPerColumn = 6;

type
    MouseButton = (LeftButton, MiddleButton, RightButton, BottomButton);
   

var
    fullDeck: Deck;
    i: Integer;
    views: array[1..CardCount] of CardView;
    shouldQuit: Boolean;
    selectedIndex: Integer; { -1 for unselected }
    x, y: Integer { card layout }


procedure MouseMove(pointer: GPoint);
var
    i: Integer;
    underPointerIndex: Integer;
begin
    underPointerIndex := -1;
    
    for i := 1 to CardCount do begin
        if PointInRect(pointer, views[i].rect) then begin
            underPointerIndex := i;
        end;
    end;
    
    if underPointerIndex <> selectedIndex then begin
        if underPointerIndex <> -1 then begin
            views[underPointerIndex].isHighlighted := True;
            DrawCard(views[underPointerIndex]);
        end;
        if selectedIndex <> -1 then begin
            views[selectedIndex].isHighlighted := False;
            DrawCard(views[selectedIndex]);
        end;
        selectedIndex := underPointerIndex;
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


procedure Keypress(ch: Char);
begin
    if (ch = 'q') or (ch = 'Q') then exit(Soli);
end;


procedure EventLoop;
var
    pointer: GPoint;
    lastPoint: GPoint;
    ch: Char;
begin
    lastPoint.x := -1; lastPoint.y := -1;
    
    shouldQuiet := False;
    while not shouldQuit do begin
        if IOCRead(TransKey, ch) = IOEIOC then begin
            Keypress(ch);
        end;
        
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
    FSAddToTitleLine('Soli - press ''q'' to quit');
    IOSetModeTablet(RelTablet);
    IOCursorMode(TrackCursor);
    selectedIndex := -1;
    
    fullDeck := MakeFullDeck;
    
    x := 45;
    y := 60;
    for i := 1 to CardCount do begin
        with views[i] do begin
            card := fullDeck[i];
            rect.origin.x := x;
            rect.origin.y := y;
            rect.size.width := CardWidth;
            rect.size.height := CardHeight;
            isHighlighted := False;
        end;
        y := y + 60;
        if i mod CardsPerColumn = 0 then begin
            x := x + 55;
            y := 60;
        end;
    end;
    
    RenderCards;
    
    EventLoop;
end.
