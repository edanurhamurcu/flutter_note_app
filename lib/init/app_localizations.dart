import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/enums/locales.dart';

@immutable
///AppLocalizations class is used to manage the localization of the app.
final class AppLocalizations extends EasyLocalization {
  AppLocalizations({required super.child, super.key})
      : super(
        supportedLocales: _supportedItems, 
        path: _path,
        useOnlyLangCode: true);

  static final List<Locale> _supportedItems = [
    Locales.en.locale,
    Locales.tr.locale,
  ];

  static const String _path = 'assets/translations';

  static Future<void> changeLocale({
    required BuildContext context, 
    required Locales locale}) async {
    context.setLocale(locale.locale);
  }
}
