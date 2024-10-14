import 'package:flutter/material.dart';
import 'package:mobile/services/db.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget(
      {super.key,
      required this.name,
      required this.icon,
      required this.id,
      required this.type});
  final String id;
  final String type;
  final String name;
  final IconData icon;

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
              title:  Text("Eliminare la categoria ${widget.name}?",style: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface),),
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
                      await Db().deleteCategory(context,
                          type: widget.type,
                          categoryId: widget.id,
                          categoryName: widget.name);
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
            Icon(widget.icon,
                size: 30, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        IconButton(
          onPressed: isLoadingDelete == false ? delete : null,
          icon: Icon(Icons.delete_rounded,
              size: 30, color: Theme.of(context).colorScheme.onSurface),
        )
      ]),
    );
  }
}
