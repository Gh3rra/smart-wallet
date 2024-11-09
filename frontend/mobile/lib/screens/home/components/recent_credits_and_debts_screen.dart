import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/provider/category_provider.dart';
import 'package:mobile/screens/transactions/transactions_screen.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/category.dart';
import 'package:mobile/widgets/transaction_card.dart';
import 'package:provider/provider.dart';

class RecentCreditsAndDebtsScreen extends StatefulWidget {
  const RecentCreditsAndDebtsScreen(
      {super.key,
      required this.incomesCategory,
      required this.expensesCategory,
      required this.getDebitAndCreditId});
  final Map<String, Map<String, dynamic>> incomesCategory;
  final Map<String, Map<String, dynamic>> expensesCategory;
  final Function() getDebitAndCreditId;

  @override
  State<RecentCreditsAndDebtsScreen> createState() =>
      _RecentCreditsAndDebtsScreenState();
}

class _RecentCreditsAndDebtsScreenState
    extends State<RecentCreditsAndDebtsScreen> {
  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);

    return FutureBuilder<Map<String, dynamic>>(
        future: widget.getDebitAndCreditId(),
        builder: (context, querySnapshot) {
          if (querySnapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
                stream: Db()
                    .userDoc
                    .collection("transactions")
                    .where("categoryId", whereIn: [
                      querySnapshot.data!["credit"],
                      querySnapshot.data!["debit"]
                    ])
                    .orderBy("date", descending: true)
                    .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SizedBox();
                  }
                  if (categoryProvider.isLoading != true) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 25),
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Crediti recenti",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                       minimumSize: const WidgetStatePropertyAll(Size(0, 0),),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Theme.of(context)
                                                .colorScheme
                                                .surfaceContainer),
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        padding: const WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(horizontal: 8,vertical: 6)),
                                        shape: const WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))))),
                                    onPressed: () {
                                      /* Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                CreditsScreen(
                                                              querySnapshot:
                                                                  querySnapshot.data!,
                                                            ),
                                                          )); */
                                    },
                                    child: Text(
                                      "Vedi tutte",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ))
                              ],
                            ),
                          ),
                          ListView.builder(
                              padding: const EdgeInsets.only(top: 10),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final transactionDoc =
                                    snapshot.data!.docs[index];
                                final transaction =
                                    transactionDoc.data() as Map;
                                final categoryPath =
                                    transaction["type"] == "ENTRATA"
                                        ? "incomesCategory"
                                        : "expensesCategory";
                                return TransactionCard(
                                   borderRadius: BorderRadius.circular(20),
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                    transactionId: transactionDoc.id,
                                    title: transaction["title"],
                                    amount: transaction["amount"],
                                    type: transaction["type"],
                                    categoryIcon:
                                        transaction["type"] == "ENTRATA"
                                            ? widget.incomesCategory[
                                                transaction[
                                                    "categoryId"]]!["icon"]
                                            : widget.expensesCategory[
                                                transaction[
                                                    "categoryId"]]!["icon"],
                                    date: transaction["date"].toDate());
                              }),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                });
          }

          return const SizedBox();
        });
  }
}
