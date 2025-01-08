import 'package:flutter/material.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/model/user_model.dart';

import 'package:mobile/screens/home/components/home_header.dart';
import 'package:mobile/screens/home/components/recent_credits_and_debts_screen.dart';
import 'package:mobile/screens/home/components/recent_transactions_screen.dart';
import 'package:mobile/screens/home/wallet_section.dart';

import 'package:mobile/common/services/db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    print(Theme.of(context).colorScheme.onPrimary.value);
    return StreamBuilder(
        stream: Db().getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = UserModel.fromMap(snapshot.data!.first);
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TOTAL BILANCE
                  HomeHeader(
                    user: user,
                  ),
                  // WALLET SECTION
                  const WalletSection(),
                  // RECENT TRANSACTIONS SECTION
                  const RecentTransactionsScreen(),
                  // RECENT CREDITS SECTION
                  const RecentCreditsAndDebtsScreen()
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurface),
            );
          }

          return const Center(
            child: Text("ERROR"),
          );
        });
  }
}
