import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/screens/graphs/components/date_graphs.dart';
import 'package:mobile/screens/settings/category/category_settings_screen.dart';
import 'package:mobile/screens/settings/components/setting_widget.dart';
import 'package:mobile/screens/settings/general/general_settings_screen.dart';
import 'package:mobile/screens/settings/import_export/import_export_screen.dart';

class GraphsScreen extends StatefulWidget {
  /// Pagina dei grafici
  const GraphsScreen({super.key});

  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        // Title
        title: Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Analisi",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
          child: StreamBuilder(
              stream: Db().getTransactions(),
              builder: (context, snapshot) {
                return StreamBuilder(
                    stream: Db().getCategoriesStream(),
                    builder: (context, categoriesSnapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          categoriesSnapshot.connectionState ==
                              ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        );
                      }
                      if ((categoriesSnapshot.hasData &&
                              categoriesSnapshot.data!.isNotEmpty) &&
                          (snapshot.hasData && snapshot.data!.isNotEmpty)) {
                        final categoriesList = categoriesSnapshot.data!;
                        final transactionsList = snapshot.data!.map(
                          (e) {
                            final transaction = {
                              ...e,
                              "category": categoriesList
                                  .where(
                                    (element) =>
                                        element["id"] == e["category_id"],
                                  )
                                  .first
                            };
                            return TransactionModel.fromMap(transaction);
                          },
                        ).toList();
                        return  DateGraphs(transactions: transactionsList);
                      }
                      return const SizedBox();
                    });
              })),
    );
  }
}
