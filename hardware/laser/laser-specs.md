# Laser System Specifications

**445nm blue laser for thermal pre-heating**

---

## Overview

The laser subsystem heats the rock surface to 1200-1400K before plasma cutting. Pre-heating dramatically improves plasma efficiency by:
- Reducing material removal energy
- Improving impedance matching
- Weakening material structure

**Key specs:**
- 5W average power (50W peak during pulses)
- 445nm wavelength (blue)
- 1 kHz pulse rate, 10% duty cycle
- Heats granite to 1305K in ~500ms

---

## Laser Module

### Recommended Part

**DTR's Copper Module with 445nm Laser Diode**
- Vendor: DTR's Laser Shop (online)
- Power: 5W (or 7W for margin)
- Wavelength: 445nm ±5nm
- Beam quality: M² < 1.5
- Price: ~$180

**Alternatives:**
- Nichia NDB7A75 (7W, 450nm) - $100
- Osram PLPT9 450L_E (9W, 450nm) - $120
- Generic 5W 445nm module - $80-150

### Laser Diode Specifications

| Parameter | Value |
|-----------|-------|
| Type | Multi-mode laser diode |
| Wavelength | 445nm (blue) |
| Output power | 5W CW, 50W pulsed |
| Threshold current | ~1A |
| Operating current | 2-2.5A (for 5W) |
| Peak current | 5A (for pulsed operation) |
| Operating voltage | ~5V forward |
| Package | TO-56 or custom copper |
| Beam divergence | Fast: 35°, Slow: 10° |

### Module Features

**Must have:**
- Heat sink (copper or aluminum)
- Integrated TEC cooling (optional but recommended)
- Adjustable focus (threaded collar)
- TTL modulation input (for pulse control)
- Over-current protection

**Nice to have:**
- Power meter output (photodiode feedback)
- Temperature sensor
- Case/housing included

---

## Driver Circuit

### Recommended Driver

**LM3429 Based Laser Driver**
- Current range: 0-5A adjustable
- PWM/TTL modulation input
- Efficiency: >90%
- Price: ~$50-70

**Alternatives:**
- G2 Laser Driver (0-5A) - $60
- DIY LM317-based (simple, less efficient) - $20
- FlexDrive (compact, 0-3A) - $35

### Driver Specifications

| Parameter | Value |
|-----------|-------|
| Input voltage | 12V DC |
| Output current | 0-5A (adjustable) |
| Modulation frequency | 0-100 kHz |
| Modulation input | TTL 0-5V |
| Duty cycle range | 1-100% |
| Rise/fall time | <1 μs |
| Efficiency | 85-95% |
| Protection | Over-current, over-temp, reverse polarity |

### Control Interface

**From Arduino:**
```
Arduino Pin 21 (PWM) → Driver TTL input
Arduino Pin 22 (Digital) → Enable/disable
```

**PWM settings:**
- Frequency: 1 kHz (for thermal accumulation)
- Duty cycle: 10% (adjustable 0-100%)
- Logic: HIGH = laser on

---

## Optical System

### Collimation

**Laser output is divergent and elliptical!**

**Primary collimator:**
- Type: Aspheric lens
- Focal length: 8-12mm
- Diameter: 10mm
- Coating: AR-coated for 445nm

**Output after collimation:**
- Beam diameter: 3-5mm
- Divergence: <1 mrad

### Focusing Lens

**Secondary lens for tight focus:**
- Type: Plano-convex
- Focal length: 50mm (adjustable)
- Diameter: 25mm
- Coating: AR-coated for 445nm
- Material: BK7 or fused silica

**Focus specifications:**
- Spot size: <1mm diameter
- Working distance: 50mm (adjustable ±10mm)
- Power density: >600 kW/cm² at focus

### Lens Mount

**Adjustable mount required:**
- XYZ adjustment (±5mm)
- Tilt adjustment (±5°)
- Locking mechanism
- Compatible with standard lens tubes

**3D printable or commercial:**
- Thorlabs SM1 series (compatible)
- Custom 3D printed PETG/ABS

---

## Housing & Safety

### Enclosure

**Requirements:**
- Blocks stray laser light
- Allows access for alignment
- Interlocked door (prevents firing when open)
- Ventilation for cooling

**Materials:**
- 3D printed ABS/PETG (black)
- Laser-cut aluminum (anodized)
- Acrylic (only if painted black inside)

**Features:**
- Beam path fully enclosed
- Interlocked access panel
- Visible through filtered viewport
- Cable management ports

### Safety Interlocks

**Hardware:**
- Magnetic switch on access door
- Wired to Arduino GPIO (Pin 23)
- Normally-closed (NC) contact
- Laser cannot fire if door open

**Override:**
- Key switch for alignment mode
- Allows firing with door open
- USE WITH EXTREME CAUTION
- Only for trained users with goggles

### Warning Labels

**Required labels:**
- "DANGER: CLASS 4 LASER RADIATION"
- "AVOID EYE OR SKIN EXPOSURE"
- "Wavelength: 445nm, Power: 5W"
- Laser hazard symbol

**Placement:**
- On enclosure (all sides)
- On access panels
- Visible from all angles

---

## Cooling System

### Heat Load

**From laser diode:**
- Electrical input: 12W (5V × 2.4A)
- Optical output: 5W
- Heat dissipated: 7W

**From driver:**
- Power dissipation: ~1W

**Total: ~8W continuous, 30W peak during pulses**

### Cooling Methods

**Option 1: Passive (Heat Sink)**
- Large aluminum heat sink (50×50×30mm)
- Natural convection
- OK for 50% duty cycle or less
- Simple, no moving parts

**Option 2: Active (Fan)**
- Heat sink + 40mm fan (12V)
- Forced air cooling
- Required for continuous operation
- Recommended for reliability

