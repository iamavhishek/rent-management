import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

class SettingsCubit extends Cubit<DateSystem> {

  SettingsCubit() : super(_loadSavedDateSystem());
  static const String _dateSystemKey = 'preferred_date_system';

  static DateSystem _loadSavedDateSystem() {
    final Box<dynamic> box = Hive.box<dynamic>(Constants.settingsBox);
    final String saved = box.get(_dateSystemKey, defaultValue: 'ad') as String;
    return saved == 'bs' ? DateSystem.bs : DateSystem.ad;
  }

  void setDateSystem(DateSystem system) {
    Hive.box<dynamic>(
      Constants.settingsBox,
    ).put(_dateSystemKey, system == DateSystem.bs ? 'bs' : 'ad');
    emit(system);
  }

  void toggleDateSystem() {
    final DateSystem newSystem = state == DateSystem.ad ? DateSystem.bs : DateSystem.ad;
    setDateSystem(newSystem);
  }
}
