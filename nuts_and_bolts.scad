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

// value tables to follow. see below for functions
//ISO4017
HEX_HEAD_AC_WIDTHS =
[       -1, 004.32, 006.01, 007.66, 008.79, 011.05,     -1, 014.38, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    018.90, 021.10, 024.49, 026.75, 030.14, 033.53, 035.72, 039.98, 
//    M10     M12     M14     M16     M18     M20     M22     M24
    045.20, 050.85, 055.37, 060.79, 069.28, 075.06, 080.83, 086.60, 
//    M27     M30     M33     M36     M39     M42     M45     M48
    092.38, 098.15, 109.70
//    M52     M56     M64
];
//Source: real world sockets
HEX_HEAD_SOCKET_WIDTHS =
[       -1, 007.60, 009.50, 011.30, 012.50, 015.00, 016.30, 018.80, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    027.00, 032.00, 035.00, 039.00, 043.00, 047.00, 052.00, 054.00, 
//    M10     M12     M14     M16     M18     M20     M22     M24
    060.00, 067.00, 071.00, 077.00, 084.00, 093.00, 100.00, 104.00, 
//    M27     M30     M33     M36     M39     M42     M45     M48
    109.00, 115.00, 130.00
//    M52     M56     M64
];

//ISO4017
HEX_HEAD_THICKNESS =
[       -1, 001.40, 002.00, 002.80, 003.50, 004.00,     -1, 005.30, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    006.40, 007.50, 008.80, 010.00, 011.50, 012.50, 014.00, 015.00, 
//    M10     M12     M14     M16     M18     M20     M22     M24
    017.00, 018.70, 021.00, 022.50, 025.00, 026.00, 028.00, 030.00, 
//    M27     M30     M33     M36     M39     M42     M45     M48
    033.00, 035.00, 040.00
//    M52     M56     M64
];


COURSE_METRIC_BOLT_INNER_THREAD_DIAMETERS =
//based on max values
[   000.75, 001.60, 002.50, 003.30, 004.20, 005.00, 006.00, 006.80, 
//    M1      M2      M3      M4      M5      M6      M7      M8
    008.50, 010.20, 012.00, 014.00, 015.50, 017.50, 019.50, 021.00, 
//    M10     M12     M14     M16     M18     M20     M22     M24
    024.00, 026.50, 029.50, 032.00, 035.00, 037.50, 040.50, 043.00, 
//    M27     M30     M33     M36     M39     M42     M45     M48
// last three are fine thread only
    050.50,     -1,     -1
//    M52     M56     M64
];


