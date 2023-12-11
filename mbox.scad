
// mbox(size = [x,y,z], center = true/false);
// mbox(size =  x ,     center = true/false);

include <mdefaults.scad>;

use <mutil.scad>;
use <mcube.scad>;

module mbox(size = default_size, 
        center = true, 
        wall_thickness = default_wall_thickness, 
        chamfer = default_chamfer, 
        xpos = true,
        xneg = true,
        ypos = true,
        yneg = true,
        zpos = true,
        zneg = true,
        manifold_underlap = false,
        manifold_overlap = false,
        color = undef) {
    
    assert(is_num(size) || (is_list(size) && len(size) == 3), "size must be 'num' or 'array[3]'");
    _size = mlist3(size) + mlist3(manifold_overlap ? default_manifold_overlap : 0) - mlist3(manifold_underlap ? default_manifold_overlap : 0);
    _wall = wall_thickness + (manifold_overlap ? default_manifold_overlap * 2 : 0) - (manifold_underlap ? default_manifold_overlap * 2 : 0);

    mcenter(center, _size) {
        mcolor(color) {


            translate([_size.x / 2, _size.y / 2, _size.z / 2]) { // follow center semantics from native cube()
                
                if(xpos) translate([ _size.x / 2,            0,            0]) mcube([_wall,        _size.y,        _size.z], center = [-1,  0,  0], chamfer = chamfer, color = color);
                if(xneg) translate([-_size.x / 2,            0,            0]) mcube([_wall,        _size.y,        _size.z], center = [ 1,  0,  0], chamfer = chamfer, color = color);

                if(ypos) translate([           0,  _size.y / 2,            0]) mcube([       _size.x, _wall,        _size.z], center = [ 0, -1,  0], chamfer = chamfer, color = color);
                if(yneg) translate([           0, -_size.y / 2,            0]) mcube([       _size.x, _wall,        _size.z], center = [ 0,  1,  0], chamfer = chamfer, color = color);

                if(zpos) translate([           0,            0,  _size.z / 2]) mcube([       _size.x,        _size.y, _wall], center = [ 0,  0, -1], chamfer = chamfer, color = color);
                if(zneg) translate([           0,            0, -_size.z / 2]) mcube([       _size.x,        _size.y, _wall], center = [ 0,  0,  1], chamfer = chamfer, color = color);
            }

        }
    }


}

mbox(zpos = false, [default_size * 1.5, default_size, default_size], xpos = false, xneg = false, wall_thickness = 1, chamfer = .25, color = "red");
mbox(zpos = false, xpos = false, color = "orange", manifold_underlap = true, wall_thickness = 1.5, chamfer = 0.25);
mbox(zneg = false, [default_size * 0.5, default_size, default_size], xpos = false, color = "blue", manifold_underlap = true, wall_thickness = 2, chamfer = 0.25);