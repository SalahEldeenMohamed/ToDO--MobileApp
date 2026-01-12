// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get title => 'قائمة المهام';

  @override
  String get addTaskTitle => 'اضف مهمة جديدة';

  @override
  String get selectTime => 'حدد اليوم';

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الانجليزية';

  @override
  String get theme => 'المود';

  @override
  String get dark => 'الليلي';

  @override
  String get light => 'النهاري';

  @override
  String get enterTask => 'أدخل عنوان المهمة';

  @override
  String get enterDesc => 'أدخل وصف المهمة';

  @override
  String get addText => 'اضف';

  @override
  String get descWarning => 'الرجاء إدخال وصف المهمة';

  @override
  String get taskWarning => 'الرجاء إدخال عنوان المهمة';
}
