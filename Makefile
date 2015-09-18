all: case/openivi-vents.dxf

%.eps: %.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -q -dt -f dxf:"-polyaslines -mm" $< $@

case/headunit.stl: case/headunit.scad case/openivi-vents.dxf

%.stl: %.scad
	openscad -o $@ $<

.PHONY: all
