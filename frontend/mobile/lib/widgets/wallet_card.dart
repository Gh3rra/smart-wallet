import 'package:flutter/material.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/wallet_edit_widget.dart';

class WalletCard extends StatefulWidget {
  const WalletCard({
    super.key,
    required this.walletId,
    required this.name,
    required this.amount,
    required this.color,
    required this.firstCard,
    required this.lastCard,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
  final String walletId;
  final String name;
  final double amount;
  final Color color;
  final bool firstCard;
  final bool lastCard;
}

class _WalletCardState extends State<WalletCard> {
  @override
  Widget build(BuildContext context) {
    Color textColor =
        widget.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      margin: EdgeInsets.only(
          left: widget.firstCard == true ? 25 : 20,
          right: widget.lastCard == true ? 25 : 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) => WalletEditWidget(
              walletId: widget.walletId,
              name: widget.name,
              amount: widget.amount,
              color: widget.color,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("€ ${formatDoubleToString(widget.amount)}",
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
