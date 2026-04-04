import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:nested/nested.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/language/language_cubit.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/screens/home_screen.dart';
import 'package:rent_bill_maker/screens/onboarding_screen.dart';
import 'package:rent_bill_maker/services/notification_service.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PropertyModelAdapter());
  Hive.registerAdapter(TenantModelAdapter());
  Hive.registerAdapter(BillModelAdapter());
  Hive.registerAdapter(PaymentStatusAdapter());
  Hive.registerAdapter(DateSystemAdapter());

  // Open boxes (v2 names for clean schema)
  await Hive.openBox<PropertyModel>(Constants.propertiesBox);
  await Hive.openBox<TenantModel>(Constants.tenantsBox);
  await Hive.openBox<BillModel>(Constants.billsBox);
  await Hive.openBox<dynamic>(Constants.settingsBox);

  // Initialize notification service
  await NotificationService.initialize();

  runApp(const RentBillMakerApp());
}

class RentBillMakerApp extends StatelessWidget {
  const RentBillMakerApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: <SingleChildWidget>[
      BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
      BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()),
    ],
    child: BlocBuilder<LanguageCubit, AppLanguage>(
      builder: (BuildContext context, AppLanguage language) {
        final L10n l10n = L10n(language);
        return MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<PropertyBloc>(
              create: (_) => PropertyBloc()..add(LoadProperties()),
            ),
            BlocProvider<TenantBloc>(
              create: (_) => TenantBloc()..add(LoadTenants()),
            ),
            BlocProvider<BillBloc>(create: (_) => BillBloc()..add(LoadBills())),
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
            home: _getHome(),
          ),
        );
      },
    ),
  );

  Widget _getHome() {
    final Box<dynamic> box = Hive.box<dynamic>(Constants.settingsBox);
    final bool onboardingCompleted =
        box.get('onboarding_completed', defaultValue: false) as bool;
    if (!onboardingCompleted) {
      return const OnboardingScreen();
    }
    return const HomeScreen();
  }
}
