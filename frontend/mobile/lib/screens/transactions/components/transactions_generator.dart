// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/screens/transactions/components/date_transaction_widget.dart';
import 'package:mobile/common/widgets/transaction_card.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsGenerator extends StatefulWidget {
  const TransactionsGenerator({
    super.key,
    required this.transactions,
    required this.setKey,
    required this.transactionsStream,
  });
  final SupabaseStreamBuilder transactionsStream;

  final Map<String, Map<String, dynamic>> transactions;
  final Function(int i) setKey;

  @override
  State<TransactionsGenerator> createState() => _TransactionsGeneratorState();
}

class _TransactionsGeneratorState extends State<TransactionsGenerator> {
  getPadding(isFirst, isLast) {
    if (isFirst) {
      if (isLast) {
        return const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10);
      }
      return const EdgeInsets.only(top: 10, left: 25, right: 25);
    }
    if (isLast) {
      return const EdgeInsets.only(left: 25, right: 25, bottom: 10);
    }
    return const EdgeInsets.only(left: 25, right: 25);
  }

  getRadius(isFirst, isLast) {
    if (isFirst) {
      if (isLast) {
        return BorderRadius.circular(20);
      }
      return const BorderRadius.vertical(top: Radius.circular(20));
    }
    if (isLast) {
      return const BorderRadius.vertical(bottom: Radius.circular(20));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Stopwatch generator = Stopwatch()..start();
    print("Mi trovo all'interno della build di transaction generator");

    List<String> dates = widget.transactions.keys.toList();
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dates.length, //filteredTrans.length,
        itemBuilder: (context, i) {
          String date = dates[i];
          List dateTransactions = widget.transactions[date]!["transactions"];

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            key: i == 0 ||
                    !DateUtils.isSameMonth(
                        DateFormat("dd/MM/yyyy").parse(dates[i]),
                        DateFormat("dd/MM/yyyy").parse(dates[i - 1]))
                ? widget.setKey(i)
                : null,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DateTransactionWidget(
                      date: date,
                      totalAmount: widget.transactions[date]!["totalAmount"]),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        spreadRadius: -8,
                        blurRadius: 30)
                  ], color: Colors.transparent),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                          .copyWith(bottom: 20),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dateTransactions.length,
                      itemBuilder: (context, index) {
                        bool isFirst = index == 0;
                        bool isLast = index == dateTransactions.length - 1;
                        TransactionModel transaction = dateTransactions[index];
                        EdgeInsets padding = getPadding(isFirst, isLast);

                        BorderRadius? borderRadius = getRadius(isFirst, isLast);
                        if (index == dateTransactions.length - 1) {
                          print("Transazioni generate in ${generator.elapsed}");
                        }
                        return TransactionCard(
                          transactionStream: widget.transactionsStream.map(
                            (event) => event.firstWhere(
                              (element) => element["id"] == transaction.id,
                            ),
                          ),
                          transaction: transaction,
                          borderRadius: borderRadius,
                          padding: padding,
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
