// BOF

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#cube
// cube(size = [x,y,z], center = true/false);
// cube(size =  x ,     center = true/false);

module mcube(size = 1, center = false, chamfer = undef, color = undef) {

    module cubey(_size, _chamfer) {

        if(is_undef(_chamfer) || _chamfer == 0) {
            cube(size);
        } else {
            hull() {
                translate([_size.x / 2, _size.y / 2, _size.z / 2]) {
                    cube([_size.x               , _size.y - _chamfer * 2, _size.z - _chamfer * 2], center = true); // x axis
                    cube([_size.x - _chamfer * 2, _size.y               , _size.z - _chamfer * 2], center = true); // y axis
                    cube([_size.x - _chamfer * 2, _size.y - _chamfer * 2, _size.z               ], center = true); // z axis
                }
            }
        }
    }


    assert(is_num(size) || (is_list(size) && len(size) == 3), "size must be 'num' or 'list[3]'");
    final_size = is_num(size) ? [size, size, size] : size;
    

    assert(is_bool(center) || (is_list(center) && len(center) == 3), "center must be 'bool' or 'list[3]'");
    if(is_bool(center)) {
        translate([center ? -final_size.x / 2 : 0, center ? -final_size.y / 2 : 0, center ? -final_size.z / 2 : 0]) {
            if(is_undef(color)) {
                cubey(final_size, _chamfer = chamfer);
            } else {
                color(color) {
                    cubey(final_size, _chamfer = chamfer);
                }
            }
        }
    } else {
        translate([(center.x / 2) * final_size.x, (center.y / 2) * final_size.y, (center.z / 2) * final_size.z]) {
            translate([-final_size.x / 2, -final_size.y / 2, -final_size.z / 2]) {
                if(is_undef(color)) {
                    cubey(final_size, _chamfer = chamfer);
                } else {
                    color(color) {
                        cubey(final_size, _chamfer = chamfer);
                    }
                }
            }
        }
    }


}


// test parts
color("red")     cube(  4                                                );
                mcube(  5,         true, chamfer = 1   , color =  "green");
color("pink")   mcube(  5,             , chamfer = 1                     );
                mcube(  5, [-1, -1, -1], chamfer = 1                     );
                mcube(4.5,         true, chamfer = 0.25, color = "orange");



// EOF
