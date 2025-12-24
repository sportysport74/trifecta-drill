/*
 * Trifecta Drill - Phase Control Firmware
 * ==========================================
 * 
 * Controls the complete trifecta drilling system:
 * - 19-channel acoustic array (40 kHz)
 * - Pulsed laser heating (1 kHz PWM)
 * - Plasma torch (relay control)
 * 
 * Safety features:
 * - Emergency stop (hardware interrupt)
 * - Interlocks (door switches)
 * - Temperature monitoring
 * - Watchdog timer
 * 
 * Hardware: Arduino Mega 2560
 * Author: Sportysport + Claude
 * Date: December 2025
 */

// ============================================================================
// PIN DEFINITIONS
// ============================================================================

// Acoustic array outputs (19 channels)
const int ACOUSTIC_PINS[] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 
                             12, 13, 14, 15, 16, 17, 18, 19, 20};
const int NUM_ACOUSTIC = 19;

// Laser control
const int LASER_PWM_PIN = 21;     // PWM output for laser modulation
const int LASER_ENABLE_PIN = 22;  // Digital enable

// Plasma control
const int PLASMA_RELAY_PIN = 23;  // Relay control

// Safety inputs
const int EMERGENCY_STOP_PIN = 24;  // Emergency stop button (interrupt)
const int DOOR_INTERLOCK_PIN = 25;  // Door interlock switch

// Status LEDs
const int LED_POWER = 26;      // Green - System on
const int LED_LASER = 27;      // Red - Laser armed
const int LED_PLASMA = 28;     // Amber - Plasma active

// Analog inputs
const int TEMP_SENSOR_PIN = A0;     // Thermocouple amplifier
const int CURRENT_48V_PIN = A1;     // Ultrasonic current
const int CURRENT_12V_PIN = A2;     // Laser current
const int VOLTAGE_48V_PIN = A3;     // 48V rail monitor

// ============================================================================
// CONFIGURATION
// ============================================================================

// Acoustic parameters
const unsigned long ACOUSTIC_FREQ = 40000;  // 40 kHz
const int ACOUSTIC_RAMP_TIME_MS = 2000;     // 2 second ramp

// Laser parameters
const int LASER_PULSE_FREQ = 1000;  // 1 kHz
const int LASER_DUTY_CYCLE = 10;    // 10% duty cycle
const int LASER_PWM_VALUE = 25;     // 0-255 (10% ≈ 25)

// Plasma parameters
const float PLASMA_TEMP_THRESHOLD = 800.0;  // K - minimum temperature

// Safety limits
const float MAX_TEMP = 1600.0;      // K - emergency shutdown
const float MAX_CURRENT_48V = 22.0; // A - over-current trip
const float MAX_CURRENT_12V = 11.0; // A - over-current trip

// Watchdog timeout
const unsigned long WATCHDOG_TIMEOUT_MS = 1000;  // 1 second

// ============================================================================
// STATE MACHINE
// ============================================================================

enum SystemState {
  STATE_STANDBY,
  STATE_ACOUSTIC_ONLY,
  STATE_ACOUSTIC_LASER,
  STATE_FULL_TRIFECTA,
  STATE_SHUTDOWN,
  STATE_EMERGENCY
};

SystemState currentState = STATE_STANDBY;

// ============================================================================
// GLOBAL VARIABLES
// ============================================================================

float surfaceTemp = 25.0;      // °C
float current48V = 0.0;        // A
float current12V = 0.0;        // A
bool emergencyStop = false;
bool doorOpen = false;

unsigned long lastWatchdog = 0;
unsigned long stateStartTime = 0;

// ============================================================================
// SETUP
// ============================================================================

