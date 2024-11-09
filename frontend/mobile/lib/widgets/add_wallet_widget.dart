// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/utils/wallet_color.dart';

class AddWalletWidget extends StatefulWidget {
  const AddWalletWidget({
    super.key,
  });

  @override
  State<AddWalletWidget> createState() => _AddWalletWidgetState();
}

class _AddWalletWidgetState extends State<AddWalletWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  Color color = Color(getRandomColorValue());
  bool isLoading = false;

  submit() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      await Db().addWallet(
          name: nameController.text,
          amount: formatDoubleFromString(amountController.text),
          color: color.value);
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  showAddWalletWidget() async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          const AddWalletWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color currentColor = color;

    Color textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: IntrinsicHeight(
        child: Container(
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
                          "Aggiungi Portafoglio",
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(color),
                            padding:
                                const WidgetStatePropertyAll(EdgeInsets.all(6)),
                          ),
                          constraints:
                              const BoxConstraints(maxHeight: 50, maxWidth: 50),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                title: Text(
                                  "Seleziona un colore",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 16),
                                ),
                                content: SizedBox(
                                  height: 200,
                                  child: BlockPicker(
                                    availableColors: walletColors,
                                    pickerColor: color,
                                    onColorChanged: (value) {
                                      currentColor = value;
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        color = currentColor;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "CONFERMA",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: textColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    IntrinsicHeight(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Inserisci un nome";
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 16,
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
                        controller: amountController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^(\d)+([,.]{1}\d{1,2}){0,1}$')
                                  .hasMatch(value)) {
                            return "Inserisci un importo";
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface),
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            prefixIcon: Text(
                              "€ ",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                                minWidth: 0, minHeight: 0)),
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
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                TextButton(
                  onPressed: submit,
                  child: Text(
                    "CONFERMA",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface),
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
