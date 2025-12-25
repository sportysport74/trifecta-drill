// ============================================================================
// TRIFECTA DRILL - FRAME STRUCTURE
// ============================================================================
// 2020 aluminum extrusion frame with component mounts
//
// License: MIT
// Version: 1.1 (syntax fixed)
// Date: December 24, 2025
// ============================================================================

// USER PARAMETERS
// ============================================================================

frame_width = 500;
frame_depth = 500;
frame_height = 600;
extrusion_size = 20;
panel_thickness = 5;

fol_array_height = 200;
laser_height = 250;
plasma_height = 280;

$fn = 40;

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module trifecta_frame() {
    base_frame();
    vertical_posts();
    
    translate([0, 0, frame_height])
        top_frame();
    
    translate([0, 0, frame_height/2])
        mid_braces();
    
    component_mounts();
}

// ============================================================================
// FRAME COMPONENTS
// ============================================================================

module base_frame() {
    // Perimeter
    for (angle = [0:90:270]) {
        rotate([0, 0, angle])
            translate([frame_width/2 - extrusion_size/2, frame_depth/2 - extrusion_size, 0])
                extrusion_piece(frame_depth);
    }
    
    // Cross supports
    translate([0, frame_depth/3 - extrusion_size/2, 0])
        rotate([0, 0, 90])
            extrusion_piece(frame_width);
    
    translate([0, -frame_depth/3 - extrusion_size/2, 0])
        rotate([0, 0, 90])
            extrusion_piece(frame_width);
}

module vertical_posts() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([
                x * (frame_width/2 - extrusion_size/2),
                y * (frame_depth/2 - extrusion_size/2),
                extrusion_size
            ])
                extrusion_piece_vertical(frame_height);
        }
    }
}

module top_frame() {
    base_frame();
}

module mid_braces() {
    // Front and back
    for (y = [-1, 1]) {
        translate([0, y * (frame_depth/2 - extrusion_size/2), 0])
            rotate([0, 0, 90])
                extrusion_piece(frame_width);
    }
    
    // Left and right
    for (x = [-1, 1]) {
        translate([x * (frame_width/2 - extrusion_size/2), 0, 0])
            extrusion_piece(frame_depth);
    }
}

module component_mounts() {
    translate([0, 0, fol_array_height])
        mounting_plate(300, 300);
    
    translate([frame_width/2 - 100, 0, frame_height - 100])
        mounting_plate(200, 300);
    
    translate([-frame_width/2 + 100, 0, 50])
        mounting_plate(200, 200);
}

// ============================================================================
// HELPERS
// ============================================================================

module extrusion_piece(length) {
    color("silver", 0.8)
        cube([extrusion_size, length, extrusion_size]);
}

module extrusion_piece_vertical(height) {
    color("silver", 0.8)
        cube([extrusion_size, extrusion_size, height]);
}

module mounting_plate(width, depth) {
    plate_thickness = 3;
    
    color("lightgray", 0.7)
        difference() {
            cube([width, depth, plate_thickness], center=true);
            
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([
                        x * (width/2 - 15),
                        y * (depth/2 - 15),
                        0
                    ])
                        cylinder(h=plate_thickness + 2, d=5.5, center=true);
                }
            }
        }
}

// ============================================================================
// RENDER
// ============================================================================

trifecta_frame();

// ============================================================================

echo("=== FRAME SPECIFICATIONS ===");
echo(str("External: ", 
    frame_width + 2*extrusion_size, " × ", 
    frame_depth + 2*extrusion_size, " × ", 
    frame_height + 2*extrusion_size, " mm"));
echo(str("Internal: ", frame_width, " × ", frame_depth, " × ", frame_height, " mm"));
echo("============================");
