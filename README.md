# 3D Printed car headunit - OpenIVI Mobility

This is a 3D printable car headunit designed to house a Mini-ITX motherboard
and 7" touchscreen.

## Hardware

This design has been built using the following components:

Component           | Approximate Cost/€
------------------- | ------------------:
Gigabyte J1900N-D3V | 88.00
8GB RAM             | 58.00
SSD                 | 51.00
M3-ATX PicoPSU      | 55.00
Molex → P4 cable    | 4.00
[Touchscreen](http://www.chalk-elec.com/?page_id=1280#!/7-open-frame-universal-HDMI-LCD-with-capacitive-multi-touch/p/21750207/category=3094861) | 125.00
[Left-hand Right angle mini hdmi](http://www.amazon.de/COM-FOUR%C2%AE-Stecker-Adapter-vergoldet-gewinkelt/dp/B00LOGIUVU/ref=sr_1_1?s=computers&ie=UTF8&qid=1443017549&sr=1-1&keywords=COM-FOUR%C2%AE+HDMI+Buchse+auf+Mini+HDMI+Stecker+Adapter+vergoldet+schwarz+%28links+gewinkelt%29) | 7.00
HDMI cable          | 5.00
Right angle DVI     | 6.00
M3 Hex bolts        | 0.10
M3 Nylock nuts      | 0.10
M3 Washers          | 0.10
12v PSU             | 10.00

Note that for other Mini-ITX motherboards you may want to check the clearance
of the SSD mount on the left.  On the Gigabyte motherboard the PCI header
_just_ fits underneath.

## Compiling

The 3D model is designed in [OpenSCAD](http://www.openscad.org/).

	sudo apt-get install openscad inkscape pstoedit
	# Create case/openivi-vents.dxf from case/openivi-vents.svg
	make
	openscad case/headunit.scad

