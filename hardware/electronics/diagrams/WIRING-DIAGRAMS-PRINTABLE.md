# TRIFECTA DRILL - PRINTABLE WIRING DIAGRAMS
# ============================================================================
# Complete visual guide for hand-wiring the control system
# Print this document and follow step-by-step
#
# License: MIT
# Version: 1.0
# Date: December 24, 2025
# ============================================================================

## HOW TO USE THIS DOCUMENT
## ============================================================================

**PRINT INSTRUCTIONS:**
1. Save this file as PDF (use browser or Markdown → PDF converter)
2. Print on letter/A4 paper
3. Use while building - check off each connection as you complete it
4. Keep as reference during troubleshooting

**TOOLS NEEDED:**
- Soldering iron (if using perfboard)
- Wire strippers
- Multimeter
- Screwdriver set
- Zip ties for cable management

---

## DIAGRAM 1: POWER DISTRIBUTION
## ============================================================================

```
                        MAIN POWER DISTRIBUTION
                        
                                120V AC Wall Power
                                      │
                                      ↓
                            ┌─────────────────┐
                            │   MAIN SWITCH   │ ← Illuminated rocker 20A
                            │    (SW1)        │
                            └────────┬────────┘
                                     │
                            ┌────────┴────────┐
                            │   20A FUSE      │ ← Slow-blow 5×20mm
                            │    (F1)         │
                            └────────┬────────┘
                                     │
                     ┌───────────────┼───────────────┐
                     ↓               ↓               ↓
              ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
              │   PSU #1    │ │   PSU #2    │ │   PSU #3    │
              │             │ │             │ │             │
              │ RSP-1000-48 │ │  12V / 5A   │ │  5V / 3A    │
              │             │ │   Generic   │ │   USB Type  │
              │  48V / 21A  │ │   Switching │ │   Adapter   │
              └──────┬──────┘ └──────┬──────┘ └──────┬──────┘
                     │               │               │
                     ↓               ↓               ↓
                  +48V DC         +12V DC         +5V DC
                     │               │               │
                     │               │               └──→ Arduino VIN
                     │               └──────────────────→ Laser Driver
                     └──────────────────────────────────→ MOSFET Array
                                                          (19× Transducers)

ALL GROUNDS CONNECTED TOGETHER (COMMON GND)
```

**☑ CHECKLIST - POWER SECTION:**
- [ ] Main switch installed and rated for 20A
- [ ] Fuse holder with 20A slow-blow fuse
- [ ] PSU #1 outputs 48V DC (measure with multimeter)
- [ ] PSU #2 outputs 12V DC (measure with multimeter)
- [ ] PSU #3 outputs 5V DC (measure with multimeter)
- [ ] All ground wires connected to common point
- [ ] Earth ground connected to enclosure

---

## DIAGRAM 2: ARDUINO MEGA PINOUT
## ============================================================================

