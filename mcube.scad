// BOF

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#cube
// cube(size = [x,y,z], center = true/false);
// cube(size =  x ,     center = true/false);

module mcube(size = 1, center = false, chamfer = undef, color = undef) {

    assert(is_undef(center) || is_bool(center) || (is_list(center) && len(center) == 3), "center must be 'undef' or 'bool' or 'vector[3]'");

    module cubey(size, chamfer) {
        
        if(is_undef(chamfer) || chamfer == 0) { 
            cube(final_size);
        } else {
            hull() {
                translate([size.x / 2, size.y / 2, size.z / 2]) {
                    cube([size.x              , size.y - chamfer * 2, size.z - chamfer * 2], center = true); // x axis
                    cube([size.x - chamfer * 2, size.y              , size.z - chamfer * 2], center = true); // y axis
                    cube([size.x - chamfer * 2, size.y - chamfer * 2, size.z              ], center = true); // z axis
                }
            }
        }
    }


    final_size = is_num(size) ? [size, size, size] : size;
    
    if(is_bool(center)) {
        translate([center ? -final_size.x / 2 : 0, center ? -final_size.y / 2 : 0, center ? -final_size.z / 2 : 0]) {
            cubey(size = final_size, chamfer = chamfer);
        }
    }
    if(is_list(center)) { 
        translate([(center.x / 2) * final_size.x, (center.y / 2) * final_size.y, (center.z / 2) * final_size.z]) {
            translate([-final_size.x / 2, -final_size.y / 2, -final_size.z / 2]) {
                cubey(size = final_size, chamfer = chamfer);
            }
        }
    }

}


// test parts
color("red")     cube(  4                              );
color("green")  mcube(  5,         true, chamfer = 1   );
color("pink")   mcube(  5,        false, chamfer = 1   );
color("blue")   mcube(  5, [-1, -1, -1], chamfer = 1   );
color("orange") mcube(4.5,         true, chamfer = 0.25);



// EOF
