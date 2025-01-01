import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_app/features/components/auth/providers/auth_provider.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

class AuthButton extends StatelessWidget {
  final bool isSignUp;
  final AuthProvider authProvider;
  final Function(AuthProvider) handleAuthAction;

  const AuthButton({
    super.key,
    required this.authProvider,
    required this.isSignUp,
    required this.handleAuthAction,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        minimumSize: const Size(double.infinity / 2, 50),
      ),
      onPressed: () => handleAuthAction(authProvider),
      child: Text(
        isSignUp ? LocaleKeys.auth_register.tr() : LocaleKeys.auth_login.tr(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
