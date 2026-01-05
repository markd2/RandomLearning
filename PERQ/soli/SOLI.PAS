program Soli;

imports Util from Util;
imports Card from Card;
imports Geom from Geom;
imports GrafUtil from GrafUtil;
imports CardView from CardView;
imports Events from Events;
imports FileUtils from FileUtils; { FSAddToTitleLine }

const
    CardWidth = 40;
    CardHeight = 56;  { 1:1.4 ratio }
    CardCount = 35;
    CardsPerColumn = 6;


var
    fullDeck: Deck;
    i: Integer;
    views: array[1..CardCount] of CardView;
    shouldQuit: Boolean;
    selectedIndex: Integer; { -1 for unselected }
    x, y: Integer; { card layout }
    ev: Event;


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


procedure MouseRelease(pointer: GPoint; button: MouseButton);
begin
    case button of
        LeftButton: Writeln('release Left button');
        MiddleButton: Writeln('release Middle button');
        RightButton: Writeln('release Right button');
        BottomButton: Writeln('release Bottom button');
    end;
end;


procedure Keypress(ch: Char);
begin
    Writeln('keypress: ', ord(ch):1, ' ', ch);
    if (ch = 'q') or (ch = 'Q') then begin
        Writeln('quitting');
        exit(Soli);
    end;
end;

    
procedure RenderCards;
var
    i: Integer;
begin
    for i := 1 to CardCount do begin
        DrawCard(views[i]);
    end;
end; { RenderCards }
             

begin
    shouldQuit := False;
    writeln(chr(12));
    FSAddToTitleLine('Soli - press ''q'' to quit');
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
    
    InitEvent;
    
    while not shouldQuit do begin
        ev := GetNextEvent;
        
        case ev.etype of
            Move: MouseMove(ev.pointer);
            Click: MouseClick(ev.pointer, ev.button);
            Key: Keypress(ev.key);
            Release: MouseRelease(ev.pointer, ev.button);
        end;
    end;
end.
