// BOF
// NOSTL





// cube(size = [x,y,z], center = true/false);

module mcube(size = [0, 0, 0], center = false, align = undef, chamfer = 0, debug_lib = false, color = undef) {

     module cubey(size, chamfer) {
          // red for x-axis
          // green for y-axis
          // blue for z-axis
          c = chamfer * 2;
          color("red")   cube([size.x    , size.y - c, size.z - c], center = true);
          color("green") cube([size.x - c, size.y    , size.z - c], center = true);
          color("blue")  cube([size.x - c, size.y - c, size.z    ], center = true);
     }



     // any defined alignment value will override center value
     //
     a = (align == undef ? (center ? [0, 0, 0] : [1, 1, 1]) : align);
     translate([(size.x / 2) * a.x, (size.y / 2) * a.y, (size.z / 2) * a.z]) {
          
         if(debug_lib) {
             union() cubey(size, chamfer);
         } else {
            if(color == undef) {
                hull() cubey(size, chamfer);
            } else {
                color(color) {
                    hull() cubey(size, chamfer);
                }
            }

         }
    }
}




if(!is_undef(debug_lib)) {

    translate([30, 30, 30]) color("pink") cube([10, 10, 10]);
    translate([31, 31, 31]) color("red") mcube([10, 10, 10]);

    translate([10,10,10]) color("pink") mcube([20, 20, 20], center = true);
    mcube([20, 20, 20], center = true, chamfer = 2);

}



// EOF
