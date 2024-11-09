import 'package:flutter/material.dart';
import 'package:mobile/screens/graphs/graphs_screen.dart';
import 'package:mobile/screens/home/home_screen.dart';
import 'package:mobile/screens/main/components/bottom_bar_navigation.dart';
import 'package:mobile/screens/settings/settings_screen.dart';
import 'package:mobile/widgets/colors.dart';

class MainScreen extends StatefulWidget {
  /// Pagina Principale. Contiene una bottom bar che decide quel pagina mostrare tra:
  /// + HomeScreen
  /// + GraphScreen
  /// + SettingScreen
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const GraphsScreen(),
    const SettingsScreen()
  ];

  setIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: pages[selectedIndex]),
        bottomNavigationBar: BottomBarNavigation(
          selectedIndex: selectedIndex,
          setIndex: (index) => setIndex(index),
        ));
  }
}
