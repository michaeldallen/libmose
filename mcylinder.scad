// BOF
// NOSTL

use <libmose/mutil.scad>

module mcylinder(h = 10, d = 0, d1 = 0, d2 = 0, center = false, chamfer = 0, color = undef) {

    mcolor(color) {    
        
        if(d == 0) {
           assert(chamfer == 0);
        } else {
            assert(d1 == 0 && d2 == 0);
        }

        if(d == 0) {
            cylinder(h = h, d1 = d1, d2 = d2, center = center);
        } else {
            if (chamfer == 0) {
                cylinder(h = h, d = d, center = center);
            } else {
                hull() {
                    cylinder(h = h, d = d - chamfer * 2, center = center);
                    translate([0, 0, center ? 0 : chamfer]) {
                        cylinder(h = h - chamfer * 2, d = d, center = center);
                    }
                }
            }
        } 
    }
}

    


if(!is_undef(debug_lib)) {
    
    mcylinder(h = 20, d = 10, chamfer = 2.5, center = true);


}


echo("\n
\nmcylinder usage:
\n\tmodule mcylinder(h = 10, d = 0, d1 = 0, d2 = 0, center = false, chamfer = 0)
\n
\n
");


// EOF
//inch = 25.4; mcylinder(d = inch / 4, h = 10, $fn = 60, center = true, chamfer = inch / 8 / 4, color = "lightblue");
