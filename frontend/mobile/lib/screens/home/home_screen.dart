import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/provider/category_provider.dart';
import 'package:mobile/screens/home/components/home_header.dart';
import 'package:mobile/screens/home/components/recent_credits_and_debts_screen.dart';
import 'package:mobile/screens/home/components/recent_transactions_screen.dart';
import 'package:mobile/screens/home/components/wallet_section.dart';
import 'package:mobile/widgets/add_transaction_screen.dart';
import 'package:mobile/screens/transactions/components/credits_screen.dart';
import 'package:mobile/screens/transactions/transactions_screen.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/add_wallet_widget.dart';
import 'package:mobile/widgets/transaction_card.dart';
import 'package:mobile/widgets/wallet_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = AuthService().userId;
  Map<String, Map<String, dynamic>> incomesCategory = {};
  Map<String, Map<String, dynamic>> expensesCategory = {};

  Future<Map<String, dynamic>> getDebitAndCreditId() async {
    var debitQuery = await Db()
        .userDoc
        .collection("incomesCategory")
        .where("name", isEqualTo: "DEBITO")
        .get();
    var creditQuery = await Db()
        .userDoc
        .collection("expensesCategory")
        .where("name", isEqualTo: "CREDITO")
        .get();

    String debitId = "";
    String creditId = "";

    if (debitQuery.docs.isNotEmpty) {
      debitId = debitQuery.docs.first.id;
    }
    if (creditQuery.docs.isNotEmpty) {
      creditId = creditQuery.docs.first.id;
    }

    return {"debit": debitId, "credit": creditId};
  }

  @override
  void initState() {
    super.initState();
    //fetchCategories();
  }

  /* fetchCategories() async {
    print("Fetching categories");
    setState(() {
      fetchingCategory = true;
    });
    var incomes = await Db().userDoc.collection("incomesCategory").get();
    var expenses = await Db().userDoc.collection("expensesCategory").get();
    for (var element in incomes.docs) {
      incomesCategory[element.id] = {
        "name": element["name"],
        "icon": element["icon"],
      };
    }
    for (var element in expenses.docs) {
      expensesCategory[element.id] = {
        "name": element["name"],
        "icon": element["icon"],
      };
    }
    setState(() {
      fetchingCategory = false;
    });
    print("Fetching completo");
  }
 */
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userStreamer = Db().userDoc.snapshots();
    incomesCategory = Provider.of<CategoryProvider>(context).incomesCategory;
    expensesCategory = Provider.of<CategoryProvider>(context).expensesCategory;

    print("ora buildo");

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
                  HomeHeader(
                    user: user,
                  ),
                  //WALLET SECTION
                  const WalletSection(),
                  //RECENT TRANSACTIONS SECTION
                  RecentTransactionsScreen(
                      incomesCategory: incomesCategory,
                      expensesCategory: expensesCategory,
                      ),
                  //RECENT CREDITS SECTION
                  RecentCreditsAndDebtsScreen(
                      incomesCategory: incomesCategory,
                      expensesCategory: expensesCategory,
                      
                      getDebitAndCreditId: getDebitAndCreditId)
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
