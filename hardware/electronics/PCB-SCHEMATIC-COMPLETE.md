# TRIFECTA DRILL - CONTROL BOARD PCB SCHEMATIC
# ============================================================================
# Complete electrical design for Arduino Mega-based control system
# Compatible with KiCad, EasyEDA, or hand-wiring
#
# License: MIT
# Version: 1.0
# Date: December 24, 2025
# ============================================================================

## BOARD SPECIFICATIONS
## ============================================================================

**Board Type:** Custom PCB or Perfboard/Stripboard
**Dimensions:** 200mm × 150mm (recommended)
**Layers:** 2-layer (power + signal)
**Recommended thickness:** 1.6mm FR4

**Power Requirements:**
- Input: 120V AC (from wall) → Multiple isolated supplies
- 48V DC @ 21A (for acoustic array)
- 12V DC @ 5A (for laser driver)
- 5V DC @ 3A (for Arduino + logic)

**Current Handling:**
- Acoustic MOSFETs: 2A each × 19 = 38A total
- Laser driver: 5A peak
- Plasma relay: 25A (SSR)

---

## SYSTEM BLOCK DIAGRAM
## ============================================================================

```
                           TRIFECTA DRILL CONTROL SYSTEM
                           
┌─────────────────────────────────────────────────────────────────────┐
│                         POWER DISTRIBUTION                          │
│                                                                     │
│  120V AC ──┬─→ PSU 48V/21A ──→ MOSFET Array ──→ 19× Transducers   │
│            │                                                        │
│            ├─→ PSU 12V/5A ───→ Laser Driver ───→ 5W Laser         │
│            │                                                        │
│            └─→ PSU 5V/3A ────→ Arduino Logic                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         CONTROL LOGIC                               │
│                                                                     │
│  Arduino Mega 2560 (Main Controller)                               │
│  ├─→ PWM Outputs (D2-D21) ──→ 19× MOSFET Drivers ──→ Transducers  │
│  ├─→ Digital Out (D22) ─────→ Laser PWM Driver                    │
│  ├─→ Digital Out (D23) ─────→ Plasma SSR (temp-activated)         │
│  ├─→ Analog In (A0-A2) ─────→ Current Sensors (monitoring)        │
│  ├─→ SPI (D50-D53) ─────────→ Thermocouple Amplifier             │
│  ├─→ Digital In (D24-D25) ──→ Door Interlocks (safety)           │
│  └─→ Digital In (D26) ──────→ Emergency Stop (NC)                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         SAFETY SYSTEMS                              │
│                                                                     │
│  Emergency Stop ──┬─→ Cuts ALL power via main contactor           │
│                   └─→ Arduino interrupt (software shutdown)        │
│                                                                     │
│  Door Interlocks ─→ Arduino monitors (redundant NC switches)      │
│                   └─→ Software prevents activation if open         │
│                                                                     │
│  Thermal Shutdown → Thermocouple > 100°C = automatic shutdown     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## DETAILED SCHEMATIC - SECTION 1: POWER SUPPLY
## ============================================================================

```
                        POWER DISTRIBUTION SECTION

120V AC ──┬──[FUSE 20A]──[MAIN SWITCH]──┬──[PSU1: RSP-1000-48]──→ 48V/21A
          │                              │   (Mean Well)
          │                              │
          ├──────────────────────────────┼──[PSU2: 12V/5A]──────→ 12V/5A
          │                              │   (Generic SMPS)
          │                              │
          └──────────────────────────────┴──[PSU3: 5V/3A]───────→ 5V/3A
                                             (USB-style)

NOTES:
- All PSUs must have earth ground connected
- Fuse rated for worst-case current (20A)
- Main switch: Illuminated rocker, 20A rated
- Emergency stop cuts power BEFORE this point (main contactor)

