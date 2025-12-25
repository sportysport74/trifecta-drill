// ============================================================================
// TRIFECTA DRILL - PLASMA TORCH MOUNTING BRACKET
// ============================================================================
// Height-adjustable mount for CUT-50 style plasma torch
// Temperature-activated, auto-ignition control
//
// License: MIT
// Version: 1.0
// Date: December 24, 2025
// ============================================================================

// USER PARAMETERS
// ============================================================================

// Plasma torch specifications (CUT-50 standard)
torch_body_diameter = 20;     // mm (handle diameter)
torch_body_length = 180;      // mm
torch_nozzle_diameter = 15;   // mm (consumable holder)
torch_nozzle_length = 50;     // mm

// Mounting bracket
bracket_width = 80;           // mm
bracket_height = 150;         // mm
bracket_thickness = 8;        // mm
clamp_gap = 3;                // mm (for tightening)

// Height adjustment
standoff_min = 7;             // mm (minimum arc distance)
standoff_max = 15;            // mm (maximum arc distance)
adjustment_slots = 5;         // Number of height positions

// Frame mounting (2020 aluminum extrusion)
extrusion_size = 20;          // mm (standard 2020 profile)
mounting_slot_width = 6;      // mm (T-slot width)

// Hardware
clamp_screw_dia = 6;          // mm (M6 for torch clamp)
mount_screw_dia = 5;          // mm (M5 for frame)
adjustment_pin_dia = 4;       // mm (M4 for height lock)

// Rendering
$fn = 50;

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module plasma_torch_bracket() {
    // Main bracket body
    bracket_body();
    
    // Torch clamp assembly
    translate([0, 0, bracket_height/2])
        torch_clamp();
    
    // Height adjustment mechanism
    translate([bracket_width/2 - 15, 0, 0])
        height_adjustment_track();
}

// ============================================================================
// COMPONENT MODULES
// ============================================================================

// Main bracket body
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
            
            // Frame mounting ears (top and bottom)
            for (z = [10, bracket_height - 10]) {
                translate([-bracket_width/2 - 25, -extrusion_size/2, z - 10])
                    cube([25, extrusion_size, 20]);
            }
        }
        
        // Frame mounting T-slot holes (4× total)
        for (z = [10, bracket_height - 10]) {
            for (x = [-bracket_width/2 - 20, -bracket_width/2 - 8]) {
                translate([x, 0, z])
                    rotate([90, 0, 0])
                        cylinder(h=extrusion_size + 2, d=mount_screw_dia, center=true);
                
                // Hex nut trap
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
        
        // Lightening holes (weight reduction)
        for (z = [bracket_height/4, bracket_height*3/4]) {
            translate([0, 0, z])
                rotate([90, 0, 0])
                    cylinder(h=bracket_thickness + 2, d=20, center=true);
        }
    }
}

// Torch clamp assembly
module torch_clamp() {
    clamp_length = 60;
    clamp_od = torch_body_diameter + 10;
    
    difference() {
        union() {
            // Main clamp cylinder (split)
            difference() {
                cylinder(h=clamp_length, d=clamp_od, center=true);
                
                // Split gap for clamping
                translate([clamp_od/2 - clamp_gap/2, -clamp_od/2 - 1, -clamp_length/2 - 1])
                    cube([clamp_gap, clamp_od + 2, clamp_length + 2]);
            }
            
            // Clamp ears (for M6 bolt)
            for (y = [-clamp_od/2 - 5, clamp_od/2 + 5]) {
                translate([clamp_od/2 - clamp_gap/2 - 3, y, 0])
                    rotate([90, 0, 0])
                        cylinder(h=abs(y) * 2, d=12, center=true);
            }
            
            // Mounting tab (connects to bracket)
            translate([-clamp_od/2, -8, 0])
                cube([15, 16, clamp_length], center=true);
        }
        
        // Torch body bore
        cylinder(h=clamp_length + 2, d=torch_body_diameter + 0.5, center=true);
        
        // Clamp screw hole
        translate([clamp_od/2 + 5, 0, 0])
            rotate([90, 0, 0])
                cylinder(h=clamp_od + 20, d=clamp_screw_dia, center=true);
        
        // Mounting tab holes (for height adjustment pins)
        translate([-clamp_od/2 + 7, 0, clamp_length/2 - 10])
            rotate([0, 90, 0])
                cylinder(h=20, d=adjustment_pin_dia, center=true);
        
        translate([-clamp_od/2 + 7, 0, -clamp_length/2 + 10])
            rotate([0, 90, 0])
                cylinder(h=20, d=adjustment_pin_dia, center=true);
    }
}

// Height adjustment track
module height_adjustment_track() {
    track_length = bracket_height - 40;
    track_width = 20;
    
    difference() {
        // Track body
        translate([0, -track_width/2, 20])
            cube([bracket_thickness, track_width, track_length]);
        
        // Adjustment slots (vertical slots at intervals)
        slot_spacing = track_length / (adjustment_slots + 1);
        for (i = [1:adjustment_slots]) {
            translate([-1, 0, 20 + i * slot_spacing])
                rotate([0, 90, 0])
                    cylinder(h=bracket_thickness + 2, d=adjustment_pin_dia + 0.3, center=false);
            
            // Slot extensions (allow vertical fine-tuning)
            translate([-1, -(adjustment_pin_dia + 0.3)/2, 20 + i * slot_spacing - 3])
                cube([bracket_thickness + 2, adjustment_pin_dia + 0.3, 6]);
        }
    }
}

