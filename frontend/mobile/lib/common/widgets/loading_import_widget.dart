import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/common/services/db.dart';
import 'package:open_file/open_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ImportState { start, loading, complete, error }

class LoadingImportWidget extends StatefulWidget {
  const LoadingImportWidget({super.key, required this.context});
  final BuildContext context;

  @override
  State<LoadingImportWidget> createState() => _LoadingImportWidgetState();
}

class _LoadingImportWidgetState extends State<LoadingImportWidget> {
  bool isTooLong = false;
  double percentage = 0;
  int rowsLength = 0;
  int current = 0;
  ImportState importState = ImportState.start;

  @override
  void initState() {
    super.initState();
  }

  pickExcel() async {
    // PICK FILE XLSX
    FilePickerResult? res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx"],
        allowMultiple: false,
        withData: true);
    if (res != null) {
      var bytes = res.files.single.bytes;
      var excel = Excel.decodeBytes(bytes!);
      try {
        setState(() {
          importState = ImportState.loading;
        });

        await Db().importFromExcel(
          excel: excel,
        );
        setState(() {
          importState = ImportState.complete;
        });
      } catch (e) {
        print(e);
        setState(() {
          importState = ImportState.error;
        });
      }
    } else {
      setState(() {
        importState = ImportState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (importState) {
      case ImportState.start:
        return ScaffoldMessenger(
          child: Builder(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: GestureDetector(
                  onTap: () {},
                  child: AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    content: IntrinsicHeight(
                      child: Column(
                        children: [
                          const Text(
                              "Per importare correttamente le tue transazioni segui questo file",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                              onTap: () async {
                                final bytes = await rootBundle.load(
                                    "assets/download/how_to_import_transactions.pdf");
                                final file = File(
                                    "/storage/emulated/0/Download/istruzioni.pdf");
                                await file
                                    .writeAsBytes(bytes.buffer.asUint8List());

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Salvato sul dispositivo \n${file.path}"),
                                  action: SnackBarAction(
                                      label: "Apri",
                                      onPressed: () {
                                        OpenFile.open(file.path);
                                      }),
                                ));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Istruzioni.pdf",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.download_rounded,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 25,
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                              "oppure scarica questo file di esempio e compilalo",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                              onTap: () async {
                                final bytes = await rootBundle
                                    .load("assets/download/esempio.xlsx");
                                final file = File(
                                    "/storage/emulated/0/Download/esempio.xlsx");
                                await file
                                    .writeAsBytes(bytes.buffer.asUint8List());

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Salvato sul dispositivo \n${file.path}"),
                                  action: SnackBarAction(
                                      label: "Apri",
                                      onPressed: () {
                                        OpenFile.open(file.path);
                                      }),
                                ));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Esempio.xlsx",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.download_rounded,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 25,
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            pickExcel();
                          },
                          child: Text(
                            "Scegli file...",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface),
                          ))
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      case ImportState.loading:
        return AlertDialog(

          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: const Text("Importazione..."),
          content: Container(
            padding:  const EdgeInsets.only(
              top: 20,
              bottom: 20
            ),
            child:  IntrinsicHeight(child: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary,))),
          ),
        );
      case ImportState.complete:
        return AlertDialog(
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
      case ImportState.error:
        return AlertDialog(
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
                  "Importazione non completata",
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
}