POWER RAILS ON PCB:
┌──────────────────────────────────────────────────────┐
│ +48V ━━━━━━━━━━━━━━━ (TOP COPPER POUR)              │
│                                                      │
│ +12V ──────────────── (Trace, 3mm width)            │
│                                                      │
│ +5V  ──────────────── (Trace, 2mm width)            │
│                                                      │
│ GND  ━━━━━━━━━━━━━━━ (BOTTOM COPPER POUR)           │
└──────────────────────────────────────────────────────┘
```

**Component List - Power:**
- PSU1: Mean Well RSP-1000-48 (48V 21A)
- PSU2: Generic 12V 5A switching supply
- PSU3: 5V 3A USB-style adapter
- F1: 20A slow-blow fuse (5×20mm)
- SW1: 20A illuminated rocker switch
- Terminal blocks: 10A screw terminals (×6)

---

## DETAILED SCHEMATIC - SECTION 2: ARDUINO MEGA
## ============================================================================

```
                    ARDUINO MEGA 2560 CONNECTIONS

        ┌────────────────────────────────────┐
        │    ARDUINO MEGA 2560 R3            │
        │                                    │
    5V ─┤ VIN (7-12V)    ← 5V from PSU3    │
   GND ─┤ GND            ← Common GND       │
        │                                    │
        │  DIGITAL PWM OUTPUTS (Acoustic)   │
        ├─ D2  ──→ MOSFET Driver 1          │
        ├─ D3  ──→ MOSFET Driver 2          │
        ├─ D4  ──→ MOSFET Driver 3          │
        ├─ D5  ──→ MOSFET Driver 4          │
        ├─ D6  ──→ MOSFET Driver 5          │
        ├─ D7  ──→ MOSFET Driver 6          │
        ├─ D8  ──→ MOSFET Driver 7          │
        ├─ D9  ──→ MOSFET Driver 8          │
        ├─ D10 ──→ MOSFET Driver 9          │
        ├─ D11 ──→ MOSFET Driver 10         │
        ├─ D12 ──→ MOSFET Driver 11         │
        ├─ D13 ──→ MOSFET Driver 12         │
        ├─ D14 ──→ MOSFET Driver 13         │
        ├─ D15 ──→ MOSFET Driver 14         │
        ├─ D16 ──→ MOSFET Driver 15         │
        ├─ D17 ──→ MOSFET Driver 16         │
        ├─ D18 ──→ MOSFET Driver 17         │
        ├─ D19 ──→ MOSFET Driver 18         │
        ├─ D20 ──→ MOSFET Driver 19         │
        │                                    │
        │  CONTROL OUTPUTS                   │
        ├─ D22 ──→ Laser Driver TTL         │
        ├─ D23 ──→ Plasma SSR Control       │
        │                                    │
        │  SAFETY INPUTS (with pullups)     │
        ├─ D24 ──← Door Interlock 1 (NC)    │
        ├─ D25 ──← Door Interlock 2 (NC)    │
        ├─ D26 ──← Emergency Stop (NC)      │
        │                                    │
        │  SENSOR INPUTS (Analog)            │
        ├─ A0  ──← Current Sensor 1 (48V)   │
        ├─ A1  ──← Current Sensor 2 (12V)   │
        ├─ A2  ──← Voltage Divider (48V)    │
        │                                    │
        │  SPI (Thermocouple)                │
        ├─ D50 (MISO) ──← MAX6675          │
        ├─ D51 (MOSI) ──→ MAX6675          │
        ├─ D52 (SCK)  ──→ MAX6675          │
        ├─ D53 (SS)   ──→ MAX6675          │
        │                                    │
        └────────────────────────────────────┘

NOTES:
- All digital inputs have 10kΩ pullup resistors to 5V
- NC (Normally Closed) switches open on fault
- Arduino detects open = fault condition
```

**Component List - Arduino Section:**
- U1: Arduino Mega 2560 R3
- R1-R3: 10kΩ resistors (safety input pullups)
- Headers: Male pin headers for Arduino socket

---

## DETAILED SCHEMATIC - SECTION 3: MOSFET DRIVERS (×19)
## ============================================================================

```
                    SINGLE MOSFET DRIVER CIRCUIT
                    (Repeat 19 times for each transducer)

