import 'package:flutter/material.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/model/category_model.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isLoadingDelete = false;

  delete() async {
    setState(() {
      isLoadingDelete = true;
    });
    await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text(
                "Eliminare la categoria ${widget.category.name}?",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              //titleTextStyle:  TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface))),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await Db()
                          .deleteCategory(context, id: widget.category.id);
                    },
                    child: Text("Si",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ))),
              ],
            ));
    setState(() {
      isLoadingDelete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Icon(IconData(widget.category.icon, fontFamily: "MaterialIcons"),
                size: 30, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.category.name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        widget.category.name == "CREDITI" ||
                widget.category.name =="DEBITI" ||
                widget.category.name == "ALTRO"
            ? const SizedBox()
            : IconButton(
                onPressed: isLoadingDelete == false ? delete : null,
                icon: Icon(Icons.delete_rounded,
                    size: 30, color: Theme.of(context).colorScheme.onSurface),
              )
      ]),
    );
  }
}