```
                    ARDUINO MEGA 2560 - TOP VIEW
                    
    ┌─────────────────────────────────────────────────────────┐
    │  RESET                                          AREF    │
    │  3.3V                                           GND     │
    │  5V ←────────────────────────────── Connect 5V PSU     │
    │  GND ←───────────────────────────── Common GND         │
    │  GND                                                    │
    │  VIN ←───────────────────────────── 5V from PSU #3     │
    │                                                         │
    │  A0 ←──────────────────────────── Current Sensor #1   │
    │  A1 ←──────────────────────────── Current Sensor #2   │
    │  A2 ←──────────────────────────── Voltage Divider      │
    │  A3                                                     │
    │  A4                                                     │
    │  A5                                                     │
    │  ...                                                    │
    │                                                         │
    │  D2  ──→ MOSFET Driver #1                             │
    │  D3  ──→ MOSFET Driver #2                             │
    │  D4  ──→ MOSFET Driver #3                             │
    │  D5  ──→ MOSFET Driver #4                             │
    │  D6  ──→ MOSFET Driver #5                             │
    │  D7  ──→ MOSFET Driver #6                             │
    │  D8  ──→ MOSFET Driver #7                             │
    │  D9  ──→ MOSFET Driver #8                             │
    │  D10 ──→ MOSFET Driver #9                             │
    │  D11 ──→ MOSFET Driver #10                            │
    │  D12 ──→ MOSFET Driver #11                            │
    │  D13 ──→ MOSFET Driver #12                            │
    │  D14 ──→ MOSFET Driver #13                            │
    │  D15 ──→ MOSFET Driver #14                            │
    │  D16 ──→ MOSFET Driver #15                            │
    │  D17 ──→ MOSFET Driver #16                            │
    │  D18 ──→ MOSFET Driver #17                            │
    │  D19 ──→ MOSFET Driver #18                            │
    │  D20 ──→ MOSFET Driver #19                            │
    │  D21                                                    │
    │  D22 ──→ Laser Driver TTL                             │
    │  D23 ──→ Plasma SSR Control                           │
    │  D24 ←── Door Interlock #1 (with pullup)              │
    │  D25 ←── Door Interlock #2 (with pullup)              │
    │  D26 ←── Emergency Stop (with pullup)                 │
    │  ...                                                    │
    │  D50 (MISO) ←── MAX6675 (SO pin)                      │
    │  D51 (MOSI)                                            │
    │  D52 (SCK)  ──→ MAX6675 (SCK pin)                     │
    │  D53 (SS)   ──→ MAX6675 (CS pin)                      │
    └─────────────────────────────────────────────────────────┘
```

**☑ CHECKLIST - ARDUINO:**
- [ ] Arduino Mega seated in socket or mounted on standoffs
- [ ] 5V power connected to VIN pin
- [ ] GND connected
- [ ] Upload blink test sketch to verify Arduino works
- [ ] All pin connections labeled with masking tape

---

## DIAGRAM 3: SINGLE MOSFET DRIVER CIRCUIT (REPEAT 19×)
## ============================================================================

```
                    MOSFET DRIVER - ONE CHANNEL
                    (Build 19 of these, one for each transducer)

Arduino Pin Dx ──┬───[ R1: 1kΩ ]───┬─────────────┐
   (D2-D20)      │                  │             │
                 │                  │          ┌──┴──┐
               [GND]              [R2]         │ IRF │ Q1: IRF540N
                                  10kΩ         │ 540N│ N-Channel MOSFET
                                   │           │     │
                                 [GND]         └──┬──┘
                                                  │
                                               GATE
                                                  │
                                    ┌─────────────┴─────────────┐
                                    │                           │
                                  DRAIN                       SOURCE
                                    │                           │
                                    ├───[ D1: 1N4007 ]─────[GND]
                                    │    (flyback diode)
                                    │
                                    ├───[ C1: 100nF ]──────[GND]
                                    │    (decoupling)
                                    │
                                    └──→ To TRANSDUCER (+)
                                    
Transducer (-) ────────────────────────────────→ +48V Rail


COMPONENTS PER DRIVER:
- Q1: IRF540N MOSFET (TO-220 package)
- R1: 1kΩ resistor (1/4W, brown-black-red)
- R2: 10kΩ resistor (1/4W, brown-black-orange)
- D1: 1N4007 diode (black body with silver stripe)
- C1: 100nF ceramic capacitor (marked "104")
```

**WIRING ORDER (per driver):**
1. Solder R1 (1kΩ) between Arduino pin and MOSFET gate
2. Solder R2 (10kΩ) between MOSFET gate and GND (pull-down)
3. Solder D1 (1N4007) between DRAIN and SOURCE (stripe toward SOURCE)
4. Solder C1 (100nF) between DRAIN and GND
5. Connect SOURCE to GND
6. Connect DRAIN to transducer (+) wire
7. Connect transducer (-) wire to +48V rail

