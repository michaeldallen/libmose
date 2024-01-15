module mcenter(center, _size) {

    assert(is_bool(center) || (is_list(center) && len(center) == 3), "center must be 'bool' or 'array[3]'");

    _translate =
        is_bool(center)
        ? [center ? -_size.x / 2 : 0, center ? -_size.y / 2 : 0, center ? -_size.z / 2 : 0]
        : [((center.x / 2) * _size.x) - (_size.x / 2), ((center.y / 2) * _size.y) - (_size.y / 2), ((center.z / 2) * _size.z) -(_size.z / 2)];

    translate(_translate) {
        children();
    }

}


module mcolor(color) {

    if(is_undef(color)) {
        children();
    } else {
        color(color) {
            children();
        }
    }
}



function mlist3(v) = (
    is_num(v)
        ? [v, v, v]
        : v
);


function mprecision(value, precision) = (
   round(value * pow(10, precision)) /  pow(10, precision)
);


function mm2i(mm) = (
    mm / 25.4
);

function i2mm(i) = (
    i * 25.4
);

