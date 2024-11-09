// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/add_transaction_screen.dart';
import 'package:mobile/utils/utils.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
    required this.user,
  });
  final DocumentSnapshot<Object?> user;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  
  @override
  Widget build(BuildContext context) {
    double difference = widget.user["totalBilance"].toDouble() -
                widget.user["totalWallet"].toDouble();
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 50, left: 40, right: 40),
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
                "€ ${formatDoubleToString(widget.user["totalBilance"].toDouble())}",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceContainer),
                      elevation: const WidgetStatePropertyAll(0),
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 2, vertical: 2)),
                      shape: const WidgetStatePropertyAll(CircleBorder())),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTransactionScreen(),
                        ));
                  },
                  child: Icon(
                    Icons.add_rounded,
                    size: 45,
                    color: Theme.of(context).colorScheme.onPrimary,
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
          difference != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Il totale dei portafogli è ${formatDoubleToString(widget.user["totalWallet"].toDouble())}",
                      style: TextStyle(
                          fontSize: 13, color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    Text(
                        "La differenza è di ${formatDoubleToString(difference)}",
                        style: TextStyle(
                            fontSize: 13,color: Theme.of(context).colorScheme.onSecondary))
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
