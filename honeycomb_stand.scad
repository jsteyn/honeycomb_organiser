/**
@author: Jannetta S Steyn, Stuart M Lewis
@updated: 2021-01-15
@updated: 2021-01-14
@created: 2021-01-12

Honeycomb lock-in organiser
**/

// Switch on the bits you need rendered for export to STL
connector=false; // if true draw a connector
base=true; // if true draw the base
joint=false; // if true draw a joint (filler piece)
/*
Optionals:
0 = inner ring for paper towel cardboard tube
1 = large outer round rim
2 = large outer hexagonal rim
3 = outer ring for holding toilet roll tube
*/
optionals=[3]; // specify which optionals to draw

// Parameters
diameter=60; // Circumdiameter of hexagon
base_thickness=5; // Height of object (in z direction)
joint_tolerance=0.4; // Tolerance applied to holes
joint_radius=3; // Radius of joint circles
joint_diameter=joint_radius*2;
joint_width=(3/5)*joint_diameter; // Width of joint rect
joint_length=(6/5)*joint_diameter; // Height of joint rect

// Optional stuff




// Draw base
if (base) {
    for (x=optionals) {
            // Elevate to top level of base
        translate([0,0,base_thickness]) {
            if (x==0) {
                // Draw holder - cardboard tube inner
                // Draw small ring
                ring(22,2,25,100);
            }

            if (x==1) {
                // Draw holder - large ring
                //Draw big ring
                ring(50,2,25,100);
            }
            
            if (x==2) {
                // Draw hexagon holder
                ring(50,2,25,6);
            }
            if (x==3) {
                // Draw toilet roll tube holder
                ring(45,2,30,100);
            }
        }
    }
    difference() {
        honeycomb();
        
        ring_arrange(6,diameter/2,true)
            translate([-(6/5)*joint_diameter,0,0])
                rotate([0,0,-90])
                    joint(joint_width,joint_length,base_thickness,
                          joint_diameter,joint_tolerance);
    }
}


// Draw connector
if (connector) {
    translate([60,0,0]) {
        double_joint(joint_length*2)
            joint(joint_width,joint_length,base_thickness,
                  joint_diameter);
    }
}

// Draw a filler (half a connector)
if (joint) {
    translate([80,0,0]) {
           joint(joint_width,joint_length,base_thickness,
                  joint_diameter);
     }
}

// --
// Double joints fit in place (This can be commented out)
/*
ring_arrange(6,diameter/2,true)
    rotate([0,0,90])
        double_joint(joint_length*2)
            joint(joint_width,joint_length,base_thickness,
                  joint_diameter);
*/
// --

/**
* Base hexagon shape of the stand
**/
module honeycomb() {
    cylinder(d=diameter,h=base_thickness,$fn=6);
}

/**
* Shape of the key for the stand
* @param width [x] Width of the rectangle
* @param length [y] Length of the rectangle (originating from the center of the circle)
* @param thickness [z] Height of the shape
* @param diameter Diameter of the circle
* @param tolerance Additional thickness to be added (for cutouts)
**/
module joint(width,length,thickness,diameter=5,tolerance=0) {
    cylinder(d=diameter+tolerance,
             h=thickness, $fn=30);
    translate([-width/2-tolerance/2,0,0])
        cube([width+tolerance,
              length,
              thickness]);
}

/**
* Create two mirrored children
* @param distance [y] Distance between centers of the children
**/
module double_joint(distance) {
    translate([0,-distance/2,0])
        children();
    translate([0,distance/2,0])
        rotate([0,0,180])
            children();
}

/**
* Arrange children along points on a polygon
* @param n Number of points (i.e. polygon sides)
* @param distance [x] Radius of the circle to plot on
* @param on_apothem If true, position children on the center of each face of the polygon, else position them on the vertices
**/
module ring_arrange(n,distance,on_apothem) {
    r=on_apothem ? 180/n : 0;
    d=on_apothem ? distance*cos(180/n) : n;
    
    rotate([0,0,r])
        for (i = [0:n])
            rotate([0,0,360*i/n])
                translate([d,0,0])
                    children();
}

/**
* Rings on base 
* @param outer diameter of ring
* @param thickness of diameter ring
* @param height of ring
**/
module ring(outer_diameter, thickness, height, faces) {
    difference() {
        cylinder(d=outer_diameter,h=height,center=false,$fn=faces);
        cylinder(d=outer_diameter-thickness,h=height,center=false,$fn=faces);
    }
}
