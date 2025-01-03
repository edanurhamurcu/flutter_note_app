import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/enums/locales.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:notes_app/init/lang/providers/language_provider.dart';
import 'package:provider/provider.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  final List<Locales> languages = Locales.values;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LanguageProvider>(context, listen: false)
          .setInitialLanguage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                LocaleKeys.setting_select_language.tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return RadioListTile<Locales>(
                  title: Text(languages[index].name),
                  value: languages[index],
                  activeColor: Colors.amber,
                  groupValue: languageProvider.selectedLanguage,
                  onChanged: (value) {
                    languageProvider.changeLanguage(context, value);
                    Navigator.pop(context);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(color: Colors.grey);
              },
            ),
          ],
        );
      }),
    );
  }
}
