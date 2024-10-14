// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/widgets/category_icon.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/transaction_edit_widget.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen(
      {super.key,
      required this.title,
      required this.amount,
      required this.type,
      required this.category,
      required this.date,
      required this.categoryIcon,
      required this.transactionId,
      this.fetchTransactions,
      required this.categoryId});
  final String transactionId;
  final String title;
  final double amount;
  final String type;
  final String category;
  final int categoryIcon;
  final String categoryId;
  final DateTime date;
  final Function()? fetchTransactions;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  bool isLoadingDelete = false;
  delete() async {
    setState(() {
      isLoadingDelete = true;
    });
    await showDialog(
        barrierDismissible: !isLoadingDelete,
        context: context,
        builder: (dialogContext) => AlertDialog(
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
                          type: widget.type,
                          amount: widget.amount);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //NAME, AMOUNT AND DATE
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.type == "ENTRATA"
                                      ? Text(
                                          "+${formatDoubleToString(widget.amount)} €",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                        )
                                      : Text(
                                          "-${widget.amount.toString().replaceAll(".", ",")} €",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    DateFormat("dd/MM/yyyy")
                                        .format(widget.date),
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
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
                                categoryIcon: widget.categoryIcon,
                                category: widget.category,
                                size: 40,
                                type: widget.type)
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
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categoria:",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              Text("VIAGGI",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: MyButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return TransactionEditWidget(
                                          fetchTransactions:
                                              widget.fetchTransactions,
                                          transactionId: widget.transactionId,
                                          title: widget.title,
                                          type: widget.type,
                                          amount: widget.amount,
                                          date: widget.date,
                                          categoryId: widget.categoryId);
                                    },
                                  );
                                  
                                },
                                color: Colors.white,
                                fontSize: 16,
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
                                onPressed:
                                    isLoadingDelete == false ? delete : null,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                text: "Elimina",
                                backgroundColor: widget.type == "ENTRATA"
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSecondary,
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
