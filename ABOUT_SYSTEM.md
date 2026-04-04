# Rent Bill Maker - Complete System Reference

## Project Overview

Flutter (Material 3) rental management app for Nepali landlords. Tracks properties, tenants, and generates rent bills. Supports both **Gregorian (AD)** and **Bikram Sambat (BS, Nepali)** calendars throughout the UI. Local-language (Nepali/Nepali Romanized) and English toggle. All data persisted in local Hive CE storage. No backend.

**Version**: 1.0.0+1 | **Min Dart SDK**: ^3.11.4

---

## Dependencies (pubspec.yaml)

### Runtime
| Package | Purpose |
|---------|---------|
| `flutter_bloc ^9.1.1` + `nested ^1.0.0` | State management with BLoC/Cubit pattern |
| `hive_ce_flutter ^2.3.4` | Local key-value database |
| `freezed_annotation ^3.1.0` + `equatable ^2.0.8` | Immutable value classes with codegen |
| `reactive_forms ^18.2.2` | Reactive form validation in create_bill_screen and add_edit_tenant_screen |
| `nepali_date_picker ^7.0.1` + `nepali_utils ^3.0.8` | BS/AD date conversion and Nepali date picker UI |
| `go_router ^17.1.0` | Declarative routing |
| `google_fonts ^8.0.2` | Poppins font everywhere |
| `pdf ^3.12.0` + `printing ^5.14.3` | PDF generation and share/print |
| `share_plus ^12.0.2` | Share bill PDFs/images |
| `image_picker ^1.2.1` | Pick tenant citizenship photo |
| `qr_flutter ^4.1.0` | QR code on bills |
| `screenshot ^3.0.0` | Capture widget screenshots for bill preview |
| `table_calendar ^3.2.0` | Calendar UI |
| `flutter_local_notifications ^21.0.0` + `timezone ^0.11.0` + `workmanager ^0.9.0+3` | Scheduled notifications |
| `intl ^0.20.2` | Date formatting |
| `uuid ^4.5.3` | Generate unique IDs |
| `cached_network_image ^3.4.1` | Cached network images |
| `shimmer ^3.0.0` | Loading skeleton animations |
| `flutter_svg ^2.2.4` | SVG asset rendering |
| `path_provider ^2.1.5` | File system paths |
| `permission_handler ^12.0.1` | Runtime permissions |
| `url_launcher ^6.3.2` | Open external URLs |

### Dev
`freezed ^3.2.5`, `json_serializable ^6.13.1`, `hive_ce_generator ^1.11.1`, `build_runner ^2.13.1`, `flutter_lints ^6.0.0`

---

## Directory Structure (every file)

