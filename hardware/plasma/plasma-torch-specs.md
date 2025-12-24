# Plasma Torch Specifications

**85W plasma torch for material removal**

---

## Overview

The plasma torch is the final stage of the trifecta, providing direct material removal via vaporization. When activated on pre-heated (>800K) rock, it achieves 85-92% energy transfer efficiency.

**Key features:**
- 85W continuous operation
- Non-contact arc ignition
- Air or argon plasma
- 10,000K arc temperature
- Activates automatically when surface reaches 800K

---

## Torch Selection

### Recommended Models

**Option 1: CUT-50 Style Plasma Cutter (Modified)**
- Common Chinese plasma cutter
- 50-85W models available
- Price: $200-400
- Modifications: Remove trigger interlock, add relay control

**Option 2: Eastwood Versa-Cut 40**
- 40A @ 120V = 4.8kW (way overkill, but adjustable!)
- Can be turned down to 85W
- Price: ~$500
- Good control electronics

**Option 3: DIY Plasma Generator**
- Custom built from scratch
- High voltage transformer + arc gap
- Price: $100-200 in parts
- More dangerous, not recommended for beginners

**Recommended:** Option 1 (CUT-50 modified)

---

## Plasma Torch Specifications

### Electrical

| Parameter | Value |
|-----------|-------|
| Input voltage | 110V or 220V AC |
| Input current | 10-15A (at full power) |
| Power consumption | 100-150W total (85W to torch) |
| Arc voltage | 80-120V DC |
| Arc current | 0.8-1.2A |
| Duty cycle | 100% (at rated power) |
| Power factor | >0.90 |

### Mechanical

| Parameter | Value |
|-----------|-------|
| Torch length | 150-200mm |
| Torch diameter | 15-20mm |
| Torch weight | 100-150g |
| Cable length | 3-5m |
| Mounting | Standard CNC bracket |

### Consumables

| Part | Material | Life |
|------|----------|------|
| Electrode | Hafnium or tungsten | 100-200 hours |
| Nozzle | Copper | 50-100 hours |
| Shield cup | Ceramic or metal | 200+ hours |
| Swirl ring | Ceramic | 500+ hours |

---

## Arc Characteristics

### Temperature

**Arc core:** 10,000-15,000K
**Effective work temp:** 3,000-5,000K (at surface)
**Heat affected zone:** 5-10mm diameter

### Voltage-Current Curve

Plasma arc is a **negative resistance device**:
```
V ∝ 1/I
```

**Operating point:** V = 100V, I = 0.85A (85W)

**Stability requires:**
- Constant current power supply (ballast)
- Feedback control
- Arc length monitoring

### Arc Length

**Standoff distance:** 5-10mm (torch to work)
**Arc length:** 2-5mm actual arc
**Longer arc:** Lower current, higher voltage
**Shorter arc:** Higher current, lower voltage

**Optimal:** 3mm arc, 7mm standoff

---

## Gas System

### Gas Options

**Option 1: Air (Simpler)**
- Pros: Free, always available
- Cons: Lower quality cut, more oxidation
- Flow rate: 2-3 CFM (60-90 L/min)
- Pressure: 40-60 PSI

**Option 2: Argon (Better)**
- Pros: Cleaner cut, better for granite
- Cons: Costs $50/tank, requires regulator
- Flow rate: 2-5 L/min (much less than air!)
- Pressure: 20-40 PSI

**Option 3: Nitrogen**
- Similar to argon
- Slightly cheaper
- Good alternative

**Recommended for prototype:** Air (simplicity)
**Recommended for performance:** Argon

### Gas Delivery

**For air:**
- Small air compressor (pancake style)
- 1-2 gallon tank
- 90 PSI capability
- Filter/dryer (moisture removal critical!)

**For argon:**
- Welding regulator (CGA-580 fitting)
- K-size cylinder (last ~50 hours)
- Flowmeter (0-10 L/min)

---

## Power Supply

### Specifications

