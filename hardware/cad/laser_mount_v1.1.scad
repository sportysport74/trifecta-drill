// ============================================================================
// TRIFECTA DRILL - LASER MOUNTING ASSEMBLY
// ============================================================================
// Adjustable XYZ mount for 5W 445nm laser module
// Compatible with DTR's Copper Module or similar
//
// License: MIT
// Version: 1.1 (syntax fixed)
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

// XY adjustment ranges
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
                        cylinder(h=6, d=3.2, center=false);
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
        translate([0, 0, 10])
            cylinder(h=10, d=10.5, center=false);
        
        translate([0, 0, lens_holder_length - 60])
            cylinder(h=10, d=lens_diameter + 0.5, center=false);
        
        // Mounting flange holes (4× M4)
        for (angle = [0:90:270]) {
            rotate([0, 0, angle])
                translate([tube_od/2 + 3, 0, -6])
                    cylinder(h=8, d=4.5, center=false);
        }
        
        // Adjustment access slots
        for (angle = [45, 135, 225, 315]) {
            rotate([0, 0, angle])
                translate([tube_od/2 - 1, -1, 20])
                    cube([3, 2, lens_holder_length - 70]);
        }
    }
    
    // Exit aperture cap
    translate([0, 0, lens_holder_length])
        difference() {
            cylinder(h=5, d=tube_od, center=false);
            translate([0, 0, -1])
                cylinder(h=7, d=5, center=false);
        }
}

// ============================================================================
// RENDER
// ============================================================================

laser_mount_assembly();

// ============================================================================

echo("=== LASER MOUNT SPECIFICATIONS ===");
echo(str("Total height: ", post_length + 100, " mm"));
echo(str("Base diameter: ", post_base_dia, " mm"));
echo(str("Laser module: ", laser_module_diameter, "mm × ", laser_module_length, "mm"));
echo("=====================================");
