// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'To Do List';

  @override
  String get addTaskTitle => 'Add new Task';

  @override
  String get selectTime => 'Select Date';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get theme => 'Theme';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get enterTask => 'Enter Task Title';

  @override
  String get enterDesc => 'Enter Task Description';

  @override
  String get addText => 'Add';

  @override
  String get descWarning => 'Please enter task Description';

  @override
  String get taskWarning => 'Please enter task title';
}
