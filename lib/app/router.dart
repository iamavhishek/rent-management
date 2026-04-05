import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/repositories/settings_repository.dart';
import 'package:rent_bill_maker/screens/add_edit_property_screen.dart';
import 'package:rent_bill_maker/screens/add_edit_tenant_screen.dart';
import 'package:rent_bill_maker/screens/create_bill_screen.dart';
import 'package:rent_bill_maker/screens/home_screen.dart';
import 'package:rent_bill_maker/screens/onboarding_screen.dart';
import 'package:rent_bill_maker/screens/property_list_screen.dart';
import 'package:rent_bill_maker/screens/tenant_list_screen.dart';

enum AppRoute {
  onboarding('/onboarding'),
  tenantList('/tenants'),
  tenantAdd('/tenants/add'),
  propertyList('/properties'),
  propertyAdd('/properties/add'),
  billCreate('/bill/create'),
  ;

  const AppRoute(this.path);
  final String path;
}

final SettingsRepository _settingsRepo = SettingsRepository();

final GoRouter router = GoRouter(
  initialLocation: _settingsRepo.isOnboardingComplete()
      ? '/home'
      : '/onboarding',
  routes: <RouteBase>[
    GoRoute(
      path: AppRoute.onboarding.path,
      builder: (_, _) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (_, _, Widget child) => child,
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (_, _) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoute.tenantList.path,
          builder: (_, _) => const TenantListScreen(),
        ),
        GoRoute(
          path: AppRoute.tenantAdd.path,
          builder: (BuildContext context, GoRouterState state) {
            final TenantModel? tenant = state.extra as TenantModel?;
            return AddEditTenantScreen(tenant: tenant);
          },
        ),
        GoRoute(
          path: AppRoute.propertyList.path,
          builder: (_, _) => const PropertyListScreen(),
        ),
        GoRoute(
          path: AppRoute.propertyAdd.path,
          builder: (BuildContext context, GoRouterState state) {
            final PropertyModel? property = state.extra as PropertyModel?;
            return AddEditPropertyScreen(property: property);
          },
        ),
        GoRoute(
          path: AppRoute.billCreate.path,
          builder: (BuildContext context, GoRouterState state) {
            final BillModel? bill = state.extra as BillModel?;
            return CreateBillScreen(bill: bill);
          },
        ),
      ],
    ),
  ],
);
