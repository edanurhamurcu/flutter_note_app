/// This Dart code snippet is defining an enum called `Locales` that represents different language locales.
///  It includes two values: `tr` for Turkish and `en` for English.
/// Each value is associated with a `Locale` object from the `flutter/material.dart` package.

// ignore_for_file: dangling_library_doc_comments

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Locales {
  tr(Locale('tr', 'TR')),
  en(Locale('en', 'US'));

  final Locale locale;
  const Locales(this.locale);

}
