import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/transactions/credits_screen.dart';
import 'package:mobile/screens/transactions/add_transaction_screen.dart';
import 'package:mobile/screens/transactions/transactions_screen.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/widgets/add_wallet_widget.dart';
import 'package:mobile/widgets/transaction_card.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/wallet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = AuthService().userId;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userStreamer =
        FirebaseFirestore.instance.collection("users").doc(userId).snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: userStreamer,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TOTAL BILANCE
                  Container(
                    padding: const EdgeInsets.only(
                        top: 80, bottom: 50, left: 40, right: 40),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            blurRadius: 30,
                            spreadRadius: -8),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "€ ${formatDoubleToString(user["totalBilance"].toDouble())}",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer),
                                    elevation: const WidgetStatePropertyAll(0),
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2)),
                                    shape: const WidgetStatePropertyAll(
                                        CircleBorder())),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddTransactionScreen(),
                                      ));
                                },
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 45,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ))
                          ],
                        ),
                        Text(
                          "Bilancio totale",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  //WALLET SECTION
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 40, right: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "I tuoi portafogli",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer),
                                    elevation: const WidgetStatePropertyAll(0),
                                    padding: WidgetStatePropertyAll(
                                        const EdgeInsets.symmetric(
                                                horizontal: 3)
                                            .copyWith(left: 8)),
                                    shape: const WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))))),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const AddWalletWidget(),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Aggiungi",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.add_rounded,
                                      size: 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        height: 150,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(userId)
                                .collection("wallets")
                                .orderBy("order")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final walletDoc =
                                          snapshot.data!.docs[index];
                                      final obj = walletDoc.data() as Map;
                                      return WalletCard(
                                        walletId: walletDoc.id,
                                        firstCard: index == 0,
                                        lastCard: index ==
                                            snapshot.data!.docs.length - 1,
                                        amount: obj["amount"].toDouble(),
                                        name: obj["name"],
                                        color: Color(obj["color"]),
                                      );
                                    });
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                      ),
                    ],
                  ),
                  //RECENT TRANSACTIONS SECTION
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(userId)
                          .collection("transactions")
                          .orderBy("date", descending: true)
                          .limit(3)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 50),
                            child: Text(
                              "Nessuna transazione. Aggiungine una!",
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Transazioni recenti",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainer),
                                            elevation:
                                                const WidgetStatePropertyAll(0),
                                            padding:
                                                const WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: 8)),
                                            shape: const WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))))),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const TransactionsScreen(),
                                              ));
                                        },
                                        child: Text(
                                          "Vedi tutte",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ))
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ListView.builder(
                                        padding: const EdgeInsets.only(top: 10),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final transactionDoc =
                                              snapshot.data!.docs[index];
                                          final obj =
                                              transactionDoc.data() as Map;

                                          return TransactionCard(
                                              transactionId: transactionDoc.id,
                                              title: obj["title"],
                                              amount: obj["amount"],
                                              type: obj["type"],
                                              category: obj["category"]["name"],
                                              categoryIcon: obj["category"]
                                                  ["icon"],
                                              categoryId: obj["category"]["id"],
                                              date: obj["date"].toDate());
                                        })),
                              ],
                            ),
                          );
                        }

                        return const Text("ERROR!");
                      }),

                  //RECENT CREDITS SECTION
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(userId)
                          .collection("transactions")
                          .where("category.name", isEqualTo: "CREDITO")
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return const SizedBox();
                        }
                        if (snapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 25),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Crediti recenti",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainer),
                                            elevation:
                                                const WidgetStatePropertyAll(0),
                                            padding:
                                                const WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        horizontal: 8)),
                                            shape: const WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))))),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CreditsScreen(),
                                              ));
                                        },
                                        child: Text(
                                          "Vedi tutte",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ))
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ListView.builder(
                                        padding: const EdgeInsets.only(top: 10),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final transactionDoc =
                                              snapshot.data!.docs[index];
                                          final obj =
                                              transactionDoc.data() as Map;
                                          return TransactionCard(
                                              transactionId: transactionDoc.id,
                                              title: obj["title"],
                                              amount: obj["amount"],
                                              type: obj["type"],
                                              category: obj["category"]["name"],
                                              categoryIcon: obj["category"]
                                                  ["icon"],
                                              categoryId: obj["category"]["id"],
                                              date: obj["date"].toDate());
                                        })),
                              ],
                            ),
                          );
                        }

                        return const Text("ERROR!");
                      })
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          return const Center(
            child: Text("ERROR"),
          );
        });
  }
}
