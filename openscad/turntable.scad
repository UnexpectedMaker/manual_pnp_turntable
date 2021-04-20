tolerance = 0.05;

component_tray_dia = 182;
component_tray_height = 8.6;
component_tray_inner_idia = 39.8;
component_tray_inner_odia = 116.6;
component_tray_inner_thk = 2;
component_tray_hole_dia = 29.6;
component_tray_stopper_hole_dia=5;

component_pocket_idia = 121;
component_pocket_odia = 179;
component_pocket_length = 29;
component_pocket_depth = 8.1;
component_pocket_angle = 8;

component_bearing_idia = 25;
component_bearing_odia = 37;
component_bearing_height = 6;

parts_outer_dia = 126;
parts_inner_dia = 90;
parts_border = 3;
parts_hole_dia = 14;
parts_thk = 1.6;
parts_border_thk = 2;
parts_bearing_holder_dia = 28;
parts_bearing_holder_height = 4;
parts_bearing_holder_thk = 3.20;

part_bearing_idia = 8;
part_bearing_odia = 22;
part_bearing_height = 7;

base_height = 17;
base_outer_dia = component_tray_dia + 8;
base_outerloop_odia = component_tray_dia + 4;
base_outerloop_idia = base_outerloop_odia - 46;
base_sector_angle = 45;

cover_something_width = 15;
cover_thk = 3;

base_innerloop_odia = 50;
base_outerloop_thk = 3;
base_innerloop_thk = base_outerloop_thk;

module sector(h, d, a1, a2) {
    if (a2 - a1 > 180) {
        difference() {
            cylinder(h=h, d=d,$fn=256);
            translate([0,0,-0.5]) sector(h+1, d+1, a2-360, a1); 
        }
    } else {
        difference() {
            cylinder(h=h, d=d,$fn=256);
            rotate([0,0,a1]) translate([-d/2, -d/2, -0.5])
                cube([d, d/2, h+1]);
            rotate([0,0,a2]) translate([-d/2, 0, -0.5])
                cube([d, d/2, h+1]);
        }
    }
}    

module base() {
    difference() {
        union() {
            cylinder( d=base_innerloop_odia, h=base_innerloop_thk, $fn=128 );
            for( a=[0:90:360] )
                rotate([0,0,a] )
                    translate([0,base_outerloop_idia/4 + base_innerloop_odia/4,1.1])
                        cube( size=[15,(base_outerloop_idia - base_innerloop_odia)/2 + 4,2.2],center=true );

            difference() {
                cylinder( d=base_outerloop_odia+1, h=base_innerloop_thk, $fn=256 );
                translate([0,0,-1])
                cylinder( d=base_outerloop_idia, h=base_innerloop_thk+2, $fn=256 );
            }

            difference() {
                cylinder( d=base_outer_dia, h=base_height, $fn=256 );
                translate([0,0,base_height-cover_thk])
                   cylinder( d=base_outerloop_odia, h=cover_thk+2, $fn=256 );
                translate([0,0,base_height-cover_thk-4])
                    cylinder( d2=component_tray_dia+1,d1=base_outerloop_odia,h=5,$fn=256 );
                translate([0,0,-1])
                   cylinder( d=base_outerloop_odia, h=base_height-cover_thk-2, $fn=256 );
                for( a=[0:90:360] )
                    rotate([0,0,a] )
                        translate([0,base_outer_dia/4+base_outerloop_odia/4,base_height-cover_thk/2+1])
                        cube( size=[cover_something_width,(base_outer_dia-base_outerloop_odia)/2+4,cover_thk+2],center=true );
            }
            
            cylinder( d=part_bearing_odia+4,h=base_innerloop_thk+7.2-component_bearing_height,$fn=64 );
            cylinder( d=part_bearing_odia-2*tolerance,h=base_innerloop_thk+6.6,$fn=64 );
            cylinder( d=part_bearing_idia+3,h=base_innerloop_thk+15-part_bearing_height,$fn=64 );
            cylinder( d=part_bearing_idia-2*tolerance,h=base_innerloop_thk+13.6,$fn=64 );
        }

        difference() {
            translate([0,0,-1])
            sector( base_height+2,    base_outer_dia+4,(90-base_sector_angle)/2,(90+base_sector_angle)/2);
            translate([0,0,-2])
            sector( base_height+4,    base_outer_dia-10,(90-base_sector_angle)/2-10,(90+base_sector_angle)/2+10);
        }
    }
}

