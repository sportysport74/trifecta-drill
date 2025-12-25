// ============================================================================
// TRIFECTA DRILL - COMPLETE ASSEMBLY
// ============================================================================
// Full system assembly showing all major components
// Use this file to visualize the complete build
//
// License: MIT
// Version: 1.0
// Date: December 24, 2025
// ============================================================================

// INCLUDE ALL COMPONENT FILES
// ============================================================================
// NOTE: In OpenSCAD, use File → Open to load this file
// Then manually include other .scad files, or copy/paste modules
// ============================================================================

// USER PARAMETERS
// ============================================================================

show_frame = true;            // Show frame structure
show_fol_array = true;        // Show FoL acoustic array
show_laser = true;            // Show laser assembly
show_plasma = true;           // Show plasma torch
show_enclosure = false;       // Show safety panels (set false for visibility)
show_work_surface = true;     // Show granite sample for reference

// Rendering quality
$fn = 50;

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module complete_trifecta_assembly() {
    
    // FRAME STRUCTURE
    if (show_frame) {
        trifecta_frame_simplified();
    }
    
    // FOL ACOUSTIC ARRAY
    if (show_fol_array) {
        translate([0, 0, 200])  // Height from base
            fol_array_simplified();
    }
    
    // LASER MOUNT
    if (show_laser) {
        translate([150, 0, 0])  // Offset to side
            laser_mount_simplified();
    }
    
    // PLASMA TORCH
    if (show_plasma) {
        translate([-150, 0, 0])  // Offset to other side
            plasma_bracket_simplified();
    }
    
    // SAFETY ENCLOSURE
    if (show_enclosure) {
        enclosure_panels_simplified();
    }
    
    // WORK SURFACE (granite sample for scale)
    if (show_work_surface) {
        work_surface();
    }
    
    // BEAM PATHS (visualization only)
    //beam_paths_viz();
}

// ============================================================================
// SIMPLIFIED COMPONENT MODELS
// ============================================================================
// These are simplified versions for assembly visualization
// Use the individual .scad files for detailed models
// ============================================================================

// Simplified frame
module trifecta_frame_simplified() {
    frame_w = 500;
    frame_d = 500;
    frame_h = 600;
    extrusion = 20;
    
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
                translate([x * (frame_w/2 - extrusion/2), y * (frame_d/2 - extrusion/2), extrusion])
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

// Simplified FoL array
module fol_array_simplified() {
    plate_size = 300;
    plate_thickness = 10;
    
    color("gold", 0.8) {
        // Mounting plate
        difference() {
            translate([-plate_size/2, -plate_size/2, 0])
                cube([plate_size, plate_size, plate_thickness]);
            
            // Center transducer hole
            translate([0, 0, -1])
                cylinder(h=plate_thickness + 2, d=10);
            
            // Inner ring (6 holes)
            r1 = 156.25 / 2;
            for (i = [0:5]) {
                angle = i * 60;
                translate([r1 * cos(angle), r1 * sin(angle), -1])
                    cylinder(h=plate_thickness + 2, d=10);
            }
            
            // Outer ring (12 holes)
            r2 = 252.8 / 2;
            for (i = [0:11]) {
                angle = i * 30;
                translate([r2 * cos(angle), r2 * sin(angle), -1])
                    cylinder(h=plate_thickness + 2, d=10);
            }
        }
        
        // Transducers (visualization)
        color("darkgray") {
            // Center
            cylinder(h=7, d=10);
            
            // Inner ring
            for (i = [0:5]) {
                angle = i * 60;
                translate([r1 * cos(angle), r1 * sin(angle), 0])
                    cylinder(h=7, d=10);
            }
            
            // Outer ring
            for (i = [0:11]) {
                angle = i * 30;
                translate([r2 * cos(angle), r2 * sin(angle), 0])
                    cylinder(h=7, d=10);
            }
        }
    }
}

// Simplified laser mount
module laser_mount_simplified() {
    color("gray", 0.7) {
        // Base post
        translate([0, 0, 0])
            cylinder(h=250, d=13);
        
        // Base plate
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
    
    // Laser beam (visualization)
    color("red", 0.3)
        translate([0, 0, 280])
            rotate([90, 0, 0])
                cylinder(h=300, d=1);
}

// Simplified plasma bracket
module plasma_bracket_simplified() {
    color("darkgray", 0.7) {
        // Bracket plate
        translate([-40, -4, 0])
            cube([80, 8, 150]);
        
        // Torch clamp
        translate([0, 0, 75])
            rotate([90, 0, 0])
                difference() {
                    cylinder(h=60, d=30, center=true);
                    cylinder(h=61, d=20, center=true);
                }
        
        // Torch body
        color("gray")
            translate([0, 0, 75])
                rotate([90, 0, 0])
                    cylinder(h=180, d=18, center=true);
        
        // Torch nozzle
        color("copper")
            translate([0, 90, 75])
                rotate([90, 0, 0])
                    cylinder(h=50, d=15);
    }
    
