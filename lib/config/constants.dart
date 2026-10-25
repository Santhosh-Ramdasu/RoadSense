// App-wide constants and configuration
const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'YOUR_API_KEY_HERE');

const String appName = 'RoadSense';
const String appTagline = 'Detect Today. Prevent Tomorrow.';
const String appVersion = '1.0.0';

// Map default (Bengaluru, India)
const double defaultLat = 12.9716;
const double defaultLng = 77.5946;
const double defaultZoom = 12.0;

// Damage categories
const List<String> damageCategories = [
  'Road Crack',
  'Pothole',
  'Bridge Damage',
  'Corrosion / Rust',
  'Water Leakage',
  'Broken Streetlight',
  'Garbage Overflow',
  'Drainage Block',
];

// Severity levels
const List<String> severityLevels = ['Low', 'Medium', 'High', 'Critical'];

// Status values
const String statusPending = 'Pending';
const String statusAssigned = 'Assigned';
const String statusInProgress = 'In Progress';
const String statusResolved = 'Resolved';

// User roles
const String roleAdmin = 'admin';
const String roleCitizen = 'citizen';
const String roleEngineer = 'engineer';
const String roleDecisionMaker = 'decision_maker';

// Demo engineer accounts
const List<Map<String, dynamic>> demoEngineers = [
  {'id': 'eng001', 'name': 'Rajesh Kumar', 'zone': 'North', 'phone': '+91 98765 43210'},
  {'id': 'eng002', 'name': 'Priya Sharma', 'zone': 'South', 'phone': '+91 87654 32109'},
  {'id': 'eng003', 'name': 'Arjun Nair', 'zone': 'East', 'phone': '+91 76543 21098'},
  {'id': 'eng004', 'name': 'Divya Reddy', 'zone': 'West', 'phone': '+91 65432 10987'},
  {'id': 'eng005', 'name': 'Suresh Pillai', 'zone': 'Central', 'phone': '+91 54321 09876'},
];
