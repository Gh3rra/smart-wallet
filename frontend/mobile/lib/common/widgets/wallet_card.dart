import 'package:flutter/material.dart';
import 'package:mobile/common/utils/utils.dart';
import 'package:mobile/common/widgets/wallet_edit_widget.dart';
import 'package:mobile/model/wallet_model.dart';

class WalletCard extends StatefulWidget {
  const WalletCard({
    super.key,
    required this.firstCard,
    required this.lastCard,
    required this.wallet,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
  final WalletModel wallet;
  final bool firstCard;
  final bool lastCard;
}

class _WalletCardState extends State<WalletCard> {
  @override
  Widget build(BuildContext context) {
    Color textColor =
        widget.wallet.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
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
      ], color: widget.wallet.color, borderRadius: BorderRadius.circular(15)),
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
                          walletId: widget.wallet.id,
                          name: widget.wallet.name,
                          amount: widget.wallet.amount,
                          color: widget.wallet.color,
                        ),
                      ),
              transitionDuration: const Duration(milliseconds: 100));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.wallet.name,
              style: TextStyle(
                  color: textColor, fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("€ ${formatDoubleToString(widget.wallet.amount)}",
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