```
lib/
  main.dart                          # App entry, Hive init, BLoC providers, L10n setup
  hive_registrar.g.dart              # Generated Hive type adapters (see Hive section below)

  models/
    bill/bill_model.dart             # Bill entity + PaymentStatus + DateSystem enums
    bill/bill_model.freezed.dart     # Generated (do not edit) - copyWith, toString, etc.
    bill/bill_model.g.dart           # Generated JSON serialization
    property/property_model.dart     # Property entity
    property/property_model.freezed.dart
    property/property_model.g.dart
    tenant/tenant_model.dart         # Tenant entity
    tenant/tenant_model.freezed.dart
    tenant/tenant_model.g.dart

  repositories/                      # DATA ACCESS LAYER - only layer that talks to Hive
    property_repository.dart         # Properties CRUD via Hive box
    tenant_repository.dart           # Tenants CRUD + getByPropertyId + getActiveOnly
    bill_repository.dart             # Bills CRUD + queries (overdue, pending, byTenant, byProperty)
    settings_repository.dart         # Hive settings box - language, dateSystem, onboarding flag

  bloc/                              # BUSINESS LOGIC LAYER - uses repositories, never Hive
    bill/bill_bloc.dart              # BillBloc - CRUD, mark paid/unpaid, overdue/pending queries
    bill/bill_event.dart             # 11 event types
    bill/bill_state.dart             # BillInitial, BillLoading, BillLoaded, BillError
    language/language_cubit.dart     # LanguageCubit - toggle EN/NE, uses SettingsRepository
    property/property_bloc.dart      # PropertyBloc - CRUD
    property/property_event.dart     # 5 event types
    property/property_state.dart     # PropertyInitial, PropertyLoading, PropertyLoaded, PropertyError
    reports/reports_cubit.dart       # ReportsCubit - delegates to ReportService
    reports/reports_state.dart       # ReportsInitial, ReportsLoading, ReportsLoaded, ReportsError
    settings/settings_cubit.dart     # SettingsCubit - AD/BS date system, uses SettingsRepository
    tenant/tenant_bloc.dart          # TenantBloc - CRUD, GetTenantsByProperty
    tenant/tenant_event.dart         # 6 event types
    tenant/tenant_state.dart         # TenantInitial, TenantLoading, TenantLoaded, TenantError

  screens/                           # UI LAYER - only talks to BLoCs/Cubits, no direct Hive/Repo
    onboarding_screen.dart           # 4-step wizard: Language -> Calendar -> Property -> Tenant
    home_screen.dart                 # Main shell with BottomNavigationBar (Dashboard, Bills, Reports, Settings)
    create_bill_screen.dart          # Complex reactive form for bill generation
    history_screen.dart              # All bills grouped by year+month, with status/year filters
    tenant_list_screen.dart          # List/search tenants, FAB to add
    add_edit_tenant_screen.dart      # Reactive form for tenant CRUD
    property_list_screen.dart        # List/search properties, FAB to add
    add_edit_property_screen.dart    # Form for property CRUD
    settings_screen.dart             # Language/Calendar toggles, nav to tenant/property lists
    reports_screen.dart              # Monthly + yearly analytics via ReportsCubit

  widgets/
    stat_card.dart                   # Dashboard metric card with icon + gradient background
    bill_card.dart                   # Primary bill display in lists, swipe actions, receipt overlay
    bill_receipt_widget.dart         # Receipt template (receives property/tenant as constructor params)
    bill_preview_overlay.dart        # Full-screen preview (resolves property/tenant from BLoC states)

  services/
    report_service.dart              # Financial analytics: monthly/yearly collection stats
    notification_service.dart        # Flutter local notifications (initialized at startup)

  utils/
    l10n.dart                        # Manual localization system (EN/NE), month names, L10n.get(key)
    theme.dart                       # AppTheme class with full ThemeData
    constants.dart                   # Hive box names, currency symbol (रू), app name
```

### Assets
```
assets/images/                       # Onboarding illustration images
assets/icons/                        # SVG icons for dashboard stat cards
```

---

## Data Models (complete field reference)

### PropertyModel (typeId: 0)
Auto-generated with Freezed + Hive serialization.

| Field | Type | Notes |
|-------|------|-------|
| `id` | `String` | UUID v4 |
| `name` | `String` | Property name |
| `address` | `String` | Full address |
| `unitNumber` | `String` | Room/flat/shop identifier |
| `monthlyRent` | `double` | Base rent amount |
| `securityDeposit` | `double` | Default 0 |
| `ownerName` | `String` | Owner's full name |
| `ownerPhone` | `String` | Owner's phone number |
| `createdAt` | `DateTime` | |
| `updatedAt` | `DateTime` | |
| `isActive` | `bool` | |

- `PropertyModel.create()` factory: auto-generates id, timestamps, isActive=true.

### TenantModel (typeId: 1)

| Field | Type | Notes |
|-------|------|-------|
| `id` | `String` | UUID v4 |
| `name` | `String` | Tenant full name |
| `phone` | `String` | |
| `propertyId` | `String` | Foreign key to PropertyModel.id |
| `moveInDate` | `DateTime` | |
| `leaseEndDate` | `DateTime?` | |
| `citizenshipNumber` | `String` | Nepal citizenship/doc number |
| `citizenshipImagePath` | `String?` | Picked image stored locally |
| `createdAt` | `DateTime` | |
| `updatedAt` | `DateTime` | |
| `isActive` | `bool` | |
| `electricityRate` | `double` | Default 0, per-unit rate |
| `waterRate` | `double` | Default 0, per-unit rate |
| `initialElectricityReading` | `double` | Default 0 |
| `initialWaterReading` | `double` | Default 0 |
| `leftDate` | `DateTime?` | When tenant moved out |
| `monthlyRent` | `double` | Default 0 |

- `TenantModel.create()` factory: auto-generates id, timestamps, isActive=true.