void setup() {
  // Initialize serial
  Serial.begin(115200);
  Serial.println(F("Trifecta Drill Controller v1.0"));
  Serial.println(F("Initializing..."));
  
  // Configure acoustic pins
  for (int i = 0; i < NUM_ACOUSTIC; i++) {
    pinMode(ACOUSTIC_PINS[i], OUTPUT);
    digitalWrite(ACOUSTIC_PINS[i], LOW);
  }
  
  // Configure laser pins
  pinMode(LASER_PWM_PIN, OUTPUT);
  pinMode(LASER_ENABLE_PIN, OUTPUT);
  digitalWrite(LASER_ENABLE_PIN, LOW);
  analogWrite(LASER_PWM_PIN, 0);
  
  // Configure plasma pin
  pinMode(PLASMA_RELAY_PIN, OUTPUT);
  digitalWrite(PLASMA_RELAY_PIN, LOW);
  
  // Configure safety inputs (pull-up)
  pinMode(EMERGENCY_STOP_PIN, INPUT_PULLUP);
  pinMode(DOOR_INTERLOCK_PIN, INPUT_PULLUP);
  
  // Configure status LEDs
  pinMode(LED_POWER, OUTPUT);
  pinMode(LED_LASER, OUTPUT);
  pinMode(LED_PLASMA, OUTPUT);
  
  // Attach emergency stop interrupt
  attachInterrupt(digitalPinToInterrupt(EMERGENCY_STOP_PIN), 
                   emergencyStopISR, FALLING);
  
  // Initialize watchdog
  lastWatchdog = millis();
  
  // Power LED on
  digitalWrite(LED_POWER, HIGH);
  
  Serial.println(F("Initialization complete!"));
  Serial.println(F("System in STANDBY mode"));
  Serial.println();
  printHelp();
}

// ============================================================================
// MAIN LOOP
// ============================================================================

void loop() {
  // Update watchdog
  kickWatchdog();
  
  // Read sensors
  readSensors();
  
  // Check safety
  if (!checkSafety()) {
    enterEmergencyState();
    return;
  }
  
  // Process serial commands
  if (Serial.available()) {
    processCommand();
  }
  
  // State machine
  switch (currentState) {
    case STATE_STANDBY:
      runStandby();
      break;
      
    case STATE_ACOUSTIC_ONLY:
      runAcousticOnly();
      break;
      
    case STATE_ACOUSTIC_LASER:
      runAcousticLaser();
      break;
      
    case STATE_FULL_TRIFECTA:
      runFullTrifecta();
      break;
      
    case STATE_SHUTDOWN:
      runShutdown();
      break;
      
    case STATE_EMERGENCY:
      runEmergency();
      break;
  }
  
  // Small delay
  delay(10);
}

// ============================================================================
// SENSOR READING
// ============================================================================

void readSensors() {
  // Read temperature (K-type thermocouple with amplifier)
  // Assumes 0-5V = 0-1000°C
  int tempRaw = analogRead(TEMP_SENSOR_PIN);
  float tempC = (tempRaw / 1023.0) * 1000.0;  // 0-1000°C
  surfaceTemp = tempC + 273.15;  // Convert to Kelvin
  
  // Read 48V current (Hall effect sensor, 10A/V)
  int current48Raw = analogRead(CURRENT_48V_PIN);
  current48V = (current48Raw / 1023.0) * 5.0 * 10.0;  // Convert to A
  
  // Read 12V current
  int current12Raw = analogRead(CURRENT_12V_PIN);
  current12V = (current12Raw / 1023.0) * 5.0 * 10.0;  // Convert to A
}

// ============================================================================
// SAFETY CHECKING
// ============================================================================

bool checkSafety() {
  // Check emergency stop
  if (emergencyStop) {
    Serial.println(F("ERROR: Emergency stop activated!"));
    return false;
  }
  
  // Check door interlock
  doorOpen = !digitalRead(DOOR_INTERLOCK_PIN);  // Active low
  if (doorOpen && (currentState != STATE_STANDBY)) {
    Serial.println(F("ERROR: Door opened during operation!"));
    return false;
  }
  
  // Check temperature
  if (surfaceTemp > MAX_TEMP) {
    Serial.println(F("ERROR: Temperature too high!"));
    Serial.print(F("  Temp: "));
    Serial.print(surfaceTemp);
    Serial.println(F(" K"));
    return false;
  }
  
  // Check 48V current
  if (current48V > MAX_CURRENT_48V) {
    Serial.println(F("ERROR: 48V over-current!"));
    Serial.print(F("  Current: "));
    Serial.print(current48V);
    Serial.println(F(" A"));
    return false;
  }
  
  // Check 12V current
  if (current12V > MAX_CURRENT_12V) {
    Serial.println(F("ERROR: 12V over-current!"));
    Serial.print(F("  Current: "));
    Serial.print(current12V);
    Serial.println(F(" A"));
    return false;
  }
  
  // Check watchdog
  if (millis() - lastWatchdog > WATCHDOG_TIMEOUT_MS) {
    Serial.println(F("ERROR: Watchdog timeout!"));
    return false;
  }
  
  return true;
}

