import 'package:flutter/material.dart';
import 'package:mobile/screens/graphs/graphs_screen.dart';
import 'package:mobile/screens/home/home_screen.dart';
import 'package:mobile/screens/settings/settings_screen.dart';
import 'package:mobile/widgets/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const GraphsScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Icon(
                    Icons.home_rounded,
                    size: 35,
                    color: selectedIndex == 0
                        ? Theme.of(context).colorScheme.onPrimary
                        : onTertiary,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Icon(Icons.bar_chart_rounded,
                      size: 35,
                      color: selectedIndex == 1
                          ? Theme.of(context).colorScheme.onPrimary
                          : onTertiary),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Icon(Icons.settings_rounded,
                      size: 35,
                      color: selectedIndex == 2
                          ? Theme.of(context).colorScheme.onPrimary
                          : onTertiary),
                ),
              ],
            )));
  }
}