### BillModel (typeId: 2)

| Field | Type | Notes |
|-------|------|-------|
| `id` | `String` | UUID v4 |
| `billNumber` | `String` | Auto: `BILL-{year}-{month}-{timestamp}` |
| `tenantId` | `String` | FK to TenantModel.id |
| `propertyId` | `String` | FK to PropertyModel.id |
| `month` | `int` | Billing month (1-12) |
| `year` | `int` | Billing year (stored in AD) |
| `rentAmount` | `double` | Base rent |
| `electricityCharges` | `double` | |
| `waterCharges` | `double` | |
| `internetCharges` | `double` | |
| `otherCharges` | `double` | |
| `otherChargesDescription` | `String` | |
| `discount` | `double` | |
| `totalAmount` | `double` | Computed: rent + charges + extras - discount - deductions |
| `paidAmount` | `double` | 0 on creation |
| `dueDate` | `DateTime` | |
| `status` | `PaymentStatus` | |
| `paidDate` | `DateTime?` | Nullable |
| `paymentMode` | `String?` | |
| `notes` | `String?` | |
| `pdfPath` | `String?` | Local path to generated PDF |
| `createdAt` | `DateTime` | |
| `updatedAt` | `DateTime` | |
| `dynamicCharges` | `Map<String, double>` | Default empty - arbitrary custom charges |
| `dynamicDeductions` | `Map<String, double>` | Default empty - arbitrary custom deductions |
| `electricityUnits` | `double?` | |
| `waterUnits` | `double?` | |
| `previousElectricityReading` | `double?` | |
| `currentElectricityReading` | `double?` | |
| `previousWaterReading` | `double?` | |
| `currentWaterReading` | `double?` | |

- **Getters**: `outstandingAmount` = totalAmount - paidAmount; `isFullyPaid` = paidAmount >= totalAmount; `isOverdue` = dueDate past && not paid.
- `BillModel.create()` auto-generates id, billNumber, sets status=pending, paidAmount=0.

### PaymentStatus (typeId: 4)
- `pending`, `paid`, `overdue`, `partiallyPaid`

### DateSystem (typeId: 5)
- `ad` (Gregorian), `bs` (Bikram Sambat)

---

## BLoC/Cubit Reference (all events + states)

### LanguageCubit (state: `AppLanguage` enum: `ne` or `en`)
- **ctor**: Loads saved language from Hive (`app_language` key, default `ne`).
- **methods**: `toggleLanguage()`, `setLanguage(AppLanguage)`.

### SettingsCubit (state: `DateSystem` enum: `ad` or `bs`)
- **ctor**: Loads saved system from Hive (`preferred_date_system` key, default `ad`).
- **methods**: `setDateSystem(DateSystem)`, `toggleDateSystem()`.

### PropertyBloc (states: PropertyInitial, PropertyLoading, PropertyLoaded[properties], PropertyError[message])
| Event | Payload | What it does |
|-------|---------|-------------|
| `LoadProperties` | none | Emits all properties from Hive box |
| `AddProperty` | `PropertyModel` | Puts into Hive, re-emits loading |
| `UpdateProperty` | `PropertyModel` | Puts into Hive, re-emits loading |
| `DeleteProperty` | `id` (String) | Deletes by ID, re-emits loading |
| `GetPropertyById` | `id` (String) | Single property result or error |

### TenantBloc (states: TenantInitial, TenantLoading, TenantLoaded[tenants], TenantError[message])
| Event | Payload | What it does |
|-------|---------|-------------|
| `LoadTenants` | none | Emits all tenants |
| `AddTenant` | `TenantModel` | Put into Hive |
| `UpdateTenant` | `TenantModel` | Put into Hive |
| `DeleteTenant` | `id` (String) | Delete from Hive |
| `GetTenantById` | `id` (String) | Single tenant or error |
| `GetTenantsByProperty` | `propertyId` (String) | Filter by property |

### BillBloc (states: BillInitial, BillLoading, BillLoaded[bills], BillError[message])

All list operations sort by createdAt descending (most recent first).

