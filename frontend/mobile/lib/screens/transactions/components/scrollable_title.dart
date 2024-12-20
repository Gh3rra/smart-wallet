// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/transactions/components/date_scroll_transactions_widget.dart';

class ScrollableTitle extends StatefulWidget {
  const ScrollableTitle(
      {super.key, required this.scrollController, required this.text});
  final ScrollController scrollController;
  final String text;

  @override
  State<ScrollableTitle> createState() => _ScrollableTitleState();
}

class _ScrollableTitleState extends State<ScrollableTitle> {
  double paddingTitle = 20;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset < 50 &&
          widget.scrollController.offset > 0) {
        setState(() {
          paddingTitle = 20 + widget.scrollController.offset;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      expandedHeight: 120,
      backgroundColor: Theme.of(context).colorScheme.surface,
      snap: false,
      floating: false,
      pinned: true,
      leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          onPressed: () => Navigator.pop(context),
          icon: Text(
            String.fromCharCode(Icons.arrow_back_rounded.codePoint),
            style: TextStyle(
                fontFamily: Icons.arrow_back_rounded.fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface),
          )),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        expandedTitleScale: 1.3,
        titlePadding: EdgeInsets.only(bottom: 16, left: paddingTitle),
        title: Text(
          widget.text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
