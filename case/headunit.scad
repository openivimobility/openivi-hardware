
// 2 DIN headunit
w = 180;
h = 100;
d = 180; // Estimate

// LCD
lcdw = 161.92 + 0.2;
lcdh = 110.27 + 0.2;
lcdt = 5.7;

wall = 3;

difference() {
	cube([w,d, h/2]);

	translate([wall,wall,wall]) cube([w-wall*2, d-wall*2, h]);
	
	translate([(w-lcdw)/2, -1, (h-lcdh)/2])
		cube([lcdw, lcdt, lcdh]);

}

// see page 9 of
// http://formfactors.org/developer%5Cspecs%5Cmini_itx_spec_V1_1.pdf


module atxmountinghole(x,y) {
	translate([x,y,0]) union() {
		cylinder(h=100, r=3);
	}
}

module miniatx() {
	atxmountinghole(0,0); // Hole C
	atxmountinghole(157.48, 22.86); // Hole F
	atxmountinghole(0, 154.94); // Hole H
	atxmountinghole(157.48, 154.94); // Hole J
	// TODO connectors
	translate([-6.35, -10.16, 5]) %cube([170,170,8]);
}
translate([6.35+5, 10.16+5,0])
miniatx();