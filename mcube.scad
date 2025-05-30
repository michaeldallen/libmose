// BOF

// extends: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#cube
// cube(size = [x,y,z], center = true/false);
// cube(size =  x ,     center = true/false);

include <mdefaults.scad>;

use <mutil.scad>;

module mcube(size = default_size, center = false, chamfer = undef, color = undef, manifold_underlap = false, manifold_overlap = false) {

    module cubey(cubey_size, _chamfer) {

        if(is_undef(_chamfer) || _chamfer == 0) {
            cube(cubey_size);
        } else {
            hull() {
                translate([cubey_size.x / 2, cubey_size.y / 2, cubey_size.z / 2]) {
                    cube([cubey_size.x               , cubey_size.y - _chamfer * 2, cubey_size.z - _chamfer * 2], center = true); // x axis
                    cube([cubey_size.x - _chamfer * 2, cubey_size.y               , cubey_size.z - _chamfer * 2], center = true); // y axis
                    cube([cubey_size.x - _chamfer * 2, cubey_size.y - _chamfer * 2, cubey_size.z               ], center = true); // z axis
                }
            }
        }
    }

    
    assert(is_num(size) || (is_list(size) && len(size) == 3), "size must be 'num' or 'array[3]'");
    _size = mlist3(size) + mlist3(manifold_overlap ? default_manifold_overlap : 0) - mlist3(manifold_underlap ? default_manifold_overlap : 0);

    mcenter(center, _size) {
        mcolor(color) {
            cubey(_size, _chamfer = chamfer);
        }
    }

}


// test parts
                mcube(  5,         true, chamfer = 1   , color =  "green");
color("pink")   mcube(  [6,6,6]                                          );
                mcube(  5, [-1, -1, -1], chamfer = 1   , color = "orange");
                mcube(4.5,         true, chamfer = 0.25                  );



// EOF
