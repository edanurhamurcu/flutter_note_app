import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/features/components/auth/screens/auth_screen.dart';
import 'package:notes_app/features/components/notes/screens/notes_screen.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            Future.delayed(const Duration(seconds: 3), () {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_alt,
                      color: Colors.orange,
                      size: 100.0,
                    ),
                    SizedBox(height: 20),
                    Text(
                      LocaleKeys.note_app.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ],
                ),
              );
            });
          }

          if (snapshot.hasData) {
            return const NotesScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
