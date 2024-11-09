// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/settings/account_settings_screen.dart';
import 'package:mobile/screens/settings/category_settings_screen.dart';
import 'package:mobile/screens/settings/general_settings_screen.dart';
import 'package:mobile/screens/settings/import_export_screen.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/setting_widget.dart';

class SettingsScreen extends StatelessWidget {
  /// Pagina delle impostazioni
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          // Back button
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  } catch (e) {
                    print(e);
                  }
                },
                icon: Text(
                  String.fromCharCode(Icons.logout_rounded.codePoint),
                  style: TextStyle(
                      fontFamily: Icons.logout_rounded.fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface),
                )),
          ),
        ],
        // Title
        title: Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Impostazioni",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 30,
                    spreadRadius: -8),
              ],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: [
                SettingWidget(
                  prefixIcon: Icons.build_rounded,
                  title: "Generali",
                  prefixIconSize: 30,
                  onTap: () {
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GeneralSettingsScreen(),
                            ));
                      },
                    );
                  },
                ),
                SettingWidget(
                  prefixIcon: Icons.person_rounded,
                  title: "Account",
                  subTitle: "Modifica le impostazioni account",
                  prefixIconSize: 30,
                  onTap: () {
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AccountSettingsScreen(),
                            ));
                      },
                    );
                  },
                ),
                SettingWidget(
                  prefixIcon: Icons.category_rounded,
                  title: "Categorie",
                  subTitle: "Aggiungi,modifica o rimuovi categorie",
                  prefixIconSize: 30,
                  onTap: () {
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CategorySettingsScreen(),
                            ));
                      },
                    );
                  },
                ),
                SettingWidget(
                  prefixIcon: Icons.download_rounded,
                  title: "Importa/Esporta",
                  subTitle: "Importa o esporta le tue spese",
                  prefixIconSize: 30,
                  onTap: () {
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImportExportScreen(),
                            ));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
