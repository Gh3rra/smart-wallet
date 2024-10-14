import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/utils/utils.dart';

class DateTransactionWidget extends StatelessWidget {
  const DateTransactionWidget(
      {super.key, required this.date, required this.totalAmount});
  final DateTime date;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat("dd/MM/yyyy").format(date),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "${formatDoubleToString(totalAmount)} €",
            style: const TextStyle(
                color: onTertiary, fontSize: 16, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
