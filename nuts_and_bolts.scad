// Copyright 2010 D1plo1d

// This library is dual licensed under the GPL 3.0 and the GNU Lesser General Public License as per http://creativecommons.org/licenses/LGPL/2.1/ .

//testNutsAndBolts();

module SKIPtestNutsAndBolts()
{
	$fn = 360;
	translate([0,15])nutHole(3, proj=2);
	boltHole(3, length= 30, proj=2);
}

MM = "mm";
INCH = "inch"; //Not yet supported

//conversion from M-number to index for shorter lists
//fractional sizes (M3.5) not yet supported
M = [-1, 0, 1, 2, 3, 4, 5, 6, 7, 
//      M1,M2,M3,M4,M5,M6,M7,M8, 
     -1, 8, -1, 9, -1, 10, -1, 11, -1, 12, -1, 13, -1, 14, -1, 15,
//      M10,   M12,    M14,   M16,    M18,    M20,    M22,    M24,
     -1, -1, 16, -1, -1, 17, -1, -1, 18, -1, -1, 19, -1, -1, 20, -1, -1, 21, -1, -1, 22, -1, -1, 23,
//          M27,        M30,        M33,        M36,        M39,        M42,        M45,        M48,
     -1, -1, 1, 24, -1, -1, -1, 25, -1, -1, -1, -1, -1, -1, -1, 26];
//             M52,             M56,                           M64

//Based on: http://www.roymech.co.uk/Useful_Tables/Screws/Hex_Screws.htm
METRIC_NUT_AC_WIDTHS =
[	
	-1,  
	-1,
	6.40,//m3
	8.10,//m4
	9.20,//m5
	11.50,//m6
	-1,
	15.00,//m8
	19.60,//m10
	22.10,//m12
	-1,
	27.70,//m16
	-1,
	34.60,//m20
	-1,
	41.60,//m24
	-1,
	53.1,//m30
	-1,
	63.5,//m36,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1
];
METRIC_NUT_THICKNESS =
[
	-1,
	-1,
	2.40,//m3
	3.20,//m4
	4.00,//m5
	5.00,//m6
	-1,
	6.50,//m8
	8.00,//m10
	10.00,//m12
	-1,
	13.00,//m16
	-1,
	16.00//m20
	-1,
	19.00,//m24
	-1,
	24.00,//m30
	-1,
	29.00,//m36,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1
];

COURSE_METRIC_BOLT_MAJOR_THREAD_DIAMETERS =
[//based on max values
	-1,
	-1,
	2.98,//m3
	3.978,//m4
	4.976,//m5
	5.974,//m6
	-1,
	7.972,//m8
	9.968,//m10
	11.966,//m12
	-1,
	15.962,//m16
	-1,
	19.958,//m20
	-1,
	23.952,//m24
	-1,
	29.947,//m30
	-1,
	35.940,//m36,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1
];

module nutHole(size, units=MM, tolerance = +0.0001, proj = -1)
{
	//takes a metric screw/nut size and looksup nut dimensions
	radius = METRIC_NUT_AC_WIDTHS[M[size]]/2+tolerance;
	height = METRIC_NUT_THICKNESS[M[size]]+tolerance;
	if (proj == -1)
	{
		cylinder(r= radius, h=height, $fn = 6, center=[0,0]);
	}
	if (proj == 1)
	{
		circle(r= radius, $fn = 6);
	}
	if (proj == 2)
	{
		translate([-radius/2, 0])
			square([radius*2, height]);
	}
}

module boltHole(size, units=MM, length, tolerance = +0.0001, proj = -1)
{
	radius = COURSE_METRIC_BOLT_MAJOR_THREAD_DIAMETERS[M[size]]/2+tolerance;
//TODO: proper screw cap values
	capHeight = METRIC_NUT_THICKNESS[M[size]]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;
	capRadius = METRIC_NUT_AC_WIDTHS[M[size]]/2+tolerance; //METRIC_BOLT_CAP_RADIUS[size]+tolerance;

	if (proj == -1)
	{
	translate([0, 0, -capHeight])
		cylinder(r= capRadius, h=capHeight);
	cylinder(r = radius, h = length);
	}
	if (proj == 1)
	{
		circle(r = radius);
	}
	if (proj == 2)
	{
		translate([-capRadius/2, -capHeight])
			square([capRadius*2, capHeight]);
		square([radius*2, length]);
	}
}