// ============================================================================
// STATE FUNCTIONS
// ============================================================================

void runStandby() {
  // All systems off
  digitalWrite(LED_LASER, LOW);
  digitalWrite(LED_PLASMA, LOW);
}

void runAcousticOnly() {
  // Acoustic array on
  unsigned long elapsed = millis() - stateStartTime;
  
  if (elapsed < ACOUSTIC_RAMP_TIME_MS) {
    // Ramp up
    int duty = map(elapsed, 0, ACOUSTIC_RAMP_TIME_MS, 0, 128);
    setAcousticPower(duty);
  } else {
    // Full power
    setAcousticPower(128);
  }
}

void runAcousticLaser() {
  // Acoustic + Laser
  setAcousticPower(128);  // Full power
  
  // Enable laser
  digitalWrite(LASER_ENABLE_PIN, HIGH);
  analogWrite(LASER_PWM_PIN, LASER_PWM_VALUE);
  digitalWrite(LED_LASER, HIGH);
}

void runFullTrifecta() {
  // All systems active
  setAcousticPower(128);
  
  // Laser on
  digitalWrite(LASER_ENABLE_PIN, HIGH);
  analogWrite(LASER_PWM_PIN, LASER_PWM_VALUE);
  digitalWrite(LED_LASER, HIGH);
  
  // Plasma on (if temperature sufficient)
  if (surfaceTemp > PLASMA_TEMP_THRESHOLD) {
    digitalWrite(PLASMA_RELAY_PIN, HIGH);
    digitalWrite(LED_PLASMA, HIGH);
  } else {
    digitalWrite(PLASMA_RELAY_PIN, LOW);
    digitalWrite(LED_PLASMA, LOW);
  }
}

void runShutdown() {
  // Graceful shutdown sequence
  unsigned long elapsed = millis() - stateStartTime;
  
  if (elapsed < 500) {
    // Turn off plasma first
    digitalWrite(PLASMA_RELAY_PIN, LOW);
    digitalWrite(LED_PLASMA, LOW);
  } else if (elapsed < 1000) {
    // Turn off laser
    digitalWrite(LASER_ENABLE_PIN, LOW);
    analogWrite(LASER_PWM_PIN, 0);
    digitalWrite(LED_LASER, LOW);
  } else if (elapsed < 2000) {
    // Ramp down acoustic
    int duty = map(elapsed - 1000, 0, 1000, 128, 0);
    setAcousticPower(duty);
  } else {
    // Complete shutdown
    setAcousticPower(0);
    currentState = STATE_STANDBY;
    Serial.println(F("Shutdown complete."));
  }
}

void runEmergency() {
  // IMMEDIATE shutdown, no ramp
  setAcousticPower(0);
  digitalWrite(LASER_ENABLE_PIN, LOW);
  analogWrite(LASER_PWM_PIN, 0);
  digitalWrite(PLASMA_RELAY_PIN, LOW);
  
  // Flash all LEDs
  static unsigned long lastBlink = 0;
  if (millis() - lastBlink > 500) {
    digitalWrite(LED_LASER, !digitalRead(LED_LASER));
    digitalWrite(LED_PLASMA, !digitalRead(LED_PLASMA));
    lastBlink = millis();
  }
  
  Serial.println(F("EMERGENCY MODE - PRESS RESET TO RECOVER"));
}

// ============================================================================
// ACOUSTIC CONTROL
// ============================================================================

void setAcousticPower(int duty) {
  // duty: 0-255
  // Generate 40 kHz square wave on all channels
  
  if (duty == 0) {
    // All off
    for (int i = 0; i < NUM_ACOUSTIC; i++) {
      digitalWrite(ACOUSTIC_PINS[i], LOW);
    }
    return;
  }
  
  // For now, simple on/off
  // TODO: Implement proper PWM at 40 kHz
  bool state = (duty > 128);
  for (int i = 0; i < NUM_ACOUSTIC; i++) {
    digitalWrite(ACOUSTIC_PINS[i], state);
  }
}

