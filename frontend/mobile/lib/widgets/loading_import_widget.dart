import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/db.dart';

class LoadingImportWidget extends StatefulWidget {
  const LoadingImportWidget(
      {super.key, required this.excel, required this.context});
  final BuildContext context;
  final Excel excel;

  @override
  State<LoadingImportWidget> createState() => _LoadingImportWidgetState();
}

class _LoadingImportWidgetState extends State<LoadingImportWidget> {
  double i = 0;
  bool isTooLong = false;
  bool isCompleted = false;
  late double percentage;
  late var rows;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rows = widget.excel.tables["Transazioni"]!.rows;
    percentage = i / rows.length;
    startImport();
  }

  startImport() async {
    // RIPETI CICLO PER OGNI RIGA
    Stopwatch stopwatch = Stopwatch()..start();
    for (List<Data?> row in rows) {
      // LETTURA DI OGNI CELLA PER OGNI RIGA
      var firstCell = row[0]!.value as TextCellValue;
      String title = firstCell.value.text!;
      var secondCell = row[1]!.value;
      double amount = 0;
      switch (secondCell) {
        case IntCellValue():
          amount = secondCell.value.toDouble();
          break;
        case DoubleCellValue():
          amount = secondCell.value;
          break;

        default:
          throw Exception("PORCO CANE");
      }
      var thirdCell = row[2]!.value;
      DateTime date;
      switch (thirdCell) {
        case DateCellValue():
          date = thirdCell.asDateTimeLocal();

          break;
        case DateTimeCellValue():
          date = thirdCell.asDateTimeLocal();

        default:
          throw Exception("PORCO GIUDA");
      }
      var fourthCell = row[3]!.value as TextCellValue;
      String categoryName = fourthCell.value.text!;
      var fifthCell = row[4]!.value as TextCellValue;
      String type = fifthCell.value.text!;
      var sixthCell = row[5]!.value as IntCellValue;
      int categoryIcon = sixthCell.value;

       await Db().addTransactionsFromImport(
          type: type == "ENTRATE" ? "ENTRATA" : "USCITA",
          title: title,
          amount: amount,
          categoryName: categoryName,
          categoryIcon: categoryIcon,
          date: date); 
      setState(() {
        i++;
        if (stopwatch.elapsed.inSeconds > 20 &&
            rows.length - i > rows.length / 3) {
          isTooLong = true;
        }
        percentage = i / rows.length;
      });
    }
    setState(() {
      isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isCompleted == false
        ? AlertDialog(
            title: const Text("Importazione..."),
            content: Container(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: SizedBox(width: 300,
                child: IntrinsicHeight(
                  child:
                      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    LinearProgressIndicator(
                      backgroundColor: Theme.of(context).colorScheme.onTertiary,
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
                        Text("${i.toStringAsFixed(0)}/${rows.length}")
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
        : AlertDialog(
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
                    "Importazione completata",
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
