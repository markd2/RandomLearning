Program JustJust;
{------------------------------------------------------------
  Program for displaying justified text
  
  Copyright (C) 1981 - Three Rivers Computer Corporation
------------------------------------------------------------}


Imports XScreen from XScreen;
Imports Perq_String from Perq_String;
Imports Memory from Memory;
Imports SigUtils from SigUtils;
Imports System from System;
Imports Sleep from Sleep;
Imports CmdParse from CmdParse;
Imports SaveWindow from SaveWindow;

Const
    InitIndentSize = 3;
    Debug = false;
    LeftIndent = 10;
    RightIndent= 5;
    
Type
    BigStr = String[255];

Var
    S,NextWord,KSetName: BigStr;
    LeftX,Wide,NextWide,SpaceCnt,SpaceSize,Extra,KSetId,CurKSet,MaxHi,LastHi,
        MaxKSet,LastKSet,IndentSize,i,x,y: integer;
    MinX, MinY, WinWidth, WinHeight: integer;
    LineWidth: integer;
    SleepVal: integer;
    EOP,Indent,Centering,HadEOLN,Fill: boolean;
    KSet: array[0..9] of FontPtr;
    TmpKSet: FontPtr;
    F: Text;
    save: Boolean;
    win: WinRange;
    c: Char;
    inItalic, inBold, italicThisLine, boldThisLine: boolean;
    
Const CR = Chr(13);
      LF = Chr(10);

Procedure DoWriteLn;
  begin
  XSPutChr(CR);
  XSPutChr(LF);
  end;

Procedure cmdsparse;
  var Str: string;
      ArgC: integer;
      t: integer;
      title: String;
  begin
  ArgC := ArgCount;
  if ArgC < 5 then
    begin
    Writeln('** Usage: just window# save filename sleep [title]');
    Exit(JustJust);
    end;
  NextArgStr(Str);
  NextArgInt(t);
  win := t;
  NextArgInt(t);
  save := RECAST(t, Boolean);
  NextArgStr(S);
  NextArgInt(SleepVal);
  if ArgC > 5 then
     begin
     RemDelimiters(UsrCmdLine, ' ',str);
     Title := UsrCmdLine;
     end
  else title := '';
  XScreenInit;
  XSChangeWindow(win);
  if save then SaveAndRestoreWindow(win, title)
  else XSRedrawWindow(win, title);
  XSPutChr(FF);
  end;
    
begin { JustJust }

cmdsparse;

{ Adjust the margins slightly to fit in the current window }
SReadCursor(LeftX,Y);
LeftX:=LeftX+LeftIndent;
XSGetUseWindow(win, MinX, MinY, WinWidth, WinHeight);
LineWidth := Winwidth - (LeftIndent + RightIndent);

reset(F,S);
NextWord:='';
NextWide:=0;
LastHi:=0;
LastKSet:=0;
Indent:=true;
inItalic := false;
inBold := false;
IndentSize:=InitIndentSize;
Fill:=true;
HadEOLN:=true;
EOP:=false;
Centering:=false;
  KSet[0]:=MakePtr(FontSeg,0,FontPtr);
CurKSet:=0;
for i:=1 to 9 do KSet[i]:=nil;

