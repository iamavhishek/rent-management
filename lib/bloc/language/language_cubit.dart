import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class LanguageCubit extends Cubit<AppLanguage> {
  static const _languageKey = 'app_language';

  LanguageCubit() : super(_loadSavedLanguage());

  static AppLanguage _loadSavedLanguage() {
    final box = Hive.box(Constants.settingsBox);
    final saved = box.get(_languageKey, defaultValue: 'ne') as String;
    return saved == 'en' ? AppLanguage.en : AppLanguage.ne;
  }

  void toggleLanguage() {
    final newLang =
        state == AppLanguage.ne ? AppLanguage.en : AppLanguage.ne;
    setLanguage(newLang);
  }

  void setLanguage(AppLanguage language) {
    Hive.box(Constants.settingsBox).put(
      _languageKey,
      language == AppLanguage.en ? 'en' : 'ne',
    );
    emit(language);
  }
}
