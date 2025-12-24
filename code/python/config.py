"""
Configuration file for Trifecta Drill system

Modify these parameters to match your hardware setup
"""

# ============================================================================
# ACOUSTIC SYSTEM CONFIGURATION
# ============================================================================

ACOUSTIC_CONFIG = {
    # Array geometry
    'array_type': 'fol',  # 'fol', 'grid', or 'random'
    'n_emitters': 19,     # 7, 19, or 37 for FoL
    
    # Transducer specifications
    'frequency': 40e3,    # Hz - carrier frequency
    'power_per_emitter': 40.0,  # W - electrical power
    'emitter_diameter': 10e-3,  # m - transducer diameter
    
    # Power supply
    'supply_voltage': 48.0,  # V DC
    'supply_current_max': 20.0,  # A
    
    # Control
    'pwm_frequency': 40e3,  # Hz - must match transducer
    'phase_control': False,  # True for individual phase control
}

# ============================================================================
# LASER SYSTEM CONFIGURATION
# ============================================================================

LASER_CONFIG = {
    # Laser specifications
    'wavelength': 445e-9,  # m - blue laser
    'power_average': 5.0,  # W - average power
    'power_peak': 50.0,    # W - peak during pulses
    
    # Modulation
    'pulse_frequency': 1000.0,  # Hz - 1 kHz default
    'duty_cycle': 0.10,    # 10% duty cycle
    
    # Optics
    'focal_length': 50e-3,  # m - focusing lens
    'spot_diameter': 1e-3,  # m - at focus
    'work_distance': 50e-3,  # m - from lens to work
    
    # Power supply
    'supply_voltage': 12.0,  # V DC
    'supply_current_max': 5.0,  # A
    
    # Safety
    'interlock_pin': 23,   # Arduino GPIO pin
    'enable_pin': 21,      # Arduino GPIO pin (PWM)
}

# ============================================================================
# PLASMA SYSTEM CONFIGURATION
# ============================================================================

PLASMA_CONFIG = {
    # Torch specifications
    'power_rating': 85.0,   # W
    'arc_voltage': 100.0,   # V DC nominal
    'arc_current': 0.85,    # A nominal
    
    # Gas
    'gas_type': 'air',      # 'air' or 'argon'
    'flow_rate': 3.0,       # L/min (for argon)
    
    # Control
    'enable_pin': 22,       # Arduino GPIO pin (relay)
    'ignition_delay': 0.1,  # seconds after enable
    
    # Temperature threshold
    'min_temperature': 800.0,  # K - minimum for activation
}

# ============================================================================
# MATERIAL PROPERTIES (GRANITE DEFAULT)
# ============================================================================

MATERIAL_CONFIG = {
    # Thermal properties
    'density': 2700.0,           # kg/m³
    'specific_heat': 800.0,      # J/(kg·K)
    'thermal_conductivity': 3.0,  # W/(m·K)
    'melting_point': 1500.0,     # K
    'vaporization_point': 3000.0,  # K
    
    # Mechanical properties
    'youngs_modulus': 50e9,      # Pa
    'poissons_ratio': 0.25,      # dimensionless
    'thermal_expansion': 8e-6,   # 1/K
    
    # Optical properties
    'absorptivity_base': 0.15,   # at 445nm
    'emissivity': 0.90,          # for radiation
    
    # Acoustic properties
    'acoustic_velocity': 5000.0,  # m/s - P-wave
    'acoustic_impedance': 13.5e6,  # Pa·s/m (Rayl)
    'damping_factor': 0.20,       # dimensionless
    
    # Strength
    'compressive_strength': 200e6,  # Pa
    'tensile_strength': 15e6,       # Pa
    'fracture_threshold': 100e6,    # Pa - for microcracks
    
    # Removal
    'specific_energy': 7.36e9,   # J/m³ - energy to remove
}

# ============================================================================
# CONTROL SYSTEM CONFIGURATION
# ============================================================================

CONTROL_CONFIG = {
    # Hardware
    'controller': 'arduino_mega',  # or 'raspberry_pi'
    'serial_port': '/dev/ttyUSB0',  # adjust for your system
    'baud_rate': 115200,
    
    # Safety
    'emergency_stop_pin': 23,    # interrupt pin
    'watchdog_timeout': 1.0,     # seconds
    
    # Sequence timing
    'acoustic_ramp_time': 2.0,   # seconds
    'laser_ramp_time': 1.0,      # seconds
    'plasma_ignition_wait': 0.1,  # seconds
    'shutdown_delay': 2.0,       # seconds
    
    # Monitoring
    'temperature_poll_rate': 10,  # Hz
    'power_poll_rate': 100,      # Hz
    'depth_poll_rate': 1,        # Hz
}

# ============================================================================
# SENSOR CONFIGURATION
# ============================================================================