Arduino Pin ──┬─────[R1 1kΩ]────┬──┐
              │                  │  │
            [GND]              [D1] │ ← Flyback diode (1N4007)
                               1N4007│
                                  │  │
                                 [Q1]│ ← MOSFET (IRF540N)
                              IRF540N│
                                GATE─┘
                                  │
                              DRAIN──┬──→ Transducer (+)
                                     │
                                  SOURCE──[GND]

Transducer (-)  ────────────────→ +48V


COMPLETE CIRCUIT (with protection):

   +5V                        +48V
    │                           │
    └──[R2 10kΩ]───┬           │
                   │            │
Arduino Pin ───[R1 1kΩ]────GATE│
                           IRF540N
                         DRAIN──┬────→ Transducer (+)
                                │
                         SOURCE─┴────[GND]
                                │
                               [C1]  ← 100nF ceramic (noise)
                               100nF
                                │
                              [GND]

Transducer (-) ─────────────────→ +48V

NOTES:
- R1 (1kΩ): Gate current limiting
- R2 (10kΩ): Pull-down to prevent float
- D1 (1N4007): Flyback protection for inductive load
- C1 (100nF): Decoupling capacitor
- IRF540N specs: 100V, 33A, RDS(on) = 44mΩ
```

**Per-Driver Power Dissipation:**
```
I_transducer = 2A (max per transducer)
V_DS = I × RDS(on) = 2A × 0.044Ω = 0.088V
P_dissipation = I² × RDS(on) = 4 × 0.044 = 0.176W

With 19 drivers: Total = 3.3W (needs heatsinking or fan)
```

**Component List - Per MOSFET Driver:**
- Q1: IRF540N N-channel MOSFET (TO-220 package)
- R1: 1kΩ resistor (1/4W)
- R2: 10kΩ resistor (1/4W)
- D1: 1N4007 diode
- C1: 100nF ceramic capacitor

**Total for 19 drivers:**
- 19× IRF540N MOSFETs
- 19× 1kΩ resistors
- 19× 10kΩ resistors
- 19× 1N4007 diodes
- 19× 100nF capacitors

---

## DETAILED SCHEMATIC - SECTION 4: LASER DRIVER
## ============================================================================

```
                    LASER DRIVER CONTROL CIRCUIT

Arduino D22 (PWM) ───[R1 1kΩ]────┬──→ Laser Driver TTL Input
                                  │
                                [R2]  ← 10kΩ pull-down
                                10kΩ
                                  │
                                [GND]

Laser Driver (X-Drive or equivalent):
┌────────────────────────────────────────┐
│  LASER DRIVER MODULE                   │
│                                        │
│  +12V ←─────────────────── +12V PSU2  │
│  GND  ←─────────────────── GND        │
│  TTL  ←─────────────────── Arduino D22│
│                                        │
│  OUT+ ──────────────────→ Laser (+)   │
│  OUT- ──────────────────→ Laser (-)   │
│                                        │
└────────────────────────────────────────┘

TTL SIGNAL CHARACTERISTICS:
- HIGH (5V) = Laser ON
- LOW (0V)  = Laser OFF
- PWM frequency: 1 kHz (for pulsed heating)
- Duty cycle: 10% (adjustable in code)

SAFETY INTERLOCK:
Door Open ──→ Arduino detects ──→ D22 forced LOW ──→ Laser OFF
```

**Component List - Laser Section:**
- Laser Driver: X-Drive or LM3429-based (external module)
- R1: 1kΩ resistor
- R2: 10kΩ resistor
- Connectors: 2-pin screw terminal for laser

---

## DETAILED SCHEMATIC - SECTION 5: PLASMA CONTROL
## ============================================================================

```
                    PLASMA TORCH RELAY CIRCUIT

Arduino D23 ───[R1 1kΩ]────┬──→ SSR Control (+)
                            │
                          [R2]  ← 10kΩ pull-down
                          10kΩ
                            │
                          [GND]

