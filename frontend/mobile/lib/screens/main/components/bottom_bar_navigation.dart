import 'package:flutter/material.dart';

class BottomBarNavigation extends StatelessWidget {
  const BottomBarNavigation(
      {super.key, required this.selectedIndex, required this.setIndex});
  final int selectedIndex;
  final Function setIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                setIndex(0);
              },
              child: Icon(
                Icons.home_rounded,
                size: 35,
                color: selectedIndex == 0
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            InkWell(
              onTap: () {
                setIndex(1);
              },
              child: Icon(Icons.bar_chart_rounded,
                  size: 35,
                  color: selectedIndex == 1
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onTertiary),
            ),
            InkWell(
              onTap: () {
                setIndex(2);
              },
              child: Icon(Icons.settings_rounded,
                  size: 35,
                  color: selectedIndex == 2
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onTertiary),
            ),
          ],
        ));
  }
}