| Event | Payload | What it does |
|-------|---------|-------------|
| `LoadBills` | none | All bills, sorted by createdAt desc |
| `AddBill` | `BillModel` | Put into Hive |
| `UpdateBill` | `BillModel` | Put into Hive |
| `DeleteBill` | `id` (String) | Delete from Hive |
| `GetBillById` | `id` (String) | Single bill or error |
| `GetBillsByTenant` | `tenantId` (String) | Filter by tenantId |
| `GetBillsByProperty` | `propertyId` (String) | Filter by propertyId |
| `GetBillsByDateRange` | `startDate`, `endDate` | Filter by createdAt range |
| `MarkBillAsPaid` | `billId`, `paymentMode?` | Sets status=paid, paidAmount=totalAmount, paidDate=now |
| `MarkBillAsUnpaid` | `billId` | Sets status=pending, paidAmount=0, clears paidDate/paymentMode |
| `GetOverdueBills` | none | Filters isOverdue && not paid, sorted by dueDate desc |
| `GetPendingBills` | none | Filters pending or partiallyPaid, sorted by dueDate desc |

---

## Screens (complete description)

### `main.dart`
- Initializes Flutter binding, Hive CE, registers 5 type adapters, opens 4 boxes.
- MultiBlocProvider: LanguageCubit + SettingsCubit at top, then nested LanguageCubit builder.
- Inner provider: PropertyBloc (auto LoadProperties), TenantBloc (auto LoadTenants), BillBloc (auto LoadBills).
- MaterialApp receives L10n provider for translations and locale (ne/en).
- Route decision: OnboardingScreen (if `onboarding_completed` not in Hive settings) -> HomeScreen.

### `onboarding_screen.dart`
- 4-page StepPageView: Language selection -> Calendar system -> Add Property -> Add Tenant.
- Language + Calendar steps are **not skippable**. Property + Tenant steps are skippable (can be done later).
- Contains shared widgets: `_IllustrationBubble` (animated colored circle), `_LanguageTile`, `_OnboardingField` (FormGroup-based form field with validation), `_PrimaryButton`, `_GhostButton`, `_StepIndicator`.
- On completion: sets `onboarding_completed=true` in Hive settings box, navigates to HomeScreen with fade transition.

### `home_screen.dart`
- StatefulWidget with BottomNavigationBar: Home (index 0), History (2), Reports (1), Settings (3). *(Note: non-sequential indices)*
- **DashboardScreen** (index 0): Pull-to-refresh triggers LoadProperties, LoadTenants, LoadBills. Shows 4 stat tiles: properties count, tenants count, pending amount, overdue amount. Shows 5 recent bills via `BillCard`. FAB to create bill (navigates to CreateBillScreen). Floating `BillCard` shows bill count summary.
- Uses `BillCard` in the recent bills section.

### `create_bill_screen.dart` (~1200 lines)
- Complex reactive form using `reactive_forms`.
- Top section: Property dropdown, Tenant dropdown (filtered by property), month/year/date system selection.
- BS date support: if user has BS selected, month/year pickers use Nepali month names and BS year range.
- Rent auto-fills from tenant's `monthlyRent`.
- Utility section: Shows Electric and Water charge inputs with unit count tracking (previous/current readings) and rate calculation.
- Advanced section: Internet charges, Other charges + description, Discount, Dynamic charges map (add custom charges), Dynamic deductions map (add custom deductions).
- Total amount auto-calculates: rent + all charges - discount - all deductions.
- Submit: creates `BillModel.create()`, dispatches `AddBill` event, shows success snackbar, pops route.
- Uses `_DatePickerField` widget for date input (swaps between AD/BS calendar picker).

### `history_screen.dart`
- Groups all bills by Year -> Month, shows grouped `SliverList`.
- Filter chips: year selector, status filter (All, Paid, Pending, Overdue, Partially Paid).
- Pull-to-refresh. Empty state with illustration and "create first bill" button.

### `tenant_list_screen.dart`
- Search bar filters by name. Pull-to-refresh. List shows tenant name, phone, property name, citizenship number.
- Swipe actions: edit (leads to AddEditTenantScreen), delete (with confirmation).
- FAB navigates to AddEditTenantScreen.

### `add_edit_tenant_screen.dart`
- Reactive form with validation. Fields: name, phone, citizenship number, property dropdown, move-in date, lease end date, electricity rate, water rate, initial electricity reading, initial water reading, monthly rent, citizenship image picker, isActive toggle.
- When editing, populates form with existing tenant data.
- Uses `ReactiveTextField`, `ReactiveDropdownField`, `ReactiveDatepickerField`, `ReactiveSwitch` from reactive_forms.

