module CardView;

exports

imports Geom from Geom;
imports GrafUtil from GrafUtil;
imports Card from Card;


type
    CardView = record
        card: CardRec;
        rect: GRect;
        isHighlighted: Boolean;
    end;
    
procedure DrawCard(var cv: CardView);

private

procedure DrawCard(var cv: CardView);
var
    highlightRect: GRect;
begin
    EraseRect(cv.rect);
    StrokeRect(cv.rect);
    if cv.isHighlighted then begin
        highlightRect := RectInset(cv.rect, 2, 3);
        StrokeRect(highlightRect);
    end;
end. { DrawCard }


