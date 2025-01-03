import 'package:flutter/material.dart';
import 'package:notes_app/features/components/auth/screens/auth_screen.dart';
import 'package:notes_app/features/components/notes/screens/add_note_screen.dart';
import 'package:notes_app/features/components/notes/screens/notes_screen.dart';
import 'package:notes_app/features/components/settings/screens/change_password_screen.dart';
import 'package:notes_app/features/components/settings/settings_screen.dart';
import 'package:notes_app/features/components/splash/splash_screen.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String splash = '/splash';
  static const String addNote = '/add-note';
  static const String editNote = '/edit-note';
  static const String notes = '/notes';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case addNote:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AddNoteScreen(
            id: args?['id'],
            title: args?['title'] ?? '',
            content: args?['content'] ?? '',
          ),
        );
      case notes:
        return MaterialPageRoute(builder: (_) => const NotesScreen());
      case editNote:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AddNoteScreen(
            id: args?['id'],
            title: args?['title'] ?? '',
            content: args?['content'] ?? '',
          ),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
