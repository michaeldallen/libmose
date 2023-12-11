// BOF
// NOSTL


module mcylinder(h = 10, d = 0, d1 = 0, d2 = 0, center = false, align = [0, 0, 0], chamfer = 0, color = undef) {
    
    if(d == 0) {
       assert(chamfer == 0);
    } else {
        assert(d1 == 0 && d2 == 0);
    }
    translate([(d / 2) * align.x, (d / 2) * align.y, (h / 2) * (align.z - 1)]) {

    if(d == 0) {
        color(color) {
            cylinder(h = h, d1 = d1, d2 = d2, center = center);
        }
    } else {
        if (chamfer == 0) {
            color(color) {
                cylinder(h = h, d = d, center = center);
            }
        } else {
            hull() {
                color(color ? color : "blue") { 
                    cylinder(h = h, d = d - chamfer * 2, center = center);
                }
                color(color ? color : "red") {
                    translate([0, 0, center ? 0 : chamfer]) {
                        cylinder(h = h - chamfer * 2, d = d, center = center);
                    }
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
