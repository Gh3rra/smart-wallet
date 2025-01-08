import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/screens/auth/widgets/auth_gate.dart';
import 'package:mobile/theme/theme_constants.dart';
import 'package:mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://vnedtoqwbeifzbwscpxn.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuZWR0b3F3YmVpZnpid3NjcHhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMTQwNTQsImV4cCI6MjA0ODg5MDA1NH0.p8I7k5mphuQgDQ-D0aF0U6fejPdTtbcNDOThlI_to3Q");
  await FlutterDisplayMode.setHighRefreshRate();
  //TASK: TOGLIERE DEBUG PRIMA DI BUILDARE
  await FlutterDownloader.initialize(debug: true);
  final initialThemeMode = await Db().getInitialTheme();
  final initialCapsLock = await Db().getInitialCapsLock();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeManager(
            themeMode: initialThemeMode, capsLock: initialCapsLock),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale("en"),
          Locale("it")
        ],
        debugShowCheckedModeBanner: false,
        title: 'Smart Wallet',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ThemeManager>(context).themeMode,
        home: const AuthGate());
  }
}
