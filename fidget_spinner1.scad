
$fn = 64;

// measured size = 9.5
module bearing_small() {  // |||
    sphere(d=10.4);
}

// measured size = 11.1
module bearing_large() {  // |||
    sphere(d=12.1);
}

radial_outer_d = 16;
radial_inner_d = 6.3;
radial_h = 5;

module radial(hollow=true) {    // ||+
    difference() {
        cylinder(d=radial_outer_d, h=radial_h);
        if (hollow) { cylinder(d=radial_inner_d, h=radial_h); }
    }
}


main_d = 28;
main_h = 5;

cap_d = 23;
cap_h1 = 1;
cap_h2 = 2.2;

module cap() {
    cylinder(d=cap_d, h=cap_h1);
    // Main cylinder
    translate([0, 0, cap_h1])
        cylinder(d=radial_inner_d, h=cap_h2);
    // Offset ring (to prevent rubbing)
    translate([0, 0, cap_h1])
        cylinder(d=radial_inner_d + 0.8, h=0.3);
}

num_arms=3;
arm_d=main_d;
arm_h=main_h;
extra_main_d=2;

module main_body() {
    for( i = [0:num_arms-1]) {
        rotate(a=(i * 360/num_arms), v=[0, 0, 1]) {
            translate([arm_d, 0, 0]) {
                difference() {
                    cylinder(d=arm_d, h=arm_h);
                    translate([0, 0, arm_h/2]) {
                        bearing_large();
                    }
                }
            }
        }
    }

   difference() {
       cylinder(d=main_d * 2, h=main_h);

       for( i = [0:num_arms-1]) {
           rotate(a=(i * 360/num_arms + 60), v=[0, 0, 1]) {
               translate([arm_d, 0, 0]) {
                   cylinder(d=arm_d + extra_main_d, h=arm_h);
               }
           }
           rotate(a=(i * 360/num_arms), v=[0, 0, 1]) {
               translate([arm_d, 0, arm_h/2]) {
                   bearing_large();
                }
           }
       }
       radial(false);
    }
}

module main_caps(offset=false) {
    x = offset ? 25 : 0;
    y = offset ? 30 : 0;

    translate([x, y, 0]) {
        cap();
        translate([-20, 20, 0]) cap();
    }
}


main_body();
// main_caps(false);
