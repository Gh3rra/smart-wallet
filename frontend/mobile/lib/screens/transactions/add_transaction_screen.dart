// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/screens/transactions/animated_title.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String userId = AuthService().userId;
  int step = 0;
  int stepReached = 0;
  double paddingTitle = 20;
  bool isLoading = false;
  bool isLoadingCategory = false;
  bool isLoadingWallet = false;
  bool amountError = false;
  bool titleError = false;
  bool categoryError = false;
  final ScrollController _scrollController = ScrollController();
  String? type;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  QueryDocumentSnapshot<Map<String, dynamic>>? category;
  QueryDocumentSnapshot<Map<String, dynamic>>? wallet;

  List<DropdownMenuItem> categoryList = [];
  List<DropdownMenuItem> walletList = [
    const DropdownMenuItem(
      value: null,
      child: Text("NON SPECIFICATO"),
    )
  ];

  @override
  void initState() {
    super.initState();
    setWalletList();
    dateController.text = DateFormat("dd/MM/yyyy").format(selectedDate);
  }

  validateAmount() {
    if (amountController.text.isNotEmpty &&
        RegExp(r"^\d+([.,]{1}\d{1,2}){0,1}$").hasMatch(amountController.text)) {
      setState(() {
        amountError = false;
      });
      return true;
    }
    setState(() {
      amountError = true;
    });
    return false;
  }

  validateTitle() {
    if (titleController.text.isNotEmpty) {
      setState(() {
        titleError = false;
      });
      return true;
    }
    setState(() {
      titleError = true;
    });
    return false;
  }

  validateCategory() {
    if (category != null) {
      setState(() {
        categoryError = false;
      });
      return true;
    }
    setState(() {
      categoryError = true;
    });
    return false;
  }

  setCategoryList() async {
    setState(() {
      isLoadingCategory = true;
      category = null;
      categoryList.clear();
    });

    if (type == "ENTRATA") {
      var categoryCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("incomesCategory")
          .orderBy("name")
          .get()
          .then(
            (value) => value.docs,
          );

      for (var element in categoryCollection) {
        categoryList.add(DropdownMenuItem(
          value: element,
          child: Text(element["name"]),
        ));
      }
    } else {
      var categoryCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("expensesCategory")
          .orderBy("name")
          .get()
          .then(
            (value) => value.docs,
          );

      for (var element in categoryCollection) {
        categoryList.add(DropdownMenuItem(
          value: element,
          child: Text(element["name"]),
        ));
      }
    }
    setState(() {
      isLoadingCategory = false;
    });
  }

  setWalletList() async {
    setState(() {
      isLoadingWallet = true;
    });

    var walletCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("wallets")
        .orderBy("order")
        .get()
        .then(
          (value) => value.docs,
        );

    for (var element in walletCollection) {
      walletList.add(DropdownMenuItem(
        value: element,
        child: Text(element["name"]),
      ));
    }
    setState(() {
      isLoadingWallet = false;
    });
  }

  submit() async {
    setState(() {
      isLoading = true;
    });

    await Db().addTransaction(
        type: type!,
        title: titleController.text,
        amount: formatDoubleFromString(amountController.text),
        categoryId: category!.id,
        walletId: wallet?.id,
        date: selectedDate);
    Navigator.pop(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      //TYPE
      Step(
          state: step == 0
              ? StepState.editing
              : stepReached > 0
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 0,
          title: const Text("Tipo"),
          stepStyle: StepStyle(
              color: stepReached > 0 || step == 0
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                  onPressed: () {
                    setState(() {
                      type = "ENTRATA";
                      step++;
                      if (step > stepReached) stepReached = step;
                    });
                    setCategoryList();
                  },
                  text: "ENTRATA",
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  height: 40,
                  radius: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                MyButton(
                  onPressed: () {
                    setState(() {
                      type = "USCITA";
                      step++;
                      if (step > stepReached) stepReached = step;
                    });
                    setCategoryList();
                  },
                  text: "USCITA",
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  height: 40,
                  radius: 20,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          )),
      //AMOUNT
      Step(
          state: step == 1
              ? StepState.editing
              : stepReached > 1
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 1,
          stepStyle: StepStyle(
              color: stepReached > 1 || step == 1
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent),
          title: const Text("Importo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                IntrinsicWidth(
                  child: MyTextField(
                    controller: amountController,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "€ ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                amountError == true
                    ? Text(
                        "Inserisci un importo",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 13),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step--;
                        });
                      },
                      fontSize: 15,
                      text: "INDIETRO",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    MyButton(
                      onPressed: () {
                        if (validateAmount()) {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        }
                      },
                      fontSize: 15,
                      text: "CONTINUA",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ],
            ),
          )),
      //TITLE
      Step(
          state: step == 2
              ? StepState.editing
              : stepReached > 2
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 2,
          stepStyle: StepStyle(
              color: stepReached > 2 || step == 2
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent),
          title: const Text("Titolo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyTextField(
                    controller: titleController,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
                        Icons.title_rounded,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                titleError == true
                    ? Text(
                        "Inserisci un titolo",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 13),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step--;
                        });
                      },
                      fontSize: 15,
                      text: "INDIETRO",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    MyButton(
                      onPressed: () {
                        if (validateTitle()) {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        }
                      },
                      fontSize: 15,
                      text: "CONTINUA",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ],
            ),
          )),
      //DATE
      Step(
          state: step == 3
              ? StepState.editing
              : stepReached > 3
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 3,
          stepStyle: StepStyle(
              color: stepReached > 3 || step == 3
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent),
          title: const Text("Data"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyTextField(
                    controller: dateController,
                    onTap: () async {
                      DateTime? tempDate = await showDatePicker(
                          initialDate: selectedDate,
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendar,
                          keyboardType: TextInputType.datetime,
                          builder: (context, child) => Theme(
                              data: ThemeData(
                                  colorScheme: ColorScheme(
                                      brightness: Theme.of(context).brightness,
                                      primary: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      onPrimary:
                                          Theme.of(context).colorScheme.primary,
                                      secondary: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onSecondary: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      error:
                                          Theme.of(context).colorScheme.error,
                                      onError:
                                          Theme.of(context).colorScheme.onError,
                                      surface: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onSurface: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                              child: child!),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          helpText: "",
                          locale: const Locale('it', 'IT'));
                      setState(() {
                        if (tempDate != null) {
                          selectedDate = tempDate;
                          dateController.text =
                              DateFormat("dd/MM/yyyy").format(selectedDate);
                        }
                      });
                    },
                    readOnly: true,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step--;
                        });
                      },
                      fontSize: 15,
                      text: "INDIETRO",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step++;
                          if (step > stepReached) {
                            stepReached = step;
                          }
                        });
                      },
                      fontSize: 15,
                      text: "CONTINUA",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ],
            ),
          )),
      //CATEGORY
      Step(
          state: step == 4
              ? StepState.editing
              : stepReached > 4
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 4,
          stepStyle: StepStyle(
              color: stepReached > 4 || step == 4
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent),
          title: const Text("Categoria"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField(
                    dropdownColor: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(15),
                    hint: Text("Seleziona categoria",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface)),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(20),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        suffixIcon: isLoadingCategory == false
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 35,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                        suffixIconConstraints:
                            const BoxConstraints(minHeight: 0, minWidth: 0)),
                    icon: const SizedBox(),
                    value: category,
                    items: categoryList,
                    onChanged: (value) {
                      category = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                categoryError == true
                    ? Text(
                        "Inserisci una categoria",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 13),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step--;
                        });
                      },
                      fontSize: 15,
                      text: "INDIETRO",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    MyButton(
                      onPressed: () {
                        if (validateCategory()) {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        }
                      },
                      fontSize: 15,
                      text: "CONTINUA",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ],
            ),
          )),
      //WALLET
      Step(
          state: step == 5
              ? StepState.editing
              : stepReached > 5
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 5,
          stepStyle: StepStyle(
              color: stepReached > 5 || step == 5
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent),
          title: const Text("Portafoglio"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField(
                    dropdownColor: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(15),
                    hint: Text("Seleziona portafoglio",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface)),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(20),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        suffixIcon: isLoadingWallet == false
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 35,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                        suffixIconConstraints:
                            const BoxConstraints(minHeight: 0, minWidth: 0)),
                    icon: const SizedBox(),
                    value: wallet,
                    items: walletList,
                    onChanged: (value) {
                      wallet = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step--;
                        });
                      },
                      fontSize: 15,
                      text: "INDIETRO",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step++;
                          if (step > stepReached) {
                            stepReached = step;
                          }
                        });
                      },
                      fontSize: 15,
                      text: "CONTINUA",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ],
            ),
          )),
      //SUMMARY
      Step(
          state: step == 6
              ? StepState.editing
              : stepReached > 6
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 6,
          stepStyle: StepStyle(
              color: stepReached > 6 || step == 6
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent),
          title: const Text("Invia"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Tipo: ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: type,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Titolo: ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: titleController.text,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Importo: ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text:
                                  "${amountController.text.replaceAll(".", ",")} €",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Data: ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text:
                                  DateFormat("dd/MM/yyyy").format(selectedDate),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Categoria: ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: category == null ? "" : category!["name"],
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Portafoglio: ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: wallet == null
                                  ? "NON SPECIFICATO"
                                  : wallet!["name"],
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ])),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onPressed: () {
                        setState(() {
                          step--;
                        });
                      },
                      fontSize: 15,
                      text: "INDIETRO",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    MyButton(
                      onPressed: submit,
                      fontSize: 15,
                      text: "INVIA",
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      height: 40,
                      radius: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ],
            ),
          ))
    ];

    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        AnimatedTitle(
            scrollController: _scrollController, text: "Nuova Transazione"),
        SliverList(
            delegate: SliverChildListDelegate([
          Form(
            child: Stepper(
              physics: const NeverScrollableScrollPhysics(),
              stepIconBuilder: (stepIndex, stepState) {
                switch (stepState) {
                  case StepState.indexed:
                    return Text(
                      "${stepIndex + 1}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: stepReached > stepIndex || stepIndex == 0
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onSurface),
                    );
                  case StepState.complete:
                    return Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  case StepState.editing:
                    return Icon(
                      Icons.edit_rounded,
                      size: 17,
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  default:
                }
                return null;
              },
              connectorColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onSurface),
              connectorThickness: 2,
              controlsBuilder: (context, details) {
                return const SizedBox();
              },
              onStepTapped: (value) {
                if (value <= step) {
                  setState(() {
                    step = value;
                  });
                }
              },
              currentStep: step,
              steps: steps,
            ),
          ),
        ]))
      ],
    ));
  }
}
