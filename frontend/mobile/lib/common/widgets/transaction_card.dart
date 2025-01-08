import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/widgets/transaction_detail_screen.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/theme/theme_manager.dart';
import 'package:mobile/common/widgets/category_icon.dart';
import 'package:mobile/common/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    this.fetchTransactions,
    this.padding,
    this.borderRadius,
    required this.transaction,
    required this.transactionStream,
  });
  final Stream<Map<String, dynamic>> transactionStream;
  final TransactionModel transaction;
  final Function()? fetchTransactions;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailScreen(
                    transactionStream: transactionStream,
                    fetchTransactions: fetchTransactions,
                    transaction: transaction,
                  ),
                ));
          });
        },
        child: Container(
          padding: padding,
          height: 90,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ICON
              CategoryIcon(
                category: transaction.category,
                type: transaction.type,
                size: 25,
                margin: const EdgeInsets.only(right: 15),
              ),
              //TEXT
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // NAME AND AMOUNT
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              Provider.of<ThemeManager>(context).capsLock ==
                                      true
                                  ? transaction.title.toUpperCase()
                                  : transaction.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: transaction.type == Type.entrata
                                ? Text(
                                    "+${formatDoubleToString(transaction.amount)} €",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary))
                                : Text(
                                    "-${formatDoubleToString(transaction.amount)} €",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary)),
                          )
                        ],
                      ),
                    ),

                    //DATE
                    Text(DateFormat("dd/MM/yyyy").format(transaction.date),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
