/*
Mounting plate for the Minnowboard MAX
*/

// Minnowboard MAX dimentions
mbmax_w = 99;
mbmax_d = 74;
wall = 3;
thin_wall = 1.5;

w = mbmax_w;
d = mbmax_d;

// Bottom of motherboard from base
// 6mm for the Minnowboard (which has a connector sticking 4.25mm down)
// Minnowboard has a 5177985-2  5H connector
// http://datasheet.octopart.com/5177985-2-Tyco-Electronics-datasheet-528420.pdf
// page 9: height is 3.75+0.5mm = 4.25mm
height_mb = wall + 6;

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


module minnowboard_max(generate_holes) {
    if (!generate_holes) {
        // Visualise the location of the 6motherboard
//        //translate([0,0, height_mb])
        //% cube([mbmax_w, mbmax_d, 20]);
    }
    // From 80101_0125_F200_ThruHolePlated.ncd
    // Diameter = 0.156" = 4mm
    mountinghole(0.15 * 25.4, 0.15 * 25.4, generate_holes);  // Location: (0.15, 0.15)
    mountinghole(0.15 * 25.4, 2.75 * 25.4, generate_holes);  // Location: (0.15, 2.75)
    mountinghole(3.75 * 25.4, 2.75 * 25.4, generate_holes);  // Location: (3.75, 2.75)
    mountinghole(3.75 * 25.4, 0.15 * 25.4, generate_holes);  // Location: (3.75, 0.15)
}

frame = 3;

module case() {

	difference () {
		union () {
			difference() {
				cube([w, d, wall]);
                translate([frame, frame, thin_wall]) 
                    cube([(w-frame*3)/2, (d-frame*3)/2, wall]);
                translate([(frame + w)/2, frame, thin_wall]) 
                    cube([(w-frame*3)/2, (d-frame*3)/2, wall]);
                translate([frame, (frame+d)/2, thin_wall]) 
                    cube([(w-frame*3)/2, (d-frame*3)/2, wall]);
                translate([(frame + w)/2, (frame+d)/2, thin_wall]) 
                    cube([(w-frame*3)/2, (d-frame*3)/2, wall]);
			}
            translate([(w-mbmax_w)/2, (d-mbmax_d)/2, 0]) minnowboard_max(false);
            
         
		}
        translate([(w-mbmax_w)/2, (d-mbmax_d)/2, 0]) minnowboard_max(true);
	}
}

module printable() {
    case();
}

module slice_y() {
	intersection() {
		case();
		translate([w/2,-500,-500]) cube([1000,1000,1000]);
	}
}

module slice_z() {
	projection(cut=true) translate([0,0,-wall/2]) case();
}

printable();
//slice_z();