**☑ CHECKLIST - MOSFET DRIVERS:**
- [ ] Driver #1 (D2) complete and tested
- [ ] Driver #2 (D3) complete and tested
- [ ] Driver #3 (D4) complete and tested
- [ ] Driver #4 (D5) complete and tested
- [ ] Driver #5 (D6) complete and tested
- [ ] Driver #6 (D7) complete and tested
- [ ] Driver #7 (D8) complete and tested
- [ ] Driver #8 (D9) complete and tested
- [ ] Driver #9 (D10) complete and tested
- [ ] Driver #10 (D11) complete and tested
- [ ] Driver #11 (D12) complete and tested
- [ ] Driver #12 (D13) complete and tested
- [ ] Driver #13 (D14) complete and tested
- [ ] Driver #14 (D15) complete and tested
- [ ] Driver #15 (D16) complete and tested
- [ ] Driver #16 (D17) complete and tested
- [ ] Driver #17 (D18) complete and tested
- [ ] Driver #18 (D19) complete and tested
- [ ] Driver #19 (D20) complete and tested

---

## DIAGRAM 4: SENSOR CIRCUITS
## ============================================================================

```
        CURRENT SENSOR #1 (48V Rail Monitoring)
        
                +48V Rail (from PSU #1)
                      │
                      ↓
            ┌───────────────────┐
            │   ACS712-30A      │  ← Hall-effect current sensor module
            │   Module          │
            │                   │
            │  VCC ←─── +5V     │
            │  GND ←─── GND     │
            │  OUT ─→ Arduino A0│
            │                   │
            └─────────┬─────────┘
                      │
                      ↓
              To MOSFET Array DRAIN connections


        CURRENT SENSOR #2 (12V Rail Monitoring)
        
                +12V Rail (from PSU #2)
                      │
                      ↓
            ┌───────────────────┐
            │   ACS712-30A      │
            │   Module          │
            │                   │
            │  VCC ←─── +5V     │
            │  GND ←─── GND     │
            │  OUT ─→ Arduino A1│
            │                   │
            └─────────┬─────────┘
                      │
                      ↓
              To Laser Driver


        VOLTAGE DIVIDER (48V Monitoring)
        
    +48V Rail ──[ R3: 100kΩ ]──┬──[ R4: 10kΩ ]── GND
                                │
                                └────→ Arduino A2
                                
    IMPORTANT: Double-check resistor values!
    - R3 must be 100kΩ (brown-black-yellow)
    - R4 must be 10kΩ (brown-black-orange)
    - Output voltage = 4.36V (safe for Arduino)


        THERMOCOUPLE (Temperature Sensing)
        
    K-Type Thermocouple ────→ MAX6675 Module
                              │
                              ├─ VCC ←─── +5V
                              ├─ GND ←─── GND
                              ├─ SCK ──→ Arduino D52
                              ├─ CS  ──→ Arduino D53
                              └─ SO  ──→ Arduino D50 (MISO)
```

**☑ CHECKLIST - SENSORS:**
- [ ] ACS712 #1 installed in 48V rail
- [ ] ACS712 #2 installed in 12V rail
- [ ] Both sensors reading ~0A with no load
- [ ] Voltage divider assembled (100kΩ + 10kΩ)
- [ ] Voltage divider reading ~48V on serial monitor
- [ ] MAX6675 module connected to SPI pins
- [ ] Thermocouple reading room temperature correctly

---

## DIAGRAM 5: LASER DRIVER CONNECTION
## ============================================================================

```
                    LASER DRIVER WIRING
                    
Arduino D22 ──[ R5: 1kΩ ]──┬───→ Laser Driver TTL Input
                            │
                          [R6]  ← 10kΩ pull-down
                          10kΩ
                            │
                          [GND]


        LASER DRIVER MODULE (X-Drive or equivalent)
        
        ┌──────────────────────────────────────┐
        │  LASER DRIVER                        │
        │                                      │
        │  +12V ←────────────── +12V (PSU #2) │
        │  GND  ←────────────── Common GND    │
        │  TTL  ←────────────── Arduino D22   │
        │                                      │
        │  OUT+ ────────────→ Laser Module (+)│
        │  OUT- ────────────→ Laser Module (-)│
        │                                      │
        └──────────────────────────────────────┘
        
LASER MODULE (5W 445nm)
- Do NOT look at beam
- MUST wear OD6+ safety goggles
- Connect after all other wiring complete
```

