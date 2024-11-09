import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/transaction_detail_screen.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/theme/theme_manager.dart';
import 'package:mobile/widgets/category_icon.dart';
import 'package:mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.transactionId,
    this.fetchTransactions,
    required this.categoryIcon,
    this.padding,
    this.borderRadius,
  });
  final String transactionId;
  final String title;
  final double amount;
  final String type;
  final int categoryIcon;
  final DateTime date;
  final Function()? fetchTransactions;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    print("TRANSACTION CARD");
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
                    fetchTransactions: fetchTransactions,
                    transactionId: transactionId,
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
                categoryIcon: categoryIcon,
                type: type,
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
                              Provider.of<ThemeManager>(context).isCapsLock ==
                                      true
                                  ? title.toUpperCase()
                                  : title,
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
                            child: type == "ENTRATA"
                                ? Text("+${formatDoubleToString(amount)} €",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary))
                                : Text("-${formatDoubleToString(amount)} €",
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
                    Text(DateFormat("dd/MM/yyyy").format(date),
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
