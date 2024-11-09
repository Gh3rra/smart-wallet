import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/category.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.size,
    required this.type,
    this.margin,
    required this.categoryIcon,
  });

  final String type;
  final int categoryIcon;
  final double size;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin ?? const EdgeInsets.all(0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: type == "ENTRATA"
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary),
        child: Icon(
          IconData(categoryIcon, fontFamily: "MaterialIcons"),
          size: size,
          color: Colors.white,
        ));
  }
}
