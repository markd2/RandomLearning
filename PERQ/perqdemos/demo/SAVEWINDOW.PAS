Module SaveWindow;
{--------------------------------------------------------------------------
 SaveWindow - Contains a procedure to save the screen under a window before
               redrawing the window
 
 Written by Brad Myers  27-Jul-81
 
 Copyright (C) 1981 - Three Rivers Computer Corporation
--------------------------------------------------------------------------}

{-------------------------------------------------------------------------
 Change log:
     27-Jul-81 Brad Myers V1.0   Started
-------------------------------------------------------------------------}

{/////////////////////////////} EXPORTS {\\\\\\\\\\\\\\\\\\\\\\\\\\}
imports Screen From Screen;

Const maxAmt = 10; {maximum increment}

Procedure SaveAndRestoreWindow(win: WinRange; title: String);
Procedure RemoveWindow;

{/////////////////////////////} PRIVATE {\\\\\\\\\\\\\\\\\\\\\\\\\\}

imports XScreen from XScreen;
imports IO_Private from IO_Private;
imports Memory from Memory;



Procedure SaveAndRestoreWindow(win: WinRange; title: String);
{-------------------------------------------------------------------------
 Abstract: Saves the screen underneith window win and then redraws the window
           using title as the new title for the window
 Parameters: win is the window to refresh
             title is the new title to pass to redraw
 SideEffects: If another window had been previously saved away, its memory
               is deallocated.  A new segment is created and the screen
               under the window is copied into it.  The segment number
               is stored in the variable IOPriv1Unused.  The window
               number is stored in IOPriv2Unused.
 Environment: IOPriv1Unused must be initialized to FALSE before this routine
               is called the first time.  After being called for the last
               time, the segment in IOPriv1Unused must be DecRefCount
               twice
-------------------------------------------------------------------------}
    var x,y,w,h,ww,seg, size: integer;
        hasTitle: boolean;
    begin
    seg := RECAST(IOPriv1Unused, INTEGER);
    
    if seg <> 0 then begin {get rid of old one}
                     IOPriv1Unused := false;
                     DecRefCount(seg);
                     DecRefCount(seg);
                     end;

    ChangeWindow(win);
    XSGetFullWindow(Win, x, y, w, h);
    
    ww := ((w+maxAmt+63) div 64) * 4;  {round up to nearest quad}
    size := (ww*(h+maxAmt)+255) div 256; {number of blocks to allocate}
    
    CreateSegment(seg, size, 1, size);
    IncRefCount(seg);
    RasterOp(RRpl, w+maxAmt, h+maxAmt, 0, 0, ww, MakePtr(seg, 0, RasterPtr),
                                 x, y, SScreenW, SScreenP);
    
    XSRedrawWindow(win,title);

{$R-}
    IOPriv2Unused := RECAST(win, BOOLEAN);
    IOPriv1Unused := RECAST(seg, BOOLEAN);
{$R=}
    end;


Procedure RemoveWindow;
{-------------------------------------------------------------------------
 Abstract: Removes the saved window from the screen by restoring the text
           undernieth
 SideEffects: Restores the contents of the screen to the state before the
               SaveAndRestoreWindow was called.  Forgets the saved picture.
 Environment: IOPriv1Unused is FALSE or has valid data.
              IOPriv2Unused has the window number
-------------------------------------------------------------------------}
    var x,y,w,h,ww,seg, size: integer;
        hasTitle: boolean;
        win: WinRange;
    begin
    if IOPriv1Unused = FALSE then exit(RemoveWindow);
    
    seg := RECAST(IOPriv1Unused, INTEGER);
    win := RECAST(IOPriv2Unused, WinRange);

    ChangeWindow(win);
    XSGetFullWindow(Win, x, y, w, h);
    
    ww := ((w+maxAmt+63) div 64) * 4;  {round up to nearest quad}

    RasterOp(RRpl, w, h, x, y, SScreenW, SScreenP,
                         0, 0, ww, MakePtr(seg, 0, RasterPtr));

    IOPriv1Unused := false;
    IOPriv2Unused := false;
    DecRefCount(seg);
    DecRefCount(seg); {get rid of it}
    end.
