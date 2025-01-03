/// This Dart code snippet is defining an enum called `Locales` that represents different language locales.
///  It includes two values: `tr` for Turkish and `en` for English.
/// Each value is associated with a `Locale` object from the `flutter/material.dart` package.

// ignore_for_file: dangling_library_doc_comments

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

enum Locales {
  tr(Locale('tr', 'TR')),
  en(Locale('en', 'US'));

  final Locale locale;
  const Locales(this.locale);
}

extension LocalesExtension on Locales {
  String get name {
    switch (this) {
      case Locales.tr:
        return LocaleKeys.setting_Turkish.tr();
      case Locales.en:
        return LocaleKeys.setting_English.tr();
      default:
        return '';
    }
  }

  Locale get locale {
    switch (this) {
      case Locales.tr:
        return const Locale('tr', 'TR');
      case Locales.en:
        return const Locale('en', 'US');
      default:
        return const Locale('en', 'US');
    }
  }
}
