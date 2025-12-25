// ============================================================================
// TRIFECTA DRILL - LASER MOUNTING ASSEMBLY
// ============================================================================
// Adjustable XYZ mount for 5W 445nm laser module
// Compatible with DTR's Copper Module or similar
//
// License: MIT
// Version: 1.0
// Date: December 24, 2025
// ============================================================================

// USER PARAMETERS
// ============================================================================

// Laser module specifications
laser_module_diameter = 12;   // mm (typical for DTR modules)
laser_module_length = 60;     // mm
module_heatsink_dia = 20;     // mm (cooling fins)

// Mounting post (standard optical post)
post_diameter = 12.7;         // mm (1/2 inch standard)
post_length = 150;            // mm (adjustable height)
post_base_dia = 50;           // mm (base plate)
post_base_thickness = 10;     // mm

// XYZ adjustment ranges
x_travel = 30;                // mm (±15mm from center)
y_travel = 30;                // mm (±15mm from center)
z_travel = 50;                // mm (height adjustment)

// Lens holder
lens_diameter = 25;           // mm (for 50mm focal length lens)
lens_thickness = 5;           // mm
lens_holder_length = 80;      // mm (tube for collimator + lens)

// Mounting hardware
clamp_screw_dia = 5;          // mm (M5 for post clamp)
adjustment_screw_dia = 4;     // mm (M4 for XY adjustment)

// Rendering settings
$fn = 60;

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module laser_mount_assembly() {
    // Base post with mounting plate
    translate([0, 0, 0])
        mounting_post();
    
    // XY adjustment stage
    translate([0, 0, post_length])
        xy_stage();
    
    // Laser module holder
    translate([0, 0, post_length + 25])
        laser_holder();
    
    // Lens tube assembly
    translate([0, 0, post_length + 25])
        rotate([90, 0, 0])
            lens_tube();
}

// ============================================================================
// COMPONENT MODULES
// ============================================================================

// Optical post with base
module mounting_post() {
    difference() {
        union() {
            // Base plate
            cylinder(h=post_base_thickness, d=post_base_dia, center=false);
            
            // Post column
            translate([0, 0, post_base_thickness])
                cylinder(h=post_length, d=post_diameter, center=false);
            
            // Reinforcement collar
            translate([0, 0, post_base_thickness])
                cylinder(h=20, d1=post_base_dia*0.6, d2=post_diameter, center=false);
        }
        
        // Mounting holes in base (4× M6)
        for (angle = [0:90:270]) {
            rotate([0, 0, angle])
                translate([post_base_dia*0.35, 0, -1])
                    cylinder(h=post_base_thickness+2, d=6.5, center=false);
        }
        
        // Central wire routing hole
        translate([0, 0, -1])
            cylinder(h=post_base_thickness+2, d=8, center=false);
        
        // Height adjustment slots (3× slots in post)
        for (angle = [0:120:240]) {
            rotate([0, 0, angle])
                translate([post_diameter/2 - 2, -2, post_base_thickness + 30])
                    cube([4, 4, post_length - 50]);
        }
    }
}

// XY adjustment stage
module xy_stage() {
    stage_size = 60;
    stage_thickness = 15;
    
    difference() {
        union() {
            // Base platform
            translate([-stage_size/2, -stage_size/2, 0])
                cube([stage_size, stage_size, stage_thickness]);
            
            // Guide rails (X-axis)
            for (y = [-stage_size/2 + 10, stage_size/2 - 10]) {
                translate([-stage_size/2, y - 3, stage_thickness])
                    cube([stage_size, 6, 8]);
            }
        }
        
        // Post mounting hole (center)
        translate([0, 0, -1])
            cylinder(h=stage_thickness+2, d=post_diameter+0.5, center=false);
        
        // Post clamp slot
        translate([-1, -stage_size/2 - 1, -1])
            cube([2, stage_size/2, stage_thickness+2]);
        
        // Clamp screw hole
        translate([0, -stage_size/3, stage_thickness/2])
            rotate([0, 90, 0])
                cylinder(h=stage_size, d=clamp_screw_dia, center=true);
        
        // XY adjustment screw holes (4× corners)
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * stage_size/3, y * stage_size/3, -1])
                    cylinder(h=stage_thickness+2, d=adjustment_screw_dia, center=false);
            }
        }
        
        // Lightening pockets (reduce weight)
        for (x = [-1, 0, 1]) {
            for (y = [-1, 1]) {
                if (!(x == 0 && y == 0)) {
                    translate([x * stage_size/4, y * stage_size/4, stage_thickness - 8])
                        cylinder(h=10, d=15, center=false);
                }
            }
        }
    }
}

