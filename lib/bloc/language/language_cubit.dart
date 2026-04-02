import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class LanguageCubit extends Cubit<AppLanguage> {
  LanguageCubit() : super(AppLanguage.ne);

  void toggleLanguage() {
    emit(state == AppLanguage.ne ? AppLanguage.en : AppLanguage.ne);
  }
}