    // Plasma arc (visualization)
    color("cyan", 0.4)
        translate([0, 140, 75])
            rotate([90, 0, 0])
                cylinder(h=20, d=3);
}

// Simplified enclosure
module enclosure_panels_simplified() {
    frame_w = 500;
    frame_d = 500;
    frame_h = 600;
    panel_t = 5;
    
    color("blue", 0.2) {
        // Front panel (with door opening)
        difference() {
            translate([0, frame_d/2, frame_h/2 + 20])
                cube([frame_w, panel_t, frame_h], center=true);
            
            translate([0, frame_d/2, frame_h/2 - 30])
                cube([400, panel_t + 2, 500], center=true);
        }
        
        // Side panels
        for (x = [-1, 1]) {
            translate([x * frame_w/2, 0, frame_h/2 + 20])
                cube([panel_t, frame_d, frame_h], center=true);
        }
        
        // Back panel
        translate([0, -frame_d/2, frame_h/2 + 20])
            cube([frame_w, panel_t, frame_h], center=true);
        
        // Top panel
        translate([0, 0, frame_h + 20])
            cube([frame_w, frame_d, panel_t], center=true);
    }
    
    // Door
    color("cyan", 0.3)
        translate([0, frame_d/2 + 10, frame_h/2 - 30])
            cube([400, panel_t, 500], center=true);
}

// Work surface (granite sample)
module work_surface() {
    sample_size = 100;
    sample_height = 50;
    
    color("darkgray", 0.9)
        translate([0, 150, -sample_height])
            cube([sample_size, sample_size, sample_height], center=true);
    
    // Focal point indicator
    color("red")
        translate([0, 150, 0])
            sphere(d=2);
}

// Beam path visualizations
module beam_paths_viz() {
    // Acoustic pressure waves
    color("green", 0.1)
        translate([0, 0, 200])
            cylinder(h=200, d1=300, d2=10);
    
    // Laser beam
    color("red", 0.3)
        translate([150, 0, 280])
            rotate([90, 0, 0])
                cylinder(h=300, d=1);
    
    // Plasma arc
    color("cyan", 0.4)
        translate([-150, 140, 75])
            rotate([90, 0, 0])
                cylinder(h=20, d=3);
    
    // Convergence zone
    color("yellow", 0.2)
        translate([0, 150, 0])
            sphere(d=20);
}

// ============================================================================
// ANNOTATIONS AND LABELS
// ============================================================================

module assembly_labels() {
    // Component labels (text requires additional library)
    // For now, use colored spheres as markers
    
    // FoL Array marker
    color("green")
        translate([0, -180, 200])
            sphere(d=5);
    
    // Laser marker
    color("red")
        translate([150, -180, 280])
            sphere(d=5);
    
    // Plasma marker
    color("cyan")
        translate([-150, -180, 75])
            sphere(d=5);
    
