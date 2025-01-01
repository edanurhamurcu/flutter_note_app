import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
      child: Column(
        children: [
          const Icon(
            Icons.note_alt,
            color: Colors.orange,
            size: 80.0,
          ),
          Text(
            LocaleKeys.note_app.tr(),
            style: const TextStyle(
              fontSize: 24,
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
