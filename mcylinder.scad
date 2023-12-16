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
    
    x_offset = is_bool(center) ? 0 : center.x * (effective_diameter / 2);
    y_offset = is_bool(center) ? 0 : center.y * (effective_diameter / 2);
    
    size = [effective_diameter, effective_diameter, h];
  
    _center = is_bool(center) ? (center ? [1, 1, 0] : [1, 1, 1]) : [center.x + 1, center.y + 1, center.z];
    
    mcenter(_center, size) {
        mcolor(color) {
            translate([0, 0, h/2]) {
                if(d == 0) {
                        cylinder(h = h, d1 = d1, d2 = d2, center = true);
                } else {
                    if (chamfer == 0) {
                        cylinder(h = h, d = d, center = true);
                    } else {
                        hull() {
                            cylinder(h = h, d = d - chamfer * 2, center = true);
                            translate([0, 0, center ? 0 : chamfer]) {
                                cylinder(h = h - chamfer * 2, d = d, center = true);
                            }
                        }
                    }
                }
            }
        }
    }

}

    




echo("\n
\nmcylinder usage:
\n\tmodule mcylinder(h = 10, d = 0, d1 = 0, d2 = 0, center = false, chamfer = 0)
\n
\n
");


// EOF
inch = 25.4; 

//    mcylinder(h = 20, d = 10, chamfer = 2.5, center = true);


mcylinder(d = inch / 4, h = 10, $fn = 60, center = true, chamfer = inch / 8 / 4, color = "lightblue");

mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center = false, color = "orange");

mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center = [1,2,3], color = "fuchsia");
mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center = [0,0,0], color =  "salmon");
mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center =  false,  color =   "cyan");
mcylinder(d1 = inch / 4, d2 = inch / 6, h = 10, $fn = 60, center =  true,  color =   "pink");
 
color("lightgreen") cylinder(d = inch / 4-1, h = 10, $fn = 60, center = false);
