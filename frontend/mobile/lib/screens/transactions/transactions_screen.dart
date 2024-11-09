// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobile/screens/transactions/components/scrollable_title.dart';
import 'package:mobile/screens/transactions/components/date_scroll_transactions_widget.dart';
import 'package:mobile/screens/transactions/components/search_bar_widget.dart';
import 'package:mobile/screens/transactions/components/transactions_generator.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/date_transaction_widget.dart';
import 'package:mobile/widgets/transaction_card.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    super.key,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<Map<String, Map<String, dynamic>>> transactions;
  List<DateTime> months = [];
  List<GlobalKey> keys = [];
  double dailyAmount = 0;
  double paddingTitle = 0;
  late DocumentSnapshot lastDocument;
  ScrollController scrollController = ScrollController();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool transactionsExist = true;

  Future<Map<String, Map<String, dynamic>>> fetchTransactions() async {
    Stopwatch stop = Stopwatch()..start();
    Map<String, Map<String, dynamic>> tempTransactions = {};
    //GET N TRANSACTIONS
    Stopwatch stopFire = Stopwatch()..start();

    List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> transactionsDocs =
        await Db()
            .userDoc
            .collection("transactions")
            .orderBy("date", descending: true)
            .get()
            .then(
              (value) => value.docs,
            );
    stopFire.stop();
    print("Firestore finito in ${stopFire.elapsed}");
    Stopwatch stopARRAY = Stopwatch()..start();

    if (transactionsDocs.isNotEmpty) {
      for (var element in transactionsDocs) {
        DateTime date = element["date"].toDate();
        String day = DateFormat("dd/MM/yyyy").format(date);
        if (!months.contains(DateTime(date.year, date.month))) {
          months.add(DateTime(date.year, date.month));
        }
        if (!tempTransactions.containsKey(day)) {
          tempTransactions[day] = {"transactions": [], "totalAmount": 0.0};
        }
        tempTransactions[day]!["transactions"]!.add(element);
        tempTransactions[day]!["totalAmount"] += element["amount"];
      }

      //lastDocument = transactionsDocs[transactionsDocs.length - 1];

      setState(() {});
      stopARRAY.stop();
      print("Array finito in ${stopARRAY.elapsed}");
    }
    stop.stop();
    print("Fetch finito in ${stop.elapsed}");

    return tempTransactions;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    transactions = fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
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
                        transactionsExist == false
                            ? const Text("Nessuna transazione presente.")
                            : TransactionsGenerator(
                       
                                fetchTransactions: fetchTransactions,
                                setKey: (i) {
                                  GlobalKey key = GlobalKey();
                                  keys.add(key);
                                  return key;
                                },
                                transactions: transactions,
                              ),
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
