import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/snackbar_helper.dart';
import 'package:notes_app/features/components/auth/providers/auth_provider.dart';
import 'package:notes_app/features/components/settings/screens/change_language.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:notes_app/init/lang/providers/language_provider.dart';
import 'package:notes_app/init/theme/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProd = Provider.of<AuthProvider>(context, listen: false);
    final themeProd = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) => AppBar(
            title: Text(LocaleKeys.setting_settings.tr()),
            automaticallyImplyLeading: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                LocaleKeys.setting_common.tr(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Card(
              color: themeProd.isDarkMode ? Colors.grey[800] : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) => ListTile(
                      title: Text(LocaleKeys.setting_language.tr()),
                      subtitle: Text(
                        context.locale.languageCode == 'tr'
                            ? LocaleKeys.setting_Turkish.tr()
                            : LocaleKeys.setting_English.tr(),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      leading: Icon(Icons.language),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ChangeLanguage(),
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3),
                        );
                      },
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) => SwitchListTile(
                      inactiveTrackColor: Colors.grey[200],
                      title: Text(LocaleKeys.setting_theme).tr(),
                      subtitle: themeProvider.isDarkMode
                          ? Text(LocaleKeys.setting_dark_mode.tr())
                          : Text(LocaleKeys.setting_light_mode.tr()),
                      secondary: themeProvider.isDarkMode
                          ? Icon(Icons.brightness_4)
                          : Icon(Icons.brightness_7),
                      value: themeProvider.isDarkMode,
                      onChanged: (bool value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                LocaleKeys.setting_account.tr(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Card(
              color: themeProd.isDarkMode ? Colors.grey[800] : Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text(LocaleKeys.setting_change_password).tr(),
                    leading: Icon(Icons.lock_outline),
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ChangePassword()));
                    },
                  ),
                  ListTile(
                    title: Text(LocaleKeys.auth_logout).tr(),
                    leading: Icon(Icons.logout_outlined),
                    onTap: () {
                      authProd.signOut();
                      SnackbarHelper.showSuccess(
                          context, LocaleKeys.auth_success_logout.tr());
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