### `property_list_screen.dart`
- Search bar filters by name. Pull-to-refresh (replaces initial load). Cards show property name, address, unit number, monthly rent, owner name/phone.
- Swipe actions: edit (leads to AddEditPropertyScreen), delete.
- FAB navigates to AddEditPropertyScreen.

### `add_edit_property_screen.dart`
- Reactive form. Fields: name, address, unit number, owner name, owner phone, monthly rent, security deposit, isActive toggle.
- When editing, populates existing data.

### `settings_screen.dart`
- Sections:
  1. **App Settings**: Language toggle (RadioGroup: Nepali/English via LanguageCubit), Calendar toggle (RadioGroup: BS/AD via SettingsCubit).
  2. **Data Management**: Navigate to TenantListScreen and PropertyListScreen.
  3. **About**: Shows app name.
- Uses `RadioGroup<T>` with `RadioListTile<T>` for selection (Flutter 3.32+ API).

### `reports_screen.dart`
- Monthly report: Month dropdown, year dropdown. Shows total rent, bills count, collection amount, collection rate, pending amount, overdue amount. Uses report service.
- Yearly report: Year dropdown. Shows total yearly collection, total bills, monthly breakdown list.
- Empty state if no data exists for selected period.

---

## Services

### `report_service.dart` (ReportService)
No constructor params. Uses Hive boxes directly via `Hive.box<T>()`.

**`getMonthlyReport(month, year, dateSystem)`** -> `Map<String, dynamic>` with keys:
- `totalRentCollected` (double)
- `totalPendingAmount` (double)
- `totalOverdueAmount` (double)
- `totalBills` (int)
- `paidBills` (int)
- `collectionRate` (double, 0-100)
- `totalBilledAmount` (double)
- `monthlyCollection` (Map<int, double>)
- `monthlyStats` (List<Map>) - per-bill stats

For BS month: converts to AD year first using `midDate.toDateTime()`, then filters by `createdAt` month/year.

**`getYearlyReport(year, dateSystem)`** -> `Map<String, dynamic>` with keys:
- `totalYearlyCollection` (double)
- `totalBills` (int)
- `monthlyCollection` (Map<int, double>) - per-month collected amounts
- `monthlyBills` (Map<int, int>) - per-month bill count
- `totalPendingAmount` (double)
- `totalOverdueAmount` (double)

For BS year: uses `NepaliDateTime(year).toDateTime()` to calculate year boundaries.

### `notification_service.dart` (NotificationService)
Static class. `initialize()` sets up `flutter_local_notifications` with Android + iOS/macOS initialization settings. Uses `timezone` package. Currently only initialization, no scheduling calls.

---

## Widgets

### `StatCard({title, value, icon, color})`
Material Card with gradient overlay (10% to 5% alpha of color), centered icon (32px), value (titleLarge bold), title (bodySmall).

### `BillCard(BillModel bill)`
Full bill information card with:
- Bill number chip + status badge (`Paid`/`Pending`/`Overdue`/`Partially Paid`).
- Tenant name (fetched via tenantBox lookup), property name, billing period (localized month + year, formatted per date system).
- Rent + charges + deductions breakdown.
- Total amount in primary color.
- Outstanding amount in red if not fully paid.
- Payment date if paid.
- Swipe actions: mark paid/unpaid (confirms with dialog), share PDF, delete.
- Receipt button: opens `BillPreviewOverlay`.
- Share button: creates PDF and shares via `share_plus`.

### `BillReceiptWidget(BillModel bill, {showBorder: false})`
Complete receipt template for rendering. Shows:
- App name, bill number, date.
- Tenant + property details.
- Billing period.
- Charges table (rent, electricity, water, internet, other, discount, dynamic charges).
- Total amount.
- Status indicator.
- Currency symbol (रू) throughout.

### `BillPreviewOverlay(BillModel bill)`
Full-screen overlay with `Scaffold` showing the receipt inside a scrollable view. Has a close button. Uses `BillReceiptWidget` internally.

---

## Localization (`lib/utils/l10n.dart`)

**Type**: `L10n` class, not using Flutter's intl/arb. Manual string map approach.