while not EOF(F) do
    begin   { begin the next line }
    S:='';  { the current line thus far }
    if Indent and (not Centering) then
        Wide:=KSet[CurKSet]^.Index[ord(' ')].Width*IndentSize
    else
        Wide:=0;
    if inItalic then wide := wide+roll+2;
    if inBold then wide := wide+1;
    if Length(NextWord) <> 0 then    { catch the leftovers }
        begin  { remove leading spaces }
        i:=1;
        while NextWord[i] = ' ' do i:=i+1;
        if i <> 1 then
            begin
            NextWide:=NextWide-KSet[CurKSet]^.Index[ord(' ')].Width*(i-1);
            NextWord := SubStr(NextWord,i,Length(NextWord)-i+1)
            end
        end;
    SpaceCnt:=0;
    MaxKSet:=LastKSet;
    MaxHi:=LastHi;
    if KSet[CurKSet]^.Height > MaxHi then
        begin
        MaxKSet:=CurKSet;
        MaxHi:=KSet[CurKSet]^.Height
        end;
    italicThisLine := inItalic;
    boldThisLine := inBold;
    repeat {collect a line}
        if NextWide > LineWidth then
            begin
            WriteLn('** Word Too Long - ''',NextWord,'''');
            NextWord:='';
            NextWide:=0
            end;
        S := Concat(S,NextWord);
        for i:=1 to Length(NextWord) do
            if NextWord[i] = ' ' then SpaceCnt:=SpaceCnt+1;
        Wide:=Wide+NextWide;
        NextWord:='';
        NextWide:=0;
        EOP:=false;  { true when this line is end of paragraph }
        if EOLN(F) or HadEOLN then
            begin
            if (not HadEOLN) and Fill then Get(F) else HadEOLN := false;
            if EOLN(F) or EOF(F) or Centering then   { end of paragraph }
                begin
                if not fill then Get(F);
                EOP:=true;
                NextWord:='';
                NextWide:=0;
                while (not EOF(F)) and (EOLN(F) or (F^ = ' ')) and Fill do
                     Get(F);
                HadEOLN:=true
                end
            else if F^ = '.' then      { got a KSet command Coming }
                begin
                Get(F);
                case F^ of
         '1'..'9':  begin
                    KSetId:=ord(F^) - ord('0');
                    Get(F);
                    while F^ = ' ' do Get(F);
                    KSetName:='';
                    while (F^ <> ' ') and (not EOLN(F)) do
                        begin
                        KSetName[0]:=chr(Length(KSetName)+1);
                        KSetName[length(KSetName)]:=F^;
                        Get(F)
                        end;
                    while not EOLN(F) do Get(F);
                    if KSet[KSetId] <> nil then XSDestroyFont(KSet[KSetId]);
                    KSet[KSetId]:=XSLoadFont(KSetName);
                    if KSet[KSetId] = NIL then
                            WriteLn('** KSet ',KSetName,' not found')
                    end;
          'c','C':  begin
                    Get(F);
                    while F^ = ' ' do Get(F);
                    Centering:=true;
                    if Indent then
                        begin
                        Indent:=false;
                        TmpKSet:=GetFont;
                        Wide:=TmpKSet^.Index[ord(' ')].Width*IndentSize
                        end
                    end;
          's','S':  begin
                    { Skip n lines }
                    i:=0;
                    Get(F);
                    while F^ = ' ' do Get(F);
                    while not EOLN(F) do
                        begin
                        if F^ in ['0'..'9'] then
                            i:=i*10+(ord(F^)-ord('0'))
                        else
                            Writeln('** Bad Numerical Input');
                        Get(F)
                        end;
                    for x:=1 to i do DoWriteLn;
                    SReadCursor(X,Y);
                    SSetCursor(LeftX,Y)
                    end;
          'f','F':  begin
                    Get(F);
                    Fill:=true
                    end;
          'n','N':  begin
                    Get(F);
                    Fill:=false
                    end;
          'i','I':  begin
                    { Set Indentation (# spaces) }
                    IndentSize:=0;
                    Get(F);
                    while F^ = ' ' do Get(F);
                    while not EOLN(F) do
                        begin
                        if F^ in ['0'..'9'] then
                            IndentSize:=IndentSize*10+(ord(F^)-ord('0'))
                        else
                            Writeln('** Bad Numerical Input');
                        Get(F)
                        end
                    end;
        Otherwise:  WriteLn('** Bad Command')
                  end { case }
                end
            else
                begin
                NextWord:=' ';
                NextWide:=NextWide+KSet[CurKSet]^.Index[ord(' ')].Width
                end
            end;
        if not EOP then  { get the next word }
            begin
            while (not EOF(F)) and (F^ = ' ') and (not EOLN(F)) do
                begin
                NextWord[0]:=chr(Length(NextWord)+1);
                NextWord[Length(NextWord)]:=' ';
                NextWide:=NextWide+KSet[CurKSet]^.Index[ord(' ')].Width;
                Get(F)
                end;
            while (not EOF(F)) and (not EOLN(F)) and (F^ <> ' ') do
                if F^ = '^' then
                    begin
                    Get(F);
                    if F^ = '^' then
                        begin
                        NextWord[0]:=chr(Length(NextWord)+1);
                        NextWord[Length(NextWord)]:='^';
                        NextWide:=NextWide+KSet[CurKSet]^.Index[ord(F^)].Width;
                        end
                    else if F^ in ['0'..'9'] then
                        begin
                        KSetId:=ord(F^) - ord('0');
                        if KSet[KSetId] <> nil then
                            begin
                            CurKSet:=KSetId;
                            NextWord[0]:=chr(Length(NextWord)+2);
                            NextWord[Length(NextWord)-1]:=chr(0);
                            NextWord[Length(NextWord)]:=chr(KSetId);
                            if KSet[CurKSet]^.Height > MaxHi then
                                begin
                                MaxKSet:=CurKSet;
                                MaxHi:=KSet[CurKSet]^.Height
                                end
                            end
                        else
                            Writeln('** KSet ',KSetId:1,' not loaded')
                        end
                    else
                        if (F^ = 'i') or (F^ = 'I') then
                           begin
                           Get(F);
                           if F^='-' then c := 'i'
                           else if F^='+' then c := 'I'
                           else begin
                                WriteLn('** Italic not followed by + or -');
                                c := 'i';
                                end;
                           if c = 'c' then inItalic := false
                           else begin
                                inItalic := true;
                                if not italicThisLine then
                                   begin
                                   italicThisLine := true;
                                   wide := wide+roll+2;
                                   end;
                                end;
                           NextWord[0]:=chr(Length(NextWord)+2);
                           NextWord[Length(NextWord)-1]:=chr(0);
                           NextWord[Length(NextWord)]:=c;
                           end
                    else
                        if (F^ = 'b') or (F^ = 'B') then
                           begin
                           Get(F);
                           if F^='-' then c := 'b'
                           else if F^='+' then c := 'B'
                           else begin
                                WriteLn('** Bold not followed by + or -');
                                c := 'b';
                                end;
                           if c = 'b' then inBold := false
                           else begin
                                inBold := true;
                                if not boldThisLine then
                                   begin
                                   boldThisLine := true;
                                   wide := wide+1;
                                   end;
                                end;
                           NextWord[0]:=chr(Length(NextWord)+2);
                           NextWord[Length(NextWord)-1]:=chr(0);
                           NextWord[Length(NextWord)]:=c;
                           end
                    else
                        WriteLn('** Bad In text directive');
                    Get(F)
                    end
                else
                    begin
                    NextWord[0]:=chr(Length(NextWord)+1);
                    NextWord[Length(NextWord)]:=F^;
                    NextWide:=NextWide+KSet[CurKSet]^.Index[ord(F^)].Width;
                    Get(F);
                    LastHi:=KSet[CurKSet]^.Height;
                    LastKSet:=CurKSet
                    end
            end;
        if EOF(F) then EOP:=true
    until (Wide + NextWide > LineWidth) or EOP;
    TmpKSet:=GetFont;
    SetFont(KSet[MaxKSet]);
    DoWriteLn;
    XSSetFont(TmpKSet);
    SReadCursor(X,Y);
    SSetCursor(LeftX,Y);
    if Indent and (not Centering) and Fill then
        begin
        for i := 1 to IndentSize do
            XSPutChr(' ');
        Indent:=false
        end;
    if EOP or Centering or not Fill then
        begin
        SpaceSize:=0;
        Extra:=0
        end
    else
        begin
        SpaceSize:=(LineWidth - Wide) div SpaceCnt;
        Extra:=(LineWidth - Wide) mod SpaceCnt
        end;
    if Centering then
        begin
        SReadCursor(X,Y);
        SSetCursor(X+(LineWidth - Wide) div 2,Y);
        centering:=false
        end;
    for i:=1 to Length(S) do
        if S[i] = ' ' then
            begin
            XSPutChr(' ');
            SReadCursor(X,Y);
            if Extra > 0 then
                begin
                SSetCursor(X+SpaceSize+1,Y);
                Extra:=Extra-1
                end
            else
                SSetCursor(X+SpaceSize,Y);
            end
        else if S[i] = chr(0) then
            begin
            i:=i+1;
            if s[i] = 'i' then XSSetItalic(false)
            else if s[i] = 'I' then XSSetItalic(true)
            else if s[i] = 'b' then XSSetBold(false)
            else if s[i] = 'B' then XSSetBold(true)
            else XSSetFont(KSet[ord(S[i])])
            end
        else
            XSPutChr(S[i]);
    if EOP then
        begin
        if Fill then DoWriteLn;
        S:='';
        Wide:=0;
        LastHi:=0;
        LastKSet:=0;
        EOP:=false;
        Indent:=true
        end
    end;
XSSetFont(KSet[0]);
Sleep(SleepVal)
end.
    