module component_pocket()
{
    hull() {
        difference() {
            translate( [0,(component_pocket_length-component_pocket_odia)/2,component_pocket_depth-4.2] )
                cylinder( d=component_pocket_odia,h=4.2,$fn=256 );
            translate( [0,(-component_pocket_idia-component_pocket_length)/2,component_pocket_depth-5.2] )
                cylinder( d=component_pocket_idia,h=6.2,$fn=256 );
            for( i=[-1,1] ) 
                translate([i*component_pocket_odia/2,-component_pocket_odia/2,0]) 
                    rotate( [0,0,-i*4] )
                        cube( size=[component_pocket_odia, component_pocket_odia*2, component_pocket_depth*2 + 4], center=true );
            
        }
        difference() {
            translate( [0,7,0.5] )
                cube( size=[20,10.7,1],center=true );
            for( i=[-1,1] ) 
                translate([i*component_pocket_odia/2,-component_pocket_odia/2,0]) 
                    rotate( [0,0,-i*3] )
                        cube( size=[component_pocket_odia, component_pocket_odia*2, 2*(component_pocket_depth-4.2 )], center=true );
        }
    }
}

module component_tray()
{
    difference() {
        cylinder( d=component_tray_dia, h=component_tray_height, $fn=256 );
        difference() {
            translate( [0,0,component_tray_inner_thk] )
                cylinder( d=component_tray_inner_odia, h=component_tray_height, $fn=128 );
            cylinder( d=component_tray_inner_idia, h=component_tray_height+component_tray_inner_thk+2, $fn=128 );
        }
        translate( [0,0,-1] )
            cylinder( d=component_tray_hole_dia, h=component_tray_height+2, $fn=64 );
        translate( [0,0,-2] )
            cylinder( d=component_bearing_odia+2*tolerance, h=component_tray_height, $fn=64 );
        translate( [0,70,-1] )
            cylinder( d=component_tray_stopper_hole_dia, h=component_tray_height+2, $fn=32 );
        translate( [0,81.7,-1] )
            cylinder( d=component_tray_stopper_hole_dia, h=component_tray_height+2, $fn=32 );
        for( a=[10:10:350] ) 
            rotate( [0,0,a] )
                translate( [0,(component_pocket_idia+component_pocket_odia)/4,component_tray_inner_thk] )
                    component_pocket();
            
        
    }
}

/*
     part 1 - single parts tray
          2 - two modules maint part
          3 - two modeles bearing part
*/

module parts_tray(hole=1,part=1)
{
    difference() {
        union() {
            if( part != 3 )
                cylinder( d=parts_outer_dia, h=parts_thk+parts_border_thk,$fn=128 );
            else 
                cylinder( d=parts_inner_dia-parts_border, h=parts_thk/2,$fn=128 );
                
            if( part != 2 ) {
                holder_height = parts_bearing_holder_height + ( part == 3 ? parts_border_thk / 2:0);
                translate( [0,0,-holder_height] )
                    cylinder( d=parts_bearing_holder_dia, h=holder_height,$fn=64 );
                translate( [0,0,-holder_height-4] )
                    cylinder( d2=parts_bearing_holder_dia, d1=part_bearing_odia-0.5, h=4,$fn=64 );
            }
        }
        if( part == 2 )
            translate( [0,0,-1] )
                cylinder( d=parts_bearing_holder_dia, h=parts_thk+2,$fn=64 );
            
        difference() {
            translate( [0,0,parts_thk] )
                cylinder( d=parts_outer_dia-parts_border, h=parts_thk+parts_border_thk,$fn=128 );
            translate( [0,0,parts_thk-1] )
                cylinder( d=parts_inner_dia, h=parts_thk+parts_border_thk+2,$fn=128 );
        }
        translate( [0,0,parts_thk - (part!=2 ? 0 : parts_thk/2)] )
            cylinder( d=parts_inner_dia-parts_border, h=parts_thk+parts_border_thk,$fn=128 );
        if( hole ) 
            translate( [0,0,-2] )
                cylinder( d=parts_hole_dia, h=parts_thk+parts_border_thk+4,$fn=128 );

        if( part != 2 ) 
            translate( [0,0,-parts_bearing_holder_height-5-( part == 3 ? parts_border_thk / 2:0)] )
                cylinder( d=part_bearing_odia+2*tolerance, h=5+parts_bearing_holder_height,$fn=64 );

    }
}