**Usage**: `L10n.of(context)` or pass `L10n(language)` directly.

**Data**:
- `_localizedValues` typed as `Map<AppLanguage, Map<String, Object>>`
- Keys are simple string tokens like `'app_name'`, `'create_bill'`, `'select_tenant'` etc.
- Values include strings, booleans, and nested `Map<int, String>` for month names.

**Month name maps** (key -> nested map with int keys 1-12):
| Key | Language | Calendar |
|-----|----------|----------|
| `'months'` | Nepali | BS month names (बैशाख through चैत्र) |
| `'months_ad'` | Nepali | AD month names (जनवरी through डिसेम्बर) |
| `'months'` | English | AD month names (January through December) |
| `'months_bs'` | English | BS month names (Baisakh through Chaitra) |

**`getMonthName(int month, {bool isBS: false})`**: Returns correct month name based on language + calendar combo.

**`String get(String key)`**: Returns value from map for current language, or the key itself if missing.

**`AppLocalizationsDelegate`**: `LocalizationsDelegate<L10n>` - always supported, auto-reload, provides `L10n` via `of(context)`.

---

## Theme (`lib/utils/theme.dart`)

**AppTheme.lightTheme** - Material 3, Google Fonts Poppins throughout.

**Colors**:
| Constant | Value | Usage |
|----------|-------|-------|
| `primary` | `#2563EB` Royal Blue | Primary buttons, accents, nav selection |
| `primaryLight` | `#60A5FA` | Lighter variant |
| `primaryLighter` | `#EFF6FF` | Nav indicator background |
| `accent` | `#10B981` Emerald | Success states |
| `danger` | `#EF4444` | Error, overdue |
| `warning` | `#F59E0B` | Warning states |
| `success` | `#22C55E` | Paid badge |
| `textPrimary` | `#0F172A` | Main text |
| `textSecondary` | `#334155` | Secondary text |
| `textMuted` | `#64748B` | Muted/caption text |
| `divider` | `#E2E8F0` | Borders |
| `surface` | `#F8FAFC` | Card backgrounds |
| `background` | `#F1F5F9` | Form fill backgrounds |
| `cardBg` | `Colors.white` | Card backgrounds |
| `shadow` | `0x0A0F172A` | Subtle shadows |

**Typography**: Google Fonts Poppins. headlineLarge(32/w700), headlineMedium(24/w700), titleLarge(18/w600), titleMedium(15/w600), bodyLarge(15), bodyMedium(13), bodySmall(11/w500), labelLarge(14/w600/white).

**UI specifics**: Cards rounded(16) with 0.5 divider border, inputs rounded(12) with filled background, buttons full-width 50px tall rounded(12), FAB rounded(16).

---

## Constants (`lib/utils/constants.dart`)

```dart
Constants.propertiesBox = 'properties'   // Hive box
Constants.tenantsBox = 'tenants'          // Hive box
Constants.billsBox = 'bills'              // Hive box
Constants.settingsBox = 'settings'        // Hive box (dynamic, not typed)
Constants.currency = 'रू'                  // Nepali Rupee symbol
Constants.appName = 'घर भाडा बिल'         // Nepali app name
```

---

## Hive Storage

### Type Adapter Registration (main.dart)
```
PropertyModel -> typeId 0
TenantModel   -> typeId 1
BillModel     -> typeId 2  (but codegen uses typeId 2)
PaymentStatus -> typeId 4
DateSystem    -> typeId 5
```

### Boxes
| Box Name | Type | Contains |
|----------|------|----------|
| `properties` | `PropertyModel` | All properties |
| `tenants` | `TenantModel` | All tenants |
| `bills` | `BillModel` | All bills |
| `settings` | `dynamic` | app_language ('ne'/'en'), preferred_date_system ('ad'/'bs'), onboarding_completed (bool) |

### Generated File: `lib/hive_registrar.g.dart`
Contains `PropertyModelAdapter`, `TenantModelAdapter`, `BillModelAdapter`, `PaymentStatusAdapter`, `DateSystemAdapter`. Auto-generated by `hive_ce_generator`.

---

## Calendar Standardization (AD-Standard Storage)