**Option 3: TEC (Thermoelectric)**
- Peltier cooler (12V, 20W)
- Active temperature control
- Maintains 20-25°C diode temp
- Best performance, more complex
- Price: +$30

**Recommended:** Option 2 (heat sink + fan)

### Temperature Monitoring

**Thermistor on heat sink:**
- NTC 10kΩ @ 25°C
- Connected to Arduino analog input
- Monitor laser temperature
- Shutdown if >60°C

---

## Alignment Procedure

**SAFETY FIRST - WEAR GOGGLES (OD6+ at 445nm)!**

### Step 1: Collimation

1. Mount laser module in housing
2. Install collimating lens
3. Enable laser at LOW power (0.5W)
4. Project beam on wall (5m away)
5. Adjust lens position until beam is parallel
6. Beam should NOT expand over 5m distance

### Step 2: Focus

1. Position focusing lens at 50mm from work surface
2. Enable laser at low power
3. Adjust lens until spot is smallest
4. Measure spot size (should be <1mm)
5. Mark optimal position

### Step 3: Aim

1. Center laser spot on acoustic focal point
2. Use laser-printed target on work surface
3. Adjust X-Y position
4. Lock in place

### Step 4: Verification

1. Enable full power (5W)
2. Test on granite sample
3. Should see heating within seconds
4. IR camera shows hot spot formation

---

## Performance Specifications

### Output Power

**Target:** 5W average, 50W peak

**Measurement:**
- Thermal power meter (Ophir or Coherent)
- Laser check card (qualitative)
- Photodiode + calibration

**Stability:** ±5% over 30 minutes

### Spot Quality

**Target:** <1mm diameter, Gaussian profile

**Measurement:**
- Beam profiler (expensive!)
- Knife-edge scan (DIY)
- Burn pattern on paper (qualitative)

### Modulation

**Pulse frequency:** 1 kHz ±10 Hz
**Duty cycle:** 10% ±1%
**Rise time:** <10 μs

**Verification:**
- Oscilloscope + photodiode
- Check square wave output
- Adjust PWM frequency on Arduino

---

## Thermal Performance

### Heating Rate

**On granite:**
- Initial: ~13K per pulse (first few pulses)
- Steady-state: 1305K after 400-600ms
- Thermal stress: 536 MPa

**Validation:**
- IR camera or thermocouple
- Should match simulation within 10%

### Absorption Enhancement

**With acoustic pre-stress:**
- Base absorption: α = 0.15 (15%)
- Enhanced: α = 0.45 (45%)
- 3× improvement!

**Measurement:**
- Compare heating rate with/without acoustic
- Should see 2-3× faster heating

---

## Safety Equipment

### Personal Protective Equipment

**MANDATORY - NO EXCEPTIONS:**
1. **Laser safety goggles**
   - OD6+ at 445nm
   - Visible light transmission (VLT) >20%
   - Certified to ANSI Z136 or EN207
   - Price: $50-100
   
2. **Long sleeves**
   - No exposed skin
   - Non-flammable material

3. **Closed-toe shoes**
   - In case of dropped hot parts

### Facility Requirements

**Controlled access:**
- Posted warning signs
- Locked door or key access
- Only trained operators

**Fire safety:**
- Class ABC extinguisher
- Within 10 feet
- Monthly inspection

**Emergency procedures:**
- Eye wash station (nearby)
- First aid kit
- Emergency contact numbers posted

---

## Maintenance

### Daily (If Used)

- [ ] Visually inspect lens for dust/damage
- [ ] Check beam alignment (low power test)
- [ ] Verify interlock function
- [ ] Check cooling fan operation

### Weekly

- [ ] Clean lens (isopropanol + lens tissue)
- [ ] Check mounting hardware (tightness)
- [ ] Test emergency stop
- [ ] Verify output power (power meter)

### Monthly

- [ ] Deep clean optical path
- [ ] Check driver current setting
- [ ] Inspect wiring connections
- [ ] Verify temperature sensor

### Annually

- [ ] Replace laser diode (if power dropped >20%)
- [ ] Replace cooling fan
- [ ] Re-align optical system
- [ ] Professional safety inspection

---

## Troubleshooting

### No Laser Output

**Check:**
- Driver power supply (12V present?)
- Enable signal (HIGH on Pin 22?)
- Current setting (>1A?)
- Laser diode connection
- Interlock closed?

### Weak Output

**Possible causes:**
- Current too low → Adjust driver
- Diode degradation → Replace
- Dirty lens → Clean
- Misalignment → Re-align

### Overheating

**Symptoms:**
- Output drops after warmup
- Driver thermal shutdown

**Solutions:**
- Improve cooling (add fan)
- Reduce duty cycle
- Check heat sink contact (thermal paste)

### Poor Focus

**Causes:**
- Lens dirty → Clean
- Wrong working distance → Adjust
- Beam quality poor → Check collimator

---

## Bill of Materials

See [BOM.md](../../docs/design/BOM.md) for complete list.

**Summary:**
- Laser module: $180
- Driver: $70
- Optics: $50
- Safety goggles: $50
- Mounting hardware: $30
- Cooling: $20
- **Total: ~$400**

---

## References

- Laser safety: ANSI Z136.1
- Diode datasheets: Nichia, Osram
- Laser driver guides: Sam's Laser FAQ
- Thermal modeling: docs/validation/thermal-diffusion-validation.md

---

**SAFETY WARNING:**

Class 4 lasers can cause:
- **Permanent eye damage in <0.1 second**
- Skin burns
- Fire hazards

**NEVER operate without:**
- Proper training
- Safety goggles (OD6+)
- Interlocked enclosure
- Fire extinguisher nearby

**When in doubt, don't turn it on!**