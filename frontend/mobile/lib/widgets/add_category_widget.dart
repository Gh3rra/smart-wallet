// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/utils/wallet_color.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget({
    super.key,
    required this.type,
  });
  final String type;

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
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
      await Db().addCategory(
          name: nameController.text, icon: icon!.data, type: widget.type);
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color categoryColor = widget.type == "ENTRATA"
        ? const Color(0xff6197FF)
        : const Color(0xFFFF4848);
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
                                iconPackModes: [IconPack.roundedMaterial],
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
                    isLoading == false ? Navigator.pop(context) : null;
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
