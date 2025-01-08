// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/screens/transactions/components/scrollable_title.dart';
import 'package:mobile/screens/transactions/components/search_bar_widget.dart';
import 'package:mobile/screens/transactions/components/date_scroll_transactions_widget.dart';
import 'package:mobile/screens/transactions/components/transactions_generator.dart';
import 'package:mobile/common/services/db.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    super.key,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Map<String, Map<String, dynamic>> transactions;
  List<DateTime> months = [];
  List<GlobalKey> keys = [];
  ScrollController scrollController = ScrollController();
  bool transactionsExist = true;
  
  Map<String, Map<String, dynamic>> groupTransactions(
      {required List<TransactionModel> transactions}) {
    Map<String, Map<String, dynamic>> tempTransactions = {};
    //GET N TRANSACTIONS

    if (transactions.isNotEmpty) {
      for (var element in transactions) {
        DateTime date = element.date;
        String day = DateFormat("dd/MM/yyyy").format(date);
        if (!months.contains(DateTime(date.year, date.month))) {
          months.add(DateTime(date.year, date.month));
        }
        if (!tempTransactions.containsKey(day)) {
          tempTransactions[day] = {"transactions": [], "totalAmount": 0.0};
        }
        tempTransactions[day]!["transactions"]!.add(element);
        tempTransactions[day]!["totalAmount"] += element.amount;
      }
    }

    return tempTransactions;
  }

  @override
  void initState() {
    print("SALVE E BENVENTUO IN TRANSACTION SCREEN");
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsStream = Db().getTransactions();
    print("Mi trovo all'interno della build di transaction screen");
    return Scaffold(
      body: Stack(fit: StackFit.passthrough, children: [
        CustomScrollView(
            scrollBehavior: const CupertinoScrollBehavior(),
            controller: scrollController,
            slivers: [
              ScrollableTitle(
                text: "Transazioni",
                scrollController: scrollController,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    alignment: Alignment.topCenter,
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SEARCH BAR
                        const SearchBarWidget(),

                        const SizedBox(
                          height: 30,
                        ),

                        StreamBuilder(
                            stream: transactionsStream,
                            builder: (context, transactionsSnapshot) {
                              if (transactionsSnapshot.hasData &&
                                  transactionsSnapshot.data!.isNotEmpty) {
                                return StreamBuilder(
                                    stream: Db().getCategoriesStream(),
                                    builder: (context, categoriesSnapshot) {
                                      if (categoriesSnapshot.hasData &&
                                          categoriesSnapshot.data!.isNotEmpty) {
                                        final categoriesList =
                                            categoriesSnapshot.data!;
                                        final transactionsList =
                                            transactionsSnapshot.data!.map(
                                          (e) {
                                            final transaction = {
                                              ...e,
                                              "category": categoriesList
                                                  .where(
                                                    (element) =>
                                                        element["id"] ==
                                                        e["category_id"],
                                                  )
                                                  .first
                                            };
                                            return TransactionModel.fromMap(
                                                transaction);
                                          },
                                        ).toList();
                                        transactions = groupTransactions(
                                            transactions: transactionsList);
                                        return TransactionsGenerator(
                                          transactionsStream:
                                              transactionsStream,
                                          setKey: (i) {
                                            GlobalKey key = GlobalKey();
                                            keys.add(key);
                                          },
                                          transactions: transactions,
                                        );
                                      }
                                      return const SizedBox();
                                    });
                              }
                              return const Text(
                                  "Nessuna transazione presente.");
                            }),
                      ],
                    ),
                  ),
                ]),
              )
            ]),
        DateScrollTransactionsWidget(
            keys: keys, months: months, scrollController: scrollController)
      ]),
    );
  }
}