    // Focal point marker
    color("yellow")
        translate([0, 150, 0])
            sphere(d=5);
}

// ============================================================================
// RENDER OPTIONS
// ============================================================================

// Main assembly view
complete_trifecta_assembly();
//assembly_labels();

// ============================================================================
// ASSEMBLY VERIFICATION
// ============================================================================
//
// Use this model to verify:
// 1. Component clearances (no collisions)
// 2. Beam path alignments (all converge at focal point)
// 3. Access for assembly/maintenance
// 4. Cable routing paths
// 5. Overall footprint and height
//
// Measurements to check:
// - FoL array to focal point: ~200mm (validated in simulation)
// - Laser to focal point: Variable (adjust XY stage)
// - Plasma nozzle to focal point: 7-10mm (critical standoff)
// - Overall footprint: 540×540mm (with frame)
// - Total height: 640mm (fits on standard workbench)
// - Weight (estimated): 25-30kg fully assembled
//
// ============================================================================
// ASSEMBLY SEQUENCE SUMMARY
// ============================================================================
//
// Phase 1: Frame assembly (Day 1, 4-6 hours)
// 1. Cut extrusions to length
// 2. Assemble base frame
// 3. Install vertical posts
// 4. Add top frame and braces
// 5. Verify squareness
//
// Phase 2: Component installation (Day 2, 6-8 hours)
// 1. Mount FoL array plate
// 2. Install and wire transducers
// 3. Mount laser assembly
// 4. Mount plasma bracket and torch
// 5. Install electronics shelf
// 6. Route all cables
//
// Phase 3: Electronics (Day 3, 4-6 hours)
// 1. Wire Arduino control system
// 2. Connect MOSFETs and relays
// 3. Install sensors
// 4. Wire safety interlocks
// 5. Test all systems individually
//
// Phase 4: Enclosure and safety (Day 4, 3-4 hours)
// 1. Install side panels
// 2. Install back panel with cable ports
// 3. Hang access door
// 4. Install interlocks
// 5. Mount warning lights
// 6. Install emergency stop
//
// Phase 5: Testing and calibration (Day 5, variable)
// 1. Power on test (no drilling)
// 2. Acoustic array verification
// 3. Laser alignment
// 4. Plasma test fire
// 5. Sequential activation test
// 6. First drilling test on granite
// 7. Measure and validate performance
//
// Total build time: 2-3 weekends for experienced builder
//
// ============================================================================
// BILL OF MATERIALS SUMMARY
// ============================================================================
//
// See COMPLETE-BOM-WITH-URLS.md for detailed parts list
//
// Quick summary:
// - Acoustic components: $2,565
// - Laser system: $400
// - Plasma system: $700
// - Control electronics: $645
// - Frame and mechanical: $697
// - TOTAL: ~$5,100
//
// Tools required:
// - Drill, saw, allen keys, multimeter, soldering iron
// - Safety equipment (MANDATORY): Laser goggles, welding helmet, 
//   hearing protection, fire extinguisher
//
// ============================================================================
// TROUBLESHOOTING GUIDE
// ============================================================================
//
// Common issues:
//
// 1. Components don't fit:
//    - Check extrusion lengths (measure twice!)
//    - Verify panel dimensions include frame overlap
//    - Confirm hole alignments before drilling
//
// 2. Beam paths don't converge:
//    - Re-check FoL array height (200mm)
//    - Adjust laser XY stage
//    - Verify plasma standoff (7-10mm)
//    - Use laser alignment tool
//
// 3. Enclosure panels don't fit:
//    - Measure frame diagonals (should be equal)
//    - Check for square at all corners
//    - Allow 1-2mm tolerance in panel cuts
//
// 4. Insufficient rigidity:
//    - Add diagonal braces
//    - Use threadlocker on all screws
//    - Add rubber feet to reduce vibration
//
// ============================================================================

echo("=== COMPLETE ASSEMBLY SPECIFICATIONS ===");
echo("Total components modeled: 4 major assemblies");
echo("  1. Frame structure (2020 extrusion)");
echo("  2. FoL acoustic array (19 emitters)");
echo("  3. Laser mount (XYZ adjustable)");
echo("  4. Plasma torch bracket (height adjustable)");
echo("");
echo("Overall dimensions: 540 × 540 × 640 mm");
echo("Estimated weight: 25-30 kg");
echo("Build time: 2-3 weekends");
echo("Total cost: ~$5,100");
echo("========================================");
