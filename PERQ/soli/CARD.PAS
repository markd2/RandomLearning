module Card;

exports

type
    Suits = (Hearts, Diamonds, Spades, Clubs);
    Ranks = (Aces, Twos, Threes, Fours, Fives, Sixes, Sevens,
             Eights, Nines, Tens, Jacks, Queens, Kings);
    
    CardRec = record
        suit: Suits;
        rank: Ranks;
    end;
    
    Deck = array[1..52] of CardRec;
    
function MakeFullDeck: Deck;


private

function MakeFullDeck: Deck;
var
    s: Suits;
    r: Ranks;
    decq: Deck;
    i: Integer;
begin
    i := 1;
    
    for s := Hearts to Clubs do begin
        for r := Aces to Kings do begin
            with decq[i] do begin
                suit := s;
                rank := r;
            end;
            i := i + 1;
        end;
    end;
    MakeFullDeck := decq;
end. { MakeFullDeck }
