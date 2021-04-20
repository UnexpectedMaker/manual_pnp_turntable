include <turntable.scad>

translate( [0,0,parts_thk/2] )
    rotate([180,0,0])
        parts_tray(1,3);