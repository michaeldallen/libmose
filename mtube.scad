// BOF


module mtube(h, od, id, align = [0, 0, 0], chamfer = 0, angle = 360) {

    translate([(od / 2) * align.x, (od / 2) * align.y, (h / 2) * (align.z - 1)]) {

        rotate([0, 0, -angle / 2]) {    

            rotate_extrude(angle = angle) {
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



mtube(h = 20, od = 40, id = 10, chamfer = 2, $fn = 360, angle = 300);


// EOF
