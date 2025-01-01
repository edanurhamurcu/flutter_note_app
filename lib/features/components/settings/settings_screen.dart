import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/navigation/app_routes.dart';
import 'package:notes_app/core/utils/snackbar_helper.dart';
import 'package:notes_app/features/components/auth/providers/auth_provider.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.setting_settings.tr()),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(LocaleKeys.setting_theme.tr()),
            trailing: const Icon(Icons.brightness_4),
            onTap: () {},
          ),
          ListTile(
            title: Text(LocaleKeys.setting_language.tr()),
            trailing: const Icon(Icons.language),
            onTap: () {},
          ),
          ListTile(
            title: Text(LocaleKeys.auth_logout.tr()),
            trailing: const Icon(Icons.logout),
            onTap: () {
              authProvider.signOut();
              SnackbarHelper.showSuccess(
                  context, LocaleKeys.auth_success_logout.tr());
              Navigator.pushNamed(context, AppRoutes.auth);
            },
          ),
        ],
      ),
    );
  }
}
