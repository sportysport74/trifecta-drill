# TRIFECTA DRILL - KICAD IMPORT GUIDE
# ============================================================================
# How to create the PCB in KiCad using this information
#
# License: MIT
# Version: 1.0
# Date: December 24, 2025
# ============================================================================

## KICAD NETLIST (Text Format)
## ============================================================================
## This netlist can be imported into KiCad Eeschema
## File → Import → Netlist

(export (version D)
  (design
    (source trifecta_control_board.kicad_sch)
    (date "2025-12-24")
    (tool "Manual Netlist")
    (comment (number 1) (value "Trifecta Drill Control Board"))
    (comment (number 2) (value "Arduino Mega + 19 MOSFET Drivers"))
    (comment (number 3) (value "MIT License"))
    (comment (number 4) (value "")))
  
  (components
    ;; MICROCONTROLLER
    (comp (ref U1)
      (value ARDUINO_MEGA_2560)
      (footprint Arduino:Arduino_Mega_R3)
      (libsource (lib Arduino) (part Arduino_Mega_2560)))
    
    ;; POWER SUPPLIES
    (comp (ref PS1)
      (value RSP-1000-48)
      (footprint MeanWell:RSP-1000)
      (libsource (lib Power_Supply) (part RSP-1000-48)))
    
    (comp (ref PS2)
      (value 12V_5A_SMPS)
      (footprint Generic:AC_DC_Converter))
    
    (comp (ref PS3)
      (value 5V_3A_USB)
      (footprint Generic:AC_DC_Converter))
    
    ;; MOSFETs (19 total)
    (comp (ref Q1) (value IRF540N) (footprint TO-220))
    (comp (ref Q2) (value IRF540N) (footprint TO-220))
    (comp (ref Q3) (value IRF540N) (footprint TO-220))
    (comp (ref Q4) (value IRF540N) (footprint TO-220))
    (comp (ref Q5) (value IRF540N) (footprint TO-220))
    (comp (ref Q6) (value IRF540N) (footprint TO-220))
    (comp (ref Q7) (value IRF540N) (footprint TO-220))
    (comp (ref Q8) (value IRF540N) (footprint TO-220))
    (comp (ref Q9) (value IRF540N) (footprint TO-220))
    (comp (ref Q10) (value IRF540N) (footprint TO-220))
    (comp (ref Q11) (value IRF540N) (footprint TO-220))
    (comp (ref Q12) (value IRF540N) (footprint TO-220))
    (comp (ref Q13) (value IRF540N) (footprint TO-220))
    (comp (ref Q14) (value IRF540N) (footprint TO-220))
    (comp (ref Q15) (value IRF540N) (footprint TO-220))
    (comp (ref Q16) (value IRF540N) (footprint TO-220))
    (comp (ref Q17) (value IRF540N) (footprint TO-220))
    (comp (ref Q18) (value IRF540N) (footprint TO-220))
    (comp (ref Q19) (value IRF540N) (footprint TO-220))
    
    ;; RESISTORS - Gate resistors (1kΩ)
    (comp (ref R1) (value 1k) (footprint Resistor_THT:R_Axial_DIN0207))
    (comp (ref R2) (value 1k) (footprint Resistor_THT:R_Axial_DIN0207))
    ;; ... (R3-R19 same as R1-R2)
    
    ;; RESISTORS - Pull-down (10kΩ)
    (comp (ref R20) (value 10k) (footprint Resistor_THT:R_Axial_DIN0207))
    (comp (ref R21) (value 10k) (footprint Resistor_THT:R_Axial_DIN0207))
    ;; ... (R22-R38 same as R20-R21)
    
    ;; DIODES - Flyback protection
    (comp (ref D1) (value 1N4007) (footprint Diode_THT:D_DO-41))
    (comp (ref D2) (value 1N4007) (footprint Diode_THT:D_DO-41))
    ;; ... (D3-D19 same as D1-D2)
    
    ;; CAPACITORS - Decoupling
    (comp (ref C1) (value 100n) (footprint Capacitor_THT:C_Disc))
    (comp (ref C2) (value 100n) (footprint Capacitor_THT:C_Disc))
    ;; ... (C3-C19 same as C1-C2)
    
    ;; SENSORS
    (comp (ref U2)
      (value ACS712-30A)
      (footprint Sensor:ACS712))
    
    (comp (ref U3)
      (value ACS712-30A)
      (footprint Sensor:ACS712))
    
    (comp (ref U4)
      (value MAX6675)
      (footprint Sensor:MAX6675))
    
    ;; SSR
    (comp (ref K1)
      (value SSR-25DA)
      (footprint Relay:Relay_SSR))
    
    ;; SAFETY COMPONENTS
    (comp (ref SW1)
      (value E-STOP)
      (footprint Button:Emergency_Stop))
    
    (comp (ref SW2)
      (value DOOR_1)
      (footprint Sensor:Reed_Switch))
    
    (comp (ref SW3)
      (value DOOR_2)
      (footprint Sensor:Reed_Switch)))
  
  (nets
    ;; POWER NETS
    (net (code 1) (name +48V)
      (node (ref PS1) (pin +OUT))
      (node (ref Q1) (pin DRAIN))
      ;; ... all MOSFET drains
      (node (ref Q19) (pin DRAIN)))
    
    (net (code 2) (name +12V)
      (node (ref PS2) (pin +OUT)))
    
    (net (code 3) (name +5V)
      (node (ref PS3) (pin +OUT))
      (node (ref U1) (pin VIN)))
    
    (net (code 4) (name GND)
      (node (ref PS1) (pin -OUT))
      (node (ref PS2) (pin -OUT))
      (node (ref PS3) (pin -OUT))
      (node (ref U1) (pin GND))
      ;; ... all component grounds
      )
    
    ;; ARDUINO TO MOSFET CONNECTIONS
    (net (code 10) (name D2)
      (node (ref U1) (pin D2))
      (node (ref R1) (pin 1)))
    
    (net (code 11) (name D3)
      (node (ref U1) (pin D3))
      (node (ref R2) (pin 1)))
    ;; ... (continue for D4-D20)
    
    ;; MOSFET GATES
    (net (code 30) (name Q1_GATE)
      (node (ref R1) (pin 2))
      (node (ref R20) (pin 1))
      (node (ref Q1) (pin GATE)))
    ;; ... (continue for all MOSFETs)
    
    ;; SAFETY INPUTS
    (net (code 100) (name D24)
      (node (ref U1) (pin D24))
      (node (ref SW2) (pin 1)))
    
    (net (code 101) (name D25)
      (node (ref U1) (pin D25))
      (node (ref SW3) (pin 1)))
    
    (net (code 102) (name D26)
      (node (ref U1) (pin D26))
      (node (ref SW1) (pin 1)))))

