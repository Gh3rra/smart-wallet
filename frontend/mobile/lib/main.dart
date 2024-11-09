import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/provider/category_provider.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/main/main_screen.dart';
import 'package:mobile/theme/theme_constants.dart';
import 'package:mobile/theme/theme_manager.dart';
import 'package:mobile/widgets/prova.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await FlutterDisplayMode.setHighRefreshRate();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => CategoryProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeManager()..initialize(),
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
  void initState() {
    super.initState();
  }

  //  test emulator 412 x 892
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
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                Provider.of<CategoryProvider>(context, listen: false)
                    .initialize();
                return const MainScreen();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("ERROR"),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              );
            }
            return const LoginScreen();
          },
        ));
  }
}