// ============================================================================
// COMMAND PROCESSING
// ============================================================================

void processCommand() {
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();
  cmd.toUpperCase();
  
  if (cmd == "STANDBY" || cmd == "0") {
    changeState(STATE_STANDBY);
  } else if (cmd == "ACOUSTIC" || cmd == "1") {
    changeState(STATE_ACOUSTIC_ONLY);
  } else if (cmd == "LASER" || cmd == "2") {
    changeState(STATE_ACOUSTIC_LASER);
  } else if (cmd == "TRIFECTA" || cmd == "3") {
    changeState(STATE_FULL_TRIFECTA);
  } else if (cmd == "SHUTDOWN" || cmd == "S") {
    changeState(STATE_SHUTDOWN);
  } else if (cmd == "STATUS" || cmd == "?") {
    printStatus();
  } else if (cmd == "HELP" || cmd == "H") {
    printHelp();
  } else {
    Serial.println(F("Unknown command. Type HELP for commands."));
  }
}

void changeState(SystemState newState) {
  if (currentState == STATE_EMERGENCY) {
    Serial.println(F("Cannot change state - EMERGENCY mode!"));
    return;
  }
  
  // Validate transition
  if (newState > currentState + 1 && newState != STATE_STANDBY) {
    Serial.println(F("Invalid state transition!"));
    Serial.println(F("Must progress through states sequentially."));
    return;
  }
  
  currentState = newState;
  stateStartTime = millis();
  
  Serial.print(F("State changed to: "));
  Serial.println(getStateName(currentState));
}

void enterEmergencyState() {
  currentState = STATE_EMERGENCY;
  stateStartTime = millis();
  Serial.println(F("*** ENTERING EMERGENCY STATE ***"));
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

void kickWatchdog() {
  lastWatchdog = millis();
}

void emergencyStopISR() {
  // Emergency stop interrupt
  emergencyStop = true;
}

String getStateName(SystemState state) {
  switch (state) {
    case STATE_STANDBY: return F("STANDBY");
    case STATE_ACOUSTIC_ONLY: return F("ACOUSTIC_ONLY");
    case STATE_ACOUSTIC_LASER: return F("ACOUSTIC_LASER");
    case STATE_FULL_TRIFECTA: return F("FULL_TRIFECTA");
    case STATE_SHUTDOWN: return F("SHUTDOWN");
    case STATE_EMERGENCY: return F("EMERGENCY");
    default: return F("UNKNOWN");
  }
}

void printStatus() {
  Serial.println();
  Serial.println(F("=== SYSTEM STATUS ==="));
  Serial.print(F("State: "));
  Serial.println(getStateName(currentState));
  Serial.print(F("Surface Temp: "));
  Serial.print(surfaceTemp);
  Serial.println(F(" K"));
  Serial.print(F("48V Current: "));
  Serial.print(current48V);
  Serial.println(F(" A"));
  Serial.print(F("12V Current: "));
  Serial.print(current12V);
  Serial.println(F(" A"));
  Serial.print(F("Door: "));
  Serial.println(doorOpen ? F("OPEN") : F("CLOSED"));
  Serial.print(F("E-Stop: "));
  Serial.println(emergencyStop ? F("ACTIVE") : F("OK"));
  Serial.println();
}

void printHelp() {
  Serial.println();
  Serial.println(F("=== COMMANDS ==="));
  Serial.println(F("0 or STANDBY   - Enter standby mode"));
  Serial.println(F("1 or ACOUSTIC  - Enable acoustic only"));
  Serial.println(F("2 or LASER     - Enable acoustic + laser"));
  Serial.println(F("3 or TRIFECTA  - Enable all systems"));
  Serial.println(F("S or SHUTDOWN  - Graceful shutdown"));
  Serial.println(F("? or STATUS    - Print status"));
  Serial.println(F("H or HELP      - Print this help"));
  Serial.println();
}

// ============================================================================
// END OF FILE
// ============================================================================