/**
* Creates a hex-shaped object that can be used in a difference{} to cut out a 
* shape to fit a hex nut in. Aligns the object-facing side of the nut to the origin
*/
module nutHole(size, units=MM, tolerance = +0.2001, proj = -1, sunken = 0)
{
	//takes a metric screw/nut size and looksup nut dimensions
	radius = HEX_HEAD_AC_WIDTHS[M[size]]/2+tolerance;
	height = HEX_HEAD_THICKNESS[M[size]]+tolerance;
	if (proj == -1)
	{
		translate([0 ,0 , -sunken-EPS])
			cylinder(r= radius, h=4*height+EPS, $fn = 6, center=[0,0]);
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

/**
* Creates a hex-shaped object that can be used in a difference{} to cut out a 
* shape to fit a hex nut in. Aligns the far-facing side of the nut to the origin,
* so that without an additional translate(), the nut will be sunken in the object
*/
module nutHole_sunken(size, units=MM, tolerance = +0.2001, proj = -1)
{
	height = HEX_HEAD_THICKNESS[M[size]]+tolerance;
	nutHole(size, units, tolerance, proj, sunken=height);
}

/**
* Creates a hex-nut object. Aligns the object-facing side of the nut to the origin
* No threads are rendered. Inner diameter is inside of thread.
*/
module nut(size, units=MM, tolerance = +0.0001, proj = -1)
{
	boltRadius = COURSE_METRIC_BOLT_INNER_THREAD_DIAMETERS[M[size]]/2+tolerance;
	nutRadius = HEX_HEAD_AC_WIDTHS[M[size]]/2+tolerance;
	nutHeight = HEX_HEAD_THICKNESS[M[size]]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;
	echo("radii=", [boltRadius, nutRadius, nutHeight]);
	difference() {
		translate([0 ,0 , 0])
			cylinder(r= nutRadius+tolerance, h=nutHeight, $fn = 6, center=[0,0]);
		translate([0,0,-EPS])
			cylinder(r = boltRadius, h = nutHeight+2*EPS, center=false);
	}
}

/**
* Creates a hex-nut object. Aligns the far-facing side of the nut to the origin,
* so that without an additional translate(), the nut will be sunken in the object
* No threads are rendered. Inner diameter is inside of thread.
*/
module nut_sunken(size, units=MM, tolerance = +0.0001, proj = -1)
{
	nutHeight = HEX_HEAD_THICKNESS[M[size]]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;

	translate([0,0,-nutHeight+EPS])
		nut(size, units, tolerance, proj);		
}


/**
* Creates a hex-cap-plus-bolt-shaped object that can be used in a difference{} to cut 
* out a shape to fit a hex bolt in. Aligns the object-facing side of the cap to the 
* origin, so the cap sits atop the object, while the bolt cuts into it
*/
module boltHole(size, units=MM, length, tolerance = +0.0001, proj = -1)
{
	radius = size/2+tolerance;

	capHeight = HEX_HEAD_THICKNESS[M[size]]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;
	capRadius = HEX_HEAD_SOCKET_WIDTHS[M[size]]/2+tolerance; //METRIC_BOLT_CAP_RADIUS[size]+tolerance;

	if (proj == -1)
	{
		translate([0, 0, -EPS])
		{
			translate([0, 0, -capHeight*4])
				cylinder(r= capRadius, h=capHeight*4 + EPS);
			cylinder(r = radius+0.2, h = length+EPS);
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

/**
* Creates a hex-cap-plus-bolt-shaped object that can be used in a difference{} to cut 
* out a shape to fit a hex bolt in. Aligns the top-facing side of the cap to the 
* origin, so cap and bolt are sunken into the object
*/
module boltHole_sunken(size, units=MM, length, tolerance = +0.0001, proj = -1)
{
	capHeight = HEX_HEAD_THICKNESS[M[size]]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;
	translate([0,0,capHeight])
		boltHole(size, units, length, tolerance, proj);

}

/**
* Creates a hex-cap-plus-bolt-shaped object 
* Aligns the object-facing side of the cap to the 
* origin, so the cap sits atop the object, while the bolt sticks into it.
* No threads are rendered. Outer diameter is outside of thread.
*/
module bolt(size, units=MM, length, tolerance = +0.0001, proj = -1)
{
	radius = size/2+tolerance;
//TODO: proper screw cap values
	capHeight = HEX_HEAD_THICKNESS[M[size]]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;
	capRadius = HEX_HEAD_AC_WIDTHS[M[size]]/2+tolerance; //METRIC_BOLT_CAP_RADIUS[size]+tolerance;

	if (proj == -1)
	{
		translate([0, 0, -EPS])
		{
			translate([0, 0, -capHeight])
				cylinder(r= capRadius, h=capHeight+EPS, $fn = 6, center=[0,0]);
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

/**
* Creates a hex-cap-plus-bolt-shaped object. Aligns the top-facing side of the 
* cap to the origin, so the cap is sunken into the object
* No threads are rendered. Outer diameter is outside of thread.
*/
module bolt_sunken(size, units=MM, length, tolerance = +0.0001, proj = -1)
{

	capHeight = HEX_HEAD_THICKNESS[M[size]]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;
	translate([0,0,capHeight])
		bolt(size, units, length, tolerance, proj);
}