SOLID STATE RELAY (SSR):
┌────────────────────────────────────────┐
│  SSR (Fotek SSR-25DA or equivalent)   │
│                                        │
│  Control (+) ←── Arduino D23           │
│  Control (-) ←── GND                   │
│                                        │
│  Load AC (~) ←── Plasma Cutter Trigger │
│  Load AC (~) ←── Plasma Cutter Trigger │
│                                        │
└────────────────────────────────────────┘

ACTIVATION LOGIC (in Arduino code):
```c
if (temperature > 800) {  // Kelvin (from thermocouple)
  digitalWrite(D23, HIGH);  // Activate plasma
} else {
  digitalWrite(D23, LOW);   // Keep plasma off
}
```

SAFETY:
- SSR is opto-isolated (Arduino side completely isolated)
- Plasma cutter has its own safety circuits
- Arduino only triggers, doesn't carry plasma current
```

**Component List - Plasma Section:**
- SSR1: Fotek SSR-25DA (25A, 380V AC)
- R1: 1kΩ resistor
- R2: 10kΩ resistor
- Connectors: 2-pin screw terminal for plasma trigger

---

## DETAILED SCHEMATIC - SECTION 6: SENSORS
## ============================================================================

```
                    CURRENT SENSOR 1 (48V Rail)

                    +48V Rail
                       │
                    [ACS712]  ← Hall-effect current sensor
                   ACS712-30A
                       │
    Arduino A0 ←───OUTPUT (analog voltage)
                       │
                     [GND]

OUTPUT SCALING:
- 0A   = 2.5V (Vcc/2)
- +30A = 5.0V
- -30A = 0.0V
- Sensitivity: 66 mV/A

Arduino code:
```c
int raw = analogRead(A0);
float voltage = raw * (5.0 / 1023.0);
float current = (voltage - 2.5) / 0.066;  // Amps
```

                    CURRENT SENSOR 2 (12V Rail)

Same circuit as above, but on 12V rail
Arduino A1 ←─── ACS712 Output


                    VOLTAGE DIVIDER (48V Monitoring)

    +48V ───[R1 100kΩ]───┬───[R2 10kΩ]─── GND
                          │
                          └────→ Arduino A2

SCALING:
- 48V input → 4.36V at Arduino (within 5V limit)
- Ratio: 10kΩ / (100kΩ + 10kΩ) = 0.0909

Arduino code:
```c
int raw = analogRead(A2);
float voltage_arduino = raw * (5.0 / 1023.0);
float voltage_48v = voltage_arduino / 0.0909;
```

                    THERMOCOUPLE (K-Type)

Thermocouple ────→ [MAX6675 Amplifier] ←─→ Arduino SPI
                      (Module)            │
                                        [D50-D53]

MAX6675 Pinout:
- VCC → 5V
- GND → GND
- SCK → D52
- CS  → D53
- SO  → D50

Arduino code:
```c
#include <max6675.h>
MAX6675 thermocouple(52, 53, 50);  // SCK, CS, SO
float tempC = thermocouple.readCelsius();
float tempK = tempC + 273.15;  // Convert to Kelvin
```
```

**Component List - Sensors:**
- U2: ACS712-30A current sensor module (48V)
- U3: ACS712-30A current sensor module (12V)
- R3: 100kΩ resistor (voltage divider)
- R4: 10kΩ resistor (voltage divider)
- U4: MAX6675 thermocouple amplifier module
- Thermocouple: K-type, 0-1370°C

---

## DETAILED SCHEMATIC - SECTION 7: SAFETY CIRCUITS
## ============================================================================

```
                    EMERGENCY STOP CIRCUIT

Main Power (120V AC) ─┬─→ [CONTACTOR] ─→ PSUs
                      │      (NC coil)
                      │
                 [E-STOP]  ← Twist-to-release mushroom button
                 NC switch
                      │
                    [GND]

When E-Stop pressed:
- Contactor coil de-energizes
- ALL power disconnected
- Arduino also detects via D26 (software shutdown)

