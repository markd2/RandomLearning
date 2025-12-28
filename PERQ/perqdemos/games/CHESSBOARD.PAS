Module ChessBoard;

{
{    CHESSBOARD         Version 1.0
{
{    interactive component of CHESS
{
{
{
{    SIEMENS AG, ZTI SOF 2,  1982
{
{    Dieter Kolb       Tel. (089) 636-2386
{
}

Exports

Type
   Figure  = char;

Procedure InitBoard;
Procedure StartGame;
Procedure ChangePlayer;
Procedure UpdateClock;
Procedure Request(var source,dest: Integer; var Answer: Char);
Procedure DrawFigure(f:Figure; pos:Integer);
Procedure MoveFigure(source,dest: Integer);
Procedure RecordAndMoveFigure(source,dest: Integer; str:string);
Procedure WriteInfo(str: String);
Procedure ClearInfo;
Procedure EndGame;

Private

{$RANGE-}

Imports  Raster  from Raster;
Imports  XScreen from XScreen;
Imports  IO_Others from IO_Others;
Imports  IO_Unit from IO_Unit;
Imports  IOErrors from IOErrors;
Imports  PERQ_String from PERQ_String;
Imports  GetTimeStamp from GetTimeStamp;
Imports  Clock from Clock;

const
   
   WhiteField = '0';
   WRook   = 't';
   BRook   = 'T';
   WKnight = 'p';
   BKnight = 'P';
   WBishop = 'f';
   BBishop = 'F';
   WQueen  = 'd';
   BQueen  = 'D';
   WKing   = 'k';
   BKing   = 'K';
   WPawn   = 'b';
   BPawn   = 'B';
   
   line1 = -21846;
   line2 = 21845;
   OrgX  = 144;
   OrgY  = 83;
   FieldW = 60;
   Boarder= 18;
   ClW   = 112;
   ClH   = 50;
   ClWX  = 115;
   ClWY  = 650;
   ClBX  = ClWX+ClW-2;
   ClBY  = ClWY;
   InfoX = 30;
   InfoY = 40;
   InstrX = 115;
   InstrY = 800;
     
type
   Box     = array[0..63] of array[0..3] of integer;
   BoxPtr  = ^Box;
   Colour  = (white, black);

var
   Field: BoxPtr;
   i,j,x,y:   Integer;
   StdFont,FiguresFont,LettersFont,NumbersFont: FontPtr;
   ContinueFlag: Boolean;
   BoardContent: array[0..63] of Figure;
   ch:    Char;
   MoveNr: Integer;
   PerqColour,Player: Colour;
   RWX,RBX,RWY,RBY: Integer;
   CurTStamp,WTStamp,BTStamp: TimeStamp;



procedure WriteInfo(str: String);
begin
   SSetCursor(InfoX,InfoY);
   SetFont(StdFont);
   Write(str);
end;


procedure ClearInfo;
begin
   SSetCursor(InfoX,InfoY);
   SetFont(StdFont);
   Write('                                                              ');
end;   


procedure ChangePlayer;
begin
   if Player=white then begin
      Player:=black;
      RasterOp(RNot,32,12,ClWX+40,ClWY-24,SScreenW,SScreenP,
                          ClWX+40,ClWY-24,SScreenW,SScreenP);
      RasterOp(RNot,32,12,ClBX+40,ClBY-24,SScreenW,SScreenP,
                          ClBX+40,ClBY-24,SScreenW,SScreenP);
      end                    
   else begin
      Player:=white;
      RasterOp(RNot,32,12,ClWX+40,ClWY-24,SScreenW,SScreenP,
                          ClWX+40,ClWY-24,SScreenW,SScreenP);
      RasterOp(RNot,32,12,ClBX+40,ClBY-24,SScreenW,SScreenP,
                          ClBX+40,ClBY-24,SScreenW,SScreenP);
      end;                    
end {ChangePlayer};


procedure UpdateClock;
var x: TimeStamp;
    delta: Integer;
procedure WriteClock(var x: TimeStamp; xpos,ypos: Integer);
var time: Integer;
    s1: TimeString;
    s2: String[8];
begin
   time := x.Second + x.Minute*60 + x.Hour*3600 + delta;
   x.Hour := time div 3600;
   time := time - x.Hour*3600;
   x.Minute := time div 60;
   x.Second := time - x.Minute*60;
   StampToString(x,s1);
   s2:=SubStr(s1,11,8);
   SetFont(NumbersFont);
   SSetCursor(xpos,ypos);
   write(s2);
   SetFont(StdFont);
end;

begin
   GetTStamp(x);
   delta:=0;
   if x.Second<>CurTStamp.Second then delta:=x.Second-CurTStamp.Second;
   if x.Minute<>CurTStamp.Minute then
      delta:=delta+(x.Minute-CurTStamp.Minute)*60;
   if x.Hour<>CurTStamp.Hour then delta:=delta+(x.Hour-CurTStamp.Hour)*60*60;
   if delta<>0 then begin
      CurTStamp:=x;
      if Player=white then
         WriteClock(WTStamp,ClWX+4,ClWY+44)
      else WriteClock(BTStamp,ClBX+4,ClBY+44);
      end;
end {UpdateClock};


procedure StartGame;
begin              
   MoveNr:=0;
   Player:=white;
   GetTStamp(CurTStamp);
   WTStamp.Hour:=0;
   WTStamp.Minute:=0;
   WTStamp.Second:=0;
   BTStamp.Hour:=0;
   BTStamp.Minute:=0;
   BTStamp.Second:=0;
end {StartGame};


procedure EndGame;
var i,j: Integer;
begin
end {EndGame};



procedure FollowCursor(var x,y: Integer);
begin
   IOReadTablet(x,y);
   if x<OrgX+1 then x:=OrgX+1;
   if x>OrgX+8*FieldW-1 then x:=OrgX+8*FieldW-1;
   if y<OrgY+1 then y:=OrgY+1;
   if y>OrgY+8*FieldW-1 then y:=OrgY+8*FieldW-1;
   IOSetCursorPos(x,y);
end {FollowCursor};  


function FieldColour(x,y:Integer): Colour;
begin
   if odd(x+y) then FieldColour:=white
   else FieldColour:=black;
end {FieldColour};


procedure DrawFigure(f:Figure; pos:Integer);
var xpos,ypos: Integer;
begin
   ypos:=pos div 8;
   xpos:=pos - ypos*8;
   SSetCursor(OrgX+7+xpos*FieldW,OrgY+8+(7-ypos)*FieldW);
   BoardContent[pos]:=f;
   if FieldColour(xpos,ypos)=black then f:=chr(ord(f)+1);
   SetFont(FiguresFont);
   SPutChr(f);
   SetFont(StdFont);
end {DrawFigure};


procedure InitFigures;
begin
   for i:=0 to 63 do BoardContent[i]:=WhiteField;
   DrawFigure(WRook,   0);
   DrawFigure(WKnight, 1);
   DrawFigure(WBishop, 2);
   DrawFigure(WQueen,  3);
   DrawFigure(WKing,   4);
   DrawFigure(WBishop, 5);
   DrawFigure(WKnight, 6);
   DrawFigure(WRook,   7);
   for i:=0 to 7 do
      DrawFigure(WPawn, 8+i);
   DrawFigure(BRook,   56);
   DrawFigure(BKnight, 57);
   DrawFigure(BBishop, 58);
   DrawFigure(BQueen,  59);
   DrawFigure(BKing,   60);
   DrawFigure(BBishop, 61);
   DrawFigure(BKnight, 62);
   DrawFigure(BRook,   63);
   for i:=0 to 7 do
      DrawFigure(BPawn, 48+i);
end {InitFigures};


function Coordinate(x,y: Integer): Integer;
begin
   Coordinate:=(7-(y-OrgY) div FieldW)*8 + (X-OrgX) div FieldW;
end {Coordinate};


procedure MoveFigure(source, dest: Integer);
const KSetSlen = 48;
var   f,oldf: char;
      Trik: record case boolean of
              true: (F: FontPtr);
              false:(Seg,Ofst: Integer)
            end;
begin
   ChangeWindow(0);
   if Player=PerqColour then IOBeep;
   f:=BoardContent[source];
   oldf:=BoardContent[dest];
   DrawFigure(WhiteField,source);
   DrawFigure(f,dest);
   if oldf<>WhiteField then begin
      if Player=white then begin
         with FiguresFont^.Index[ord(oldf)] do
            with Trik do begin
               F:=FiguresFont;
               RasterOp(RRpl,46,46,
                        RWX,RWY,SScreenW,SScreenP,
                        Offset,Line*46,KSetSLen,MakePtr(Seg,Ofst+#404,
                                                            FontPtr));
               end; 
         RWY:=RWY-53;
         if RWY<OrgY then begin
           RWY:=OrgY+8*FieldW-46;
           RWX:=RWX+46;
           end;
         end
      else begin
         with FiguresFont^.Index[ord(oldf)] do
            with Trik do begin
               F:=FiguresFont;
               RasterOp(RRpl,46,46,
                        RBX,RBY,SScreenW,SScreenP,
                        Offset,Line*46,KSetSLen,MakePtr(Seg,Ofst+#404,
                                                            FontPtr));
               end; 
         RBY:=RBY-53;
         if RBY<OrgY then begin
           RBY:=OrgY+8*FieldW-46;
           RBX:=RBX-46;
           end;
         end;
      end;
end {MoveFigure};


procedure RecordMove(str: String; cl: Colour);
begin
   ChangeWindow(2);
   str:=SubStr(str,1,9);
   if str[1]='B' then str[1]:=' ';
   if str[5]='B' then str[5]:=' ';
   if cl=white then begin
      MoveNr:=MoveNr+1;
      Writeln;
      Write(' ',MoveNr:2,': ',str,'     ');
      end
   else
      Write(str);
   ChangeWindow(0);
end {RecordMove};


procedure request(var source,dest: Integer; var Answer: Char);
begin
   source:=-1; dest:=-1; Answer:=' ';
   IOCursorMode(IndepCursor);
   while (dest=-1) and (Answer=' ') do begin
      FollowCursor(x,y);
      if IOCRead(KeyBoard,ch)=IOEIOC then
         if ch=' ' then source:=-1
            else Answer:=ch;
      if TabSwitch then begin
         if source=-1 then
            source:=Coordinate(x,y)
         else dest:=Coordinate(x,y);
         while TabSwitch do FollowCursor(x,y);
         end;
      UpdateClock;
      end;
   IOCursorMode(OffCursor);
   if Answer=chr(#15) then begin
      ChangeWindow(2);
      if PerqColour=black then begin
         PerqColour:=white;
         ChangeTitle('      PERQ     -    Human');
         end
      else begin
         PerqColour:=black;
         ChangeTitle('      Human    -    PERQ');
         end;
      ChangeWindow(0);
      end;
end {Request};
   

procedure RecordAndMoveFigure(source,dest:Integer; str:String);
begin
   MoveFigure(source,dest);
   RecordMove(str,Player);
end {RecordAndMoveFigure};


Procedure InitBoard;

begin
   
   
   RasterOp(RXor,768,1024,0,0,SScreenW,SScreenP,0,0,SScreenW,SScreenP);
   
   StdFont:=GetFont;
   FiguresFont:=XSLoadFont('Chess.Figures');
   LettersFont:=XSLoadFont('Chess.Letters');
   NumbersFont:=XSLoadFont('Chess.Numbers');
   
   SCurOff;

   RasterOp(RXNor,2*Boarder+8*FieldW,Boarder,
                  OrgX-Boarder,OrgY-Boarder,SScreenW,SScreenP,
                  OrgX-Boarder,OrgY-Boarder,SScreenW,SScreenP);
   RasterOp(RXNor,Boarder,Boarder+8*FieldW,
                  OrgX-Boarder,OrgY,SScreenW,SScreenP,
                  OrgX-Boarder,OrgY,SScreenW,SScreenP);
   RasterOp(RXNor,Boarder,Boarder+8*FieldW,
                  OrgX+8*FieldW,OrgY,SScreenW,SScreenP,
                  OrgX+8*FieldW,OrgY,SScreenW,SScreenP);
   RasterOp(RXNor,8*FieldW,Boarder,OrgX,OrgY+8*FieldW,SScreenW,SScreenP,
                  OrgX,OrgY+8*FieldW,SScreenW,SScreenP);
   
   SetFont(LettersFont);
   for i:=0 to 7 do begin
      SSetCursor(OrgX+26+i*FieldW,OrgY-16);
      SPutChr(chr(i+ord('a')));
      SSetCursor(OrgX+26+i*FieldW,OrgY+8*FieldW+2);
      SPutChr(chr(i+ord('a')));
      SSetCursor(OrgX-13,OrgY+(7-i)*FieldW+24);
      SPutChr(chr(i+ord('1')));
      SSetCursor(OrgX+8*FieldW+4,OrgY+(7-i)*FieldW+24);
      SPutChr(chr(i+ord('1')));
      end;

   new(Field);
   for i:=0 to 31 do
      for j:=0 to 3 do begin
         Field^[2*i][j]:=line1;
         Field^[2*i+1][j]:=line2;
      end;

   SetFont(FiguresFont);
   for i:=0 to 3 do
      for j:=0 to 3 do begin
         RasterOp(RRpl,FieldW,FieldW,
                       OrgX+FieldW*(2*j+1),OrgY+FieldW*(2*i),SScreenW,SScreenP,
                       0,0,4,Field);
         RasterOp(RRpl,FieldW,FieldW,
                       OrgX+FieldW*(2*j),OrgY+FieldW*(2*i+1),SScreenW,SScreenP,
                       0,0,4,Field);
      end;
   
   InitFigures;
   RWX := 5;
   RWY := OrgY+8*FieldW-46;
   RBX := 767-5-46;
   RBY := RWY;
   
   RasterOp(RXNor,ClW,2,ClWX,ClWY,SScreenW,SScreenP,
                        ClWX,ClWY,SScreenW,SScreenP);
   RasterOp(RXNor,ClW,2,ClWX,ClWY+ClH-2,SScreenW,SScreenP,
                        ClWX,ClWY+ClH-2,SScreenW,SScreenP);
   RasterOp(RXNor,2,ClH,ClWX,ClWY,SScreenW,SScreenP,
                        ClWX,ClWY,SScreenW,SScreenP);
   RasterOp(RXNor,2,ClH,ClWX+ClW-2,ClWY,SScreenW,SScreenP,
                        ClWX+ClW-2,ClWY,SScreenW,SScreenP);
   RasterOp(RXNor,ClW,2,ClBX,ClBY,SScreenW,SScreenP,
                        ClBX,ClBY,SScreenW,SScreenP);
   RasterOp(RXNor,ClW,2,ClBX,ClBY+ClH-2,SScreenW,SScreenP,
                        ClBX,ClBY+ClH-2,SScreenW,SScreenP);
   RasterOp(RXNor,2,ClH,ClBX+ClW-2,ClBY,SScreenW,SScreenP,
                        ClBX+ClW-2,ClBY,SScreenW,SScreenP);
   RasterOp(RXNor,ClW+ClW-2,2,ClWX,ClWY+20,SScreenW,SScreenP,
                              ClWX,ClWY+20,SScreenW,SScreenP);
   RasterOp(RXNor,ClW,20,ClBX,ClBY,SScreenW,SScreenP,
                         ClBX,ClBY,SScreenW,SScreenP);
   SetFont(NumbersFont);
   SSetCursor(ClWX+4,ClWY+44);
   Write('00:00:00');
   SSetCursor(ClBX+4,ClWY+44);
   Write('00:00:00');
   RasterOp(RXNor,32,24,ClWX+40,ClWY-24,SScreenW,SScreenP,
                        ClWX+40,ClWY-24,SScreenW,SScreenP);
   RasterOp(RXNor,32,12,ClBX+40,ClBY-12,SScreenW,SScreenP,
                        ClBX+40,ClBY-12,SScreenW,SScreenP);
   

   SetFont(StdFont);
   CreateWindow(2,450,615,270,400,'      Human    -    PERQ');
   PerqColour:=black;
   
   ChangeWindow(0);
   
   SSetCursor(InstrX,InstrY);
   SetFont(NumbersFont);
   Writeln('Chess   Version 1.0');
   SetFont(StdFont);
   Writeln;
   Writeln;
   Writeln('      Instruction:');
   Writeln('');
   Writeln('      Move a figure:  Select the figure');
   Writeln('        with the mouse, push yellow button,');
   Writeln('        move the mouse to the destination');
   Writeln('        field, push yellow button again.');
   Writeln('');
   Writeln('      Change sides:  Hit RETURN key');
   Writeln('');
   Writeln('      Print configuration:  Type ''p''');
   Writeln('');
   Writeln('      Change strength of opponent:  Type ''s''');
   Writeln('        and enter number between 1 and 4');
   
   IOSetFunction(CTNormal);
   IOSetModeTablet(relTablet);

end {InitBoard}.
