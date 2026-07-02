use <../mutil.scad>;

assert(mlist3(5)[0] == 5);
assert(mlist3(5)[1] == 5);
assert(mlist3([1, 2, 3])[2] == 3);
assert(mprecision(1.23456, 2) == 1.23);
assert(mm2i(25.4) == 1);
assert(i2mm(1) == 25.4);
