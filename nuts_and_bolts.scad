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
EPS = 0.0015; // to compensate z-fighting

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


//table template
/*
[   xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, 
//    M10     M12     M14     M16     M18     M20     M22     M24
    xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, xxx.xx, 
//    M27     M30     M33     M36     M39     M42     M45     M48
    xxx.xx, xxx.xx, xxx.xx
//    M52     M56     M64
]
*/

//Based on: http://www.roymech.co.uk/Useful_Tables/Screws/Hex_Screws.htm
METRIC_NUT_AC_WIDTHS =
[       -1,     -1, 006.40, 008.10, 009.20, 011.50,     -1, 015.00, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    019.60, 022.10,     -1, 027.70,     -1, 034.60,     -1, 041.60, 
//    M10     M12     M14     M16     M18     M20     M22     M24
        -1, 053.10,     -1, 063.50,     -1,     -1,     -1,     -1, 
//    M27     M30     M33     M36     M39     M42     M45     M48
        -1,     -1,     -1
//    M52     M56     M64
];

METRIC_NUT_THICKNESS =
[       -1,     -1, 002.40, 003.20, 004.00, 005.00,     -1, 006.50, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    008.00, 010.00,     -1, 013.00,     -1, 016.00,     -1, 019.00, 
//    M10     M12     M14     M16     M18     M20     M22     M24
        -1, 024.00,     -1, 029.00,     -1,     -1,     -1,     -1, 
//    M27     M30     M33     M36     M39     M42     M45     M48
        -1,     -1,     -1
//    M52     M56     M64
];


COURSE_METRIC_BOLT_MAJOR_THREAD_DIAMETERS =
//based on max values
[       -1,     -1, 002.98, 03.978, 04.976, 05.974,     -1, 07.972, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    09.968, 11.966,     -1, 15.962,     -1, 19.958,     -1, 23.952, 
//    M10     M12     M14     M16     M18     M20     M22     M24
        -1, 29.947,     -1, 35.940,     -1,     -1,     -1,     -1, 
//    M27     M30     M33     M36     M39     M42     M45     M48
        -1,     -1,     -1
//    M52     M56     M64
];
	

module nutHole(size, units=MM, tolerance = +0.0001, proj = -1)
{
	//takes a metric screw/nut size and looksup nut dimensions
	radius = METRIC_NUT_AC_WIDTHS[M[size]]/2+tolerance;
	height = METRIC_NUT_THICKNESS[M[size]]+tolerance;
	if (proj == -1)
	{
		translate([0 ,0 , -EPS])
			cylinder(r= radius, h=height+EPS, $fn = 6, center=[0,0]);
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
		translate([0, 0, -EPS])
		{
			translate([0, 0, -capHeight])
				cylinder(r= capRadius, h=capHeight);
			cylinder(r = radius, h = length+EPS);
		}
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
