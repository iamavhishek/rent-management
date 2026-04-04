import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class LanguageCubit extends Cubit<AppLanguage> {
  LanguageCubit() : super(_loadSavedLanguage());
  static const String _languageKey = 'app_language';

  static AppLanguage _loadSavedLanguage() {
    final Box<dynamic> box = Hive.box<dynamic>(Constants.settingsBox);
    final String saved = box.get(_languageKey, defaultValue: 'ne') as String;
    return saved == 'en' ? AppLanguage.en : AppLanguage.ne;
  }

  void toggleLanguage() {
    final AppLanguage newLang = state == AppLanguage.ne
        ? AppLanguage.en
        : AppLanguage.ne;
    setLanguage(newLang);
  }

  void setLanguage(AppLanguage language) {
    Hive.box<dynamic>(
      Constants.settingsBox,
    ).put(_languageKey, language == AppLanguage.en ? 'en' : 'ne');
    emit(language);
  }
}
