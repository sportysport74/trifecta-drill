// ============================================================================
// TRIFECTA DRILL - PLASMA TORCH MOUNTING BRACKET
// ============================================================================
// Height-adjustable mount for CUT-50 style plasma torch
//
// License: MIT
// Version: 1.1 (syntax fixed)
// Date: December 24, 2025
// ============================================================================

// USER PARAMETERS
// ============================================================================

// Plasma torch specifications
torch_body_diameter = 20;
torch_body_length = 180;
torch_nozzle_diameter = 15;
torch_nozzle_length = 50;

// Mounting bracket
bracket_width = 80;
bracket_height = 150;
bracket_thickness = 8;
clamp_gap = 3;

// Height adjustment
standoff_min = 7;
standoff_max = 15;
adjustment_slots = 5;

// Frame mounting
extrusion_size = 20;
mounting_slot_width = 6;

// Hardware
clamp_screw_dia = 6;
mount_screw_dia = 5;
adjustment_pin_dia = 4;

// Rendering
$fn = 50;

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module plasma_torch_bracket() {
    bracket_body();
    
    translate([0, 0, bracket_height/2])
        torch_clamp();
    
    translate([bracket_width/2 - 15, 0, 0])
        height_adjustment_track();
}

// ============================================================================
// COMPONENTS
// ============================================================================

module bracket_body() {
    difference() {
        union() {
            // Vertical plate
            translate([-bracket_width/2, -bracket_thickness/2, 0])
                cube([bracket_width, bracket_thickness, bracket_height]);
            
            // Reinforcement ribs
            for (z = [20, bracket_height - 20]) {
                translate([0, 0, z])
                    rotate([90, 0, 0])
                        linear_extrude(height=bracket_thickness, center=true)
                            polygon([
                                [-bracket_width/2, 0],
                                [bracket_width/2, 0],
                                [bracket_width/2 - 15, 25],
                                [-bracket_width/2 + 15, 25]
                            ]);
            }
            
            // Frame mounting ears
            for (z = [10, bracket_height - 10]) {
                translate([-bracket_width/2 - 25, -extrusion_size/2, z - 10])
                    cube([25, extrusion_size, 20]);
            }
        }
        
        // Frame mounting holes
        for (z = [10, bracket_height - 10]) {
            for (x = [-bracket_width/2 - 20, -bracket_width/2 - 8]) {
                translate([x, 0, z])
                    rotate([90, 0, 0])
                        cylinder(h=extrusion_size + 2, d=mount_screw_dia, center=true);
                
                translate([x, extrusion_size/2 - 4, z])
                    rotate([90, 0, 0])
                        cylinder(h=5, d=9, $fn=6, center=false);
            }
        }
        
        // Cable routing holes
        translate([0, 0, bracket_height - 30])
            rotate([90, 0, 0])
                cylinder(h=bracket_thickness + 2, d=12, center=true);
        
        translate([0, 0, 40])
            rotate([90, 0, 0])
                cylinder(h=bracket_thickness + 2, d=12, center=true);
        
        // Lightening holes
        for (z = [bracket_height/4, bracket_height*3/4]) {
            translate([0, 0, z])
                rotate([90, 0, 0])
                    cylinder(h=bracket_thickness + 2, d=20, center=true);
        }
    }
}

module torch_clamp() {
    clamp_length = 60;
    clamp_od = torch_body_diameter + 10;
    
    difference() {
        union() {
            // Main clamp cylinder
            difference() {
                cylinder(h=clamp_length, d=clamp_od, center=true);
                
                // Split gap
                translate([clamp_od/2 - clamp_gap/2, -clamp_od/2 - 1, -clamp_length/2 - 1])
                    cube([clamp_gap, clamp_od + 2, clamp_length + 2]);
            }
            
            // Clamp ears
            for (y = [-clamp_od/2 - 5, clamp_od/2 + 5]) {
                translate([clamp_od/2 - clamp_gap/2 - 3, y, 0])
                    rotate([90, 0, 0])
                        cylinder(h=abs(y) * 2, d=12, center=true);
            }
            
            // Mounting tab
            translate([-clamp_od/2, -8, 0])
                cube([15, 16, clamp_length], center=true);
        }
        
        // Torch body bore
        cylinder(h=clamp_length + 2, d=torch_body_diameter + 0.5, center=true);
        
        // Clamp screw hole
        translate([clamp_od/2 + 5, 0, 0])
            rotate([90, 0, 0])
                cylinder(h=clamp_od + 20, d=clamp_screw_dia, center=true);
        
        // Mounting tab holes
        translate([-clamp_od/2 + 7, 0, clamp_length/2 - 10])
            rotate([0, 90, 0])
                cylinder(h=20, d=adjustment_pin_dia, center=true);
        
        translate([-clamp_od/2 + 7, 0, -clamp_length/2 + 10])
            rotate([0, 90, 0])
                cylinder(h=20, d=adjustment_pin_dia, center=true);
    }
}

module height_adjustment_track() {
    track_length = bracket_height - 40;
    track_width = 20;
    
    difference() {
        translate([0, -track_width/2, 20])
            cube([bracket_thickness, track_width, track_length]);
        
        // Adjustment slots
        slot_spacing = track_length / (adjustment_slots + 1);
        for (i = [1:adjustment_slots]) {
            translate([-1, 0, 20 + i * slot_spacing])
                rotate([0, 90, 0])
                    cylinder(h=bracket_thickness + 2, d=adjustment_pin_dia + 0.3, center=false);
            
            translate([-1, -(adjustment_pin_dia + 0.3)/2, 20 + i * slot_spacing - 3])
                cube([bracket_thickness + 2, adjustment_pin_dia + 0.3, 6]);
        }
    }
}

// ============================================================================
// RENDER
// ============================================================================

plasma_torch_bracket();

// ============================================================================

echo("=== PLASMA BRACKET SPECIFICATIONS ===");
echo(str("Height: ", bracket_height, " mm"));
echo(str("Width: ", bracket_width, " mm"));
echo(str("Torch diameter: ", torch_body_diameter, " mm"));
echo(str("Standoff: ", standoff_min, "-", standoff_max, " mm"));
echo("=====================================");
