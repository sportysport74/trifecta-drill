// ============================================================================
// TRIFECTA DRILL - COMPLETE ASSEMBLY
// ============================================================================
// Full system visualization - all components together
//
// License: MIT
// Version: 1.1 (standalone, zero dependencies!)
// Date: December 24, 2025
// ============================================================================

// USER PARAMETERS
// ============================================================================

show_frame = true;
show_fol_array = true;
show_laser = true;
show_plasma = true;
show_work_surface = true;

$fn = 50;

// FIXED DIMENSIONS
frame_w = 500;
frame_d = 500;
frame_h = 600;
extrusion = 20;

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module complete_trifecta_assembly() {
    if (show_frame) {
        trifecta_frame_viz();
    }
    
    if (show_fol_array) {
        translate([0, 0, 200])
            fol_array_viz();
    }
    
    if (show_laser) {
        translate([150, 0, 0])
            laser_mount_viz();
    }
    
    if (show_plasma) {
        translate([-150, 0, 0])
            plasma_bracket_viz();
    }
    
    if (show_work_surface) {
        work_surface_viz();
    }
}

// ============================================================================
// SIMPLIFIED VISUALIZATIONS
// ============================================================================

module trifecta_frame_viz() {
    color("silver", 0.6) {
        // Base perimeter
        for (angle = [0:90:270]) {
            rotate([0, 0, angle])
                translate([frame_w/2 - extrusion/2, frame_d/2 - extrusion, 0])
                    cube([extrusion, frame_d, extrusion]);
        }
        
        // Vertical posts
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([
                    x * (frame_w/2 - extrusion/2),
                    y * (frame_d/2 - extrusion/2),
                    extrusion
                ])
                    cube([extrusion, extrusion, frame_h]);
            }
        }
        
        // Top perimeter
        translate([0, 0, frame_h + extrusion]) {
            for (angle = [0:90:270]) {
                rotate([0, 0, angle])
                    translate([frame_w/2 - extrusion/2, frame_d/2 - extrusion, 0])
                        cube([extrusion, frame_d, extrusion]);
            }
        }
    }
}

module fol_array_viz() {
    plate_size = 300;
    plate_thickness = 10;
    r1 = 78.125;  // 156.25/2
    r2 = 126.4;   // 252.8/2
    
    color("gold", 0.8) {
        // Plate
        difference() {
            translate([-plate_size/2, -plate_size/2, 0])
                cube([plate_size, plate_size, plate_thickness]);
            
            // Center hole
            translate([0, 0, -1])
                cylinder(h=plate_thickness + 2, d=10);
            
            // Inner ring
            for (i = [0:5]) {
                angle = i * 60;
                translate([r1 * cos(angle), r1 * sin(angle), -1])
                    cylinder(h=plate_thickness + 2, d=10);
            }
            
            // Outer ring
            for (i = [0:11]) {
                angle = i * 30;
                translate([r2 * cos(angle), r2 * sin(angle), -1])
                    cylinder(h=plate_thickness + 2, d=10);
            }
        }
        
        // Transducers
        color("darkgray") {
            cylinder(h=7, d=10);
            
            for (i = [0:5]) {
                angle = i * 60;
                translate([r1 * cos(angle), r1 * sin(angle), 0])
                    cylinder(h=7, d=10);
            }
            
            for (i = [0:11]) {
                angle = i * 30;
                translate([r2 * cos(angle), r2 * sin(angle), 0])
                    cylinder(h=7, d=10);
            }
        }
    }
}

module laser_mount_viz() {
    color("gray", 0.7) {
        // Base post
        cylinder(h=250, d=13);
        cylinder(h=10, d=50);
        
        // XY stage
        translate([-30, -30, 250])
            cube([60, 60, 15]);
        
        // Laser holder
        translate([0, 0, 265])
            cylinder(h=70, d=20);
        
        // Lens tube
        translate([0, 0, 280])
            rotate([90, 0, 0])
                cylinder(h=80, d=30);
    }
    
    // Beam
    color("red", 0.3)
        translate([0, 0, 280])
            rotate([90, 0, 0])
                cylinder(h=300, d=1);
}

module plasma_bracket_viz() {
    color("darkgray", 0.7) {
        // Bracket
        translate([-40, -4, 0])
            cube([80, 8, 150]);
        
        // Clamp
        translate([0, 0, 75])
            rotate([90, 0, 0])
                difference() {
                    cylinder(h=60, d=30, center=true);
                    cylinder(h=61, d=20, center=true);
                }
        
        // Torch
        color("gray")
            translate([0, 0, 75])
                rotate([90, 0, 0])
                    cylinder(h=180, d=18, center=true);
        
        // Nozzle
        color("copper")
            translate([0, 90, 75])
                rotate([90, 0, 0])
                    cylinder(h=50, d=15);
    }
    
    // Arc
    color("cyan", 0.4)
        translate([0, 140, 75])
            rotate([90, 0, 0])
                cylinder(h=20, d=3);
}

module work_surface_viz() {
    color("darkgray", 0.9)
        translate([0, 150, -50])
            cube([100, 100, 50], center=true);
    
    color("red")
        translate([0, 150, 0])
            sphere(d=2);
}

// ============================================================================
// RENDER
// ============================================================================

complete_trifecta_assembly();

// ============================================================================

echo("=== COMPLETE ASSEMBLY ===");
echo("Frame: 540 × 540 × 640 mm");
echo("Components: 4 major assemblies");
echo("Status: Ready to build!");
echo("========================");
