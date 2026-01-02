program Soli;

imports Util from Util;
imports Card from Card;

var
    fullDeck: Deck;
    i: Integer;

begin
    fullDeck := MakeFullDeck;
    
    for i := 1 to 52 do begin
        writeln(ord(fullDeck[i].rank), ord(fullDeck[i].suit));
    end;
    
    
    writeln('aces ', ord(Aces), ' kings ', ord(Kings));
    Snorgle;
end.