// Laser module holder
module laser_holder() {
    holder_length = 70;
    holder_outer_dia = laser_module_diameter + 8;
    
    difference() {
        union() {
            // Main tube
            cylinder(h=holder_length, d=holder_outer_dia, center=false);
            
            // Mounting ears (for XY stage attachment)
            for (angle = [90, 270]) {
                rotate([0, 0, angle])
                    translate([holder_outer_dia/2, -8, holder_length/2 - 10])
                        cube([12, 16, 20]);
            }
            
            // Cooling fin interface
            translate([0, 0, holder_length - 15])
                cylinder(h=15, d=module_heatsink_dia + 2, center=false);
        }
        
        // Laser module bore
        translate([0, 0, -1])
            cylinder(h=holder_length+2, d=laser_module_diameter + 0.5, center=false);
        
        // Heatsink clearance
        translate([0, 0, holder_length - 16])
            cylinder(h=17, d=module_heatsink_dia + 0.5, center=false);
        
        // Set screw holes (3× around circumference)
        for (angle = [0:120:240]) {
            rotate([0, 0, angle])
                translate([holder_outer_dia/2 - 3, 0, 30])
                    rotate([0, 90, 0])
                        cylinder(h=6, d=3.2, center=false); // M3 set screws
        }
        
        // Mounting ear holes (for XY stage)
        for (angle = [90, 270]) {
            rotate([0, 0, angle])
                translate([holder_outer_dia/2 + 6, 0, holder_length/2])
                    rotate([0, 90, 0])
                        cylinder(h=15, d=adjustment_screw_dia, center=true);
        }
        
        // Wire routing slot
        translate([-1, -holder_outer_dia/2 - 1, 10])
            cube([2, 5, holder_length - 20]);
    }
}

// Lens tube assembly (collimator + focusing lens)
module lens_tube() {
    tube_od = 30;
    tube_wall = 2;
    tube_id = tube_od - 2*tube_wall;
    
    difference() {
        union() {
            // Main tube
            cylinder(h=lens_holder_length, d=tube_od, center=false);
            
            // Mounting flange (connects to laser holder)
            translate([0, 0, -5])
                cylinder(h=5, d=tube_od + 10, center=false);
            
            // Lens retaining rings (internal)
            translate([0, 0, 15])
                cylinder(h=2, d=tube_id + 1, center=false);
            
            translate([0, 0, lens_holder_length - 55])
                cylinder(h=2, d=tube_id + 1, center=false);
        }
        
        // Central bore
        translate([0, 0, -6])
            cylinder(h=lens_holder_length + 8, d=tube_id, center=false);
        
        // Lens seats (stepped bores)
        // Collimator lens position (near laser)
        translate([0, 0, 10])
            cylinder(h=10, d=10.5, center=false); // 10mm collimator
        
        // Focusing lens position (near exit)
        translate([0, 0, lens_holder_length - 60])
            cylinder(h=10, d=lens_diameter + 0.5, center=false); // 25mm lens
        
        // Mounting flange holes (4× M4)
        for (angle = [0:90:270]) {
            rotate([0, 0, angle])
                translate([tube_od/2 + 3, 0, -6])
                    cylinder(h=8, d=4.5, center=false);
        }
        
        // Adjustment access slots (for lens positioning)
        for (angle = [45, 135, 225, 315]) {
            rotate([0, 0, angle])
                translate([tube_od/2 - 1, -1, 20])
                    cube([3, 2, lens_holder_length - 70]);
        }
    }
    
