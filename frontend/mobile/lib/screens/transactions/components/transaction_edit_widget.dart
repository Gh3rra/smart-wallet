// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/common/utils/utils.dart';
import 'package:mobile/model/category_model.dart';
import 'package:mobile/model/transaction_model.dart';

class TransactionEditWidget extends StatefulWidget {
  const TransactionEditWidget({
    super.key,
    this.fetchTransactions,
    required this.transaction,
  });
  final TransactionModel transaction;
  final Function()? fetchTransactions;

  @override
  State<TransactionEditWidget> createState() => _TransactionEditWidgetState();
}

class _TransactionEditWidgetState extends State<TransactionEditWidget> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController dateController;
  late DateTime selectedDate;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  bool isLoadingCategory = false;
  List<DropdownMenuItem> categoryList = [];
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.transaction.title);
    amountController = TextEditingController(
        text: formatDoubleToString(widget.transaction.amount));
    dateController = TextEditingController(
        text: DateFormat("dd/MM/yyyy").format(widget.transaction.date));
    selectedDate = widget.transaction.date;
    setCategoryList();
  }

  setCategoryList() async {
    setState(() {
      isLoadingCategory = true;
      categoryList.clear();
    });
    selectedCategory = widget.transaction.category;
    if (widget.transaction.type == Type.entrata) {
      var categoryCollection = await Db().getIncomeCategories();

      for (var element in categoryCollection) {
        categoryList.add(DropdownMenuItem(
          value: element,
          child: Text(element.name),
        ));
      }
    } else {
      var categoryCollection = await Db().getExpenseCategories();
      for (var element in categoryCollection) {
        categoryList.add(DropdownMenuItem(
          value: element,
          child: Text(element.name),
        ));
      }
    }
    setState(() {
      isLoadingCategory = false;
    });
  }

  submit() async {
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState!.validate()) {
      await Db().editTransaction(
          id: widget.transaction.id,
          title: titleController.text,
          amount: formatDoubleFromString(amountController.text),
          categoryId: selectedCategory!.id,
          date: selectedDate);
      if (widget.fetchTransactions != null) {
        widget.fetchTransactions!();
      }
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: IntrinsicHeight(
        child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            width: 250,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            child: isLoadingCategory == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            //ALERT TITLE
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Modifica Transazione",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //TITLE
                            IntrinsicHeight(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: titleController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Inserisci un titolo";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                decoration: InputDecoration(
                                  hintText: "Nome",
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary),
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //AMOUNT
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiary),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                        minWidth: 0, minHeight: 0)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //DATE
                            IntrinsicHeight(
                                child: TextFormField(
                              controller: dateController,
                              onTap: () async {
                                DateTime? tempDate = await showDatePicker(
                                    initialDate: selectedDate,
                                    context: context,
                                    initialEntryMode:
                                        DatePickerEntryMode.calendar,
                                    keyboardType: TextInputType.datetime,
                                    builder: (context, child) => Theme(
                                        data: ThemeData(
                                            colorScheme: ColorScheme(
                                                brightness: Theme.of(context)
                                                    .brightness,
                                                primary: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                onPrimary: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                secondary: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                onSecondary: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                                error: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                onError: Theme.of(context)
                                                    .colorScheme
                                                    .onError,
                                                surface: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                onSurface:
                                                    Theme.of(context).colorScheme.onSurface)),
                                        child: child!),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    helpText: "",
                                    locale: const Locale('it', 'IT'));
                                setState(() {
                                  if (tempDate != null) {
                                    selectedDate = tempDate;
                                    dateController.text =
                                        DateFormat("dd/MM/yyyy")
                                            .format(selectedDate);
                                  }
                                });
                              },
                              readOnly: true,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                              ),
                            )),
                            const SizedBox(
                              height: 20,
                            ),
                            //CATEGORY
                            IntrinsicHeight(
                              child: DropdownButtonFormField(
                                items: categoryList,
                                value: selectedCategory,
                                onChanged: (value) {
                                  selectedCategory = value;
                                },
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      //ACTION BUTTONS
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: isLoading == false
                                    ? () => Navigator.pop(context)
                                    : null,
                                child: Text(
                                  "ANNULLA",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                )),
                            TextButton(
                              onPressed: isLoading == false ? submit : null,
                              child: isLoading == false
                                  ? Text(
                                      "SALVA",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 19,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    )
                                  : CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                            )
                          ])
                    ],
                  )
                :
                //LOADING
                Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )),
      ),
    );
  }
}
