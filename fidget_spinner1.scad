// Fidget spinner, try 1

$fn = 64;

// measured size = 9.5
module bearing_small() {  // |||
    sphere(d=9.9);
}

// measured size = 11.1
module bearing_large() {  // |||
    sphere(d=11.3);
}

radial_outer_d = 15.9;
radial_inner_d = 6.3;
radial_h = 5;

module radial(hollow=true) {    // ||+
    difference() {
        cylinder(d=radial_outer_d, h=radial_h);
        if (hollow) { cylinder(d=radial_inner_d, h=radial_h); }
    }
}


main_d = 28;
main_h = 3;

module body_experiment() {
    difference() {
        cylinder(d=main_d, h=main_h);
        radial(false);
    }
}


cap_d = 16;
cap_h1 = 1;
cap_h2 = 2;

module cap() {
    cylinder(d=cap_d, h=cap_h1);
    translate([0, 0, cap_h1])
        cylinder(d=radial_inner_d, h=cap_h2);
}

/* experimental stuff */

bearing_outer_d = 24;

module bearing1() {
    difference() {
        cylinder(d=bearing_outer_d, h=main_h);
        translate([0, 0, main_h/2])
            bearing_large();
    }    
}

module bearing2() {
    difference() {
        cylinder(d=bearing_outer_d, h=main_h);
        translate([0, 0, main_h/2])
            bearing_small();
    }    
}


module main_experiments() {
    *body_experiment();
    
    *translate([main_d, 0, 0])
        cap();
    
    // translate([0, main_d *1.2, 0]) 
        bearing1();
    
    *translate([0, -main_d *1.2, 0])
        bearing2();
}

num_arms=3;
arm_d=main_d;
arm_h=main_h;

module main() {
    for( i = [0:num_arms-1]) {
        rotate(a=(i * 360/num_arms), v=[0, 0, 1]) {
            translate([arm_d, 0, 0]) {
                cylinder(d=arm_d, h=arm_h);
            }
        }
    }
}


main_experiments();

