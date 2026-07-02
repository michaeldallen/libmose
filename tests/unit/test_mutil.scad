use <../../mutil.scad>;

assert(mlist3(5)[0] == 5, "mlist3 should expand scalar values to three entries");
assert(mlist3(5)[1] == 5, "mlist3 should expand scalar values to three entries");
assert(mlist3([1, 2, 3])[2] == 3, "mlist3 should preserve list values");
assert(mprecision(1.23456, 2) == 1.23, "mprecision should round to the requested precision");
assert(mm2i(25.4) == 1, "mm2i should convert millimetres to inches");
assert(i2mm(1) == 25.4, "i2mm should convert inches to millimetres");

cube([1, 1, 1]);
