# RoadSense — Tools & Methods Documentation 🛠️

> A comprehensive overview of every tool, technology, package, and methodology used to build the **RoadSense** platform.

---

## 📋 Table of Contents

1. [Framework & Language](#1-framework--language)
2. [AI & Machine Learning](#2-ai--machine-learning)
3. [Maps & Geolocation](#3-maps--geolocation)
4. [Data Visualization & Charts](#4-data-visualization--charts)
5. [State Management](#5-state-management)
6. [Local Storage](#6-local-storage)
7. [Image Handling](#7-image-handling)
8. [UI & Animation Libraries](#8-ui--animation-libraries)
9. [Utility Packages](#9-utility-packages)
10. [Architecture & Design Patterns](#10-architecture--design-patterns)
11. [Platform Configurations](#11-platform-configurations)
12. [Development Tools](#12-development-tools)

---

## 1. Framework & Language

| Tool | Version | Purpose |
|------|---------|---------|
| **Flutter** | SDK ≥ 3.0.0, < 4.0.0 | Cross-platform UI framework (Android, iOS, Web) |
| **Dart** | SDK ≥ 3.0.0, < 4.0.0 | Programming language powering Flutter |
| **Material Design 3** | Built-in | Modern design system (`useMaterial3: true`) |

### Why Flutter?
- Single codebase targeting **Android**, **iOS**, and **Web**
- Rich widget ecosystem for rapid prototyping
- Hot reload for fast development during hackathon

---

## 2. AI & Machine Learning

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **Google Gemini API** | `google_generative_ai` | ^0.4.6 | AI-powered infrastructure damage detection |

### AI Methods Used

#### a) Image Analysis (`analyzeImage`)
- **Model**: `gemini-1.5-flash`
- **Input**: Raw image bytes (`Uint8List`) captured via camera or gallery
- **Prompt Engineering**: Structured system prompt instructing the AI to classify infrastructure damage
- **Output**: Structured JSON response with:
  - Damage category (8 types: Road Crack, Pothole, Bridge Damage, Corrosion/Rust, Water Leakage, Broken Streetlight, Garbage Overflow, Drainage Block)
  - Confidence score (70–99%)
  - Severity level (Low / Medium / High / Critical)
  - Severity & priority scores (1.0–10.0 scale)
  - Estimated repair cost in INR
  - Repair timeframe
  - Risk assessment, root cause analysis, and recommendations
  - Assigned government department
- **Fallback**: Intelligent simulation with realistic pre-built responses if API fails

#### b) Predictive Maintenance (`generatePredictiveInsight`)
- **Input**: Asset name, report count (last 30 days), risk score
- **Output**: 2-sentence actionable predictive maintenance insight for engineers
- **Fallback**: Tiered rule-based responses based on risk score thresholds

---

## 3. Maps & Geolocation

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **flutter_map** | `flutter_map` | ^8.1.1 | Interactive map widget (OpenStreetMap) |
| **LatLong2** | `latlong2` | ^0.9.1 | Geographic coordinate handling |
| **Geolocator** | `geolocator` | ^13.0.2 | Device GPS location access |
| **Geocoding** | `geocoding` | ^3.0.0 | Reverse geocoding (coordinates → address) |
| **OpenStreetMap** | Tile server | — | Free map tile provider (no API key required) |

### Map Methods
- **50 seeded markers** across 20 Bengaluru locations with randomized offsets
- Color-coded markers by severity (Critical → red, High → orange, Medium → amber, Low → green)
- Interactive marker popups with report details
- Real-time GPS location for citizen reporting

---

## 4. Data Visualization & Charts

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **FL Chart** | `fl_chart` | ^0.70.2 | High-performance charting library |

### Chart Types Implemented
- **Line/Trend Charts**: Reports over the last 30 days
- **Pie Charts**: Distribution by damage category and status
- **Bar Charts**: Comparative analysis across zones/departments
- **Heatmap Visualizations**: Severity density mapping

---

## 5. State Management

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **Provider** | `provider` | ^6.1.2 | Reactive state management |

### State Architecture
- **`AppState`** (extends `ChangeNotifier`): Central state store
- **Computed properties**: Filtered views (pending, critical, resolved, per-engineer reports)
- **Dashboard metrics**: Real-time stats (today's reports, resolution rate, avg response time)
- **Category & status breakdowns**: Aggregated maps for chart data
- **30-day trend data**: Daily report counts for time-series visualization

---

## 6. Local Storage

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **SharedPreferences** | `shared_preferences` | ^2.3.3 | Persistent key-value storage |
| **Path Provider** | `path_provider` | ^2.1.5 | File system path resolution |

### Storage Method
- **Simulated Firebase Firestore** using `SharedPreferences`
- All report data serialized to/from JSON
- User profile persistence across sessions
- Seed data generation on first launch (50 demo reports)
- Full CRUD operations (Create, Read, Update via `copyWith` pattern)

---

## 7. Image Handling

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **Image Picker** | `image_picker` | ^1.1.2 | Camera & gallery image capture |
| **Cached Network Image** | `cached_network_image` | ^3.4.1 | Efficient image loading with caching |

---

## 8. UI & Animation Libraries

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **Lottie** | `lottie` | ^3.3.1 | JSON-based animations (splash screen, loading) |
| **Shimmer** | `shimmer` | ^3.0.0 | Skeleton loading placeholders |
| **Animated Text Kit** | `animated_text_kit` | ^4.2.3 | Text animation effects |
| **Flutter Animate** | `flutter_animate` | ^4.5.2 | Declarative animation chains (fadeIn, slideY, etc.) |
| **Percent Indicator** | `percent_indicator` | ^4.2.4 | Circular/linear progress indicators |
| **Flutter SVG** | `flutter_svg` | ^2.0.17 | SVG asset rendering |
| **Timeline Tile** | `timeline_tile` | ^2.0.0 | Timeline/progress step visualization |
| **Cupertino Icons** | `cupertino_icons` | ^1.0.8 | iOS-style icon set |

### Animation Techniques
- **Entry animations**: Staggered fadeIn + slideY on screen components
- **Shader masks**: Gradient text effects on the splash screen title
- **Shimmer loading**: Skeleton screens while data loads
- **Micro-interactions**: Scale, opacity, and slide animations on cards

---

## 9. Utility Packages

| Tool | Package | Version | Purpose |
|------|---------|---------|---------|
| **intl** | `intl` | ^0.19.0 | Date/number formatting & internationalization |
| **UUID** | `uuid` | ^4.5.1 | Unique ID generation for reports/users |
| **URL Launcher** | `url_launcher` | ^6.3.1 | Opening external links |
| **HTTP** | `http` | ^1.3.2 | HTTP networking |
| **Permission Handler** | `permission_handler` | ^11.4.0 | Runtime permission requests (camera, location, storage) |

---

## 10. Architecture & Design Patterns

### Project Structure
```
lib/
├── main.dart                  # App entry point
├── config/
│   └── constants.dart         # App-wide constants, API keys, roles
├── models/
│   └── report_model.dart      # Data models (ReportModel, AssetPrediction, SeedData)
├── services/
│   ├── app_state.dart         # Central state management (Provider)
│   └── gemini_service.dart    # AI service layer (Gemini API)
├── screens/
│   ├── splash_screen.dart     # Animated splash/loading screen
│   ├── auth_screen.dart       # Login/authentication UI
│   ├── role_selection_screen.dart  # Role picker (Citizen/Engineer/Admin/DM)
│   ├── citizen/               # Citizen portal screens
│   ├── engineer/              # Engineer portal screens
│   ├── admin/                 # Admin portal screens
│   ├── analytics/             # Analytics & dashboard screens
│   ├── auth/                  # Auth flow screens
│   └── map/                   # Map visualization screens
├── theme/
│   └── app_theme.dart         # Design system (colors, gradients, themes)
└── widgets/
    ├── issue_card.dart        # Reusable report card widget
    └── stat_card.dart         # Dashboard stat card widget
```

### Design Patterns
| Pattern | Where Used |
|---------|-----------|
| **Provider (ChangeNotifier)** | Global state management via `AppState` |
| **Singleton Services** | `GeminiService` with static methods |
| **Repository Pattern** | `AppState` abstracts storage layer |
| **Factory Constructors** | `ReportModel.fromJson()` for deserialization |
| **Immutable Models with `copyWith`** | `ReportModel` for safe state updates |
| **Seed Data Pattern** | `SeedData.generateSeedReports()` for demo data |
| **Graceful Degradation** | AI simulation fallback when API unavailable |
| **Role-Based Access Control** | 4 roles with distinct UI portals |

---

## 11. Platform Configurations

### Android
- **Permissions**: Internet, Camera, Storage, Fine/Coarse Location
- **AndroidManifest.xml**: Configured for Flutter embedding v2
- **Hardware Acceleration**: Enabled

### iOS
- **Info.plist**: Camera and location usage descriptions
- **Bundle Name**: RoadSense

### Web
- **index.html**: PWA-ready with manifest.json
- **Flutter Web**: Supported via `flutter_bootstrap.js`

---

## 12. Development Tools

| Tool | Purpose |
|------|---------|
| **Flutter DevTools** | Performance profiling & debugging |
| **flutter_lints** | Static analysis & code quality (v5.0.0) |
| **flutter_test** | Widget and unit testing framework |
| **analysis_options.yaml** | Custom lint rules |
| **Git** | Version control |

---

## 🎯 Key Technical Highlights

1. **Zero Backend Dependency**: Entire app runs locally — no Firebase, no server — ideal for hackathon demos
2. **AI-First Approach**: Gemini 1.5 Flash for real-time image analysis with structured JSON output
3. **Smart Fallbacks**: Every AI call has a deterministic simulation fallback — the app never breaks
4. **Role-Based Architecture**: Single codebase, 4 distinct user experiences (Citizen, Engineer, Admin, Decision Maker)
5. **Predictive Analytics**: AI-generated maintenance predictions based on historical report patterns
6. **Real Geographic Data**: 20 actual Bengaluru locations with realistic infrastructure scenarios
7. **Modern UI/UX**: Dark/light themes, Material 3, shader gradients, staggered animations
8. **Cross-Platform**: Runs on Android, iOS, and Web from a single codebase

---

*Built for SDG 9 — Industry, Innovation and Infrastructure*
