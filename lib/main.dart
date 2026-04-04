import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:nested/nested.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/language/language_cubit.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/reports/reports_cubit.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/repositories/bill_repository.dart';
import 'package:rent_bill_maker/repositories/property_repository.dart';
import 'package:rent_bill_maker/repositories/settings_repository.dart';
import 'package:rent_bill_maker/repositories/tenant_repository.dart';
import 'package:rent_bill_maker/screens/home_screen.dart';
import 'package:rent_bill_maker/screens/onboarding_screen.dart';
import 'package:rent_bill_maker/services/notification_service.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PropertyModelAdapter());
  Hive.registerAdapter(TenantModelAdapter());
  Hive.registerAdapter(BillModelAdapter());
  Hive.registerAdapter(PaymentStatusAdapter());
  Hive.registerAdapter(DateSystemAdapter());

  await Hive.openBox<PropertyModel>(Constants.propertiesBox);
  await Hive.openBox<TenantModel>(Constants.tenantsBox);
  await Hive.openBox<BillModel>(Constants.billsBox);
  await Hive.openBox<dynamic>(Constants.settingsBox);

  await NotificationService.initialize();

  runApp(const RentBillMakerApp());
}

class RentBillMakerApp extends StatelessWidget {
  const RentBillMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsRepository settingsRepo = SettingsRepository();
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(settingsRepository: settingsRepo),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(settingsRepository: settingsRepo),
        ),
      ],
      child: BlocBuilder<LanguageCubit, AppLanguage>(
        builder: (BuildContext context, AppLanguage language) {
          final L10n l10n = L10n(language);
          return MultiBlocProvider(
            providers: <SingleChildWidget>[
              BlocProvider<PropertyBloc>(
                create: (_) =>
                    PropertyBloc(propertyRepository: PropertyRepository())
                      ..add(LoadProperties()),
              ),
              BlocProvider<TenantBloc>(
                create: (_) =>
                    TenantBloc(tenantRepository: TenantRepository())
                      ..add(LoadTenants()),
              ),
              BlocProvider<BillBloc>(
                create: (_) =>
                    BillBloc(billRepository: BillRepository())
                      ..add(LoadBills()),
              ),
              BlocProvider<ReportsCubit>(
                create: (_) =>
                    ReportsCubit(billRepository: BillRepository()),
              ),
            ],
            child: MaterialApp(
              title: l10n.get('app_name'),
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              locale: language == AppLanguage.ne
                  ? const Locale('ne', 'NP')
                  : const Locale('en', 'US'),
              localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                AppLocalizationsDelegate(language),
              ],
              home: _getHome(settingsRepo),
            ),
          );
        },
      ),
    );
  }

  Widget _getHome(SettingsRepository settingsRepo) {
    final bool onboardingCompleted = settingsRepo.isOnboardingComplete();
    if (!onboardingCompleted) {
      return const OnboardingScreen();
    }
    return const HomeScreen();
  }
}
