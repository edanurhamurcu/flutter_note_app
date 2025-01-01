import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

class AuthFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const AuthFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: LocaleKeys.auth_email.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.error_auth_email_empty.tr();
              } else if (!_validateEmail(value)) {
                return LocaleKeys.error_auth_email_invalid.tr();
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: LocaleKeys.auth_password.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.error_auth_password_empty.tr();
              } else if (value.length < 6) {
                return LocaleKeys.error_auth_password_short.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  bool _validateEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }
}
