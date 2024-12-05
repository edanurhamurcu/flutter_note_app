import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/features/components/auth/providers/auth_provider.dart';
import 'package:notes_app/features/components/notes/screens/notes_screen.dart';
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
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.note_alt,
                    color: Colors.orange,
                    size: 150.0,
                  ),
                  Text(LocaleKeys.note_app.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            if (isSignUp) ...[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: LocaleKeys.auth_name.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                    labelText: LocaleKeys.auth_lastName.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              const SizedBox(height: 10),
            ],
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: LocaleKeys.auth_email.tr(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: LocaleKeys.auth_password.tr(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (isSignUp)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity / 2, 50),
                  maximumSize: const Size(double.infinity / 4, 50),
                ),
                onPressed: () async {
                  try {
                    await authProvider.signUpWithEmail(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      name: nameController.text.trim(),
                      surname: surnameController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(LocaleKeys.auth_success_register.tr())),
                    );
                    Navigator.of(context).pushReplacementNamed('/notes');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: Text(
                  LocaleKeys.auth_register.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (!isSignUp)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity / 2, 50),
                  maximumSize: const Size(double.infinity / 4, 50),
                ),
                onPressed: () async {
                  try {
                    await authProvider.signInWithEmail(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NotesScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: Text(
                  LocaleKeys.auth_login.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isSignUp = !isSignUp;
                    nameController.clear();
                    surnameController.clear();
                    emailController.clear();
                    passwordController.clear();
                  });
                },
                child: RichText(
                  text: TextSpan(
                    text: isSignUp
                        ? "${LocaleKeys.auth_already_have_account.tr()} "
                        : "${LocaleKeys.auth_no_account.tr()} ",
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: isSignUp
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
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: () async {
                try {
                  await authProvider.signInWithGoogle();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(LocaleKeys.auth_success_sign_in_google.tr())),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              icon: SvgPicture.asset(
                'assets/icons/google.svg',
                width: 22,
                height: 22,
              ),
              hoverColor: Colors.transparent,
              tooltip: LocaleKeys.auth_sign_in_google.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
