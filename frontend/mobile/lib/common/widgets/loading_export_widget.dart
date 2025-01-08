import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class LoadingExportWidget extends StatefulWidget {
  const LoadingExportWidget(
      {super.key, required this.context, required this.docs});
  final BuildContext context;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  @override
  State<LoadingExportWidget> createState() => _LoadingExportWidgetState();
}

class _LoadingExportWidgetState extends State<LoadingExportWidget> {
  double i = 0;
  bool isTooLong = false;
  bool isCompleted = false;
  bool isError = false;

  late double percentage;

  @override
  void initState() {
    super.initState();    percentage = i / widget.docs.length;
    startExport();
  }

  startExport() async {
    Stopwatch stopwatch = Stopwatch()..start();
    Excel excel = Excel.createExcel()..rename("Sheet1", "transactions"); //create an excel sheet
    Sheet sheetObject = excel['transactions'];
    for (int i = 0; i < widget.docs.length; i++) {
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i))
          .value = TextCellValue(widget.docs[i]["title"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
          .value = DoubleCellValue(widget.docs[i]["amount"]);

      DateTime da = widget.docs[i]["date"].toDate();
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
          .value = DateTimeCellValue.fromDateTime(da);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
          .value = TextCellValue(widget.docs[i]["monthYear"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i))
          .value = TextCellValue(widget.docs[i]["category"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i))
          .value = TextCellValue(widget.docs[i]["type"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i))
          .value = IntCellValue(widget.docs[i]["icon"]);

      setState(() {
        if (stopwatch.elapsed.inSeconds > 20 &&
            widget.docs.length - i > widget.docs.length / 3) {
          isTooLong = true;
        }
        percentage = i / widget.docs.length;
      });
    }

    File("/storage/emulated/0/Download/transazioni.xlsx")
      ..createSync(
        recursive: true,
      )
      ..writeAsBytesSync(excel.save()!);

    // RIPETI CICLO PER OGNI RIGA

    setState(() {
      isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isCompleted == false && isError == false
        ? AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            title: const Text("Esportazione..."),
            content: Container(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: SizedBox(
                width: 300,
                child: IntrinsicHeight(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LinearProgressIndicator(
                          backgroundColor:
                              Theme.of(context).colorScheme.onTertiary,
                          value: percentage,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${(percentage * 100).toStringAsFixed(0)}%"),
                            Text(
                                "${i.toStringAsFixed(0)}/${widget.docs.length}")
                          ],
                        ),
                        isTooLong
                            ? const Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      "L'operazione potrebbe richiedere alcuni minuti"),
                                ],
                              )
                            : const SizedBox(
                                height: 40,
                              ),
                      ]),
                ),
              ),
            ),
          )
        : isCompleted == true && isError == false
            ? AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                title: const Center(
                    child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 50,
                  color: Colors.green,
                )),
                content: const IntrinsicHeight(
                  child: Column(
                    children: [
                      Text(
                        "Esportazione completata",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface),
                      ))
                ],
              )
            : AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                title: const Center(
                    child: Icon(
                  Icons.error_outline_rounded,
                  size: 50,
                  color: Colors.red,
                )),
                content: const IntrinsicHeight(
                  child: Column(
                    children: [
                      Text(
                        "Esportazione non completata",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface),
                      ))
                ],
              );
  }
}
