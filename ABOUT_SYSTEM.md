# Rent Bill Maker - System Overview & Architecture

Rent Bill Maker is a premium rental management application designed to help landlords manage properties, tenants, and generate professional rent bills with ease. It supports both **Gregorian (AD)** and **Bikram Sambat (BS)** calendar systems throughout the entire application.

## 🚀 Core Features

- **Property Management**: Track rooms, flats, and shops.
- **Tenant Tracking**: Manage active/inactive tenants and move-out dates.
- **Dynamic Billing**: Create bills with fixed rent and dynamic utility charges (Electricity/Water units).
- **Dual Calendar System**: Native support for Nepali (BS) and English (AD) dates.
- **Professional Reports**: Monthly and yearly financial analytics (Billed vs. Collected).
- **PDF Generation**: Generate and share professional rent receipts.

---

## 📁 Directory Structure & Code Responsibilities

### `lib/models/`

Defines the data structures of the system.

- **`bill/bill_model.dart`**: The core billing entity. Stores billing periods in AD (for consistency) and handles calculation logic for totals, discounts, and units.
- **`property/property_model.dart`**: Stores property details (name, address, rent).
- **`tenant/tenant_model.dart`**: Stores tenant info, move-in/out dates, and association with a property.

### `lib/bloc/`

Handles the business logic and state management using the BLoC/Cubit pattern.

- **`bill/`**: Manages the list of bills, creation, deletion, and payment status updates.
- **`property/`**: CRUD operations for property management.
- **`tenant/`**: CRUD operations for tenants.
- **`settings/settings_cubit.dart`**: Manages global user preferences, specifically the **DateSystem (AD/BS)**.
- **`language/language_cubit.dart`**: Manages the application's locale (English/Nepali).

### `lib/services/`

Contains logic that doesn't belong in a BLoC or Model.

- **`report_service.dart`**: The financial engine. It calculates monthly/yearly stats by matching stored data against the user's preferred calendar system. It distinguishes between "Billed Amount" (period-based) and "Collected Amount" (payment-date-based).

### `lib/screens/`

The UI layer of the application.

- **`home_screen.dart`**: Dashboard showing quick stats and recent bills.
- **`create_bill_screen.dart`**: Complex form for generating bills with reactive unit calculations and calendar switching.
- **`history_screen.dart`**: Grouped list of all bills, organized by billing period.
- **`reports_screen.dart`**: Interactive financial analytics with month/year filtering.
- **`onboarding_screen.dart`**: First-time user setup for language and calendar preferences.

### `lib/widgets/`

Reusable UI components.

- **`bill_card.dart`**: The primary display component for bills in lists.
- **`bill_receipt_widget.dart`**: The visual template used for generating shareable PDFs.
- **`stat_card.dart`**: Standardized cards for dashboard metrics.

### `lib/utils/`

Helper classes and constants.

- **`l10n.dart`**: The localization engine. Translates keys to English/Nepali and handles month name conversions for both AD and BS.
- **`constants.dart`**: Storage keys (Hive box names) and theme constants.

---

## 📅 Calendar Standardization Logic

A key technical aspect of this system is the **AD-Standard Storage** approach:

1. **Save in AD**: All dates (due dates, billing months, years) are stored as Gregorian (AD) in the database (Hive) to ensure data portability and consistent sorting.
2. **Convert for Display**: When a user selects "BS" in Settings, the UI converts these stored AD values to Nepali dates on the fly.
3. **Global Synchronization**: All screens (`History`, `Reports`, `Create Bill`) and components (`BillCard`) reactively sync to the global `SettingsCubit` state. Local toggles have been removed to ensure a consistent data view across the entire application.
4. **Reactive Forms**: Form fields automatically re-validate and convert between calendar systems mid-interaction when settings change.

---

## 💾 Data Persistence

The system uses **Hive CE**, a lightweight and lightning-fast key-value database.

- Data is stored in "Boxes" (one for each model).
- Type adapters (in `lib/hive_registrar.g.dart`) handle the serialization of complex objects.