SENSOR_CONFIG = {
    # Temperature
    'thermocouple_type': 'K',    # K-type
    'thermocouple_pin': 0,       # Analog pin
    'temp_range': (0, 1500),     # K
    
    # Current sensors
    'current_pins': {
        'acoustic': 1,   # Analog pin
        'laser': 2,      # Analog pin
        'plasma': 3,     # Analog pin
    },
    'current_scale': 10.0,  # A per volt
    
    # Voltage monitors
    'voltage_pins': {
        '48V': 4,    # Analog pin
        '12V': 5,    # Analog pin
    },
    'voltage_scale': 10.0,  # V per volt (with divider)
    
    # Optional sensors
    'thermal_camera_enabled': False,
    'microphone_enabled': False,
    'laser_power_meter_enabled': False,
}

# ============================================================================
# SIMULATION PARAMETERS
# ============================================================================

SIMULATION_CONFIG = {
    # Time settings
    'time_step': 0.001,      # seconds (1ms)
    'duration': 2.0,         # seconds
    
    # Spatial resolution
    'grid_size': 100,        # points
    'domain_size': 0.1,      # meters
    
    # Output
    'save_interval': 0.01,   # seconds
    'plot_interval': 0.1,    # seconds
    'data_dir': 'data/',
    'plots_dir': 'assets/images/',
}

# ============================================================================
# FILE PATHS
# ============================================================================

PATHS = {
    'data': 'assets/data/',
    'images': 'assets/images/',
    'videos': 'assets/videos/',
    'logs': 'logs/',
    'calibration': 'calibration/',
}

# ============================================================================
# LOGGING CONFIGURATION
# ============================================================================

LOGGING_CONFIG = {
    'level': 'INFO',  # DEBUG, INFO, WARNING, ERROR, CRITICAL
    'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    'log_to_file': True,
    'log_file': 'logs/trifecta.log',
    'log_to_console': True,
}

# ============================================================================
# SAFETY LIMITS
# ============================================================================

SAFETY_LIMITS = {
    # Temperature limits
    'max_surface_temp': 1600.0,  # K - emergency shutdown
    'max_component_temp': 80.0,   # °C - internal components
    
    # Power limits
    'max_acoustic_power': 850.0,  # W
    'max_laser_power': 6.0,       # W
    'max_plasma_power': 100.0,    # W
    'max_total_power': 1000.0,    # W
    
    # Current limits
    'max_48v_current': 22.0,      # A (with margin)
    'max_12v_current': 11.0,      # A (with margin)
    
    # Time limits
    'max_continuous_operation': 600.0,  # seconds (10 min)
    'min_cooldown_time': 120.0,        # seconds (2 min)
    
    # Acoustic
    'max_acoustic_spl': 130.0,    # dB - at operator position
    'max_exposure_time': 900.0,   # seconds (15 min)
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def get_config(section):
    """Get configuration for a specific section"""
    configs = {
        'acoustic': ACOUSTIC_CONFIG,
        'laser': LASER_CONFIG,
        'plasma': PLASMA_CONFIG,
        'material': MATERIAL_CONFIG,
        'control': CONTROL_CONFIG,
        'sensor': SENSOR_CONFIG,
        'simulation': SIMULATION_CONFIG,
        'safety': SAFETY_LIMITS,
    }
    return configs.get(section, {})

def validate_config():
    """Validate configuration parameters"""
    errors = []
    
    # Check acoustic power
    total_acoustic = (ACOUSTIC_CONFIG['power_per_emitter'] * 
                     ACOUSTIC_CONFIG['n_emitters'])
    if total_acoustic > SAFETY_LIMITS['max_acoustic_power']:
        errors.append(f"Acoustic power ({total_acoustic}W) exceeds limit")
    
    # Check laser power
    if LASER_CONFIG['power_average'] > SAFETY_LIMITS['max_laser_power']:
        errors.append(f"Laser power exceeds limit")
    
    # Check supply voltages match
    acoustic_voltage = ACOUSTIC_CONFIG['supply_voltage']
    laser_voltage = LASER_CONFIG['supply_voltage']
    
    return errors

if __name__ == '__main__':
    # Validate configuration
    errors = validate_config()
    if errors:
        print("Configuration errors:")
        for error in errors:
            print(f"  - {error}")
    else:
        print("Configuration valid!")
        
    # Print summary
    print("\nTrifecta Drill Configuration Summary:")
    print(f"  Acoustic: {ACOUSTIC_CONFIG['n_emitters']} emitters @ {ACOUSTIC_CONFIG['frequency']/1e3:.1f} kHz")
    print(f"  Laser: {LASER_CONFIG['power_average']:.1f}W @ {LASER_CONFIG['wavelength']*1e9:.0f}nm")
    print(f"  Plasma: {PLASMA_CONFIG['power_rating']:.1f}W")
    print(f"  Total power: ~{ACOUSTIC_CONFIG['n_emitters']*ACOUSTIC_CONFIG['power_per_emitter'] + LASER_CONFIG['power_average'] + PLASMA_CONFIG['power_rating']:.0f}W")