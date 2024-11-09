// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/theme/theme_manager.dart';
import 'package:mobile/widgets/category_icon.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/transaction_edit_widget.dart';
import 'package:provider/provider.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
    this.fetchTransactions,
  });
  final String transactionId;
  final Function()? fetchTransactions;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  bool isLoadingDelete = false;
  delete({required String type, required double amount}) async {
    setState(() {
      isLoadingDelete = true;
    });
    await showDialog(
        barrierDismissible: !isLoadingDelete,
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: const Text("Eliminare la transazione?"),
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
                      await Db().deleteTransaction(
                          transactionId: widget.transactionId,
                          type: type,
                          amount: amount);
                      if (widget.fetchTransactions != null) {
                        widget.fetchTransactions!();
                      }
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            onPressed: () => Navigator.pop(context),
            icon: Text(
              String.fromCharCode(Icons.arrow_back_rounded.codePoint),
              style: TextStyle(
                  fontFamily: Icons.arrow_back_rounded.fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface),
            )),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TITLE
              Container(
                padding: const EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Dettagli",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //DETAILS CONTAINER
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 30,
                          spreadRadius: -8),
                    ],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: Db()
                          .userDoc
                          .collection("transactions")
                          .doc(widget.transactionId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> transaction =
                              snapshot.data!.data()!;
                          String categoryPath = transaction["type"] == "ENTRATA"
                              ? "incomesCategory"
                              : "expensesCategory";

                          return StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: Db()
                                  .userDoc
                                  .collection(categoryPath)
                                  .doc(transaction["categoryId"])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Map<String, dynamic> category =
                                      snapshot.data!.data()!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //NAME, AMOUNT AND DATE
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  transaction["type"] ==
                                                          "ENTRATA"
                                                      ? Text(
                                                          "+${formatDoubleToString(transaction["amount"])} €",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onPrimary),
                                                        )
                                                      : Text(
                                                          "-${formatDoubleToString(transaction["amount"])} €",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSecondary),
                                                        ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    Provider.of<ThemeManager>(
                                                                    context)
                                                                .isCapsLock ==
                                                            true
                                                        ? transaction["title"]
                                                            .toUpperCase()
                                                        : transaction["title"],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    DateFormat("dd/MM/yyyy")
                                                        .format(
                                                            transaction["date"]
                                                                .toDate()),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: onTertiary),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            //ICON
                                            CategoryIcon(
                                                categoryIcon: category["icon"],
                                                size: 40,
                                                type: transaction["type"])
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      //CATEGORY
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Categoria:",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                              Text(category["name"],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface))
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      //BUTTON
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: MyButton(
                                                onPressed: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          TransactionEditWidget(
                                                            fetchTransactions:
                                                                widget
                                                                    .fetchTransactions,
                                                            transactionId: widget
                                                                .transactionId,
                                                            title: transaction[
                                                                "title"],
                                                            type: transaction[
                                                                "type"],
                                                            amount: transaction[
                                                                "amount"],
                                                            date: transaction[
                                                                    "date"]
                                                                .toDate(),
                                                            categoryId:
                                                                transaction[
                                                                    "categoryId"],
                                                            onUpdate: (value) {
                                                              setState(() {
                                                                transaction =
                                                                    value;
                                                              });
                                                            },
                                                          ));
                                                },
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                text: "Modifica",
                                                backgroundColor: onSecondary,
                                                height: 40,
                                                radius: 20),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: MyButton(
                                                onPressed: isLoadingDelete ==
                                                        false
                                                    ? () => delete(
                                                        type:
                                                            transaction["type"],
                                                        amount: transaction[
                                                            "amount"])
                                                    : null,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                text: "Elimina",
                                                backgroundColor:
                                                    transaction["type"] ==
                                                            "ENTRATA"
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary,
                                                color: Colors.white,
                                                height: 40,
                                                radius: 20),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                }
                                return CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                );
                              });
                        }
                        return CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
