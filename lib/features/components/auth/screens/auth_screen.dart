import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/custom_texfield.dart';
import 'package:notes_app/core/utils/loader_overlay.dart';
import 'package:notes_app/core/utils/snackbar_helper.dart';
import 'package:notes_app/features/components/auth/providers/auth_provider.dart';
import 'package:notes_app/features/components/auth/screens/widgets/auth_btn.dart';
import 'package:notes_app/features/components/auth/screens/widgets/google_sign_in_btn.dart';
import 'package:notes_app/features/components/auth/screens/widgets/header.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  Future<void> handleAuthAction(AuthProvider authProd) async {
    LoaderOverlay().show(context);
    try {
      if (authProd.isSignUp) {
        await authProd.signUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
          surname: surnameController.text.trim(),
        );
        SnackbarHelper.showSuccess(
          context,
          LocaleKeys.auth_success_register.tr(),
        );
      } else {
        await authProd.signInWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        SnackbarHelper.showSuccess(
          context,
          LocaleKeys.auth_success_login.tr(),
        );
      }
      Navigator.of(context).pushReplacementNamed('/notes');
    } catch (e) {
      SnackbarHelper.showError(context, e.toString());
    } finally {
      LoaderOverlay().hide();
    }
  }

  Future<void> handleGoogleSignIn(AuthProvider authProvider) async {
    LoaderOverlay().show(context);
    try {
      await authProvider.signInWithGoogle();
      Navigator.of(context).pushReplacementNamed('/notes');
    } catch (e) {
      SnackbarHelper.showError(context, e.toString());
    } finally {
      LoaderOverlay().hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.2,
            horizontal: width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header(),
              if (authProvider.isSignUp) ...[
                CustomTextField(
                  controller: nameController,
                  labelText: LocaleKeys.auth_name.tr(),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: surnameController,
                  labelText: LocaleKeys.auth_lastName.tr(),
                ),
                const SizedBox(height: 10),
              ],
              CustomTextField(
                controller: emailController,
                labelText: LocaleKeys.auth_email.tr(),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: passwordController,
                labelText: LocaleKeys.auth_password.tr(),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              AuthButton(
                  authProvider: authProvider,
                  isSignUp: authProvider.isSignUp,
                  handleAuthAction: handleAuthAction),
              const SizedBox(height: 20),
              _buildToggleAuthMode(authProvider),
              const SizedBox(height: 20),
              GoogleSignInButton(
                  authProvider: authProvider,
                  handleGoogleSignIn: handleGoogleSignIn),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleAuthMode(AuthProvider authProvider) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: authProvider.toggleAuthMode,
        child: RichText(
          text: TextSpan(
            text: authProvider.isSignUp
                ? "${LocaleKeys.auth_already_have_account.tr()} "
                : "${LocaleKeys.auth_no_account.tr()} ",
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: authProvider.isSignUp
                    ? LocaleKeys.auth_login.tr()
                    : LocaleKeys.auth_register.tr(),
                style: const TextStyle(
                  color: Colors.orange,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
