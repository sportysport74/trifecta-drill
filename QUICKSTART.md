# Quick Start Guide - Trifecta Drill Prototype

**Build a working prototype in one weekend for ~$5,000**

---

## ⚡ TL;DR

1. Order parts ($5K total)
2. 3D print mounts
3. Assemble array
4. Wire electronics
5. Safety check
6. Test & drill!

**Time:** 8-16 hours | **Difficulty:** Intermediate | **Cost:** $5,000

---

## 📦 Parts List (Total: ~$5,000)

### Acoustic System ($2,500)
- **19× Ultrasonic transducers** (40 kHz, 10mm diameter, 40W)
  - Murata MA40S4S or equivalent
  - AliExpress: Search "40khz ultrasonic transducer 40W"
  - Cost: ~$100-130 each = $2,000-2,500
  
### Laser System ($300)
- **1× 5W Blue laser module** (445nm, 1kHz capable)
  - TTL modulation input required
  - Heat sink included
  - AliExpress/eBay: ~$150-200
- **1× Laser driver** (PWM capable)
  - Adjustable current (0-5A)
  - TTL modulation input
  - Cost: ~$50-100
- **1× Safety goggles** (OD6+ at 445nm)
  - Amazon/Thorlabs: ~$50

### Plasma System ($700)
- **1× Plasma torch** (85W, CNC-compatible)
  - Non-contact arc ignition preferred
  - Argon or air plasma
  - AliExpress: "CNC plasma torch 85W" ~$400-500
- **1× Plasma power supply** (110/220V)
  - 85W continuous
  - Included with torch or separate: ~$200

### Power & Control ($800)
- **Power supplies:**
  - 1× 48V 20A (for ultrasonics): ~$150
  - 1× 12V 10A (for laser): ~$50
  - 1× Plasma PSU (included above)
- **Control electronics:**
  - 1× Arduino Mega or Raspberry Pi 4: ~$50
  - 19× MOSFET drivers (ultrasonic channels): ~$100
  - 1× Laser PWM controller: ~$30
  - 1× Plasma trigger relay: ~$20
- **Wiring & connectors:**
  - Power cables, terminal blocks, crimps: ~$100
- **Safety interlocks:**
  - Emergency stop button: ~$20
  - Interlock switches: ~$30
  - Fuses & circuit breakers: ~$50

### Mechanical ($700)
- **Mounting plate** (aluminum, 300×300×10mm): ~$100
- **Transducer mounts** (3D printed or machined): ~$50
- **Laser housing** (3D printed + optics): ~$100
- **Plasma mount** (steel bracket): ~$50
- **Enclosure** (laser-cut acrylic/aluminum): ~$200
- **Fasteners** (M3/M4 screws, standoffs): ~$50
- **Cooling** (fans, heat sinks): ~$100
- **Misc** (cables, solder, supplies): ~$50

---

## 🛠️ Tools Required

- **3D printer** (or access to one)
- **Soldering iron** + solder
- **Multimeter**
- **Oscilloscope** (optional but recommended)
- **Drill press** (for mounting plate)
- **Hand tools** (screwdrivers, Allen keys, wire strippers)
- **Safety equipment** (goggles, gloves, ear protection)

---

## 📐 Step-by-Step Assembly

### Phase 1: Mechanical Assembly (2-4 hours)

#### 1.1 Print Mounts
```
Files needed:
- hardware/CAD/fol-array-mount.stl (transducer mount)
- hardware/CAD/laser-housing.stl (laser mount)
- hardware/CAD/plasma-bracket.stl (plasma mount)

Print settings:
- Material: PETG or ABS (heat resistant)
- Infill: 50%+
- Supports: Yes
```

#### 1.2 Mount Transducers
- Mark Flower of Life pattern on mounting plate
  - Center: 1 transducer
  - Ring 1: 6 transducers at 60° (radius ~25mm)
  - Ring 2: 12 transducers at 30° offset (radius ~40mm)
- Drill mounting holes (M3)
- Attach transducers with thermal paste + screws
- Wire in series/parallel (see wiring diagram)

#### 1.3 Install Laser
- Mount laser in housing
- Attach heat sink + cooling fan
- Aim at center of acoustic focus
- Install safety interlock on housing door

#### 1.4 Install Plasma Torch
- Mount on adjustable bracket
- Position 5-10mm above work surface
- Route gas line (if using argon)
- Connect ground clamp

---

### Phase 2: Electrical Wiring (4-6 hours)

#### 2.1 Power Distribution
```
Main power → Fused distribution:
├─ 48V supply → Ultrasonic array
├─ 12V supply → Laser driver → Laser
├─ Plasma PSU → Plasma torch
└─ 5V supply → Arduino/RPi
```

**Safety:**
- All grounds connected to single point
- Fuses on every branch (2× rated current)
- Emergency stop kills ALL power
- Interlock prevents laser/plasma if door open

#### 2.2 Control Wiring
```
Arduino/RPi GPIO:
├─ Pin 2-20 → MOSFET drivers → Transducers (19 channels)
├─ Pin 21 (PWM) → Laser driver (TTL modulation)
├─ Pin 22 → Plasma torch relay
├─ Pin 23 → Emergency stop (input, pull-up)
└─ Pin 24-26 → Status LEDs
```

Wiring diagram: `hardware/schematics/control-wiring.pdf`

#### 2.3 Sensor Integration (Optional)
- Temperature sensors (thermocouple at drill point)
- Acoustic pressure sensor (microphone)
- Laser power meter (photodiode)
- Depth encoder (for feedback control)

---

### Phase 3: Safety Systems (1-2 hours)

