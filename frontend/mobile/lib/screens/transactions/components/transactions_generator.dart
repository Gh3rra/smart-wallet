// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:mobile/provider/category_provider.dart';
import 'package:mobile/widgets/date_transaction_widget.dart';
import 'package:mobile/widgets/transaction_card.dart';
import 'package:provider/provider.dart';

class TransactionsGenerator extends StatefulWidget {
  const TransactionsGenerator({
    super.key,
    required this.transactions,
    required this.setKey,
    required this.fetchTransactions,
  });
  final Future<Map<String, Map<String, dynamic>>> transactions;
  final GlobalKey? Function(int i) setKey;
  final Function() fetchTransactions;

  @override
  State<TransactionsGenerator> createState() => _TransactionsGeneratorState();
}

class _TransactionsGeneratorState extends State<TransactionsGenerator> {
  getPadding(isFirst, isLast) {
    if (isFirst) {
      if (isLast) {
        return const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10);
      }
      return const EdgeInsets.only(top: 10, left: 25, right: 25);
    }
    if (isLast) {
      return const EdgeInsets.only(left: 25, right: 25, bottom: 10);
    }
    return const EdgeInsets.only(left: 25, right: 25);
  }

  getRadius(isFirst, isLast) {
    if (isFirst) {
      if (isLast) {
        return BorderRadius.circular(20);
      }
      return const BorderRadius.vertical(top: Radius.circular(20));
    }
    if (isLast) {
      return const BorderRadius.vertical(bottom: Radius.circular(20));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.transactions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("cane");
            List<String> dates = snapshot.data!.keys.toList();
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dates.length, //filteredTrans.length,
                itemBuilder: (context, i) {
                  String date = dates[i];
                  List dateTransactions = snapshot.data![date]!["transactions"];

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    key: i == 0 ||
                            !DateUtils.isSameMonth(
                                DateFormat("dd/MM/yyyy").parse(dates[i]),
                                DateFormat("dd/MM/yyyy").parse(dates[i - 1]))
                        ? widget.setKey(i)
                        : null,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: DateTransactionWidget(
                              date: date,
                              totalAmount:
                                  snapshot.data![date]!["totalAmount"]),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                spreadRadius: -8,
                                blurRadius: 30)
                          ], color: Colors.transparent),
                          margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)
                              .copyWith(bottom: 20),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dateTransactions.length,
                              itemBuilder: (context, index) {
                                bool isFirst = index == 0;
                                bool isLast =
                                    index == dateTransactions.length - 1;

                                EdgeInsets padding =
                                    getPadding(isFirst, isLast);

                                BorderRadius? borderRadius = getRadius(isFirst, isLast);

                                return TransactionCard(
                                    borderRadius: borderRadius,
                                    padding: padding,
                                    fetchTransactions: widget.fetchTransactions,
                                    transactionId: dateTransactions[index].id,
                                    type: dateTransactions[index]["type"],
                                    title: dateTransactions[index]["title"],
                                    amount: dateTransactions[index]["amount"],
                                    categoryIcon: dateTransactions[index]
                                                ["type"] ==
                                            "ENTRATA"
                                        ? Provider.of<CategoryProvider>(context)
                                                .incomesCategory[
                                            dateTransactions[index]
                                                ["categoryId"]]!["icon"]
                                        : Provider.of<CategoryProvider>(context)
                                                .expensesCategory[
                                            dateTransactions[index]
                                                ["categoryId"]]!["icon"],
                                    date: dateTransactions[index]["date"]
                                        .toDate());
                              }),
                        ),
                      ],
                    ),
                  );
                });
          }
          return const Text("CARICO........");
        });
  }
}
