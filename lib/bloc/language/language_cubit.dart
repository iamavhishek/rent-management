import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/repositories/settings_repository.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class LanguageCubit extends Cubit<AppLanguage> {
  LanguageCubit({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(settingsRepository.getLanguage());
  final SettingsRepository _settingsRepository;

  void toggleLanguage() {
    final AppLanguage newLang = state == AppLanguage.ne
        ? AppLanguage.en
        : AppLanguage.ne;
    setLanguage(newLang);
  }

  void setLanguage(AppLanguage language) {
    _settingsRepository.setLanguage(language);
    emit(language);
  }
}
