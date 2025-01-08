/* import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobile/screens/transactions/animated_title.dart';
import 'package:mobile/screens/transactions/date_scroll_transactions_widget.dart';
import 'package:mobile/screens/transactions/transactions_generator.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/date_transaction_widget.dart';
import 'package:mobile/widgets/transaction_card.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key, required this.querySnapshot});
  final Map<String, dynamic> querySnapshot;

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  List transactions = [];
  List dailyTransactions = [];
  List<String> months = [];
  List<GlobalKey> keys = [];
  double dailyAmount = 0;
  bool mergedNeed = true;
  bool isScrolled = false;
  double paddingTitle = 0;
  late DocumentSnapshot lastDocument;
  ScrollController scrollController = ScrollController();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool transactionsExist = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    /*  scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchOtherTransactions();
      }
    }); */
    fetchTransactions();
  }

  fetchTransactions() async {
    transactions.clear();
    dailyTransactions.clear();
    //GET N TRANSACTIONS
    List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> transactionsDocs =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("transactions")
            //CAZZO
            .where("categoryId", whereIn: [
              widget.querySnapshot["credit"],
              widget.querySnapshot["debit"]
            ])
            .orderBy("date", descending: true)
            .get()
            .then(
              (value) => value.docs,
            );
    List<DateTime> monthsTemp = [];
    if (transactionsDocs.isNotEmpty) {
      transactionsDocs.forEachIndexed(
        (index, element) {
          DateTime date = DateTime(
              element["date"].toDate().year, element["date"].toDate().month);
          if (!monthsTemp.contains(date)) {
            monthsTemp.add(date);
          }

          if (dailyTransactions.isNotEmpty) {
            DateTime prevDate = dailyTransactions.last["date"].toDate();
            if (DateUtils.isSameDay(date, prevDate)) {
              //log(" STESSA DATA");
              dailyTransactions.add(element);
              element["type"] == "USCITA"
                  ? dailyAmount -= element["amount"]
                  : dailyAmount += element["amount"];

              if (index == transactionsDocs.length - 1) {
                transactions.add({
                  "groupDate": date,
                  "totalAmount": dailyAmount,
                  "transactions": dailyTransactions.toList()
                });
              }
              return;
            }

            transactions.add({
              "groupDate": prevDate,
              "totalAmount": dailyAmount,
              "transactions": dailyTransactions.toList()
            });
            dailyTransactions.clear();
            dailyAmount = 0;
            //log("NUOVA DATA");

            dailyTransactions.add(element);
            element["type"] == "USCITA"
                ? dailyAmount -= element["amount"]
                : dailyAmount += element["amount"];
            if (index == transactionsDocs.length - 1) {
              transactions.add({
                "groupDate": date,
                "totalAmount": dailyAmount,
                "transactions": dailyTransactions.toList()
              });
            }
            return;
          }
          //log("PRIMO ELEMENTO");
          dailyTransactions.add(element);
          element["type"] == "USCITA"
              ? dailyAmount -= element["amount"]
              : dailyAmount += element["amount"];
          if (index == transactionsDocs.length - 1) {
            transactions.add({
              "groupDate": date,
              "totalAmount": dailyAmount,
              "transactions": dailyTransactions.toList()
            });
          }
        },
      );
      lastDocument = transactionsDocs[transactionsDocs.length - 1];
      for (var element in monthsTemp) {
        if (element.year == DateTime.now().year) {
          months.add(DateFormat("MMMM", "it_IT")
                  .format(element)
                  .toString()
                  .substring(0, 1)
                  .toUpperCase() +
              DateFormat("MMMM", "it_IT")
                  .format(element)
                  .toString()
                  .substring(1));
        } else {
          months.add(DateFormat("MMMM yyyy", "it_IT")
                  .format(element)
                  .toString()
                  .substring(0, 1)
                  .toUpperCase() +
              DateFormat("MMMM yyyy", "it_IT")
                  .format(element)
                  .toString()
                  .substring(1));
        }
      }
    } else {
      transactionsExist = false;
    }
    setState(() {});
  }

  /*  fetchOtherTransactions() async {
    List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> transactionsDocs =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user)
            .collection("transactions")
            .orderBy("date", descending: true)
            .startAfterDocument(lastDocument)
            .limit(20)
            .get()
            .then(
              (value) => value.docs,
            );

    transactionsDocs.forEachIndexed(
      (index, element) {
        //log("APPENMA AGGIUNTI $index + ${element["title"]}: ${transactions.toString()}");
        //log("${transactions.toString()} + ${element["title"]}");
        DateTime prevDate = dailyTransactions.last["date"].toDate();
        if (mergedNeed == true) {
          if (DateUtils.isSameDay(element["date"].toDate(),
              dailyTransactions.last["date"].toDate())) {
            //log("DATA UGUALE");
            dailyTransactions.add(element);
            element["type"] == "USCITE"
                ? dailyAmount -= element["amount"]
                : dailyAmount += element["amount"];
            if (index == transactionsDocs.length - 1) {
              for (var e in transactions) {
                if (DateUtils.isSameDay(
                    e["groupDate"], dailyTransactions.last["date"].toDate())) {
                  //log("sono nel for amico");
                  e["transactions"] = dailyTransactions;
                }
              }
              return;
            }
            return;
          }

          for (var e in transactions) {
            if (DateUtils.isSameDay(
                e["groupDate"], dailyTransactions.last["date"].toDate())) {
              //log("sono nel for amico");
              e["transactions"] = dailyTransactions.toList();
              e["totalAmount"] = dailyAmount;
            }
          }

          dailyTransactions.clear();
          dailyAmount = 0;
          dailyTransactions.add(element);
          //log(dailyTransactions[0]["title"]);
          element["type"] == "USCITE"
              ? dailyAmount -= element["amount"]
              : dailyAmount += element["amount"];
          if (index == transactionsDocs.length - 1) {
            transactions.add({
              "groupDate": element["date"].toDate(),
              "totalAmount": dailyAmount,
              "transactions": dailyTransactions.toList()
            });
          }
          mergedNeed = false;
          return;
        }
        if (DateUtils.isSameDay(element["date"].toDate(), prevDate)) {
          dailyTransactions.add(element);
          element["type"] == "USCITE"
              ? dailyAmount -= element["amount"]
              : dailyAmount += element["amount"];

          if (index == transactionsDocs.length - 1) {
            transactions.add({
              "groupDate": element["date"].toDate(),
              "totalAmount": dailyAmount,
              "transactions": dailyTransactions.toList()
            });
          }
          return;
        }

        transactions.add({
          "groupDate": prevDate,
          "totalAmount": dailyAmount,
          "transactions": dailyTransactions.toList()
        });
        //log("APPENMA AGGIUNTI $index: ${transactions.toString()}");
        dailyTransactions.clear();
        dailyAmount = 0;
        dailyTransactions.add(element);
        element["type"] == "USCITE"
            ? dailyAmount -= element["amount"]
            : dailyAmount += element["amount"];
        if (index == transactionsDocs.length - 1) {
          transactions.add({
            "groupDate": element["date"].toDate(),
            "totalAmount": dailyAmount,
            "transactions": dailyTransactions.toList()
          });
        }
      },
    );
    lastDocument = transactionsDocs[transactionsDocs.length - 1];
    mergedNeed = true;
    setState(() {});
  }
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.passthrough, children: [
        CustomScrollView(controller: scrollController, slivers: [
          AnimatedTitle(
            text: "Crediti e debiti",
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
                    Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            hintText: "Cerca",
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            filled: true,
                            hintStyle: const TextStyle(color: onTertiary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: onTertiary,
                            )),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    transactionsExist == false
                        ? const Text("Nessuna transazione presente.")
                        : TransactionsGenerator(
                            fetchTransactions: fetchTransactions,
                            setKey: (i) {
                              if (i == 0) {
                                GlobalKey key = GlobalKey();
                                keys.add(key);
                                return key;
                              } else if (transactions[i]["groupDate"].month !=
                                  transactions[i - 1]["groupDate"].month) {
                                GlobalKey key = GlobalKey();
                                keys.add(key);
                                return key;
                              }
                              return null;
                            },
                            transactions: transactions as Map<String, Map<String,dynamic>>,
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
 */