**Type:** High-frequency (HF) start plasma PSU

**Input:** 110V/220V AC, 50/60 Hz
**Output:** 80-120V DC open-circuit, drops to 80-100V under arc
**Current limiting:** Constant current mode (0.5-1.5A adjustable)
**Starting method:** High-frequency (HF) pulse for non-contact start

**Protection:**
- Over-current
- Over-voltage
- Thermal shutdown
- Short circuit protection

### Control Interface

**From Arduino:**
```
Arduino Pin 22 → Relay → Torch enable
```

**Relay specifications:**
- Type: Solid-state relay (SSR) or mechanical relay
- Rating: 10A @ 120V AC
- Control: 5V DC from Arduino
- Isolation: Opto-isolated

**Logic:**
- Arduino monitors temperature
- When T > 800K, set Pin 22 HIGH
- Relay closes, torch activates
- When T < 750K, set Pin 22 LOW (hysteresis)

---

## Mounting System

### Requirements

- **Adjustable height:** ±50mm
- **Adjustable angle:** ±30° tilt
- **XY position:** ±20mm lateral
- **Rigid:** No vibration during operation
- **Clearance:** Allow for cable routing

### Bracket Design

**Material:** Steel or aluminum
**Type:** CNC-style plasma torch holder

**Features:**
- Clamp-on torch attachment
- Quick-release (for consumable changes)
- Cable strain relief
- Cooling air vent

**3D printable or metal:**
- Metal preferred (heat resistant)
- If 3D printing: PETG or nylon, keep away from arc

---

## Ignition Sequence

### Non-Contact Start

**HF start method:**
1. High voltage pulse (2-5 kV, short duration)
2. Ionizes air gap between electrode and work
3. Main arc establishes (100V, 0.85A)
4. HF pulse stops

**Advantages:**
- No mechanical contact needed
- Electrode life extended
- Works on any conductive surface

### Start Procedure

**From controller:**
1. Verify work surface temperature (T > 800K)
2. Open gas valve (pre-flow 0.5s)
3. Enable HF pulse generator
4. Main arc strikes within 100ms
5. Monitor arc current (should be 0.8-1.2A)
6. If no arc after 500ms, retry or error

---

## Performance with Pre-Heating

### Cold Material (300K)

**Transfer efficiency:** 40%
**Removal rate:** Low
**Arc stability:** Poor (higher voltage needed)
**Energy required:** 7.36 GJ/m³

### Pre-Heated (1305K)

**Transfer efficiency:** 85-92%
**Removal rate:** 3× higher!
**Arc stability:** Excellent
**Energy required:** 0.84 GJ/m³ (effective)

**This is the KEY advantage of trifecta synergy!**

---

## Safety Systems

### Electrical Isolation

**Ground connection CRITICAL:**
- Work clamp attached to workpiece
- Large surface area contact
- Low resistance (<1Ω to ground)
- Separate from other system grounds

**Arc containment:**
- Electrically isolated mounting
- No conductive path except through work
- Prevents ground loops

### UV Protection

**Arc emits intense UV:**
- UVA, UVB, UVC (all wavelengths)
- Can cause "arc eye" (photokeratitis)
- Symptoms appear hours later (painful!)

**Protection:**
- Face shield (shade 5-7)
- UV-blocking viewport on enclosure
- Automatic shutoff if door opens

### Fume Extraction

**Plasma produces:**
- Ozone (O₃) - respiratory irritant
- Nitrogen oxides (NOx) - toxic
- Metal oxides from rock - irritant
- Silica dust - carcinogenic

**Ventilation required:**
- Fume extractor or exhaust hood
- 10+ air changes per hour
- HEPA filtration recommended
- Never operate indoors without ventilation!

### Fire Safety

**Plasma can ignite:**
- Paper, fabric, wood (instantly)
- Flammable gases
- Some plastics

**Precautions:**
- Clear 1m radius of flammables
- Fire-resistant work surface
- Fire extinguisher nearby (Class ABC)
- Fire blanket available

