# ReGIS - Remote Graphics Instruction Set

Another fine DEC product.  Run on the VT-100 + 4A-CGS graphics board.
Currently feeding it via VAX BSD 2.x running on the macbook.

Can do stuff locally with CONTOUR

The usual "hide and turn off annoying things"

* hide status line with option-control-.
* add to contour.yaml input_mapping section to make shift-control-up to embiggen font size. Existing binds don't work well.  `- { mods: [Shift,Control]             , key: UpArrow     , action: IncreaseFontSize }`
* also set `cursor_motion_animation_duration: 0` and cursor:shape: to block
* set `font: size:` to 18
* set hyperlink_decoration" to Never and normal/hover to none
* bell:sound: to off


simh/vax side:
```
simh> attach tq0 transfer.tap
simh> co
% tar cvf /dev/rmt12 _whatevs
```

mac side


dd if=extract.tap ibs=10244 obs=10240 cbs=10240 conv=block 2>/dev/null | tar -xvf -


macrograph-star.rf is leaving colors in a bad state
  - should have a -reset for regdemo
  - should have a -erase (right now erase if there's no argument)
  - screen.scroll leaves leftover scale
  - maybe prolog should reset things
