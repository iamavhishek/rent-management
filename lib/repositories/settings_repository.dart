import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class SettingsRepository {
  final Box<dynamic> _box = Hive.box<dynamic>(Constants.settingsBox);

  static const String _languageKey = 'app_language';
  static const String _dateSystemKey = 'preferred_date_system';

  // Onboarding
  bool isOnboardingComplete() =>
      _box.get('onboarding_completed', defaultValue: false) as bool;

  Future<void> setOnboardingComplete() async =>
      _box.put('onboarding_completed', true);

  // Language
  AppLanguage getLanguage() {
    final String saved = _box.get(_languageKey, defaultValue: 'ne') as String;
    return saved == 'en' ? AppLanguage.en : AppLanguage.ne;
  }

  Future<void> setLanguage(AppLanguage language) async =>
      _box.put(_languageKey, language == AppLanguage.en ? 'en' : 'ne');

  // Date System
  DateSystem getDateSystem() {
    final String saved = _box.get(_dateSystemKey, defaultValue: 'ad') as String;
    return saved == 'bs' ? DateSystem.bs : DateSystem.ad;
  }

  Future<void> setDateSystem(DateSystem system) async =>
      _box.put(_dateSystemKey, system == DateSystem.bs ? 'bs' : 'ad');
}