---

## Consumable Management

### Electrode

**Signs of wear:**
- Crater formation (>1mm deep)
- Difficulty starting arc
- Unstable arc (wandering)
- Increased voltage

**Replacement:** Every 100-200 hours

**Cost:** $5-15 each

### Nozzle

**Signs of wear:**
- Enlarged orifice (>10% increase)
- Melted or damaged rim
- Poor arc quality

**Replacement:** Every 50-100 hours

**Cost:** $3-8 each

### Replacement Procedure

1. Power off and disconnect
2. Wait for cooling (5 minutes)
3. Unscrew shield cup
4. Remove worn consumables
5. Install new parts (hand tight + 1/4 turn)
6. Reassemble
7. Test at low power

---

## Troubleshooting

### Arc Won't Start

**Check:**
- Gas flow (should hear/feel gas)
- Work clamp connection (tight?)
- Consumables (electrode sharp? nozzle clear?)
- Power supply (LED indicators?)
- Temperature (is surface hot enough?)

### Arc Unstable (Wandering)

**Causes:**
- Worn electrode → Replace
- Insufficient gas flow → Increase
- Wrong standoff distance → Adjust
- Magnetic fields → Shield or relocate

### Low Cutting Performance

**Causes:**
- Low power → Increase current
- Fast travel speed → Slow down
- Dirty workpiece → Clean surface
- Insufficient pre-heating → Wait for T > 800K

### Excessive Consumable Wear

**Causes:**
- Too high current → Reduce
- Contaminated gas → Add filter/dryer
- Wrong gas pressure → Adjust
- Arc too long → Reduce standoff

---

## Modifications for Trifecta

### Remove Manual Trigger

**Why:** Need automatic control from Arduino

**How:**
1. Open torch handle
2. Locate trigger switch
3. Bypass switch (permanent short)
4. Control via relay on PSU input instead

### Add Temperature Interlock

**Why:** Only activate when pre-heated

**Implementation:**
- Arduino monitors thermocouple
- Logic: IF (T > 800K) THEN enable_plasma
- Prevents inefficient cold cutting

### Optimize Standoff

**Standard plasma:** 3-5mm (for cutting)
**Trifecta:** 7-10mm (for surface treatment)

**Why:** We're ablating, not cutting through
**Adjust:** Mount at higher position

---

## Performance Metrics

### Power Efficiency

**Input:** 100W electrical
**Arc:** 85W (85% PSU efficiency)
**To material:** 72W (85% transfer efficiency on pre-heated)

**Effective cutting power:** 72W

### Material Removal Rate

**Volume:**
- Cold (300K): 0.5 mm³/s
- Pre-heated (1305K): 1.6 mm³/s
- **3.2× improvement!**

**Linear drilling:**
- 1mm kerf: 20 m/hr
- Compare to mechanical: 2 m/hr
- **10× faster!**

### Energy per Volume

**Cold material:** 170 kJ/cm³
**Pre-heated material:** 45 kJ/cm³
**Reduction:** 73% less energy!

---

## Bill of Materials

See [BOM.md](../../docs/design/BOM.md) for complete list.

**Summary:**
- Plasma cutter: $400
- Gas system: $150
- Mounting bracket: $50
- Consumables (initial): $50
- Fume extractor: $150 (optional)
- **Total: ~$650-800**

---

## References

- Plasma cutting principles: Welding handbooks
- Consumable selection: Manufacturer guides
- Safety: OSHA welding standards
- Performance data: docs/validation/

---

**SAFETY CRITICAL:**

Plasma systems involve:
- High voltage (100V+) → Shock hazard
- UV radiation → Eye damage
- Toxic fumes → Respiratory hazard
- Fire risk → Keep clear of flammables

**Never operate without:**
- Proper ventilation
- UV protection (face shield)
- Grounded work clamp
- Fire extinguisher nearby
- Training in safe operation

**Plasma + laser = double trouble! Be extra careful with combined system!**