**CRITICAL - DO NOT SKIP!**

#### 3.1 Emergency Stop
- Big red mushroom button
- Hardwired to cut ALL power
- Requires manual reset
- Test before every operation

#### 3.2 Interlocks
- Door switch on enclosure
- Laser cannot fire if door open
- Plasma cannot ignite if door open
- Visual indicator (LED) when safe

#### 3.3 Personal Protection
- **Eye protection:** OD6+ goggles at 445nm
- **Hearing protection:** 30+ dB NRR earplugs
- **Ventilation:** Fume hood or outdoors
- **Fire safety:** Class ABC extinguisher nearby

#### 3.4 Work Area
- Non-flammable surface
- Clear of combustibles
- Good lighting
- First aid kit accessible

---

### Phase 4: Software & Calibration (2-3 hours)

#### 4.1 Upload Firmware
```bash
cd code/arduino/
# Edit config.h for your setup
arduino-cli compile --fqbn arduino:avr:mega trifecta_controller.ino
arduino-cli upload --port /dev/ttyUSB0 --fqbn arduino:avr:mega
```

#### 4.2 Calibrate Acoustic
- Start with single transducer
- Measure frequency response (oscilloscope)
- Tune to 40 kHz ±100 Hz
- Test full array (all 19)
- Check for hot spots (thermal camera)

#### 4.3 Calibrate Laser
- Start at LOW power (0.5W)
- Measure spot size (<1mm)
- Check focus at work distance
- Test pulse modulation (1 kHz)
- Gradually increase to 5W

#### 4.4 Test Plasma
- Test ignition (no workpiece)
- Check arc stability
- Measure power consumption
- Adjust gas flow (if argon)

---

### Phase 5: First Test (1 hour)

**Test Protocol:**

#### 5.1 Acoustic Only
- Place granite sample
- Enable acoustic array
- Run for 10 seconds
- Check for heating/vibration
- ✅ If stable, proceed

#### 5.2 Add Laser (Low Power)
- Enable laser at 1W
- Monitor temperature (IR camera)
- Should see slow heating
- Gradually increase to 5W
- ✅ If T rises to 800K+, proceed

#### 5.3 Add Plasma
- Once T > 800K, enable plasma
- Start with 50% power
- Watch for material removal
- Increase to full power
- ✅ If drilling, SUCCESS!

#### 5.4 Measure Performance
- Time to drill 5mm
- Calculate drilling rate (m/hr)
- Compare to theory (32.5 m/hr)
- Optimize parameters

---

## 📊 Expected Results

### First Test (Raw, Unoptimized)
- **Drilling rate:** 10-20 m/hr
- **Power consumption:** 850-1000W
- **Speedup vs hand drill:** 5-10×

### After Optimization
- **Drilling rate:** 25-40 m/hr
- **Power consumption:** 800-900W
- **Speedup:** 12-20×

### With Parameter Tuning
- **Drilling rate:** 30-50 m/hr
- **Power consumption:** 750-850W
- **Speedup:** 15-25×

---

## 🐛 Troubleshooting

### Acoustic array not working
- Check wiring (common issue!)
- Verify 48V supply
- Test individual transducers
- Check for shorts

### Laser not heating enough
- Increase power
- Check focus (critical!)
- Verify surface is clean
- Try rougher surface first

### Plasma won't ignite
- Check ground connection
- Verify gas flow
- Increase gap distance
- Check power supply

### Low drilling rate
- Optimize acoustic focus
- Increase laser power
- Pre-heat longer
- Check plasma coupling

---

## 📹 Documentation

Please document your build!

**Photos to take:**
- Complete assembly
- Wiring close-ups
- First successful drill test
- Hole quality comparison

**Videos to record:**
- Full system startup
- Drilling progression
- Side-by-side vs drill comparison

**Data to log:**
- Drilling rate vs time
- Power consumption
- Temperature profile
- Hole quality metrics

**Share with community:**
- GitHub Issues
- YouTube (tag #TrifectaDrill)
- Twitter/X (@yourusername)

---

## 🎯 Next Steps

After successful first test:

1. **Parameter optimization**
   - Vary acoustic power
   - Adjust laser pulse rate
   - Optimize plasma timing
   
2. **Different materials**
   - Try basalt, limestone
   - Compare vs granite
   - Document differences

3. **Scale up**
   - Add more transducers (37-element array)
   - Increase laser power (10-20W)
   - Higher power plasma (200W)

4. **Automation**
   - CNC integration
   - Closed-loop control
   - Adaptive parameters

5. **Contribute back!**
   - Share your results
   - Improve documentation
   - Submit CAD improvements

---

## 🆘 Getting Help

**If you get stuck:**

1. Check [Troubleshooting Guide](docs/troubleshooting.md)
2. Search [GitHub Issues](https://github.com/yourusername/trifecta-drill/issues)
3. Post question with photos/videos
4. Join Discord server (link in README)

**Before asking:**
- Read relevant docs
- Check wiring diagram
- Verify safety systems
- Test components individually

---

## ⚖️ Legal Notice

- Follow local laser safety regulations
- Some jurisdictions restrict high-power lasers
- Plasma equipment may require certification
- Check building codes for power requirements

**In doubt? Consult local authorities.**

---

## 🎉 Success? Share It!

If you successfully build a prototype:

1. **Document it** (photos, videos, data)
2. **Post results** to GitHub Issues
3. **Get featured** in README Hall of Fame
4. **Eternal glory** in the contributor list

**You'll be building the future of drilling!** 🚀

---

**Questions? See full documentation or open an issue!**

**Safety first, science always.** 🔬🔥