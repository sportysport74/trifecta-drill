"""
Material Properties Database

Physical properties for various rock types and materials
for the Trifecta Drill simulations
"""

import numpy as np

# ============================================================================
# MATERIAL DATABASE
# ============================================================================

MATERIALS = {
    'granite': {
        'name': 'Granite',
        'description': 'Common igneous rock, primary target',
        
        # Thermal properties
        'density': 2700.0,           # kg/m³
        'specific_heat': 800.0,      # J/(kg·K)
        'thermal_conductivity': 3.0,  # W/(m·K)
        'thermal_diffusivity': 1.39e-6,  # m²/s
        'melting_point': 1500.0,     # K
        'vaporization_point': 3000.0,  # K
        'latent_heat_fusion': 400e3,   # J/kg
        'latent_heat_vaporization': 6000e3,  # J/kg
        
        # Mechanical properties
        'youngs_modulus': 50e9,      # Pa
        'shear_modulus': 20e9,       # Pa
        'bulk_modulus': 40e9,        # Pa
        'poissons_ratio': 0.25,      # dimensionless
        'hardness_mohs': 6.5,        # Mohs scale
        
        # Thermal expansion
        'thermal_expansion': 8e-6,   # 1/K
        
        # Optical properties
        'absorptivity': {
            '445nm': 0.15,  # Blue laser
            '532nm': 0.12,  # Green laser
            '1064nm': 0.08, # IR laser
        },
        'emissivity': 0.90,  # Thermal radiation
        'refractive_index': 1.55,
        
        # Acoustic properties
        'p_wave_velocity': 5000.0,   # m/s
        's_wave_velocity': 3000.0,   # m/s
        'acoustic_impedance': 13.5e6,  # Pa·s/m (MRayl)
        'attenuation': 0.5,          # dB/(cm·MHz)
        'quality_factor': 50,        # Q factor
        'damping_factor': 0.20,      # eta
        
        # Strength properties
        'compressive_strength': 200e6,  # Pa (typical 100-250 MPa)
        'tensile_strength': 15e6,       # Pa (typically 10-25 MPa)
        'shear_strength': 30e6,         # Pa
        'fracture_toughness': 1.5e6,    # Pa·√m
        'fracture_threshold': 100e6,    # Pa (microcrack initiation)
        
        # Removal properties
        'specific_energy': 7.36e9,   # J/m³ (energy to remove)
        'drilling_rate_mechanical': 2.0,  # m/hr (typical)
    },
    
    'basalt': {
        'name': 'Basalt',
        'description': 'Volcanic rock, slightly softer than granite',
        
        'density': 2900.0,
        'specific_heat': 850.0,
        'thermal_conductivity': 2.0,
        'thermal_diffusivity': 0.81e-6,
        'melting_point': 1473.0,
        'vaporization_point': 2900.0,
        
        'youngs_modulus': 60e9,
        'poissons_ratio': 0.28,
        'thermal_expansion': 5e-6,
        
        'absorptivity': {'445nm': 0.20},
        'emissivity': 0.92,
        
        'p_wave_velocity': 5500.0,
        'acoustic_impedance': 16.0e6,
        'damping_factor': 0.18,
        
        'compressive_strength': 250e6,
        'tensile_strength': 20e6,
        'fracture_threshold': 120e6,
        
        'specific_energy': 6.5e9,
        'drilling_rate_mechanical': 2.5,
    },
    
    'limestone': {
        'name': 'Limestone',
        'description': 'Sedimentary rock, softer than granite',
        
        'density': 2400.0,
        'specific_heat': 900.0,
        'thermal_conductivity': 2.5,
        'thermal_diffusivity': 1.16e-6,
        'melting_point': 1200.0,
        'vaporization_point': 2600.0,
        
        'youngs_modulus': 30e9,
        'poissons_ratio': 0.22,
        'thermal_expansion': 6e-6,
        
        'absorptivity': {'445nm': 0.10},
        'emissivity': 0.88,
        
        'p_wave_velocity': 4000.0,
        'acoustic_impedance': 9.6e6,
        'damping_factor': 0.25,
        
        'compressive_strength': 100e6,
        'tensile_strength': 8e6,
        'fracture_threshold': 50e6,
        
        'specific_energy': 4.0e9,
        'drilling_rate_mechanical': 4.0,
    },
    
    'sandstone': {
        'name': 'Sandstone',
        'description': 'Sedimentary rock, soft and porous',
        
        'density': 2200.0,
        'specific_heat': 920.0,
        'thermal_conductivity': 2.0,
        'thermal_diffusivity': 0.99e-6,
        'melting_point': 1100.0,
        'vaporization_point': 2500.0,
        
        'youngs_modulus': 15e9,
        'poissons_ratio': 0.20,
        'thermal_expansion': 10e-6,
        
        'absorptivity': {'445nm': 0.12},
        'emissivity': 0.85,
        
        'p_wave_velocity': 3500.0,
        'acoustic_impedance': 7.7e6,
        'damping_factor': 0.30,
        
        'compressive_strength': 70e6,
        'tensile_strength': 5e6,
        'fracture_threshold': 35e6,
        
        'specific_energy': 3.0e9,
        'drilling_rate_mechanical': 6.0,
    },
    
    'concrete': {
        'name': 'Concrete',
        'description': 'Common construction material',
        
        'density': 2400.0,
        'specific_heat': 880.0,
        'thermal_conductivity': 1.7,
        'thermal_diffusivity': 0.80e-6,
        'melting_point': 1400.0,
        'vaporization_point': 2700.0,
        
        'youngs_modulus': 30e9,
        'poissons_ratio': 0.20,
        'thermal_expansion': 12e-6,
        
        'absorptivity': {'445nm': 0.18},
        'emissivity': 0.90,
        
        'p_wave_velocity': 4200.0,
        'acoustic_impedance': 10.1e6,
        'damping_factor': 0.22,
        
        'compressive_strength': 40e6,
        'tensile_strength': 4e6,
        'fracture_threshold': 20e6,
        
        'specific_energy': 3.5e9,
        'drilling_rate_mechanical': 5.0,
    },
    
    'marble': {
        'name': 'Marble',
        'description': 'Metamorphic rock, crystalline',
        
        'density': 2700.0,
        'specific_heat': 880.0,
        'thermal_conductivity': 2.8,
        'thermal_diffusivity': 1.18e-6,
        'melting_point': 1200.0,
        'vaporization_point': 2600.0,
        
        'youngs_modulus': 55e9,
        'poissons_ratio': 0.26,
        'thermal_expansion': 5e-6,
        
        'absorptivity': {'445nm': 0.08},
        'emissivity': 0.92,
        
        'p_wave_velocity': 5200.0,
        'acoustic_impedance': 14.0e6,
        'damping_factor': 0.15,
        
        'compressive_strength': 130e6,
        'tensile_strength': 10e6,
        'fracture_threshold': 65e6,
        
        'specific_energy': 5.0e9,
        'drilling_rate_mechanical': 3.5,
    },
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def get_material(name):
    """
    Get material properties by name
    
    Parameters:
    -----------
    name : str
        Material name (case-insensitive)
        
    Returns:
    --------
    dict : Material properties
    """
    name_lower = name.lower()
    if name_lower in MATERIALS:
        return MATERIALS[name_lower].copy()
    else:
        available = ', '.join(MATERIALS.keys())
        raise ValueError(f"Material '{name}' not found. Available: {available}")

def list_materials():
    """List all available materials"""
    print("Available Materials:")
    print("-" * 60)
    for name, props in MATERIALS.items():
        desc = props.get('description', 'No description')
        print(f"  {name.capitalize():12s} - {desc}")

def compare_materials(property_name):
    """
    Compare a property across all materials
    
    Parameters:
    -----------
    property_name : str
        Property to compare (e.g., 'density', 'compressive_strength')
    """
    print(f"\nComparison: {property_name}")
    print("-" * 60)
    
    for name, props in MATERIALS.items():
        if property_name in props:
            value = props[property_name]
            print(f"  {name.capitalize():12s}: {value}")
        else:
            print(f"  {name.capitalize():12s}: N/A")

def get_acoustic_impedance(material_name):
    """Calculate acoustic impedance if not provided"""
    mat = get_material(material_name)
    if 'acoustic_impedance' in mat:
        return mat['acoustic_impedance']
    else:
        # Z = ρ * c
        rho = mat['density']
        c = mat['p_wave_velocity']
        return rho * c

def get_thermal_diffusivity(material_name):
    """Calculate thermal diffusivity if not provided"""
    mat = get_material(material_name)
    if 'thermal_diffusivity' in mat:
        return mat['thermal_diffusivity']
    else:
        # α = k / (ρ * c_p)
        k = mat['thermal_conductivity']
        rho = mat['density']
        c_p = mat['specific_heat']
        return k / (rho * c_p)

def estimate_drilling_rate(material_name, method='trifecta'):
    """
    Estimate drilling rate for a material
    
    Parameters:
    -----------
    material_name : str
        Material name
    method : str
        'mechanical' or 'trifecta'
        
    Returns:
    --------
    float : Drilling rate (m/hr)
    """
    mat = get_material(material_name)
    
    if method == 'mechanical':
        return mat['drilling_rate_mechanical']
    elif method == 'trifecta':
        # Estimate based on synergy factor (15-20×)
        base = mat['drilling_rate_mechanical']
        synergy = 17.0  # Average from validation
        return base * synergy
    else:
        raise ValueError(f"Unknown method: {method}")

# ============================================================================
# EXAMPLE USAGE
# ============================================================================

if __name__ == '__main__':
    # List all materials
    list_materials()
    
    print("\n" + "="*60)
    
    # Get granite properties
    granite = get_material('granite')
    print(f"\nGranite Properties:")
    print(f"  Density: {granite['density']} kg/m³")
    print(f"  P-wave velocity: {granite['p_wave_velocity']} m/s")
    print(f"  Compressive strength: {granite['compressive_strength']/1e6:.0f} MPa")
    
    print("\n" + "="*60)
    
    # Compare densities
    compare_materials('density')
    
    print("\n" + "="*60)
    
    # Compare drilling rates
    print("\nDrilling Rate Comparison:")
    print("-" * 60)
    for name in MATERIALS.keys():
        mech = estimate_drilling_rate(name, 'mechanical')
        trif = estimate_drilling_rate(name, 'trifecta')
        speedup = trif / mech
        print(f"  {name.capitalize():12s}: {mech:4.1f} → {trif:5.1f} m/hr ({speedup:.1f}×)")