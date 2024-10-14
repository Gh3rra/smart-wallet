// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/utils/wallet_color.dart';

class WalletEditWidget extends StatefulWidget {
  const WalletEditWidget({
    super.key,
    required this.name,
    required this.amount,
    required this.color,
    required this.walletId,
  });
  final String walletId;
  final String name;
  final double amount;
  final Color color;

  @override
  State<WalletEditWidget> createState() => _WalletEditWidgetState();
}

class _WalletEditWidgetState extends State<WalletEditWidget> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  bool isLoadingDelete = false;
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    nameController = TextEditingController(text: widget.name);
    amountController =
        TextEditingController(text: formatDoubleToString(widget.amount));
  }

  submit() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      await Db().editWallet(
          walletId: widget.walletId,
          name: nameController.text,
          newAmount: formatDoubleFromString(amountController.text),
          oldAmount: widget.amount,
          color: color.value);
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  delete() async {
    setState(() {
      isLoadingDelete = true;
    });
    await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: const Text("Eliminare il portafoglio?"),
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
                      await Db().deleteWallet(
                          walletId: widget.walletId, amount: widget.amount);
                      Navigator.pop(context);
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
                              fontSize: 18,
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
                           await  showDialog(
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
                                      fontSize: 18),
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
                                      "SALVA",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 19,
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
                        controller: amountController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^(\d)+([,.]{0,1}\d{1,2}){0,1}$')
                                  .hasMatch(value)) {
                            return "Inserisci un importo";
                          }
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 19,
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
                                  fontSize: 19,
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
                IconButton(
                  onPressed: isLoading == false && isLoadingDelete == false
                      ? delete
                      : null,
                  icon: isLoadingDelete == false
                      ? Icon(
                          Icons.delete_rounded,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                ),
                TextButton(
                  onPressed: isLoading == false && isLoadingDelete == false
                      ? submit
                      : null,
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
