import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<DateSystem> {
  SettingsCubit({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(settingsRepository.getDateSystem());
  final SettingsRepository _settingsRepository;

  void setDateSystem(DateSystem system) {
    _settingsRepository.setDateSystem(system);
    emit(system);
  }

  void toggleDateSystem() {
    final DateSystem newSystem = state == DateSystem.ad
        ? DateSystem.bs
        : DateSystem.ad;
    setDateSystem(newSystem);
  }

  Future<void> setOnboardingComplete() async {
    await _settingsRepository.setOnboardingComplete();
  }
}
