// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/settings/CHANGE_password_screen.dart';
import 'package:mobile/screens/settings/change_email_screen.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/widgets/setting_widget.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
                style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder())),
                onPressed: () => {Navigator.pop(context)},
                icon: Text(
                  String.fromCharCode(Icons.arrow_back_rounded.codePoint),
                  style: TextStyle(
                      fontFamily: Icons.arrow_back_rounded.fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface),
                ))),
        centerTitle: true,
        title: Text(
          "Account",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w500,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                      onTap: () {
                        Future.delayed(
                          const Duration(milliseconds: 300),
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangeEmailScreen(),
                                ));
                          },
                        );
                      },
                      prefixIcon: Icons.email_outlined,
                      title: "Cambia email",
                      prefixIconSize: 35,
                    ),
                    SettingWidget(
                      onTap: () {
                        Future.delayed(
                          const Duration(milliseconds: 300),
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordScreen(),
                                ));
                          },
                        );
                      },
                      prefixIcon: Icons.password_rounded,
                      title: "Modifica Password",
                      prefixIconSize: 35,
                    ),
                    SettingWidget(
                      onTap: () async {
                        //await Db().deleteAccount();
                        Future.delayed(
                          const Duration(milliseconds: 300),
                          () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        );
                      },
                      prefixIcon: Icons.delete_forever_rounded,
                      title: "Elimina Account",
                      prefixIconSize: 35,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