// ============================================================================
// VISUALIZATION HELPERS
// ============================================================================

// Plasma torch (for fit check)
module plasma_torch_viz() {
    color("gray")
        translate([0, 0, bracket_height/2]) {
            // Torch body
            rotate([90, 0, 0])
                cylinder(h=torch_body_length, d=torch_body_diameter, center=true);
            
            // Nozzle assembly
            rotate([90, 0, 0])
                translate([0, 0, torch_body_length/2])
                    cylinder(h=torch_nozzle_length, d=torch_nozzle_diameter, center=false);
        }
}

// Arc visualization (beam path)
module arc_path_viz() {
    color("cyan", 0.3)
        translate([0, torch_body_length/2 + torch_nozzle_length + 10, bracket_height/2])
            rotate([90, 0, 0])
                cylinder(h=20, d=3, center=false);
}

// 2020 extrusion (mounting reference)
module extrusion_viz() {
    color("silver", 0.5)
        translate([-bracket_width/2 - 35, 0, bracket_height/2])
            rotate([0, 0, 0])
                cube([extrusion_size, extrusion_size, bracket_height + 40], center=true);
}

// ============================================================================
// RENDER OPTIONS
// ============================================================================

// Uncomment ONE:

// Option 1: Complete assembly
plasma_torch_bracket();
//plasma_torch_viz();
//arc_path_viz();
//extrusion_viz();

// Option 2: Individual parts
//bracket_body();
//translate([100, 0, 0]) torch_clamp();
//translate([200, 0, 0]) height_adjustment_track();

// ============================================================================
// ASSEMBLY NOTES
// ============================================================================
//
// Assembly sequence:
// 1. Attach bracket to 2020 extrusion frame using 4× M5 T-slot nuts
// 2. Insert plasma torch into clamp (nozzle pointing down/forward)
// 3. Align torch nozzle 7-10mm above work surface
// 4. Tighten M6 clamp screw (do not overtighten!)
// 5. Insert 2× M4 pins through clamp tabs into adjustment slots
// 6. Verify standoff distance with feeler gauge
// 7. Route cables through bracket holes, secure with zip ties
//
// Standoff adjustment:
// - 7mm: Maximum power transfer, hot cutting
// - 10mm: Balanced performance (recommended for trifecta)
// - 15mm: Gentler cutting, extended consumable life
//
// Fine-tuning procedure:
// 1. Run acoustic + laser to heat granite to 800K
// 2. Trigger plasma manually (test button)
// 3. Adjust height until arc strikes cleanly
// 4. Lock position with adjustment pins
// 5. Test auto-activation with thermocouple interlock
//
// Safety notes:
// - Ground work clamp before ANY operation
// - Wear auto-darkening welding helmet (shade 7+)
// - Ensure adequate ventilation (10+ ACH)
// - Keep fire extinguisher within reach
// - Never touch torch during operation (100V DC!)
//
// ============================================================================
// MATERIALS
// ============================================================================
//
// Recommended:
// - Bracket: 6061-T6 Aluminum or mild steel (CNC/laser cut)
// - Clamp: 6061 Aluminum (good thermal + electrical isolation)
// - Fasteners: Stainless steel (corrosion resistance)
//
// Alternative (prototype):
// - Bracket: 1/4" steel plate (waterjet or plasma cut)
// - Clamp: 3D printed PETG (heat resistant)
// - Note: Monitor for thermal stress, may need heat shield
//
// Hardware needed:
// - 4× M5 × 12mm socket head + T-slot nuts (frame mount)
// - 1× M6 × 40mm socket head (torch clamp)
// - 2× M4 × 20mm shoulder screws (height adjustment pins)
// - 4× M5 hex nuts (mounting ear traps)
// - Threadlocker (all screws except adjustment pins)
// - Kapton tape (electrical isolation on clamp)
//
// ============================================================================
// TORCH COMPATIBILITY
// ============================================================================
//
// Compatible torches (similar dimensions):
// - CUT-50 / CUT-60 (most common)
// - Lotos LTP5000D
// - Amico CUT-50
// - Eastwood Versa-Cut 40
// - Generic Chinese 50A inverter torches
//
// NOT compatible (different mounting):
// - Hand-held torches with trigger
// - Industrial robotic torches (different interface)
// - Water-cooled torches (larger diameter)
//
// If your torch differs:
// - Measure body diameter, adjust torch_body_diameter parameter
// - May need to modify clamp length for cable routing
// - Ensure consumable holder clears adjustment mechanism
//
// ============================================================================

echo("=== PLASMA TORCH BRACKET SPECIFICATIONS ===");
echo(str("Bracket height: ", bracket_height, " mm"));
echo(str("Bracket width: ", bracket_width, " mm"));
echo(str("Torch clamp diameter: ", torch_body_diameter, " mm"));
echo(str("Standoff range: ", standoff_min, "-", standoff_max, " mm"));
echo(str("Height positions: ", adjustment_slots));
echo(str("Frame compatibility: 2020 aluminum extrusion"));
echo("==========================================");
