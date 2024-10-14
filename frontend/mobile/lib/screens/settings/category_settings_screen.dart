import 'package:flutter/material.dart';
import 'package:mobile/screens/settings/expense_category_screen.dart';
import 'package:mobile/screens/settings/income_category_screen.dart';
import 'package:mobile/widgets/setting_widget.dart';

class CategorySettingsScreen extends StatelessWidget {
  const CategorySettingsScreen({super.key});

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
                      fontWeight: FontWeight.w800,color: Theme.of(context).colorScheme.onSurface),
                ))),
        centerTitle: true,
        title:  Text(
          "Categorie",
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const IncomeCategoryScreen(),
                            ));
                      },
                      icon: Icons.trending_up_rounded,
                      title: "Entrate",
                      subTitle: "Gestione categorie entrate",
                      iconSize: 35,
                    ),
                     SettingWidget(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ExpenseCategoryScreen(),
                            ));
                      },
                      icon: Icons.trending_down_rounded,
                      title: "Uscite",
                      subTitle: "Gestione categorie uscite",
                      iconSize: 35,
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
