// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class DateScrollTransactionsWidget extends StatefulWidget {
  const DateScrollTransactionsWidget(
      {super.key,
      required this.months,
      required this.scrollController,
      required this.keys});
  final ScrollController scrollController;
  final List<String> months;
  final List<GlobalKey> keys;

  @override
  State<DateScrollTransactionsWidget> createState() =>
      _DateScrollTransactionsWidgetState();
}

class _DateScrollTransactionsWidgetState
    extends State<DateScrollTransactionsWidget> {
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 100 && isVisible == false) {
        setState(() {
          isVisible = true;
        });
      } else if (widget.scrollController.offset < 100 && isVisible == true) {
        setState(() {
          isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.keys);
    return isVisible == true
        ? AnimatedPositioned(
            top: 80,
            duration: const Duration(milliseconds: 500),
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.months.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Scrollable.ensureVisible(
                        duration: const Duration(milliseconds: 500),
                        alignment: 0.07,
                          widget.keys[index].currentContext!);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.months[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : const SizedBox();

    /* Container(
      color: Colors.blue,
      height: 30,
      width: MediaQuery.sizeOf(context).width,
      child: ListView.builder(
        reverse: true,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.months.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.months[index]),
          );
        },
      ),
    ); */
  }
}