**☑ CHECKLIST - LASER:**
- [ ] 1kΩ resistor installed between D22 and TTL
- [ ] 10kΩ pull-down resistor to GND
- [ ] Laser driver powered from 12V rail
- [ ] TTL connection verified (HIGH = laser on)
- [ ] Safety goggles ON HAND before testing
- [ ] Laser module connections secure
- [ ] Test with low power setting first

---

## DIAGRAM 6: PLASMA TORCH SSR
## ============================================================================

```
                    PLASMA RELAY CIRCUIT
                    
Arduino D23 ──[ R7: 1kΩ ]──┬───→ SSR Control (+)
                            │
                          [R8]  ← 10kΩ pull-down
                          10kΩ
                            │
                          [GND]


        SOLID STATE RELAY (Fotek SSR-25DA)
        
        ┌──────────────────────────────────────┐
        │  CONTROL SIDE (Low voltage)          │
        │                                      │
        │  (+) ←─────────── Arduino D23       │
        │  (-) ←─────────── GND               │
        │                                      │
        │─────────────────────────────────────│
        │  LOAD SIDE (Isolated)                │
        │                                      │
        │  (~) ←─────────── Plasma Trigger 1  │
        │  (~) ←─────────── Plasma Trigger 2  │
        │                                      │
        └──────────────────────────────────────┘
                          │
                          ↓
                  PLASMA CUTTER
                  (CUT-50 or equivalent)
```

**☑ CHECKLIST - PLASMA:**
- [ ] SSR mounted with heatsink
- [ ] Control wires from Arduino connected (observe polarity!)
- [ ] Load side wires to plasma torch trigger
- [ ] SSR clicks when D23 goes HIGH (test with multimeter)
- [ ] Plasma cutter trigger tested (disconnect from Arduino first!)
- [ ] Ventilation system ready before live test

---

## DIAGRAM 7: SAFETY CIRCUITS
## ============================================================================

```
            EMERGENCY STOP CIRCUIT
            
Main 120V AC ─┬──→ [ CONTACTOR K1 ] ──→ All PSUs
              │     (NC coil, 20A)
              │
         [ E-STOP ]  ← Red mushroom button
          SW2 (NC)   ← Twist to release
              │
            [GND]

When pressed: Contactor opens, ALL power disconnected


            ARDUINO E-STOP DETECTION
            
    +5V ──[ R9: 10kΩ ]──┬──[ E-Stop SW ]── GND
                         │    (NC)
                         └─────→ Arduino D26
                         
Normal: D26 reads HIGH (5V)
Fault:  D26 reads LOW (0V) = SHUTDOWN


            DOOR INTERLOCK #1
            
    +5V ──[ R10: 10kΩ ]──┬──[ Reed Switch 1 ]── GND
                          │    (NC, magnetic)
                          └─────→ Arduino D24
                          
Normal: D24 reads HIGH (door closed)
Fault:  D24 reads LOW (door open) = SHUTDOWN


            DOOR INTERLOCK #2 (REDUNDANT)
            
    +5V ──[ R11: 10kΩ ]──┬──[ Reed Switch 2 ]── GND
                          │    (NC, magnetic)
                          └─────→ Arduino D25
                          
Normal: D25 reads HIGH (door closed)
Fault:  D25 reads LOW (door open) = SHUTDOWN
```

**☑ CHECKLIST - SAFETY:**
- [ ] Emergency stop button installed (NC, red mushroom)
- [ ] Contactor wired to cut main AC power
- [ ] E-stop detection on D26 with pullup resistor
- [ ] Door interlock #1 on D24 with pullup
- [ ] Door interlock #2 on D25 with pullup
- [ ] Test: Press e-stop → all power cuts
- [ ] Test: Open door → Arduino detects (serial monitor)
- [ ] Arduino code implements safety shutdown

---

## ASSEMBLY ROADMAP
## ============================================================================

