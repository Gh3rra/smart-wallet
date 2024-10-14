import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_manager.dart';
import 'package:mobile/widgets/setting_widget.dart';
import 'package:provider/provider.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    final ThemeManager themeManager = Provider.of<ThemeManager>(context);
    bool isDarkMode = themeManager.themeMode == ThemeMode.dark;
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
                      fontWeight: FontWeight.w800,color: Theme.of(context).colorScheme.onSurface),
                ))),
        centerTitle: true,
        title:  Text(
          "Generali",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 25,
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
                  boxShadow:  [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.shadow, blurRadius: 30, spreadRadius: -8),
                  ],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    SettingWidget(
                      icon: Icons.format_size_rounded,
                      title: "Titoli maiuscolo",
                      subTitle: "I titoli delle tue spese in maiuscolo",
                      iconSize: 35,
                      isSwitch: true,
                      value: isSwitched,
                      onChanged: (temp) => setState(() {
                        isSwitched = temp;
                      }),
                    ),
                    SettingWidget(
                      icon: Icons.dark_mode_rounded,
                      title: "Tema scuro",
                      iconSize: 35,
                      isSwitch: true,
                      value: isDarkMode,
                      onChanged: (temp) => setState(() {
                        isDarkMode = temp;
                        themeManager.toggleTheme(temp);
                      }),
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
