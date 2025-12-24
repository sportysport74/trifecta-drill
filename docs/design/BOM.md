# Bill of Materials - Trifecta Drill Prototype

**Total Cost: ~$5,000**  
**Last Updated: December 2025**

---

## Acoustic System - $2,500

### Transducers
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 19 | Ultrasonic Transducer | 40kHz, 10mm, 40W | Murata MA40S4S or equiv | $120 | $2,280 |
| 19 | Transducer Mount | 3D printed PETG | Self-print | $2 | $38 |
| 1 | Mounting Plate | Aluminum 300×300×10mm | McMaster-Carr | $150 | $150 |

**Subtotal: $2,468**

---

## Laser System - $300

### Laser Module
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | Blue Laser Diode | 445nm, 5W, TTL | DTR Laser Shop | $180 | $180 |
| 1 | Laser Driver | 0-5A, PWM input | Laser driver board | $70 | $70 |
| 1 | Safety Goggles | OD6+ at 445nm | Thorlabs LG3 | $50 | $50 |

**Subtotal: $300**

---

## Plasma System - $700

### Plasma Torch
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | Plasma Torch | 85W CNC compatible | AliExpress | $450 | $450 |
| 1 | Plasma PSU | 110/220V, 85W | Included or separate | $200 | $200 |
| 1 | Gas Regulator | For argon (optional) | Welding supply | $50 | $50 |

**Subtotal: $700**

---

## Power & Control - $800

### Power Supplies
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | 48V 20A PSU | For ultrasonics | Mean Well RSP-1000-48 | $150 | $150 |
| 1 | 12V 10A PSU | For laser | Mean Well LRS-150-12 | $50 | $50 |
| 1 | 5V 5A PSU | For Arduino/sensors | Generic USB adapter | $15 | $15 |

### Control Electronics
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | Arduino Mega 2560 | Or Raspberry Pi 4 | Arduino Store | $45 | $45 |
| 19 | MOSFET Module | IRF540, 30A, logic level | AliExpress | $3 | $57 |
| 1 | Relay Module | 4-channel, 10A | Generic | $12 | $12 |
| 1 | PWM Controller | For laser modulation | Generic | $25 | $25 |
| 20 | Terminal Blocks | Screw terminals | McMaster | $2 | $40 |

### Safety Systems
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | Emergency Stop | Mushroom button, NC | McMaster | $25 | $25 |
| 3 | Interlock Switch | Magnetic, NC | McMaster | $15 | $45 |
| 5 | Fuse Holder | Panel mount | Generic | $3 | $15 |
| 10 | Fuses | Various ratings | Generic | $2 | $20 |
| 1 | Circuit Breaker | 20A main | McMaster | $30 | $30 |

### Wiring & Connectors
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 50m | 18 AWG Wire | Silicone, red/black | Generic | $1/m | $50 |
| 20m | 14 AWG Wire | For high current | Generic | $1.5/m | $30 |
| 100 | Crimp Terminals | Ferrules, ring terminals | Generic | $0.20 | $20 |
| 1 | Heat Shrink Kit | Assorted sizes | Generic | $15 | $15 |

**Subtotal: $644**

---

## Mechanical Components - $700

### Structure
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | Base Plate | Aluminum 400×400×15mm | McMaster | $200 | $200 |
| 4 | Linear Rails | MGN12, 300mm | AliExpress | $25 | $100 |
| 1 | Laser Housing | 3D printed ABS | Self-print | $15 | $15 |
| 1 | Enclosure | Laser-cut acrylic sheets | Ponoko/SendCutSend | $150 | $150 |

### Fasteners
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 100 | M3 Screws | Various lengths | McMaster | $0.15 | $15 |
| 50 | M4 Screws | Various lengths | McMaster | $0.20 | $10 |
| 50 | M3 Standoffs | Brass, various heights | McMaster | $0.40 | $20 |
| 20 | M4 T-nuts | For extrusion mounting | McMaster | $0.50 | $10 |

### Cooling
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 3 | Cooling Fans | 80mm, 12V | Generic | $8 | $24 |
| 2 | Heat Sinks | Aluminum, laser/MOSFET | Generic | $10 | $20 |
| 1 | Thermal Paste | Arctic MX-4 | Amazon | $8 | $8 |

