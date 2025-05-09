// BOF
// NOSTL

use <libmose/mutil.scad>

    
module mcylinder(h = 10, d = 0, d1 = 0, d2 = 0, center = false, chamfer = 0, color = undef) {


    // work on the mcylinder using centered cylinders, then adjust height according to center/mcenter as passed include
    

    

    
    
    if(d == 0) {
       assert(chamfer == 0);
    } else {
        assert(d1 == 0 && d2 == 0);
    }



    effective_diameter = (d) ? (d) : (d1 > d2 ? d1 : d2);
    size = [effective_diameter, effective_diameter, h];
    
    _center = is_bool(center) ? (center ? [1, 1, 1] : [1, 1, 2]) : [center.x + 1, center.y + 1, center.z + 1];
    mcenter(_center, size) {
        mcolor(color) {

                if(d == 0) {
                    cylinder(h = h, d1 = d1, d2 = d2, center = true);
                } else {
                    if (chamfer == 0) {
                        cylinder(h = h, d = d, center = true);
                    } else {

                        color("firebrick") cylinder(h = h - abs(chamfer) * 2, d = d, center = true);
                        for (z = [-1, 1]) { 
                            color("pink") hull() {                        
                                translate([0, 0, z * ((h/2) - 0.01/2)]) cylinder(h = 0.01, d = d - chamfer * 2, center = true);
                                translate([0, 0, z * (h/2 - abs(chamfer))]) cylinder(h = 0.01, d = d, center = true);
                            }
                        }
                    }
                }
            }
        }


}

    




// EOF
inch = 25.4; 

//    mcylinder(h = 20, d = 10, chamfer = 2.5, center = true);

$fn = 60;

translate([-20, 0, 0])                     mcylinder(d1 = inch / 4, d2 = inch / 8, h = 10, center = [0,  1,  1],                         color = "deeppink" );
                                           mcylinder( d = inch / 4,                h = 10, center = [0, -1, -1], chamfer = inch / 8 / 4, color = "lightblue");
                                           mcylinder( d = inch / 4,        h = 10, center = [0, -1,1], chamfer = -inch / 8 / 4, color = "royalblue");
translate([-40, 0, 0]) color("lightgreen")  cylinder( d = inch / 4,                h = 10, center = true                                                    );

translate([20, 0, 0]) mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center = false, color = "orange");

translate([40, 0, 0]) mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center = [1,2,3], color = "fuchsia");

translate([60, 0, 0]) mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center = [0,0,0], color =  "salmon");

translate([80, 0, 0]) mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center =  false,  color =   "cyan");

translate([100, 0, 0]) mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center =  true,  color =   "pink");
 
