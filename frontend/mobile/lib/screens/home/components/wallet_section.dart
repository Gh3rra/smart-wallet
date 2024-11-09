import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/widgets/add_wallet_widget.dart';
import 'package:mobile/widgets/wallet_card.dart';

class WalletSection extends StatefulWidget {
  const WalletSection({super.key});

  @override
  State<WalletSection> createState() => _WalletSectionState();
}

class _WalletSectionState extends State<WalletSection> {
  bool isWalletDialogOpen = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "I tuoi portafogli",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimaryContainer),
                      minimumSize: const WidgetStatePropertyAll(
                        Size(0, 0),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceContainer),
                      elevation: const WidgetStatePropertyAll(0),
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 8, vertical: 5)),
                      shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))))),
                  onPressed: () async {
                    if (!isWalletDialogOpen) {
                      isWalletDialogOpen = true;
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SizedBox(),
                        transitionBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return Transform.scale(
                              scale: animation.value,
                              child: const AddWalletWidget());
                        },
                        transitionDuration: const Duration(milliseconds: 100),
                      );
                      isWalletDialogOpen = false;
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Aggiungi",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        "assets/icons/add_rounded_icon.svg",
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onPrimary,
                            BlendMode.srcIn),
                      )
                    ],
                  ))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          height: 150,
          child: StreamBuilder<QuerySnapshot>(
              stream: Db()
                  .userDoc
                  .collection("wallets")
                  .orderBy("order")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final walletDoc = snapshot.data!.docs[index];
                        final walletElement = walletDoc.data() as Map;
                        return WalletCard(
                          walletId: walletDoc.id,
                          firstCard: index == 0,
                          lastCard: index == snapshot.data!.docs.length - 1,
                          amount: walletElement["amount"].toDouble(),
                          name: walletElement["name"],
                          color: Color(walletElement["color"]),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ],
    );
  }
}
