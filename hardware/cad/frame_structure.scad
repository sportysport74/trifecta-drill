// ============================================================================
// TRIFECTA DRILL - FRAME STRUCTURE
// ============================================================================
// 2020 aluminum extrusion frame with safety enclosure
// Modular design for easy assembly and modification
//
// License: MIT
// Version: 1.0
// Date: December 24, 2025
// ============================================================================

// USER PARAMETERS
// ============================================================================

// Frame dimensions
frame_width = 500;            // mm (internal width)
frame_depth = 500;            // mm (internal depth)
frame_height = 600;           // mm (internal height)

// Extrusion specifications
extrusion_size = 20;          // mm (2020 profile)
corner_bracket_size = 28;     // mm (L-bracket)

// Enclosure panels
panel_thickness = 5;          // mm (acrylic or polycarbonate)
door_width = 400;             // mm
door_height = 500;            // mm

// Access and cable management
cable_port_dia = 40;          // mm
ventilation_slots = 10;       // Number of vent slots

// Safety features
interlock_positions = 2;      // Door interlocks (redundant)
emergency_stop_dia = 40;      // mm (mushroom button)

// Component mounting positions
fol_array_height = 200;       // mm from base (acoustic array)
laser_height = 250;           // mm from base
plasma_height = 280;          // mm from base

// Rendering
$fn = 40;

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module trifecta_frame() {
    // Base frame
    base_frame();
    
    // Vertical posts
    vertical_posts();
    
    // Top frame
    translate([0, 0, frame_height])
        top_frame();
    
    // Cross braces (mid-height)
    translate([0, 0, frame_height/2])
        mid_braces();
    
    // Enclosure panels
    //enclosure_panels(); // Uncomment to show panels
    
    // Component mounting plates
    component_mounts();
    
    // Access door (hinged)
    //access_door(); // Uncomment to show door
}

// ============================================================================
// FRAME COMPONENTS
// ============================================================================

// Base frame (perimeter + cross supports)
module base_frame() {
    translate([0, 0, 0]) {
        // Perimeter
        for (angle = [0:90:270]) {
            rotate([0, 0, angle])
                translate([frame_width/2 - extrusion_size/2, frame_depth/2 - extrusion_size, 0])
                    extrusion_piece(frame_depth);
        }
        
        // Cross supports (2× for rigidity)
        translate([0, frame_depth/3 - extrusion_size/2, 0])
            rotate([0, 0, 90])
                extrusion_piece(frame_width);
        
        translate([0, -frame_depth/3 - extrusion_size/2, 0])
            rotate([0, 0, 90])
                extrusion_piece(frame_width);
    }
}

// Vertical corner posts
module vertical_posts() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([
                x * (frame_width/2 - extrusion_size/2),
                y * (frame_depth/2 - extrusion_size/2),
                extrusion_size
            ])
                rotate([0, 0, 0])
                    extrusion_piece_vertical(frame_height);
        }
    }
}

// Top frame (mirror of base)
module top_frame() {
    base_frame();
}

// Mid-height braces (lateral stability)
module mid_braces() {
    // Front and back horizontal
    for (y = [-1, 1]) {
        translate([0, y * (frame_depth/2 - extrusion_size/2), 0])
            rotate([0, 0, 90])
                extrusion_piece(frame_width);
    }
    
    // Left and right horizontal
    for (x = [-1, 1]) {
        translate([x * (frame_width/2 - extrusion_size/2), 0, 0])
                extrusion_piece(frame_depth);
    }
}

// Component mounting plates
module component_mounts() {
    // FoL array mounting plate (already modeled separately)
    translate([0, 0, fol_array_height])
        mounting_plate(300, 300);
    
    // Control electronics shelf
    translate([frame_width/2 - 100, 0, frame_height - 100])
        mounting_plate(200, 300);
    
    // Power supply shelf
    translate([-frame_width/2 + 100, 0, 50])
        mounting_plate(200, 200);
}

// ============================================================================
// ENCLOSURE COMPONENTS
// ============================================================================

// Enclosure panels (acrylic/polycarbonate)
module enclosure_panels() {
    // Front panel (with door cutout)
    color("blue", 0.3)
        difference() {
            translate([0, frame_depth/2, frame_height/2 + extrusion_size])
                cube([frame_width, panel_thickness, frame_height], center=true);
            
            // Door opening
            translate([0, frame_depth/2, frame_height/2 + extrusion_size - 50])
                cube([door_width, panel_thickness + 2, door_height], center=true);
        }
    
