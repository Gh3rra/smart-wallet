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
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 30,
            spreadRadius: -8),
      ], color: widget.color, borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () async {
          await showGeneralDialog(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SizedBox(),
              context: context,
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      Transform.scale(
                        scale: animation.value,
                        child: WalletEditWidget(
                          walletId: widget.walletId,
                          name: widget.name,
                          amount: widget.amount,
                          color: widget.color,
                        ),
                      ),
              transitionDuration: const Duration(milliseconds: 100));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                  color: textColor, fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("€ ${formatDoubleToString(widget.amount)}",
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