Arduino E-Stop Detection:

    +5V ───[R5 10kΩ]───┬───[E-Stop SW]─── GND
                        │    (NC)
                        └────→ Arduino D26

Normal: D26 reads HIGH (E-stop not pressed)
Fault:  D26 reads LOW  (E-stop pressed or wire broken)


                    DOOR INTERLOCK CIRCUITS

    +5V ───[R6 10kΩ]───┬───[Reed SW 1]─── GND
                        │    (NC)
                        └────→ Arduino D24

    +5V ───[R7 10kΩ]───┬───[Reed SW 2]─── GND
                        │    (NC)
                        └────→ Arduino D25

Normal: Both read HIGH (doors closed)
Fault:  Either LOW (door open or wire broken)

Arduino code:
```c
bool safe = digitalRead(24) && digitalRead(25) && digitalRead(26);
if (!safe) {
  // Shutdown all systems
  digitalWrite(23, LOW);  // Plasma off
  digitalWrite(22, LOW);  // Laser off
  for (int i=2; i<=20; i++) {
    analogWrite(i, 0);    // Acoustic off
  }
}
```
```

**Component List - Safety:**
- SW2: Emergency stop button (NC, twist-release)
- K1: Contactor relay (120V AC coil, 20A contacts)
- SW3-SW4: Magnetic reed switches (NC, door interlock)
- R5-R7: 10kΩ resistors (pullup)

---

## PCB LAYOUT RECOMMENDATIONS
## ============================================================================

```
LAYER 1 (TOP - Component Side):
┌────────────────────────────────────────────────────────────┐
│                                                            │
│  [Arduino Mega Socket]        [Terminal Blocks]           │
│                                (Power In/Out)             │
│                                                            │
│  [MOSFET Array - 3 rows of 7]                            │
│   Q1  Q2  Q3  Q4  Q5  Q6  Q7                             │
│   Q8  Q9  Q10 Q11 Q12 Q13 Q14                            │
│   Q15 Q16 Q17 Q18 Q19                                    │
│                                                            │
│  [Sensor Section]                                         │
│   ACS712 #1  ACS712 #2  MAX6675  Voltage Divider         │
│                                                            │
│  [Control Section]                                        │
│   SSR     Laser Driver Connector                          │
│                                                            │
└────────────────────────────────────────────────────────────┘

LAYER 2 (BOTTOM - Ground Plane):
┌────────────────────────────────────────────────────────────┐
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓ SOLID GROUND POUR ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
└────────────────────────────────────────────────────────────┘

