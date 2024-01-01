// BOF

use <libmose/mutil.scad>

module mtube(h, od, id, center = [0, 0, 0], chamfer = 0, angle = 360, chamfer_ends = false, color = undef) {

    x_offset = is_bool(center) ? 0 : center.x * od;
    y_offset = is_bool(center) ? 0 : center.y * od;
    
    size = [od, od, h];
  
    _center = is_bool(center) ? (center ? [1, 1, 0] : [1, 1, 1]) : [center.x + 1, center.y + 1, center.z];
    
    mcenter(_center, size) {
        
        _pi = 3.14159;
        _L = chamfer; // arc length == chamfer
        _r = (od - ((od - id) / 2)) / 2;  // center the radius between the inner and out wall
        _theta = (_L / _r) * (180 / _pi); // oooh, baby!
    
        _angle = (chamfer_ends) ? (angle - (_theta * 2)) : (angle);

            
            
        rotate([0, 0, -_angle / 2]) {

            mcolor(color) {
                color("lightgreen")
                rotate_extrude(angle = _angle, scale = 2) {
                    polygon(points = [
                    [id / 2          , chamfer],
                    [id / 2 + chamfer, 0      ],
                    [od / 2 - chamfer, 0      ],
                    [od / 2          , chamfer],
                    [od / 2          , h - chamfer],
                    [od / 2 - chamfer, h],
                    [id / 2 + chamfer, h],
                    [id / 2          , h - chamfer]
                    ]
                    );
                }
                
                if(chamfer_ends) {
                    translate([0, 0, h/2]) {
                        for(z = [0.01, _angle - 0.01]) {
                            rotate([0, 0, z]) {
                                color("plum") {
                                    hull() {
                                        mtube(h = h, od = od, id = id, chamfer = chamfer, $fn = $fn, angle = 0.01, color = "plum", center = true);
                                        mtube(h = h - (_L * 2), od = od - _L, id = id + _L, chamfer = _L, $fn = $fn, angle = _theta * 2, color = "slategrey");
                                    }
                                }
                            }
                        }
                    }
                }
                
                
               
            }
        }
    }

}



mtube(h = 20, od = 40, id = 10, chamfer = 2, $fn = 20, angle = 300, center = [0, -0.5, -1], color="pink");

inch = 25.4 ; translate([0, 30, 0]) /*color("lightblue")*/ scale([0.9,1,1]) mtube(h = 9, od = inch / 4, id = inch / 8, center = [0, 0, 0], chamfer = inch / 8 / 6, angle = 300, $fn = 180, chamfer_ends = true);



translate([0, -60, 0]) {

 mtube(h = 50, od = 40 , id = 32 , chamfer = 1, $fn = 360, angle = 360, chamfer_ends = true, color = "slategrey");
}
// EOF