### Miscellaneous
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | Cable Management | Zip ties, cable sleeves | Generic | $25 | $25 |
| 1 | Tool Kit | Screwdrivers, Allen keys | Harbor Freight | $50 | $50 |
| 1 | Misc Supplies | Solder, flux, etc | Generic | $50 | $50 |

**Subtotal: $697**

---

## Optional Components - $500

### Sensors & Instrumentation
| Qty | Part | Specs | Source | Unit Price | Total |
|-----|------|-------|--------|-----------|-------|
| 1 | Thermocouple | K-type, high temp | Omega | $30 | $30 |
| 1 | Thermal Camera | MLX90640 IR array | Adafruit | $60 | $60 |
| 1 | Microphone | Condenser, 20kHz+ | Generic | $25 | $25 |
| 1 | Laser Power Meter | Photodiode + amp | Thorlabs | $150 | $150 |
| 1 | Oscilloscope | USB, 50MHz | Digilent | $200 | $200 |

**Subtotal: $465**

---

## Tools (If needed) - $300

| Item | Cost |
|------|------|
| 3D Printer access | $0-500 |
| Soldering station | $50 |
| Multimeter | $30 |
| Power drill | $80 |
| Safety equipment | $100 |

**Subtotal: $260-760**

---

## Total Cost Summary

| Category | Cost |
|----------|------|
| Acoustic System | $2,468 |
| Laser System | $300 |
| Plasma System | $700 |
| Power & Control | $644 |
| Mechanical | $697 |
| **Required Total** | **$4,809** |
| Optional (sensors) | $465 |
| Tools (if needed) | $260-760 |
| **Grand Total** | **$5,534-6,034** |

---

## Sourcing Notes

### Recommended Vendors

**Electronics:**
- Digi-Key (US) - Fast shipping, great selection
- Mouser (US) - Similar to Digi-Key
- AliExpress (China) - Cheap, slow shipping (3-6 weeks)
- Amazon - Quick but more expensive

**Mechanical:**
- McMaster-Carr (US) - Best selection, fast
- Misumi (US/Japan) - Precision parts
- SendCutSend - Custom laser cutting
- 3D printing services - Shapeways, Craftcloud

**Specialty:**
- DTR Laser Shop - High-quality laser diodes
- Thorlabs - Optics and sensors
- Mean Well - Industrial power supplies
- Arduino Store - Official boards

### Money-Saving Tips

1. **Buy in bulk** - Join group buys for transducers
2. **3D print** - DIY mounts instead of machined
3. **Used equipment** - eBay for oscilloscope, tools
4. **Alternative sources** - AliExpress for generic parts
5. **Prototype first** - Start with 7-emitter array ($1,200 less)

### Lead Times

- **In-stock items:** 1-3 days (Digi-Key, McMaster)
- **Custom parts:** 1-2 weeks (laser cutting, 3D printing)
- **China shipping:** 3-6 weeks (AliExpress)
- **PCB fabrication:** 1-2 weeks (JLCPCB, OSH Park)

**Plan for 4-6 weeks total from order to assembly**

---

## Alternative Configurations

### Budget Build ($2,500)
- 7-emitter array instead of 19: Save $1,200
- Lower power laser (1W): Save $100
- Manual control (no Arduino): Save $200

### Professional Build ($15,000)
- 37-emitter array: +$5,000
- 20W fiber laser: +$3,000
- 200W plasma torch: +$1,500
- CNC integration: +$4,000
- Instrumentation: +$1,500

### Research Grade ($50,000+)
- 61-emitter array
- 100W UV laser
- Vacuum chamber
- Full automation
- Publication-grade instrumentation

---

## Revision History

| Date | Version | Changes |
|------|---------|---------|
| Dec 2025 | 1.0 | Initial BOM |

---

## Notes

- Prices are approximate and subject to change
- Always verify specs before purchasing
- Check compatibility between components
- Order 10% extra fasteners and consumables
- Keep receipts for warranty claims

**Questions? Open an issue on GitHub!**