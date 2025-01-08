import 'package:flutter/material.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/common/utils/utils.dart';
import 'package:mobile/model/category_model.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.size,
    required this.type,
    this.margin,
    required this.category,
  });

  final Type type;
  final CategoryModel category;
  final double size;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin ?? const EdgeInsets.all(0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: type == Type.entrata
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary),
        child: Icon(
          IconData(category.icon, fontFamily: "MaterialIcons"),
          size: size,
          color: Colors.white,
        ));
  }
}