THERMAL MANAGEMENT:
- MOSFETs mounted with small heatsinks OR
- 80mm fan over MOSFET array (12V, 0.3A)
- Keep ambient temp <50°C
```

**Design Rules:**
- Power traces: 3mm width minimum (48V rail)
- Signal traces: 0.5mm width (digital signals)
- Via size: 0.8mm drill, 1.5mm pad
- Clearance: 0.5mm minimum (signal-signal)
- Clearance: 2mm minimum (power-signal)

---

## ALTERNATIVE: PERFBOARD/STRIPBOARD BUILD
## ============================================================================

**If you don't want to order a custom PCB:**

**Option 1: Perfboard (for prototyping)**
```
Materials needed:
- 200×150mm perfboard (0.1" pitch)
- Wire-wrap wire or solid core 22 AWG
- Headers and sockets
- Point-to-point solder connections

Pros: Flexible, easy to modify
Cons: Time-consuming, less reliable
```

**Option 2: Stripboard/Veroboard**
```
Materials needed:
- 200×150mm stripboard
- Strip cutter tool
- Solder bridges for connections

Pros: Faster than perfboard, more organized
Cons: Need to plan cuts carefully
```

**Option 3: Modular Approach (RECOMMENDED for DIY)**
```
Use pre-made modules connected with dupont wires:

- Arduino Mega 2560 board (plug-in)
- 19× IRF540 MOSFET breakout modules (Amazon/eBay)
- ACS712 sensor modules (×2)
- MAX6675 module
- SSR module
- 48V PSU (external)
- 12V PSU (external)
- 5V PSU (external)

Total cost: ~$100 (vs ~$200 for custom PCB)
Assembly time: 4-6 hours (vs 2 days for perfboard)
```

---

## COMPLETE BILL OF MATERIALS - ELECTRONICS
## ============================================================================

| Component | Qty | Part Number | Source | Unit Cost | Total |
|-----------|-----|-------------|--------|-----------|-------|
| **Microcontroller** | | | | | |
| Arduino Mega 2560 R3 | 1 | A000067 | Arduino.cc | $45 | $45 |
| **MOSFETs & Drivers** | | | | | |
| IRF540N MOSFET | 19 | IRF540N | Digi-Key | $1.20 | $23 |
| 1kΩ resistor (1/4W) | 19 | CF14JT1K00 | Digi-Key | $0.10 | $2 |
| 10kΩ resistor (1/4W) | 22 | CF14JT10K0 | Digi-Key | $0.10 | $2 |
| 1N4007 diode | 19 | 1N4007 | Digi-Key | $0.10 | $2 |
| 100nF capacitor | 19 | K104K15X7RF53L2 | Digi-Key | $0.10 | $2 |
| **Power Supplies** | | | | | |
| Mean Well RSP-1000-48 | 1 | RSP-1000-48 | Digi-Key | $100 | $100 |
| 12V 5A PSU | 1 | Generic | Amazon | $12 | $12 |
| 5V 3A PSU | 1 | Generic | Amazon | $8 | $8 |
| **Sensors** | | | | | |
| ACS712-30A module | 2 | ACS712-30A | Amazon | $5 | $10 |
| MAX6675 module | 1 | MAX6675 | Amazon | $8 | $8 |
| K-type thermocouple | 1 | Generic | Amazon | $15 | $15 |
| 100kΩ resistor | 1 | CF14JT100K | Digi-Key | $0.10 | $0.10 |
| **Relays & Safety** | | | | | |
| SSR 25A (Fotek) | 1 | SSR-25DA | Amazon | $10 | $10 |
| Emergency stop button | 1 | YW1B-V4E11R | Amazon | $12 | $12 |
| Magnetic reed switch NC | 2 | Directed 8601 | Amazon | $8 | $16 |
| Contactor 20A 120V | 1 | Generic | Amazon | $15 | $15 |
| **Connectors** | | | | | |
| Screw terminals 2-pos | 10 | WAGO 222-412 | Amazon | $1 | $10 |
| Screw terminals 3-pos | 5 | WAGO 222-413 | Amazon | $1.20 | $6 |
| Dupont jumper wires | 100 | Generic kit | Amazon | $7 | $7 |
| **PCB Options** | | | | | |
| Custom PCB (2-layer) | 1 | Custom | JLCPCB | $50 | $50 |
| OR Perfboard 200×150mm | 1 | Generic | Amazon | $10 | $10 |
| **Enclosure** | | | | | |
| ABS project box | 1 | 200×150×75mm | Amazon | $15 | $15 |
| **TOTAL (Custom PCB)** | | | | | **$354** |
| **TOTAL (Perfboard)** | | | | | **$314** |

---

## ASSEMBLY INSTRUCTIONS
## ============================================================================

### Phase 1: Power Section (2 hours)
1. Mount PSUs in enclosure
2. Wire AC input with fuse and switch
3. Test output voltages (48V, 12V, 5V)
4. Label all power rails

### Phase 2: Arduino & Basic Wiring (3 hours)
1. Mount Arduino in socket/standoffs
2. Connect 5V power and GND
3. Upload test sketch (blink LED)
4. Verify USB programming works

### Phase 3: MOSFET Array (4 hours)
1. Solder/wire 19 MOSFET driver circuits
2. Connect to Arduino D2-D20
3. Connect to 48V rail
4. Test each driver with multimeter

### Phase 4: Sensors (2 hours)
1. Install current sensors in power lines
2. Wire MAX6675 to SPI pins
3. Install voltage divider
4. Test readings with Arduino serial monitor

### Phase 5: Safety Systems (2 hours)
1. Wire emergency stop circuit
2. Install door interlocks
3. Test all safety inputs
4. Verify software shutdown works

### Phase 6: Final Integration (3 hours)
1. Connect laser driver TTL
2. Connect plasma SSR
3. Cable management (zip ties, strain relief)
4. Final testing of all systems
5. Label all connections

**Total assembly time: 16 hours (2 full days)**

---

## TESTING PROCEDURE
## ============================================================================

### Test 1: Power-On Test
```
1. Disconnect ALL loads (transducers, laser, plasma)
2. Power on main switch
3. Verify voltages:
   - 48V rail: 47-49V DC
   - 12V rail: 11.5-12.5V DC
   - 5V rail: 4.9-5.1V DC
4. Check current draw (<0.5A on all rails)
```

### Test 2: MOSFET Driver Test
```
1. Connect ONE transducer to Driver #1
2. Upload test code (50% PWM on D2)
3. Measure voltage at MOSFET drain (should pulse 0-48V)
4. Measure current (<2A)
5. Repeat for all 19 drivers
```

### Test 3: Sensor Test
```
1. Read current sensors (should show ~0A)
2. Read voltage divider (should show ~48V)
3. Connect thermocouple, read temperature
4. Verify all readings on serial monitor
```

### Test 4: Safety Circuit Test
```
1. Press emergency stop → all outputs should go LOW
2. Open door interlock → system should shutdown
3. Verify software detects both conditions
4. Test auto-restart after fault cleared
```

### Test 5: Integration Test
```
1. Connect ALL transducers
2. Run acoustic array at 50% power
3. Monitor current draw (should be <20A total)
4. Verify no overheating of MOSFETs
5. Test laser activation (separate from plasma!)
6. Test plasma activation (with proper ventilation!)
```

---

## TROUBLESHOOTING GUIDE
## ============================================================================

| Symptom | Possible Cause | Solution |
|---------|---------------|----------|
| Arduino won't power on | 5V PSU failure | Check PSU output with multimeter |
| MOSFET gets hot | No heatsink, high current | Add heatsink or fan |
| Transducer not activating | Bad MOSFET connection | Check gate resistor, test MOSFET |
| All MOSFETs fire at once | Short in 48V rail | Inspect PCB for solder bridges |
| Plasma won't activate | SSR failure or temp too low | Test SSR with multimeter, check thermocouple |
| Current sensor reads wrong | Incorrect wiring | Verify ACS712 orientation |
| Safety shutdown triggers randomly | Loose interlock connection | Tighten connections, add debounce in code |
| USB upload fails | Driver issue | Reinstall Arduino drivers |

---

## SAFETY WARNINGS
## ============================================================================

**ELECTRICAL HAZARDS:**
- ⚠️ 120V AC can kill - use proper wiring techniques
- ⚠️ 48V DC can cause shock - don't touch during operation
- ⚠️ Always disconnect power before working on board

**COMPONENT RATINGS:**
- Do NOT exceed MOSFET current rating (33A per device)
- Use proper gauge wire (18 AWG minimum for 48V rail)
- Ensure PSUs have overcurrent protection

**TESTING:**
- ALWAYS test with ONE transducer first
- NEVER bypass safety interlocks
- Keep fire extinguisher nearby during tests

---

## FILES TO GENERATE (Future Enhancement)
## ============================================================================

For full KiCad project:
1. **control_board.kicad_sch** - Main schematic
2. **control_board.kicad_pcb** - PCB layout
3. **control_board.kicad_pro** - Project file
4. **BOM.csv** - Bill of materials
5. **Gerber files** - For manufacturing

These would require KiCad software to generate properly.
This document provides the complete circuit design for manual implementation.

---

## REVISION HISTORY
## ============================================================================

**v1.0 (Dec 24, 2025):**
- Initial release
- Complete schematic documentation
- BOM and assembly instructions
- Testing procedures

---

**END OF PCB SCHEMATIC DOCUMENTATION**
