/*
TODO

LCD fits in cutout
Thin depth of rear down to fit in golf
Model available volume in golf

*/
// 2 DIN headunit
w = 180;
h = 100;
h_front = 112;
d = 180; // Estimate

// LCD
lcdw = 161.92 + 0.2;
lcdh = 110.27 + 0.2;
lcdt = 5.7;

wall = 3;

// Bottom of ATX board from base
height_mb = wall + 3;

// see page 9 of
// http://formfactors.org/developer%5Cspecs%5Cmini_itx_spec_V1_1.pdf

module m3_nut_trap() {
	cylinder(r = 5.5 / 2 / cos(180 / 6) + 0.05, $fn=6, h=4.5);
}

module atxmountinghole(x, y, generate_holes) {
	translate([x, y, 0]) {
		if (generate_holes) {
			union() {
			cylinder(h=20, d=3, $fn=10);
			m3_nut_trap();
			}
		} else {
			cylinder(h=height_mb, d1=15, d2=10);
		}
	}
}


module vent() {
	linear_extrude(height = 20) import("openivi-vents.dxf");
}

module miniatx(generate_holes) {
	translate([6.35, 10.16]) {
		atxmountinghole(0, 0, generate_holes); // Hole C
		atxmountinghole(157.48, 22.86, generate_holes); // Hole F
		atxmountinghole(0, 154.94, generate_holes); // Hole H
		atxmountinghole(157.48, 154.94, generate_holes); // Hole J
	}
	// PicoPSU
	if (generate_holes) {
		translate([-8, 104, height_mb + 15]) cube([40, 50, 30]);
	}
	// TODO connectors
	translate([0, 0, height_mb]) % cube([170,170,8]);
}

module case() {

	difference () {
		union () {
			difference() {
				cube([w, d, h_front]);
				translate([wall,wall,wall]) cube([w-wall*2, d, h - 2*wall]);
				translate([(w-lcdw)/2, -1, (h_front-lcdh)/2]) cube([lcdw, lcdt, lcdh]);
				translate([-1, 20, h]) cube([w+2, d, h_front - h + 1]);
				translate([(w-lcdw)/2, -1, h_front - wall - 20]) cube([lcdw, 20-wall+1, 20]);

				translate([w/2-50, 50, h-10]) vent();
				translate([w/2-50, 100, h-10]) vent();
			}
			translate([170 + 5, 170 + 10,0])
			rotate([0,0,180]) miniatx(false);
		}
		translate([170 + 5, 170 + 10,0])
		rotate([0,0,180]) miniatx(true);
	}
}

module printable() {

	intersection() {
		case();
		translate([-1,-1,-1]) cube([w+2, d+2, h/2+1]);
	}

	translate([0,0,20])
	difference() {
		case();
		translate([-1,-1,-1]) cube([w+2, d+2, h/2+1]);
	}
}

module slice() {
	intersection() {
		case();
		translate([w/2,-500,-500]) cube([1000,1000,1000]);
	}
}


printable();
//case();

//slice();


