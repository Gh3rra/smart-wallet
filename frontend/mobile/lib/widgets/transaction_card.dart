import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/screens/transactions/transaction_detail_screen.dart';
import 'package:mobile/widgets/category_icon.dart';
import 'package:mobile/utils/utils.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.categoryIcon,
    required this.transactionId,
    this.fetchTransactions,
    required this.categoryId,
  });
  final String transactionId;
  final String title;
  final double amount;
  final String type;
  final String category;
  final int categoryIcon;
  final String categoryId;
  final DateTime date;
  final Function()? fetchTransactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 90,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(
                  fetchTransactions: fetchTransactions,
                  transactionId: transactionId,
                  title: title,
                  amount: amount,
                  category: category,
                  categoryIcon: categoryIcon,
                  categoryId: categoryId,
                  type: type,
                  date: date,
                ),
              ));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ICON
            CategoryIcon(
              categoryIcon: categoryIcon,
              category: category,
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
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: type == "ENTRATA"
                              ? Text("+${formatDoubleToString(amount)} €",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary))
                              : Text("-${formatDoubleToString(amount)} €",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
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
                          fontSize: 16))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