## KICAD STEP-BY-STEP IMPORT INSTRUCTIONS
## ============================================================================

### STEP 1: Install KiCad (if not already)
```
Download from: https://www.kicad.org/download/
Version: 7.0 or newer recommended
Install with default settings
```

### STEP 2: Create New Project
```
1. Open KiCad
2. File → New Project
3. Name: trifecta_control_board
4. Location: C:\Users\fatba\trifecta-drill\hardware\electronics\kicad\
5. Click "Create"
```

### STEP 3: Open Schematic Editor
```
1. Double-click "trifecta_control_board.kicad_sch"
2. This opens Eeschema (schematic editor)
```

### STEP 4: Add Arduino Mega Symbol
```
1. Press "A" key (Add symbol)
2. Search: "Arduino_Mega"
3. If not found, download Arduino KiCad library:
   https://github.com/Alarm-Siren/arduino-kicad-library
4. Place on schematic (click to drop)
5. Label as U1
```

### STEP 5: Add MOSFET Symbols (×19)
```
1. Press "A" key
2. Search: "IRF540N" or use generic "Q_NMOS_GDS"
3. Place 19 MOSFETs in a grid pattern
4. Label Q1 through Q19
5. For each MOSFET:
   - Pin 1 (G) = Gate
   - Pin 2 (D) = Drain
   - Pin 3 (S) = Source
```

### STEP 6: Add Passive Components
```
For EACH of 19 MOSFET drivers:
1. Add resistor (1kΩ) - gate resistor
   Symbol: R → Place → Label (R1-R19)
2. Add resistor (10kΩ) - pull-down
   Symbol: R → Place → Label (R20-R38)
3. Add diode (1N4007) - flyback
   Symbol: D → Place → Label (D1-D19)
4. Add capacitor (100nF) - decoupling
   Symbol: C → Place → Label (C1-C19)
```

