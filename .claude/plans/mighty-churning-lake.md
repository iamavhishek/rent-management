# Plan: Introduce Repository Layer (Hive -> Repo -> BLoC -> UI)

## Context

Currently: Screens, widgets, services, and BLoCs all talk directly to `Hive.box<T>()`.
Goal: Strict 3-layer separation where **UI only talks to BLoCs, BLoCs only talk to Repositories, Repositories only talk to Hive.**

```
UI (screens/widgets)  <--->  BLoC/Cubit  <--->  Repository  <--->  Hive
```

## New Files to Create

### 1. `lib/repositories/property_repository.dart`
Methods: `getAll()`, `getById(id)`, `add(model)`, `update(model)`, `delete(id)`

### 2. `lib/repositories/tenant_repository.dart`
Methods: `getAll()`, `getById(id)`, `getByPropertyId(propertyId)`, `getActiveOnly()`, `add(model)`, `update(model)`, `delete(id)`

### 3. `lib/repositories/bill_repository.dart`
Methods: `getAll()`, `getById(id)`, `getByTenant(tenantId)`, `getByProperty(propertyId)`, `getOverdue()`, `getPending()`, `add(model)`, `update(model)`, `delete(id)`, `markAsPaid(id, paymentMode?)`, `markAsUnpaid(id)`, `updatePdfPath(id, path)`, `getByDateRange(start, end)`, `getLatestByTenant(tenantId)`

### 4. `lib/repositories/settings_repository.dart`
Covers all settings Hive access: `isOnboardingComplete`, `setOnboardingComplete()`, `getLanguage()`, `setLanguage(lang)`, `getDateSystem()`, `setDateSystem(system)`

## Files to Modify

### Phase 1: BLoCs (BLoC -> Repo layer)

Inject repositories into BLoC constructors. Replace `late Box<T>` fields with repository method calls.

| File | Current Hive access | Replace with |
|------|-------------------|--------------|
| `lib/bloc/property/property_bloc.dart` | `propertyBox = Hive.box<PropertyModel>(...)` | `PropertyRepository _repo` injected via ctor |
| `lib/bloc/tenant/tenant_bloc.dart` | `tenantBox = Hive.box<TenantModel>(...)` | `TenantRepository _repo` injected via ctor |
| `lib/bloc/bill/bill_bloc.dart` | `billBox = Hive.box<BillModel>(...)` | `BillRepository _repo` injected via ctor |
| `lib/bloc/settings/settings_cubit.dart` | `Hive.box<dynamic>(Constants.settingsBox)` | `SettingsRepository _repo` injected via ctor |
| `lib/bloc/language/language_cubit.dart` | `Hive.box<dynamic>(Constants.settingsBox)` | `SettingsRepository _repo` injected via ctor |

### Phase 2: ReportService (service -> Repo layer)

`lib/services/report_service.dart` accepts `BillRepository` in its constructor. Replaces the 3 direct Hive box fields.

### Phase 3: main.dart (wiring)

Create repositories at startup, pass them to BLoCs:
```dart
final settingsRepo = SettingsRepository();
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => LanguageCubit(settingsRepo)),
    BlocProvider(create: (_) => SettingsCubit(settingsRepo)),
    BlocProvider(create: (_) => PropertyBloc(PropertyRepository())..add(LoadProperties())),
    BlocProvider(create: (_) => TenantBloc(TenantRepository())..add(LoadTenants())),
    BlocProvider(create: (_) => BillBloc(BillRepository())..add(LoadBills())),
  ],
  ...
)
```

### Phase 4: Screens (remove direct Hive, use BLoC events)

| File | Current issue | Fix |
|------|--------------|-----|
| `lib/screens/property_list_screen.dart` L104, L159 | `Hive.box<TenantModel>` to check occupancy | Dispatch `GetTenantsByProperty` to `TenantBloc`, read from block state |
| `lib/screens/create_bill_screen.dart` L215-217, L420-423 | `Hive.box<TenantModel>` / `Hive.box<BillModel>` | Dispatch `GetTenantsByProperty`, add event/method to BillBloc for "latest bill by tenant" (or use existing `GetBillsByTenant` + sort) |
| `lib/screens/add_edit_tenant_screen.dart` L215, L623 | Same pattern | Use BLoC events instead |
| `lib/screens/onboarding_screen.dart` L61 | `Hive.box<dynamic>` for onboarding flag | Use `SettingsRepository` (or add `setOnboardingComplete` to SettingsCubit) |

### Phase 5: Widgets (remove direct Hive, use BLoC/data pass)

| File | Current issue | Fix |
|------|--------------|-----|
| `lib/widgets/bill_card.dart` L596 | `Hive.box<BillModel>.put()` to update pdfPath | Dispatch `UpdateBill` event to BillBloc with copyWith |
| `lib/widgets/bill_receipt_widget.dart` L24-25 | `Hive.box` reads for property/tenant lookup | Pass resolved PropertyModel + TenantModel as constructor params (resolve in parent via `context.read<PropertyBloc>()` / `context.read<TenantBloc>()`) |

## Execution Order

1. Create 4 repository files
2. Update BLoCs to accept & use repositories
3. Update `main.dart` wiring
4. Update `report_service.dart`
5. Update screens to remove direct Hive (use BLoC events)
6. Update widgets to remove direct Hive
7. `dart analyze` - verify zero issues

## Verification

- `dart analyze` = 0 issues
- App launches and completes onboarding
- Dashboard loads stats and recent bills
- Create bill screen: property/tenant dropdowns work, latest bill auto-fills
- History, Reports, Settings all functional
- Bill card: mark paid/unpaid, share PDF, save pdfPath
