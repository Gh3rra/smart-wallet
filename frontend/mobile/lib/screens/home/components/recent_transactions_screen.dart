import 'package:flutter/material.dart';
import 'package:mobile/common/services/transactions_local_storage.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/common/widgets/transaction_card.dart';
import 'package:mobile/prova.dart';
import 'package:mobile/screens/transactions/transactions_screen.dart';

class RecentTransactionsScreen extends StatefulWidget {
  const RecentTransactionsScreen({
    super.key,
  });

  @override
  State<RecentTransactionsScreen> createState() =>
      _RecentTransactionsScreenState();
}

class _RecentTransactionsScreenState extends State<RecentTransactionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsStream = Db().getTransactions();

    return StreamBuilder(
        stream: transactionsStream,
        builder: (context, transactionsSnapshot) {
          if (transactionsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!transactionsSnapshot.hasData ||
              transactionsSnapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Text(
                "Nessuna transazione. Aggiungine una!",
                textAlign: TextAlign.center,
              ),
            );
          }
          if (transactionsSnapshot.hasData &&
              transactionsSnapshot.data!.isNotEmpty) {
            return StreamBuilder(
                stream: Db().getCategoriesStream(),
                builder: (context, categoriesSnapshot) {
                  if (categoriesSnapshot.hasData &&
                      categoriesSnapshot.data!.isNotEmpty) {
                    final categoriesList = categoriesSnapshot.data!;
                    final transactions = transactionsSnapshot.data!.map(
                      (e) {
                        final transaction = {
                          ...e,
                          "category": categoriesList
                              .where(
                                (element) => element["id"] == e["category_id"],
                              )
                              .first
                        };
                        return TransactionModel.fromMap(transaction);
                      },
                    ).toList();

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
                                  "Transazioni recenti",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        minimumSize:
                                            const WidgetStatePropertyAll(
                                          Size(0, 0),
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Theme.of(context)
                                                .colorScheme
                                                .surfaceContainer),
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        padding: const WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6)),
                                        shape: const WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))))),
                                    onPressed: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TransactionsScreen(),
                                            ));
                                      });
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
                              itemCount: transactions.length < 3
                                  ? transactions.length
                                  : 3,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                return TransactionCard(
                                  transactionStream: transactionsStream.map(
                                    (event) => event.firstWhere(
                                      (element) =>
                                          element["id"] == transaction.id,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  transaction: transaction,
                                );
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
