
// mbox(size = [x,y,z], center = true/false);
// mbox(size =  x ,     center = true/false);

include <mdefaults.scad>;

module mbox(size = [default_size, default_size, default_size, ], 
        center = true, 
        wall_thickness = default_wall_thickness, 
        chamfer = default_chamfer, 
        xpos = true,
        xneg = true,
        ypos = true,
        yneg = true,
        zpos = true,
        zneg = true) {
    
    _chamfer = chamfer;

    final_align = center ? [0, 0, 0] : align;

    translate([(dim.x / 2) * final_align.x, (dim.y / 2) * final_align.y, (dim.z / 2) * final_align.z]) {

echo("final_align.x", final_align.x);


if(xpos) translate([ dim.x / 2,          0,          0]) chamfered_wall([wall_thickness,          dim.y,          dim.z], align = [-1,  0,  0], chamfer = chamfer);
if(xneg) translate([-dim.x / 2,          0,          0]) chamfered_wall([wall_thickness,          dim.y,          dim.z], align = [ 1,  0,  0], chamfer = chamfer);
        
if(ypos) translate([         0,  dim.y / 2,          0]) chamfered_wall([         dim.x, wall_thickness,          dim.z], align = [ 0, -1,  0], chamfer = chamfer);
if(yneg) translate([         0, -dim.y / 2,          0]) chamfered_wall([         dim.x, wall_thickness,          dim.z], align = [ 0,  1,  0], chamfer = chamfer);

if(zpos) translate([         0,          0,  dim.z / 2]) chamfered_wall([         dim.x,          dim.y, wall_thickness], align = [ 0,  0, -1], chamfer = chamfer);
if(zneg) translate([         0,          0, -dim.z / 2]) chamfered_wall([         dim.x,          dim.y, wall_thickness], align = [ 0,  0,  1], chamfer = chamfer);


    }
}

// cube(size = [x,y,z], center = true/false);
// cube(size =  x ,     center = true/false);