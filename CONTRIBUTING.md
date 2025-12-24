# Contributing to Trifecta Drill

**Thank you for your interest in contributing!**

This is an open-source research project, and we welcome contributions from the community. Whether you're building a prototype, improving simulations, or enhancing documentation, your help is appreciated!

---

## How to Contribute

### 1. Report Issues

Found a bug? Have a question? Want to suggest an improvement?

- **Open an issue** on GitHub
- Use clear, descriptive titles
- Include relevant details (OS, hardware, error messages)
- Attach screenshots/plots if applicable

### 2. Submit Code

Want to improve the simulations or add features?

**Process:**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

**Code Guidelines:**
- Follow PEP 8 for Python code
- Add docstrings to functions
- Include comments for complex logic
- Run `black` for formatting
- Test before submitting

### 3. Build a Prototype

Building your own Trifecta Drill? **We want to hear about it!**

**What to share:**
- Build photos/videos
- Performance data (drilling rates, power consumption)
- Modifications you made
- Challenges you faced
- Lessons learned

**How to share:**
- Open a GitHub Issue titled "Prototype Build Report"
- Include detailed documentation
- Link to videos (YouTube, etc.)
- We'll feature you in the README!

### 4. Improve Documentation

Documentation is never perfect!

**Areas to improve:**
- Fix typos/grammar
- Clarify confusing sections
- Add diagrams/illustrations
- Translate to other languages
- Add troubleshooting tips

### 5. Run Simulations

Have compute resources? Run parameter sweeps!

**Interesting studies:**
- Different array geometries
- Various laser wavelengths
- Alternative materials (not just granite)
- Parameter optimization
- Sensitivity analysis

Share your results via Pull Request or Issue!

---

## Code Style

### Python
```python
# Good
def calculate_pressure(distance, power, frequency):
    """
    Calculate acoustic pressure at given distance.
    
    Parameters:
    -----------
    distance : float
        Distance from source (m)
    power : float
        Acoustic power (W)
    frequency : float
        Frequency (Hz)
        
    Returns:
    --------
    pressure : float
        Pressure amplitude (Pa)
    """
    # Implementation
    return pressure

# Bad (no docstring, unclear names)
def calc(d, p, f):
    return p * d / f
```

### Arduino
```cpp
// Good
const int LASER_PWM_PIN = 21;  // PWM output for laser modulation

void enableLaser(bool state) {
  digitalWrite(LASER_ENABLE_PIN, state ? HIGH : LOW);
}

// Bad (no comments, magic numbers)
void el(bool s) {
  digitalWrite(21, s ? 1 : 0);
}
```

---

## Documentation Style

### Markdown

- Use clear headers (##, ###)
- Add code blocks with language tags
- Include links where relevant
- Keep lines under 80 characters when possible
- Add images/diagrams to clarify complex topics

### Comments

- Explain **why**, not **what**
- Use complete sentences
- Update comments when code changes
- Remove commented-out code (use git history instead)

---

## Testing

### Before Submitting

**For code changes:**
- Run existing simulations to verify no regression
- Test on multiple Python versions if possible
- Check for numpy/scipy warnings
- Ensure plots display correctly

**For hardware changes:**
- Document thoroughly with photos
- Include BOM changes
- Note any safety implications
- Test before recommending to others

---

## Git Commit Messages

### Format
```
<type>: <short summary>

<optional longer description>

<optional footer with issue references>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting (no code change)
- `refactor`: Code restructure (no behavior change)
- `test`: Adding tests
- `chore`: Maintenance

### Examples

**Good:**
```
feat: Add basalt material properties to database

Added thermal and mechanical properties for basalt
rock to material_properties.py. Includes values from
peer-reviewed literature.

Closes #42
```

**Bad:**
```
update stuff
```

---

## Pull Request Process

1. **Update documentation** if needed
2. **Add tests** if applicable
3. **Describe changes** clearly in PR description
4. **Link related issues** (#123)
5. **Be responsive** to review comments
6. **Squash commits** before merge (if requested)

### PR Checklist

- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] No breaking changes (or clearly noted)
- [ ] Tested locally
- [ ] Commit messages are clear

---

## Community Guidelines

### Be Respectful

- Be kind and professional
- Welcome newcomers
- Assume good intentions
- Critique ideas, not people
- No harassment, discrimination, or trolling

### Be Constructive

- Provide helpful feedback
- Suggest improvements
- Share knowledge freely
- Help others learn

### Safety First

- Always prioritize safety in discussions
- Call out unsafe practices
- Encourage proper PPE and procedures
- Never encourage risky shortcuts

---

## Areas Needing Help

### High Priority

- [ ] **Prototype builds** - Be the first!
- [ ] **Experimental validation** - Test the physics
- [ ] **Parameter optimization** - Find best settings
- [ ] **Alternative geometries** - Try different patterns
- [ ] **CAD models** - Create 3D printable designs

### Medium Priority

- [ ] **Hardware testing** - Validate components
- [ ] **Code optimization** - Speed up simulations
- [ ] **Additional materials** - Expand database
- [ ] **Visualization improvements** - Better plots
- [ ] **Web interface** - Make simulations accessible

### Low Priority

- [ ] **Unit tests** - Increase coverage
- [ ] **CI/CD pipeline** - Automate testing
- [ ] **Docker container** - Simplify setup
- [ ] **Translation** - Other languages
- [ ] **Video tutorials** - How-to guides

---

## Recognition

### Contributors

All contributors will be:
- Listed in CONTRIBUTORS.md
- Credited in release notes
- Mentioned in relevant documentation

### Prototype Builders

First successful builds will be:
- Featured in README Hall of Fame
- Highlighted in project updates
- Given credit in academic papers (if applicable)

---

## Questions?

- **Technical questions:** Open an issue
- **General discussion:** Discussions tab (if enabled)
- **Private matters:** Email (see README for contact)

Don't be shy - we're all learning together!

---

## License

By contributing, you agree that your contributions will be licensed under the same MIT License that covers the project.

See [LICENSE](LICENSE) for details.

---

**Thank you for helping advance drilling technology!** 🚀

Together we can make transformative technology accessible to everyone.
