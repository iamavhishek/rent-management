# Rent Bill Maker ( rent_bill_maker )

A modern, cross-platform Flutter application for property managers and landlords to create, manage, and track rent bills. Built with Flutter and BLoC architecture, it provides a seamless experience for generating professional rent bills with QR codes, tracking payment history, and managing properties and tenants.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)

---

## Table of Contents

1. [Features](#features)
2. [Screenshots](#screenshots)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Prerequisites](#prerequisites)
6. [Installation](#installation)
7. [Running the App](#running-the-app)
8. [Building for Production](#building-for-production)
9. [App Architecture](#app-architecture)
10. [State Management](#state-management)
11. [Data Models](#data-models)
12. [Services](#services)
13. [Localization](#localization)
14. [Screens Overview](#screens-overview)
15. [Key Dependencies](#key-dependencies)
16. [Configuration](#configuration)
17. [Troubleshooting](#troubleshooting)
18. [Contributing](#contributing)
19. [License](#license)

---

## Features

### Core Features

- **Property Management**
  - Add, edit, and delete properties
  - Store property details (name, address, total rooms, floor number, etc.)
  - View property list with search functionality
  - Property-specific tenant assignment

- **Tenant Management**
  - Add, edit, and delete tenants
  - Store tenant information (name, phone, email, move-in date)
  - Assign tenants to properties
  - View tenant list with search functionality
  - Track tenant payment status

- **Bill Generation**
  - Create rent bills for tenants
  - Customize bill amount, due date, and billing month
  - Support for both Nepali and English date systems
  - Add electricity usage and charges
  - Include water bill, maintenance, and other charges
  - Add custom additional charges

- **QR Code Integration**
  - Each bill includes a unique scannable QR code
  - QR code contains bill information for quick scanning
  - Professional bill layout with all details

- **PDF Export**
  - Export bills as professional PDF documents
  - Print-ready format with all bill details
  - Share via email, messaging apps, or print

- **Payment History**
  - Track payment status (paid, unpaid, partial)
  - View payment history by month
  - Filter bills by status, property, or date
  - Mark bills as paid/unpaid

- **Reports Dashboard**
  - Monthly income summary
  - Total collected vs pending amounts
  - Property-wise revenue breakdown
  - Visual statistics with charts

- **Notifications**
  - Automated reminders for due payments
  - Configurable notification schedules
  - Background task scheduling for reminders

- **Multi-language Support**
  - English (US)
  - Nepali (Nepal)
  - Easy language switching in settings

### Additional Features

- Responsive design for all screen sizes (phone, tablet, desktop)
- Offline-first approach with local database
- Data persistence using Hive database
- Dark/light theme support (Material 3)
- Onboarding flow for new users

---

## Screenshots

> Note: Add your app screenshots in the following locations:
>
> - `/assets/screenshots/home.jpg`
> - `/assets/screenshots/properties.jpg`
> - `/assets/screenshots/tenants.jpg`
> - `/assets/screenshots/bill-create.jpg`
> - `/assets/screenshots/bill-preview.jpg`
> - `/assets/screenshots/reports.jpg`

---

## Technology Stack

| Category         | Technology                               |
| ---------------- | ---------------------------------------- |
| Framework        | Flutter 3.x                              |
| Language         | Dart 3.x                                 |
| State Management | flutter_bloc                             |
| Local Database   | hive_ce (Hive Community Edition)         |
| Navigation       | go_router                                |
| PDF Generation   | pdf, printing                            |
| QR Code          | qr_flutter                               |
| Notifications    | flutter_local_notifications, workmanager |
| Architecture     | Clean Architecture + BLoC Pattern        |
| UI Framework     | Material Design 3                        |
| Fonts            | Google Fonts (Poppins)                   |

---

## Project Structure

```
rent_bill_maker/
|
|   # Main entry point and app configuration
|-- lib/
|   |-- main.dart                 # App initialization, Hive setup, BLoC providers
|   |-- hive_registrar.g.dart     # Generated Hive type adapters
|   |
|   |-- app/
|   |   |-- router.dart           # GoRouter navigation configuration
|   |
|   |-- bloc/                     # BLoC state management
|   |   |-- bill/                 # Bill state management
|   |   |-- language/             # Language/locale management
|   |   |-- property/             # Property state management
|   |   |-- reports/              # Reports/stats management
|   |   |-- settings/             # App settings management
|   |   |-- tenant/               # Tenant state management
|   |
|   |-- models/                   # Data models (with Freezed)
|   |   |-- bill/
|   |   |-- property/
|   |   |-- tenant/
|   |
|   |-- repositories/             # Data access layer
|   |   |-- bill_repository.dart
|   |   |-- property_repository.dart
|   |   |-- settings_repository.dart
|   |   |-- tenant_repository.dart
|   |
|   |-- screens/                  # UI screens
|   |   |-- add_edit_property_screen.dart
|   |   |-- add_edit_tenant_screen.dart
|   |   |-- create_bill_screen.dart
|   |   |-- history_screen.dart
|   |   |-- home_screen.dart
|   |   |-- onboarding_screen.dart
|   |   |-- property_list_screen.dart
|   |   |-- reports_screen.dart
|   |   |-- settings_screen.dart
|   |   |-- tenant_list_screen.dart
|   |
|   |-- services/                 # Business logic services
|   |   |-- notification_service.dart
|   |   |-- report_service.dart
|   |
|   |-- utils/                    # Utilities and constants
|   |   |-- constants.dart        # App constants (box names, currency, etc.)
|   |   |-- l10n.dart             # Localization utilities
|   |   |-- responsive.dart       # Responsive breakpoint utilities
|   |   |-- theme.dart            # App theme configuration
|   |
|   |-- widgets/                  # Reusable UI components
|   |   |-- bill_card.dart
|   |   |-- bill_preview_overlay.dart
|   |   |-- bill_receipt_widget.dart
|   |   |-- stat_card.dart
|
|-- assets/                       # Static assets
|   |-- images/
|   |-- icons/
|
|-- android/                     # Android platform configuration
|-- ios/                         # iOS platform configuration
|-- linux/                       # Linux platform configuration
|-- macos/                       # macOS platform configuration
|-- web/                         # Web platform configuration
|-- windows/                     # Windows platform configuration
```

---

## Prerequisites

Before you begin, ensure you have met the following requirements:

### 1. Flutter SDK

- Flutter 3.x or higher
- Dart 3.x or higher

**Installation:**

```bash
# Check Flutter version
flutter --version

# If not installed, download from https://flutter.dev/docs/get-started/install
```

### 2. IDE / Editor

- **VS Code** (Recommended)
  - Install Flutter extension
  - Install Dart extension

- **Android Studio**
  - Install Flutter plugin
  - Install Dart plugin

- **IntelliJ IDEA**
  - Install Flutter plugin
  - Install Dart plugin

### 3. Platform-Specific Requirements

#### For Android Development:

- Android SDK (API level 21+)
- Android Studio or VS Code with Android extensions

#### For iOS Development:

- macOS (required for iOS development)
- Xcode 14+
- CocoaPods (`sudo gem install cocoapods`)

#### For Web Development:

- Chrome browser (for debugging)
- Web server configuration (handled by Flutter)

#### For Desktop (Linux/macOS/Windows):

- Platform-specific build tools
- See [Flutter Desktop docs](https://flutter.dev/desktop) for details

---

## Installation

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/your-username/rent_bill_maker.git

# Navigate to project directory
cd rent_bill_maker
```

### Step 2: Install Flutter Dependencies

```bash
# Get Flutter packages
flutter pub get
```

This command will:

- Download all dependencies listed in `pubspec.yaml`
- Generate Hive adapters (if not already generated)
- Resolve version conflicts

### Step 3: Generate Hive Adapters (if needed)

```bash
# Run build_runner to generate Hive type adapters
flutter pub run build_runner build --delete-conflicting-outputs
```

> Note: This step is usually not needed as generated files are already committed.

### Step 4: Verify Setup

```bash
# Run Flutter analyze to check for issues
flutter analyze

# Run tests
flutter test
```

---

## Running the App

### Development Mode

#### Option 1: Run on Connected Device/Emulator

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run on connected device (auto-detect)
flutter run

# Run with hot reload enabled
flutter run
```

#### Option 2: Run on Web

```bash
# Run on Chrome (web)
flutter run -d chrome
```

#### Option 3: Run on Desktop

```bash
# Run on Linux
flutter run -d linux

# Run on macOS
flutter run -d macos

# Run on Windows
flutter run -d windows
```

### Running in Debug Mode

```bash
# Debug build with hot reload
flutter run

# Debug build without hot reload
flutter run --no-hot
```

### Running in Release Mode (for testing)

```bash
# Build and run release version
flutter run --release
```

---

## Building for Production

### Android

#### Debug APK

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

#### Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### App Bundle (for Play Store)

```bash
flutter build appbundle
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

#### Simulator Build

```bash
flutter build ios --simulator --no-codesign
```

#### Device Build (requires Apple Developer account)

```bash
# For development device
flutter build ios --device

# For App Store (requires certificates)
flutter build ios --release
```

### Web

```bash
# Build for web
flutter build web

# Output: build/web/
```

### Linux

```bash
# Build Linux release
flutter build linux --release
```

Output: `build/linux/x64/release/bundle/`

### macOS

```bash
# Build macOS release
flutter build macos --release
```

Output: `build/macos/Build/Products/Release/`

### Windows

```bash
# Build Windows release
flutter build windows --release
```

Output: `build/windows/x64/release/`

---

## App Architecture

This app follows **Clean Architecture** principles with **BLoC pattern** for state management.

### Layer Architecture

```
lib/
|
|-- main.dart                    # Entry point, dependency injection
|
|-- app/                         # Application configuration
|   |-- router.dart              # Navigation routes
|
|-- bloc/                        # Business logic (State Management)
|   |-- bill/                    # Bill BLoC (events, states, bloc)
|   |-- property/                # Property BLoC
|   |-- tenant/                  # Tenant BLoC
|   |-- reports/                 # Reports Cubit
|   |-- settings/                # Settings Cubit
|   |-- language/                # Language Cubit
|
|-- models/                      # Data layer - Entities
|   |-- bill/                    # Bill model with Hive adapter
|   |-- property/                # Property model with Hive adapter
|   |-- tenant/                  # Tenant model with Hive adapter
|
|-- repositories/                # Data layer - Data access
|   |-- bill_repository.dart     # Bill CRUD operations
|   |-- property_repository.dart # Property CRUD operations
|   |-- tenant_repository.dart   # Tenant CRUD operations
|   |-- settings_repository.dart # Settings persistence
|
|-- screens/                     # Presentation layer - Pages
|   |-- (individual screens)
|
|-- widgets/                     # Presentation layer - Reusable widgets
|   |-- (reusable UI components)
|
|-- services/                    # Business logic services
|   |-- notification_service.dart
|   |-- report_service.dart
|
|-- utils/                       # Shared utilities
    |-- constants.dart           # App constants
    |-- l10n.dart                # Localization
    |-- theme.dart               # Theme configuration
    |-- responsive.dart          # Responsive utilities
```

### Architecture Flow

```
User Action
    |
    v
Screen (UI) ---> BLoC (State Management)
    |                   |
    |                   v
    |            Repository (Data Access)
    |                   |
    |                   v
    |            Hive (Local Storage)
    |                   |
    v                   v
UI Update <------- State Change
```

---

## State Management

The app uses **flutter_bloc** for state management with the following pattern:

### BLoC Structure

Each feature has its own BLoC with three main components:

1. **Events** - Triggers for state changes

   ```dart
   // Example: LoadProperties event
   class LoadProperties extends PropertyEvent {}
   ```

2. **States** - Current state representation

   ```dart
   // Example: PropertyLoaded state
   class PropertyLoaded extends PropertyState {
     final List<PropertyModel> properties;
   }
   ```

3. **Bloc** - Business logic
   ```dart
   class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
     // Handles events and emits new states
   }
   ```

### BLoCs Used

| BLoC            | Purpose                       |
| --------------- | ----------------------------- |
| `PropertyBloc`  | Manage properties CRUD        |
| `TenantBloc`    | Manage tenants CRUD           |
| `BillBloc`      | Manage bills CRUD             |
| `ReportsCubit`  | Calculate and provide reports |
| `SettingsCubit` | App settings (theme, etc.)    |
| `LanguageCubit` | Language selection            |

---

## Data Models

The app uses **Freezed** for immutable data classes with **Hive** for local persistence.

### Property Model

```dart
@freezed
class PropertyModel with _$PropertyModel {
  // Fields: id, name, address, totalRooms, floorNumber, createdAt, updatedAt
}
```

### Tenant Model

```dart
@freezed
class TenantModel with _$TenantModel {
  // Fields: id, name, phone, email, propertyId, moveInDate, photoUrl, createdAt, updatedAt
}
```

### Bill Model

```dart
@freezed
class BillModel with _$BillModel {
  // Fields: id, tenantId, propertyId, month, year, dateSystem, rentAmount,
  //         electricityUnit, electricityRate, electricityAmount, waterBill,
  //         maintenanceCharge, additionalCharge, additionalNote, totalAmount,
  //         dueDate, paymentStatus, paidDate, createdAt, updatedAt
}
```

### Enums

- `PaymentStatus` - unpaid, paid, partial
- `DateSystem` - nepali, english

---

## Services

### NotificationService

Handles scheduled notifications for bill reminders:

- Initializes flutter_local_notifications
- Schedules daily/weekly reminders
- Manages notification permissions
- Uses workmanager for background tasks

### ReportService

Provides data for reports:

- Calculates total income by month
- Provides property-wise revenue
- Generates summary statistics

---

## Localization

The app supports **English** and **Nepali** languages.

### Implementation

- Uses `flutter_localizations` for i18n
- Custom `L10n` class for string retrieval
- `LanguageCubit` for state management

### Supported Locales

| Language       | Locale Code |
| -------------- | ----------- |
| English (US)   | en_US       |
| Nepali (Nepal) | ne_NP       |

### Usage

```dart
// Get localized string
final l10n = L10n(AppLanguage.ne);
String appName = l10n.get('app_name');
```

---

## Screens Overview

| Screen                | Description               | Route             |
| --------------------- | ------------------------- | ----------------- |
| **Onboarding**        | First-time user setup     | `/onboarding`     |
| **Home**              | Dashboard with stats      | `/home`           |
| **Property List**     | View all properties       | `/properties`     |
| **Add/Edit Property** | Create or modify property | `/properties/add` |
| **Tenant List**       | View all tenants          | `/tenants`        |
| **Add/Edit Tenant**   | Create or modify tenant   | `/tenants/add`    |
| **Create Bill**       | Generate new bill         | `/bill/create`    |
| **History**           | View bill history         | (part of home)    |
| **Reports**           | View income reports       | (part of home)    |
| **Settings**          | App settings              | (part of home)    |

### Navigation

The app uses **go_router** for declarative routing:

- Shell route for bottom navigation
- Nested routes for detail screens
- Type-safe route definitions with enum

---

## Key Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.1 # State management
  go_router: ^17.1.0 # Navigation
  hive_ce_flutter: ^2.3.4 # Local database (Hive CE)
```

### PDF & Printing

```yaml
pdf: ^3.12.0 # PDF generation
printing: ^5.14.3 # Print/share PDFs
```

### QR Code

```yaml
qr_flutter: ^4.1.0 # Generate QR codes
```

### Notifications

```yaml
flutter_local_notifications: ^21.0.0 # Local notifications
workmanager: ^0.9.0+3 # Background tasks
```

### UI Components

```yaml
google_fonts: ^8.0.2 # Poppins font
shimmer: ^3.0.0 # Loading effects
table_calendar: ^3.2.0 # Calendar widget
cached_network_image: ^3.4.1 # Image caching
```

### Utilities

```yaml
intl: ^0.20.2 # Date/number formatting
uuid: ^4.5.3 # Unique IDs
path_provider: ^2.1.5 # File paths
share_plus: ^12.0.2 # Share content
url_launcher: ^6.3.2 # Open URLs
```

### Code Generation

```yaml
dev_dependencies:
  build_runner: ^2.13.1
  freezed: ^3.2.5 # Immutable data classes
  hive_ce_generator: ^1.11.1 # Hive adapters
  json_serializable: ^6.13.1 # JSON serialization
```

---

## Configuration

### Hive Boxes

The app uses four Hive boxes:

| Box Name     | Type            | Purpose          |
| ------------ | --------------- | ---------------- |
| `properties` | `PropertyModel` | Store properties |
| `tenants`    | `TenantModel`   | Store tenants    |
| `bills`      | `BillModel`     | Store bills      |
| `settings`   | `dynamic`       | App settings     |

### Constants

Defined in `lib/utils/constants.dart`:

```dart
class Constants {
  static const String propertiesBox = 'properties';
  static const String tenantsBox = 'tenants';
  static const String billsBox = 'bills';
  static const String settingsBox = 'settings';
  static const String currency = 'Rs' or 'Rs' (Nepali Rupee symbol);
  static const String appName = 'Rent Bill Maker';
}
```

### Theme Configuration

The app uses Material 3 with custom theme in `lib/utils/theme.dart`:

- Primary: Royal Blue (#2563EB)
- Accent: Emerald (#10B981)
- Custom text styles using Poppins font

### Responsive Breakpoints

Defined in `lib/utils/responsive.dart`:

| Breakpoint | Width     |
| ---------- | --------- |
| mobile     | < 600px   |
| tablet     | 600-900px |
| desktop    | > 900px   |
| navRail    | > 800px   |

---

## Troubleshooting

### Common Issues

#### 1. Hive Initialization Error

**Problem:** App crashes on startup with Hive error

**Solution:**

```bash
# Delete build folder and regenerate
rm -rf build/
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2. Android SDK Not Found

**Problem:** `Android SDK not found`

**Solution:**

```bash
# Set ANDROID_HOME
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Run flutter doctor
flutter doctor
```

#### 3. iOS Build Failed

**Problem:** Missing iOS simulator or certificates

**Solution:**

```bash
# Check available simulators
xcrun simctl list devices

# Install CocoaPods dependencies
cd ios
pod install
cd ..
```

#### 4. QR Code Not Displaying

**Problem:** QR code not rendering in bills

**Solution:**

- Check `qr_flutter` version compatibility
- Ensure bill data is not empty
- Restart the app

#### 5. Notifications Not Working

**Problem:** Scheduled notifications not triggering

**Solution:**

- Check notification permissions
- Verify AndroidManifest.xml has required permissions
- For Android 13+, request POST_NOTIFICATIONS permission

### Getting Help

If you encounter issues not listed here:

1. Check Flutter documentation: https://docs.flutter.dev/
2. Check package documentation (pub.dev)
3. Open an issue on GitHub
4. Search existing issues

---

## Contributing

Contributions are welcome! Please follow these steps:

### 1. Fork the Repository

Click the "Fork" button on GitHub.

### 2. Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/rent_bill_maker.git
cd rent_bill_maker
```

### 3. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

### 4. Make Changes

- Follow the existing code style
- Write meaningful commit messages
- Add comments for complex logic

### 5. Test Your Changes

```bash
# Run analyze
flutter analyze

# Run tests
flutter test

# Build for your target platform
flutter build apk --debug  # or other platform
```

### 6. Commit Changes

```bash
git add .
git commit -m "Add: Description of your changes"
```

### 7. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 8. Create Pull Request

- Go to the original repository
- Click "New Pull Request"
- Describe your changes
- Submit

### Code Style Guidelines

- Use meaningful variable/function names
- Follow Dart/Flutter conventions
- Use const constructors where possible
- Keep functions small and focused
- Add documentation for public APIs

---

## License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2024 Rent Bill Maker

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Acknowledgments

- [Flutter](https://flutter.dev) - UI framework
- [flutter_bloc](https://bloclibrary.dev) - State management
- [Hive](https://hive.dev) - Local database
- [GoRouter](https://pub.dev/packages/go_router) - Navigation
- [Freezed](https://freezed.dev) - Code generation
- [Google Fonts](https://fonts.google.com) - Poppins font

---

## Support

If you find this project helpful:

- Give it a star (if on GitHub)
- Share it with others
- Report bugs and issues
- Contribute to the project

---

**Happy Coding!**

Made with Flutter and Nepali Rupee symbol (Rs) for property managers everywhere.
