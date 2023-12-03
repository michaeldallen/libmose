
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
        manifold_overlap = false) {
    
    assert(is_num(size) || (is_list(size) && len(size) == 3), "size must be 'num' or 'array[3]'");
    _size = mlist3(size + (manifold_overlap ? default_manifold_overlap : 0));





    if(xpos) translate([ _size.x / 2,          0,          0]) mcube([wall_thickness,          _size.y,          _size.z], center = [-1,  0,  0], chamfer = chamfer);
    if(xneg) translate([-_size.x / 2,          0,          0]) mcube([wall_thickness,          _size.y,          _size.z], center = [ 1,  0,  0], chamfer = chamfer);
        
            

    if(ypos) translate([         0,  _size.y / 2,          0]) mcube([         _size.x, wall_thickness,          _size.z], center = [ 0, -1,  0], chamfer = chamfer);
    if(yneg) translate([         0, -_size.y / 2,          0]) mcube([         _size.x, wall_thickness,          _size.z], center = [ 0,  1,  0], chamfer = chamfer);

    if(zpos) translate([         0,          0,  _size.z / 2]) mcube([         _size.x,          _size.y, wall_thickness], center = [ 0,  0, -1], chamfer = chamfer);
    if(zneg) translate([         0,          0, -_size.z / 2]) mcube([         _size.x,          _size.y, wall_thickness], center = [ 0,  0,  1], chamfer = chamfer);



}

mbox(xpos = false);
