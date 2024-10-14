// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/date_transaction_widget.dart';
import 'package:mobile/widgets/transaction_card.dart';

class TransactionsGenerator extends StatefulWidget {
  const TransactionsGenerator(
      {super.key,
      required this.transactions,
      required this.setKey,
      required this.fetchTransactions});
  final List<dynamic> transactions;
  final GlobalKey? Function(int i) setKey;
  final Function() fetchTransactions;

  @override
  State<TransactionsGenerator> createState() => _TransactionsGeneratorState();
}

class _TransactionsGeneratorState extends State<TransactionsGenerator> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.transactions.length, //filteredTrans.length,
        itemBuilder: (context, i) {
          List dateTransactions = widget.transactions[i]["transactions"];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            key: widget.setKey(i),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DateTransactionWidget(
                      date: widget.transactions[i]["groupDate"],
                      totalAmount: (widget.transactions[i]["totalAmount"])),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: -8,
                            blurRadius: 30)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.secondary),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                          .copyWith(bottom: 20),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dateTransactions.length,
                      itemBuilder: (context, index) {
                        return TransactionCard(
                            fetchTransactions: widget.fetchTransactions,
                            transactionId: dateTransactions[index].id,
                            type: dateTransactions[index]["type"],
                            title: dateTransactions[index]["title"],
                            amount: dateTransactions[index]["amount"],
                            category: dateTransactions[index]["category"]
                                ["name"],
                            categoryIcon: dateTransactions[index]["category"]
                                ["icon"],
                            categoryId: dateTransactions[index]["category"]
                                ["id"],
                            date: dateTransactions[index]["date"].toDate());
                      }),
                ),
              ],
            ),
          );
        });
  }
}
