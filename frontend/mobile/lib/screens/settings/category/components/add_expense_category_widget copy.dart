// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/common/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddExpenseCategoryWidget extends StatefulWidget {
  const AddExpenseCategoryWidget({
    super.key,
  });

  @override
  State<AddExpenseCategoryWidget> createState() =>
      _AddExpenseCategoryWidgetState();
}

class _AddExpenseCategoryWidgetState extends State<AddExpenseCategoryWidget> {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  Color color = Color(getRandomColorValue());
  bool isLoading = false;
  IconPickerIcon? icon;

  submit() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate() && icon != null) {
      try {
        await Db().insertCategory(
            name: nameController.text,
            icon: icon!.data.codePoint,
            type: Type.uscita);
        Navigator.pop(context);
      } on PostgrestException catch (e) {
        isLoading = false;
        if (e.code == '23505') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                content: Container(
                  child: const Text(
                      "Impossibile aggiugnere la categoria. Esiste già un categoria con quel nome"),
                ),
              );
            },
          );
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color categoryColor = const Color(0xFFFF4848);
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          width: 250,
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Aggiungi Categoria",
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: categoryColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    IntrinsicHeight(
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Inserisci un nome";
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "Nome",
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onTertiary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    IntrinsicHeight(
                      child: TextFormField(
                        onTap: () async {
                          icon = await showIconPicker(context,
                              configuration: SinglePickerConfiguration(
                                title: const Text("Seleziona un'icona"),
                                searchHintText: "Cerca",
                                iconColor:
                                    Theme.of(context).colorScheme.onSurface,
                                noResultsText: "Nessun risultato.",
                                closeChild: Text(
                                  "OK",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                iconPackModes: [IconPack.allMaterial],
                                iconPickerShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ));
                          setState(() {});
                        },
                        readOnly: true,
                        validator: (value) {
                          if (icon == null) {
                            return "Seleziona un'icona";
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface),
                        decoration: InputDecoration(
                          prefixIcon: icon != null
                              ? Icon(
                                  icon!.data,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  size: 40,
                                )
                              : null,
                          suffixIcon: Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 40,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                          suffixIconConstraints:
                              const BoxConstraints(minHeight: 0, minWidth: 0),
                          hintText: icon == null ? "Seleziona icona" : null,
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onTertiary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "ANNULLA",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                TextButton(
                  onPressed: isLoading == false ? submit : null,
                  child: isLoading == false
                      ? Text(
                          "CONFERMA",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: Theme.of(context).colorScheme.onSurface),
                        )
                      : CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
