program Soli;

imports Util from Util;
imports Card from Card;
imports Geom from Geom;
imports GrafUtil from GrafUtil;

var
    fullDeck: Deck;
    i: Integer;
    
procedure Splunge;
var
    x: Integer;
    y: Integer;
    rect: GRect;
begin
    x := 10;
    while x < 500 do begin
        y := 80;
        while y < 600 do begin
            with rect do begin
                origin.x := x;
                origin.y := y;
                size.width := 40;
                size.height := 55;
            end;
            StrokeRect(rect);
            y := y + 120;
        end;
        x := x + 77;
    end;
end; { Splunge }
             

begin
    fullDeck := MakeFullDeck;
    
    for i := 1 to 52 do begin
        writeln(ord(fullDeck[i].rank), ord(fullDeck[i].suit));
    end;
    
    
    writeln('aces ', ord(Aces), ' kings ', ord(Kings));
    Snorgle;
    Splunge;
end.