**DAY 1: POWER & ARDUINO (4 hours)**
1. Mount PSUs in enclosure
2. Wire AC input with fuse and switch
3. Test all voltage rails with multimeter
4. Mount Arduino, connect 5V power
5. Upload test sketch (blink LED)

**DAY 2: MOSFET ARRAY (6 hours)**
1. Build and test MOSFET driver #1
2. Verify with oscilloscope or LED
3. Build remaining 18 drivers
4. Label all connections
5. Connect to 48V rail (NO TRANSDUCERS YET!)

**DAY 3: SENSORS & SAFETY (4 hours)**
1. Wire current sensors
2. Wire voltage divider
3. Wire thermocouple module
4. Install safety switches
5. Test all sensor readings

**DAY 4: INTEGRATION (4 hours)**
1. Connect laser driver
2. Connect plasma SSR
3. Cable management (zip ties)
4. Final testing with multimeter
5. Power-on test (no loads)

**DAY 5: FINAL TESTING (2 hours)**
1. Connect ONE transducer, test driver
2. Repeat for all 19 transducers
3. Test laser activation (with goggles!)
4. Test plasma activation (with ventilation!)
5. Full system integration test

**TOTAL: 20 hours over 5 days**

---

## TESTING CHECKLIST
## ============================================================================

### POWER TEST
- [ ] 48V rail: 47-49V DC (no load)
- [ ] 12V rail: 11.5-12.5V DC
- [ ] 5V rail: 4.9-5.1V DC
- [ ] All PSUs stay cool (<50°C)

### MOSFET TEST (per driver)
- [ ] Gate voltage: 0V (LOW) or 5V (HIGH)
- [ ] DRAIN voltage pulses 0-48V when activated
- [ ] No excessive heating of MOSFET
- [ ] Transducer hums at 40kHz

### SENSOR TEST
- [ ] Current sensor #1: 0-2A per transducer
- [ ] Current sensor #2: 0-5A for laser
- [ ] Voltage divider: ~48V reading
- [ ] Thermocouple: Room temp ±5°C

### SAFETY TEST
- [ ] E-stop cuts power immediately
- [ ] Door open triggers shutdown
- [ ] Arduino detects all faults
- [ ] System auto-restarts when fault cleared

### INTEGRATION TEST
- [ ] All 19 transducers activate
- [ ] Total current <20A at full power
- [ ] Laser pulses at 1kHz
- [ ] Plasma activates when temp >800K
- [ ] No overheating anywhere

---

## TROUBLESHOOTING TABLE
## ============================================================================

| Problem | Check This | Solution |
|---------|-----------|----------|
| Arduino won't power | 5V voltage | Verify PSU output, check connections |
| MOSFET won't activate | Gate voltage | Check resistors, Arduino pin |
| MOSFET overheats | Current too high | Add heatsink, reduce duty cycle |
| All MOSFETs fire together | 48V short | Inspect for solder bridges |
| Sensor reads zero | Wiring | Check VCC, GND, signal wire |
| Safety triggers randomly | Loose wire | Tighten connections, add capacitor |
| Plasma won't fire | SSR or temp | Test SSR with multimeter, check thermocouple |

---

## PARTS REFERENCE (Quick Lookup)
## ============================================================================

**RESISTOR COLOR CODES:**
- 1kΩ   = Brown-Black-Red
- 10kΩ  = Brown-Black-Orange
- 100kΩ = Brown-Black-Yellow

**MOSFET PINOUT (IRF540N - facing you):**
```
    ┌───┐
    │ O │  ← Mounting hole
    └─┬─┘
  G ─┤ ├─ D
  A ─┤ ├─ R
  T ─┤ ├─ A
  E ─┤ ├─ I
    ─┴─ N
      │
    SOURCE
```
Left to right: GATE, DRAIN, SOURCE

**DIODE (1N4007):**
```
───|◄|─── 
    ↑
  Stripe (cathode)
```
Stripe toward SOURCE in flyback circuit

---

**END OF WIRING DIAGRAMS**
Print this document and use while building!