1. **Save in AD**: All dates (billing months/years, due dates) stored as Gregorian AD in Hive for portability and consistent sorting.
2. **Display conversion**: When SettingsCubit state is BS, UI converts stored AD values to Nepali dates on-the-fly using `nepali_utils` (e.g., `date.toNepaliDateTime()`).
3. **Forms**: Create bill form switches between AD date picker and BS date picker based on current settings. The underlying stored values remain AD.
4. **History/Reports**: Group and filter bills by user's current date system. For BS, converts the stored AD months to BS equivalents for display grouping.

---

## Key Architectural Decisions

### Architecture: Strict 4-Layer Separation

```
Hive <-> Repository <-> BLoC/Cubit <-> UI (Screens + Widgets)
```

- **Repository layer** (`lib/repositories/`): Only layer that directly accesses Hive boxes
- **BLoC/Cubit layer** (`lib/bloc/`): Calls repository methods, emits state - never imports `hive_ce_flutter`
- **UI layer** (`lib/screens/`, `lib/widgets/`): Dispatches events to BLoCs, reads BLoC state via `BlocBuilder/BlocListener`. No imports of `hive_ce_flutter`, no direct repository construction
- **Services** (`lib/services/`): Called by Cubits (e.g., `ReportsCubit` -> `ReportService`), not directly from UI

### App Initialization & Routing
- No go_router - direct widget decision in `main.dart` based on `SettingsRepository`.
- Onboarding is a one-time screen that calls `SettingsCubit.setOnboardingComplete()`.
- Language/Calendar can be changed later in Settings. Property/Tenant can be added later via Settings -> Data Management.

### Form Pattern
- Uses `reactive_forms` (FormGroup, FormControl, validators) in create_bill_screen and add_edit_tenant_screen.
- Forms validate in real-time, disable submit button until valid.
- Dynamic charges/deductions: users add arbitrary named charges via a Map<String, double>.

### State Pattern
- BLoC for data entities (Property, Tenant, Bill) - always emit full list on change.
- Cubit for simple preferences (Language, Settings, Reports) - emit single value or loaded state.
- All BLoCs/Cubits are instantiated once in main.dart with `MultiBlocProvider`, no route-level providers.
- Repositories are created in main.dart and injected into BLoC constructors.

### Repository Pattern

Each repository wraps a single Hive box and provides a clean async API:

| Repository | Box | Key Methods |
|------------|-----|------------|
| `PropertyRepository` | `PropertyModel` | getAll, getById, add, update, delete |
| `TenantRepository` | `TenantModel` | getAll, getById, getByPropertyId, getActiveOnly, add, update, delete |
| `BillRepository` | `BillModel` | getAll, getById, getByTenant, getByProperty, getOverdue, getPending, add, update, delete, markAsPaid, markAsUnpaid, updatePdfPath |
| `SettingsRepository` | `dynamic` | getLanguage/setLanguage, getDateSystem/setDateSystem, isOnboardingComplete/setOnboardingComplete |

### Receipt/PDF
- `BillReceiptWidget` renders a visual receipt. Receives `property` and `tenant` as required constructor params (no direct data access).
- `BillCard` triggers `UpdateBill` event to BillBloc to save pdfPath after share.
- `BillPreviewOverlay` uses `BlocBuilder<PropertyBloc>` + `BlocBuilder<TenantBloc>` to resolve property/tenant from state, then passes to `BillReceiptWidget`.

---

## How to Find Anything Quickly

| Want to... | File to check |
|------------|--------------|
| Add a new BLoC event | `lib/bloc/<domain>/<domain>_event.dart` + handler in `*_bloc.dart` |
| Change UI color | `lib/utils/theme.dart` -> `AppTheme` class |
| Add translations | `lib/utils/l10n.dart` -> Add to both `AppLanguage.ne` and `AppLanguage.en` maps |
| Add a model field | Update `*_model.dart` with `@HiveField(N)`, re-run codegen |
| After model changes | Run `dart run build_runner build --delete-conflicting-outputs` |
| Change Hive box structure | `lib/utils/constants.dart` for box names, `main.dart` for registration |
| Add a new screen | `lib/screens/`, then wire nav from existing screen |
| Financial calculations | `lib/services/report_service.dart` |
| Bill sharing/PDF | `lib/widgets/bill_card.dart` (share action) |
| Onboarding flow | `lib/screens/onboarding_screen.dart` |
| Bottom nav structure | `lib/screens/home_screen.dart` |
