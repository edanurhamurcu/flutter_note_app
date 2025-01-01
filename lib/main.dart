import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/navigation/app_routes.dart';
import 'package:notes_app/features/components/auth/providers/auth_provider.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/features/components/splash/splash_screen.dart';
import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/init/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupWindows();

  runApp(AppLocalizations(
      child: MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProxyProvider<AuthProvider, NotesProvider>(
      create: (context) =>
          NotesProvider(Provider.of<AuthProvider>(context, listen: false).user),
      update: (context, authProvider, notesProvider) =>
          notesProvider!..updateUser(authProvider.user),
    ),
  ], child: const MyApp())));
}

void setupWindows() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 750),
    minimumSize: Size(400, 750),
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          inputDecorationTheme: const InputDecorationTheme(
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.grey),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.blue),
            // ),
            border: InputBorder.none,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute);
  }
}