### STEP 7: Wire Connections
```
1. Press "W" key (start wire)
2. Click to start wire, click to end
3. Connect according to netlist above:
   - Arduino D2 → R1 → Q1 Gate
   - Q1 Gate → R20 → GND
   - Q1 Drain → D1 cathode
   - Q1 Source → GND
   - D1 anode → Q1 Drain
   - Etc.
4. Add power symbols:
   - Press "P" → Search "+48V" → Place
   - Press "P" → Search "GND" → Place
```

### STEP 8: Add Labels
```
1. Press "L" key (add label)
2. Label important nets:
   - D2, D3, D4... D20 (Arduino pins)
   - +48V, +12V, +5V, GND
   - TRANSDUCER_1 through TRANSDUCER_19
```

### STEP 9: Run Electrical Rules Check
```
1. Click "Bug" icon (ERC - Electrical Rules Check)
2. Click "Run ERC"
3. Fix any errors (usually missing power flags)
4. Re-run until zero errors
```

### STEP 10: Generate Netlist
```
1. Tools → Generate Netlist
2. Format: KiCad (default)
3. Click "Generate Netlist"
4. Save as: trifecta_control_board.net
```

### STEP 11: Open PCB Editor
```
1. Tools → Update PCB from Schematic
2. This opens Pcbnew (PCB editor)
3. Click "Update PCB"
4. All components appear as a cluster
```

### STEP 12: Arrange Components on PCB
```
1. Set board outline:
   - Edge.Cuts layer
   - Draw 200×150mm rectangle
2. Move components inside outline:
   - Arduino Mega: Top left
   - MOSFET array: Center (3 rows of 7)
   - Sensors: Top right
   - Terminals: Edges
3. Use grid snap (G key) for alignment
```

### STEP 13: Route Traces
```
1. Press "X" key (route track)
2. Click component pad to start
3. Click destination pad to finish
4. Recommended trace widths:
   - Power (+48V): 3mm
   - Power (+12V, +5V): 2mm
   - Signals: 0.5mm
5. Route all connections (airwires disappear when routed)
```

### STEP 14: Add Ground Plane
```
1. Select B.Cu layer (bottom copper)
2. Press "Ctrl+Shift+Z" (add filled zone)
3. Draw around entire board
4. Properties: Net = GND, Priority = 0
5. Press "B" to fill zone
```

### STEP 15: Run Design Rules Check
```
1. Inspect → Design Rules Checker
2. Click "Run DRC"
3. Fix any clearance violations
4. Re-run until zero errors
```

### STEP 16: Generate Gerber Files
```
1. File → Plot
2. Select layers:
   ☑ F.Cu (top copper)
   ☑ B.Cu (bottom copper)
   ☑ F.SilkS (top silkscreen)
   ☑ B.SilkS (bottom silkscreen)
   ☑ Edge.Cuts (board outline)
3. Output directory: gerbers/
4. Click "Plot"
5. Click "Generate Drill Files"
```

### STEP 17: Export PDF Schematic
```
1. In Eeschema: File → Plot
2. Format: PDF
3. Options: ☑ Plot border and title block
4. Click "Plot Current Page"
5. Save as: trifecta_control_board_schematic.pdf
```

---

## ALTERNATIVE: EASYEDA (EASIER THAN KICAD!)
## ============================================================================

### Why EasyEDA?
- Web-based (no installation!)
- Drag-and-drop interface
- Built-in part library
- Direct PCB ordering (JLCPCB)

### Quick Start:
```
1. Go to: https://easyeda.com/
2. Sign up (free)
3. New Project → PCB Project
4. Add components from library
5. Wire connections
6. Click "Convert to PCB"
7. Auto-route or manual route
8. Order PCB directly (sends Gerbers to JLCPCB)
```

---

## FILE SUMMARY
## ============================================================================

**What you'll have after following these steps:**

1. **trifecta_control_board.kicad_sch** - Schematic file
2. **trifecta_control_board.kicad_pcb** - PCB layout
3. **trifecta_control_board.pdf** - Printable schematic
4. **gerbers/** folder with:
   - F.Cu.gbr (top copper)
   - B.Cu.gbr (bottom copper)
   - F.SilkS.gbr (top silkscreen)
   - B.SilkS.gbr (bottom silkscreen)
   - Edge.Cuts.gbr (board outline)
   - PTH.drl (drill file)

**Upload gerbers to:**
- JLCPCB.com (cheapest, 5 PCBs for $2 + shipping)
- PCBWay.com (good quality)
- OSH Park (US-based, purple PCBs)

---

**END OF KICAD IMPORT GUIDE**