    // Exit aperture cap (removable for alignment)
    translate([0, 0, lens_holder_length])
        difference() {
            cylinder(h=5, d=tube_od, center=false);
            translate([0, 0, -1])
                cylinder(h=7, d=5, center=false); // 5mm beam exit
        }
}

// ============================================================================
// ASSEMBLY HELPERS
// ============================================================================

// Visualization of laser beam path
module beam_path() {
    color("red", 0.3)
        translate([0, 0, post_length + 25])
            rotate([90, 0, 0])
                cylinder(h=200, d=1, center=false);
}

// Laser module (for visualization)
module laser_module_viz() {
    color("silver")
        translate([0, 0, post_length + 25])
            rotate([90, 0, 0])
                cylinder(h=laser_module_length, d=laser_module_diameter, center=true);
    
    // Heatsink fins
    color("gold")
        translate([0, 0, post_length + 25 + laser_module_length/2 - 10])
            rotate([90, 0, 0])
                cylinder(h=15, d=module_heatsink_dia, center=true);
}

// ============================================================================
// RENDER OPTIONS
// ============================================================================

// Uncomment ONE of these:

// Option 1: Complete assembly
laser_mount_assembly();
//beam_path();
//laser_module_viz();

// Option 2: Individual parts (for separate printing/machining)
//mounting_post();
//translate([80, 0, 0]) xy_stage();
//translate([160, 0, 0]) laser_holder();
//translate([240, 0, 0]) lens_tube();

// ============================================================================
// ASSEMBLY NOTES
// ============================================================================
//
// Assembly sequence:
// 1. Mount base post to frame using 4× M6 bolts
// 2. Slide XY stage onto post, tighten clamp screw
// 3. Attach laser holder to XY stage with 2× M4 screws
// 4. Insert laser module, secure with 3× M3 set screws
// 5. Insert collimator lens (10mm), secure with retaining ring
// 6. Attach lens tube to laser holder (4× M4 screws)
// 7. Insert focusing lens (25mm f=50mm), secure with ring
// 8. Attach exit cap
//
// Alignment procedure:
// 1. Position XY stage to center beam on acoustic focal point
// 2. Adjust post height so beam hits surface at 1mm spot
// 3. Fine-tune with XY adjustment screws
// 4. Lock all screws with threadlocker
// 5. Test with granite sample before full assembly
//
// Safety notes:
// - NEVER operate laser without OD6+ goggles
// - Ensure beam path is enclosed
// - Add interlock switch to enclosure door
// - Label all laser hazard areas
//
// ============================================================================
// MATERIALS
// ============================================================================
//
// Recommended:
// - Post & base: 6061-T6 Aluminum (CNC machined)
// - XY stage: 6061-T6 Aluminum (CNC machined)
// - Laser holder: 6061-T6 Aluminum (good thermal conductivity)
// - Lens tube: Black anodized aluminum (reduces internal reflections)
//
// Alternative (prototype):
// - All parts: PETG 3D printed (100% infill)
// - Post-process: Drill holes to final size
// - Note: Lower thermal performance, use active cooling
//
// Hardware needed:
// - 4× M6 × 16mm socket head (base mounting)
// - 1× M5 × 20mm socket head (post clamp)
// - 4× M4 × 12mm socket head (XY adjustment)
// - 2× M4 × 16mm socket head (laser holder mount)
// - 3× M3 × 6mm set screws (laser module)
// - 4× M4 × 12mm socket head (lens tube flange)
// - Threadlocker (all screws)
//
// ============================================================================

echo("=== LASER MOUNT SPECIFICATIONS ===");
echo(str("Total height: ", post_length + 100, " mm"));
echo(str("Base footprint: ", post_base_dia, " mm diameter"));
echo(str("XY adjustment range: ±", x_travel/2, " mm"));
echo(str("Z adjustment range: ", z_travel, " mm (post height)"));
echo(str("Laser module: ", laser_module_diameter, " mm × ", laser_module_length, " mm"));
echo(str("Lens tube length: ", lens_holder_length, " mm"));
echo(str("Working distance: ~50mm (focal length)"));
echo("=====================================");
