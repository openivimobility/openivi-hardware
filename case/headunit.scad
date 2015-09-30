/*

*/
// 2 DIN headunit
w = 180;
h = 100;
h_front = 112;
d_front = 20;
d = 180 + d_front;

// LCD screen dimentions
lcdw = 161.92 + 0.2;
lcdh = 110.27 + 0.2;
lcdt = 5.7;

// SSD dimentions
ssdw = 70.0;
ssdd = 100.0;
ssdt = 7.0;

wall = 3;

// Bottom of ATX board from base
height_mb = wall + 3;


module m3_nut_trap() {
	cylinder(r = 5.5 / 2 / cos(180 / 6) + 0.05, $fn=6, h=4.5);
}

module atxmountinghole(x, y, generate_holes) {
	// Translate from the C hole datum to a reference point
   // on the bottom left
	translate([6.35 + x, 170 - y - 10.16, 0]) {
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

// This generates two solids. The first is the positive material that should
// be added to the model. The second run is called with generate_holes=true
// and generates the material that needs to be removed.
module miniatx(generate_holes) {
	// Mini ATX motherboard spec on page 9 of
	// http://formfactors.org/developer%5Cspecs%5Cmini_itx_spec_V1_1.pdf
		atxmountinghole(0, 0, generate_holes); // Hole C
		atxmountinghole(157.48, 22.86, generate_holes); // Hole F
		atxmountinghole(0, 154.94, generate_holes); // Hole H
		atxmountinghole(157.48, 154.94, generate_holes); // Hole J
	// PicoPSU
	if (generate_holes) {
		translate([170 - 40 + 8, 22, height_mb + 15]) cube([40, 50, 30]);
	}
	// Visualise the location of the motherboard
	translate([0, 0, height_mb]) % cube([170,170,17]);
	// Visualise the location of the rear connectors
	translate([7.52 + 6.35, 170-30+1, height_mb]) % cube([158.75, 40, 40]);

}

module ssd_holder(generate_holes) {
	if (generate_holes) {
		// A SSD-shaped hole
		translate([0, 2, 0]) cube([ssdt, ssdd, ssdw]);
	} else {
		// Bottom mounting rail
		translate([-1, 0, -wall]) cube([10, ssdd, 4 + wall]);
		// Top mounting rail
		translate([0, 0, ssdw - 4]) cube([10, ssdd, 4 + wall -1]);
	}
	% cube([ssdt, ssdd, ssdw]);
}

module case() {

	difference () {
		union () {
			difference() {
				cube([w, d, h_front]);
				// Interiour volume
				translate([wall,wall,wall]) cube([w-wall*2, d, h - 2*wall]);
				// LCD
				translate([(w-lcdw)/2, -1, (h_front-lcdh)/2]) cube([lcdw, lcdt+1, lcdh]);
				// Thinned down top
				translate([-1, 20, h]) cube([w+2, d, h_front - h + 1]);
				// Interior volume in top front
				translate([(w-lcdw)/2, -1, h_front - wall - 20]) cube([lcdw, 20-wall+1, 20]);
				// 'OPENIVI' vents
				translate([w/2-50, 50, h-10]) vent();
				translate([w/2-50, 100, h-10]) vent();
			}
			translate([5, 10, 0]) miniatx(false);
			translate([wall, 20, h-wall-ssdw]) ssd_holder(false);
		}
		translate([5, 10, 0]) miniatx(true);
		translate([wall, 20, h-wall-ssdw]) ssd_holder(true);

	}
}

module teeth() {
	translate([-20, -1, 0]) cube([40, 25, 10]);
	for(i=[25:20:d-20]) {
		translate([0,i,0]) 
		rotate([0,45,45]) cube([20,20,20], true);
		translate([0,i+10,0]) 
		rotate([0,45,-45]) cube([20,20,20], true);
	}
	translate([-20, d-20, 0]) cube([40, 50, 10]);
}

module half_printablevolume() {
		translate([0,0,-10]) {
			translate([-1,-1,-1]) cube([w+2, d+2, h/2+1]);
			translate([wall/2, 0, h/2-5]) teeth();
			translate([w-wall/2, 0, h/2-5]) teeth();
		}
}


module chop_front() {
	translate([0, -1, -1]) {
		cube([w+2, 20+1, h_front+2]);
	}
}

module printable() {

	// Bottom
	intersection() {
		case();
		half_printablevolume();
	}

	// Top front
	translate([0,0,20])
	difference() {
		intersection() {
			case();
			translate([0, -0.001, 0]) chop_front(); // Hack!
		}
		half_printablevolume();
	}
	// Top rear
	translate([0,20,20])
	difference() {
		difference() {
			case();
			chop_front();
		}
		half_printablevolume();
	}

}

module slice() {
	intersection() {
		case();
		translate([w/2,-500,-500]) cube([1000,1000,1000]);
	}
}

// A couple of horizontal slices through the unit, to check that
// the parts will fit
module 2d_slices() {
	projection(cut=true) translate([0,0,-30]) case();
	projection(cut=true) translate([190,0,-1]) case();
}

printable();
//case();
//slice();

//2d_slices();
