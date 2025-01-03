import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/enums/locales.dart';
import 'package:notes_app/init/app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  Locales? _selectedLanguage;

  Locales? get selectedLanguage => _selectedLanguage;

  void setInitialLanguage(BuildContext context) {
    _selectedLanguage = AppLocalizations.currentLocale(context);
    notifyListeners();
  }

  void changeLanguage(BuildContext context, Locales? language) {
    if (language != null) {
      _selectedLanguage = language;
      AppLocalizations.changeLocale(context: context, locale: language);
      notifyListeners();
    }
  }
}