    // Side panels (left & right)
    for (x = [-1, 1]) {
        color("blue", 0.3)
            translate([x * frame_width/2, 0, frame_height/2 + extrusion_size])
                cube([panel_thickness, frame_depth, frame_height], center=true);
    }
    
    // Back panel (with cable ports)
    color("blue", 0.3)
        difference() {
            translate([0, -frame_depth/2, frame_height/2 + extrusion_size])
                cube([frame_width, panel_thickness, frame_height], center=true);
            
            // Cable routing ports
            for (z = [100, 200, 300, 400]) {
                translate([0, -frame_depth/2, z])
                    rotate([90, 0, 0])
                        cylinder(h=panel_thickness + 2, d=cable_port_dia, center=true);
            }
        }
    
    // Top panel (with ventilation)
    color("blue", 0.3)
        difference() {
            translate([0, 0, frame_height + extrusion_size])
                cube([frame_width, frame_depth, panel_thickness], center=true);
            
            // Ventilation slots
            for (i = [1:ventilation_slots]) {
                translate([
                    -frame_width/2 + i * (frame_width / (ventilation_slots + 1)),
                    0,
                    frame_height + extrusion_size
                ])
                    cube([10, frame_depth - 100, panel_thickness + 2], center=true);
            }
        }
}

// Access door (hinged on left side)
module access_door() {
    door_thickness = 5;
    
    color("cyan", 0.4)
        translate([0, frame_depth/2 + door_thickness/2, frame_height/2 - 50])
            cube([door_width, door_thickness, door_height], center=true);
    
    // Door handle
    color("red")
        translate([door_width/2 - 30, frame_depth/2 + 15, frame_height/2 - 50])
            cube([50, 10, 20], center=true);
    
    // Interlock switch positions (magnetic reed switches)
    for (z = [0, 1]) {
        color("yellow")
            translate([
                -door_width/2 + 20,
                frame_depth/2 + door_thickness,
                frame_height/2 - 50 + z * (door_height/2 - 50)
            ])
                cylinder(h=10, d=8, center=true);
    }
}

// ============================================================================
// HELPER MODULES
// ============================================================================

// Generic extrusion piece (horizontal)
module extrusion_piece(length) {
    color("silver", 0.8)
        cube([extrusion_size, length, extrusion_size]);
}

// Generic extrusion piece (vertical)
module extrusion_piece_vertical(height) {
    color("silver", 0.8)
        cube([extrusion_size, extrusion_size, height]);
}

// Mounting plate (for components)
module mounting_plate(width, depth) {
    plate_thickness = 3;
    
