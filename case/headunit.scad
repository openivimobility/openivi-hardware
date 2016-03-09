/*
OpenIVI 3D printable 2 DIN headunit

This comes in two flavours:
 - MiniITX suitable for Gigabyte J1900N-D3V
 - Minnowboard MAX
*/

minnowboard_max = true;

mini_itx = !minnowboard_max;

w = 180;
h = 100;
h_front = 112;
d_front = 20;

/* The Minnowboard MAX version is not as deep */
d = (minnowboard_max ? 130 : 180) + d_front;

// LCD screen dimentions
lcdw = 161.92 + 0.2;
lcdh = 110.27 + 0.2;
lcdt = 5.7;

// SSD dimentions
ssdw = 70.0;
ssdd = 100.0;
ssdt = 7.0;

// Minnowboard MAX dimentions
mbmax_w = 99;
mbmax_d = 74;
wall = 3;

// Bottom of motherboard from base
// 3mm for the MiniITX board (which can't be increased without hitting the
// SSD mount)
// 6mm for the Minnowboard (which has a connector sticking 4.25mm down)
// Minnowboard has a 5177985-2  5H connector
// http://datasheet.octopart.com/5177985-2-Tyco-Electronics-datasheet-528420.pdf
// page 9: height is 3.75+0.5mm = 4.25mm
height_mb = wall + (minnowboard_max ? 6 : 3);


module m3_nut_trap() {
	cylinder(r = 5.5 / 2 / cos(180 / 6) + 0.05, $fn=6, h=4.5);
}

module mountinghole(x, y, generate_holes) {
    translate([x,y,0]) {
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

module atxmountinghole(x, y, generate_holes) {
	// Translate from the C hole datum to a reference point
    // on the bottom left
    mountinghole(6.35 + x, 170 - y - 10.16, generate_holes);
}


module vent() {
	linear_extrude(height = 20) import("openivi-vents.dxf");
}

/* A flat mounting for a powerpole connector. */
module powerpole_mount(generate_holes) {
    if (generate_holes) {
        translate([3+2, -25, -0.5]) cube([3.5, 12.5, 1]);
        translate([3+10, -25, -0.5]) cube([3.5, 12.5, 1]);
        difference() {
            translate([3,-25,0]) cube([16, 25+1, 8+1]);
            translate([3, -25+14.5, 0]) cylinder(h=8+1, r=1, $fn=10);
            translate([3+16, -25+14.5, 0]) cylinder(h=8+1, r=1, $fn=10);
        }
        translate([3+1, -30, 0]) cube([14,20, 8+1]);
    } else {
        translate([0, -25 -3, -1]) cube([3+16+3, 25+3, 8+1]);
    }
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

module minnowboard_max(generate_holes) {
    if (!generate_holes) {
        // Visualise the location of the motherboard
        translate([0,0, height_mb])
        % cube([mbmax_w, mbmax_d, 20]);
    }
    // From 80101_0125_F200_ThruHolePlated.ncd
    // Diameter = 0.156" = 4mm
    mountinghole(0.15 * 25.4, 0.15 * 25.4, generate_holes);  // Location: (0.15, 0.15)
    mountinghole(0.15 * 25.4, 2.75 * 25.4, generate_holes);  // Location: (0.15, 2.75)
    mountinghole(3.75 * 25.4, 2.75 * 25.4, generate_holes);  // Location: (3.75, 2.75)
    mountinghole(3.75 * 25.4, 0.15 * 25.4, generate_holes);  // Location: (3.75, 0.15)
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
            if (mini_itx) {
                translate([5, 10, 0]) miniatx(false);
                translate([wall, 20, h-wall-ssdw]) ssd_holder(false);
            }
            if (minnowboard_max) {
                translate([(w-mbmax_w)/2, 20, 0]) minnowboard_max(false);
                translate([w-wall-21, d, wall]) powerpole_mount(false);
            }
		}
        if (mini_itx) {
            translate([5, 10, 0]) miniatx(true);
            translate([wall, 20, h-wall-ssdw]) ssd_holder(true);
        }
        if (minnowboard_max) {
            translate([(w-mbmax_w)/2, 20, 0]) minnowboard_max(true);
            translate([w-wall-21, d, wall]) powerpole_mount(true);
        }
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

	// Top
	translate([0,0,20])
	difference() {
        case();
		half_printablevolume();
	}
}

module slice_y() {
	intersection() {
		case();
		translate([w/2,-500,-500]) cube([1000,1000,1000]);
	}
}

module slice_z() {
	intersection() {
		case();
		translate([-500,-500,-500]) cube([1000,1000,500+h/2]);
	}
}

// A couple of horizontal slices through the unit, to check that
// the parts will fit
module 2d_slices() {
	projection(cut=true) translate([0,0,-4]) case();
	projection(cut=true) translate([190,0,-2.75]) case();
}

printable();
//case();
//slice_y();
//slice_z();
//2d_slices();
