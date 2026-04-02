import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/screens/home_screen.dart';
import 'package:rent_bill_maker/services/notification_service.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/theme.dart';
import 'package:rent_bill_maker/bloc/language/language_cubit.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PropertyModelAdapter());
  Hive.registerAdapter(TenantModelAdapter());
  Hive.registerAdapter(BillModelAdapter());
  Hive.registerAdapter(PaymentStatusAdapter());

  // Open boxes (v2 names for clean schema)
  await Hive.openBox<PropertyModel>(Constants.propertiesBox);
  await Hive.openBox<TenantModel>(Constants.tenantsBox);
  await Hive.openBox<BillModel>(Constants.billsBox);

  // Initialize notification service
  await NotificationService.initialize();

  runApp(const RentBillMakerApp());
}

class RentBillMakerApp extends StatelessWidget {
  const RentBillMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, AppLanguage>(
        builder: (context, language) {
          final l10n = L10n(language);
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PropertyBloc()..add(LoadProperties())),
              BlocProvider(create: (_) => TenantBloc()..add(LoadTenants())),
              BlocProvider(create: (_) => BillBloc()..add(LoadBills())),
            ],
            child: MaterialApp(
              title: l10n.get('app_name'),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              locale: language == AppLanguage.ne
                  ? const Locale('ne', 'NP')
                  : const Locale('en', 'US'),
              localizationsDelegates: [
                AppLocalizationsDelegate(language),
                // No need for GlobalMaterialLocalizations for this simple setup 
                // but we could add them if date picker localization is needed.
              ],
              home: const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