    color("lightgray", 0.7)
        translate([0, 0, 0])
            difference() {
                cube([width, depth, plate_thickness], center=true);
                
                // Mounting holes (4× corners)
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

// Corner bracket (L-bracket for frame joints)
module corner_bracket() {
    bracket_thickness = 3;
    
    color("darkgray")
        difference() {
            union() {
                cube([corner_bracket_size, corner_bracket_size, bracket_thickness]);
                
                rotate([90, 0, 0])
                    cube([corner_bracket_size, bracket_thickness, corner_bracket_size]);
                
                rotate([0, 90, 0])
                    cube([bracket_thickness, corner_bracket_size, corner_bracket_size]);
            }
            
            // Mounting holes
            for (i = [8, corner_bracket_size - 8]) {
                translate([i, i, -1])
                    cylinder(h=bracket_thickness + 2, d=5.5, center=false);
            }
        }
}

// ============================================================================
// SAFETY FEATURES
// ============================================================================

// Emergency stop button mounting
module emergency_stop_mount() {
    color("red")
        translate([frame_width/2 - 50, frame_depth/2 + 20, frame_height - 100])
            cylinder(h=60, d=emergency_stop_dia, center=false);
}

// Warning light mounts
module warning_lights() {
    colors = ["red", "yellow", "green"];
    
    for (i = [0:2]) {
        color(colors[i])
            translate([
                -frame_width/2 + 50 + i * 40,
                frame_depth/2 + 15,
                frame_height + extrusion_size - 10
            ])
                cylinder(h=20, d=22, center=true);
    }
}

// ============================================================================
// RENDER OPTIONS
// ============================================================================

// Uncomment ONE:

// Option 1: Full assembly (no panels for visibility)
trifecta_frame();
//emergency_stop_mount();
//warning_lights();

// Option 2: With enclosure panels
//trifecta_frame();
//enclosure_panels();
//access_door();

// Option 3: Exploded view (for assembly guide)
//base_frame();
//translate([0, 0, 100]) vertical_posts();
//translate([0, 0, 200]) top_frame();

// ============================================================================
// ASSEMBLY NOTES
// ============================================================================
//
// Assembly sequence:
// 1. Assemble base frame on flat surface
//    - Use corner brackets at all joints
//    - Tighten with M5 screws and T-slot nuts
//    - Check diagonal measurements (should be equal)
//
// 2. Install vertical posts
//    - Attach to base with 2× brackets per corner
//    - Use level to ensure posts are vertical
//    - Add temporary cross-braces for stability
//
// 3. Install top frame
//    - Slide onto vertical posts
//    - Align corners carefully
//    - Secure with corner brackets
//
// 4. Add mid-height braces
//    - Measure and mark center height
//    - Install horizontal braces all around
//    - Adds significant rigidity
//
// 5. Install component mounting plates
//    - FoL array at 200mm height
//    - Electronics shelf near top
//    - Power supply near bottom
//
// 6. Install enclosure panels
//    - Start with back panel (cable ports)
//    - Install side panels
//    - Install top panel (ventilation)
//    - Install front panel last
//
// 7. Hang access door
//    - Use piano hinge on left side
//    - Install magnetic catch on right
//    - Install interlock switches (2× redundant)
//
// 8. Safety features
//    - Mount emergency stop button (front right)
//    - Install warning lights (top front)
//    - Connect interlocks to Arduino
//    - Test all safety systems
//
// ============================================================================
// MATERIALS
// ============================================================================
//
// Extrusion:
// - 4m of 2020 aluminum extrusion (black anodized recommended)
// - Source: Amazon, Misumi, 80/20 Inc, local metal supplier
//
// Corner brackets:
// - 24× 2020 corner brackets (L-style)
// - Material: Die-cast zinc or aluminum
//
// Panels:
// - 2× 500×600×5mm acrylic/polycarbonate (sides)
// - 1× 500×500×5mm acrylic/polycarbonate (back)
// - 1× 500×500×5mm acrylic/polycarbonate (top)
// - 1× 400×500×5mm acrylic/polycarbonate (door)
// - Recommend polycarbonate for impact resistance
//
// Hardware:
// - 100× M5 × 10mm socket head screws
// - 100× M5 T-slot nuts (drop-in style)
// - 2× Piano hinge 500mm length
// - 2× Magnetic reed switches (NC, door interlock)
// - 1× Emergency stop button (NC, twist-release)
// - 3× LED indicator lights (12V, panel-mount)
// - Threadlocker on all frame screws
//
// Tools needed:
// - Allen keys (metric set)
// - Square (for alignment)
// - Level
// - Drill (for panel mounting holes)
// - Saw (for cutting extrusion to length)
//
// ============================================================================
// CUSTOMIZATION
// ============================================================================
//
// To modify frame size:
// - Adjust frame_width, frame_depth, frame_height parameters
// - Recalculate extrusion lengths:
//   - Horizontal: frame dimension
//   - Vertical: frame_height
//   - Panel sizes: frame dimension + overlap
//
// To add features:
// - Additional shelves: Copy mounting_plate module, adjust height
// - Cable routing: Add holes to back panel
// - Cooling fans: Add mounts to top/back panels
// - Casters: Add to base frame corners (with locking)
//
// ============================================================================

echo("=== FRAME SPECIFICATIONS ===");
echo(str("External dimensions: ", 
    frame_width + 2*extrusion_size, " × ", 
    frame_depth + 2*extrusion_size, " × ", 
    frame_height + 2*extrusion_size, " mm"));
echo(str("Internal dimensions: ", frame_width, " × ", frame_depth, " × ", frame_height, " mm"));
echo(str("Extrusion: 2020 (", extrusion_size, "mm)"));
echo(str("Total extrusion length: ~", 
    (frame_width + frame_depth) * 4 + frame_height * 4, " mm (", 
    ((frame_width + frame_depth) * 4 + frame_height * 4) / 1000, " m)"));
echo(str("Weight (empty frame): ~", 
    ((frame_width + frame_depth) * 4 + frame_height * 4) * 0.0002, " kg"));
echo("===========================");
