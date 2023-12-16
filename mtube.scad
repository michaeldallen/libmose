// BOF

use <libmose/mutil.scad>

module mtube(h, od, id, center = [0, 0, 0], chamfer = 0, angle = 360, chamfer_ends = false) {

    x_offset = is_bool(center) ? 0 : center.x * od;
    y_offset = is_bool(center) ? 0 : center.y * od;
    
    size = [od, od, h];
  
    _center = is_bool(center) ? (center ? [1, 1, 0] : [1, 1, 1]) : [center.x + 1, center.y + 1, center.z];
    
    mcenter(_center, size) {
        
        rotate([0, 0, -angle / 2]) {    

            rotate_extrude(angle = angle, scale = 2) {
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
        }
    }

}



mtube(h = 20, od = 40, id = 10, chamfer = 2, $fn = 20, angle = 300, chamfer_ends = true, center = [0, -0.5, -1]);

inch = 25.4 ; translate([0, 30, 0]) color("lightblue") scale([0.9,1,1]) mtube(h = 9, od = inch / 4, id = inch / 8, center = [0, 0, 0], chamfer = inch / 8 / 6, angle = 300, $fn = 180);


// EOF
