// ignore_for_file: avoid_print

import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/loading_import_widget.dart';
import 'package:mobile/widgets/setting_widget.dart';
import 'package:path_provider/path_provider.dart';

class ImportExportScreen extends StatefulWidget {
  const ImportExportScreen({super.key});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen> {
  String userId = AuthService().userId;
  bool isLoadingExport = false;
  bool isLoadingImport = false;
  double i = 0;
  double percentage = 0;
  bool isTooLong = false;

  exportOldData() async {
    setState(() {
      isLoadingExport = true;
    });
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 15),
          height: 250,
          width: 300,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
            const Text("L'operazione potrebbe richiedere alcuni minuti"),
            const Text(
              "Non uscire da questa finestra per non annullare l'esportazione",
              style: TextStyle(fontSize: 16),
            )
          ]),
        ),
      ),
    );
    /* print("CREO L'EXCEL");
    Excel excel = Excel.createExcel(); //create an excel sheet
    Sheet sheetObject = excel['Transazioni'];
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("transactions")
        .orderBy("date", descending: true)
        .get();
    print("ENTRO NEL CICLO");

    for (int i = 0; i < data.docs.length; i++) {
      print(i);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i))
          .value = TextCellValue(data.docs[i]["title"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
          .value = DoubleCellValue(data.docs[i]["amount"]);

      DateTime da = data.docs[i]["date"].toDate();
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
          .value = DateTimeCellValue.fromDateTime(da);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
          .value = TextCellValue(data.docs[i]["monthYear"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i))
          .value = TextCellValue(data.docs[i]["category"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i))
          .value = TextCellValue(data.docs[i]["type"]);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i))
          .value = IntCellValue(data.docs[i]["icon"]);
    }
    print("FATTO");

    File("/storage/emulated/0/Download/trans.xlsx")
      ..createSync(
        recursive: true,
      )
      ..writeAsBytesSync(excel.save()!);
 */
    setState(() {
      isLoadingExport = false;
    });
  }

  importData() async {
    // PICK FILE XLSX
    FilePickerResult? res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx"],
        allowMultiple: false,
        withData: true);
    if (res != null) {
      var bytes = res.files.single.bytes;
      var excel = Excel.decodeBytes(bytes!);
      setState(() {
        isLoadingImport = true;
      });
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            print("MO TI FACCIO LO SHOW");
            return LoadingImportWidget(context: context, excel: excel);
          });
    }

    setState(() {
      isLoadingImport = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
                style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder())),
                onPressed: () => {Navigator.pop(context)},
                icon: Text(
                  String.fromCharCode(Icons.arrow_back_rounded.codePoint),
                  style: TextStyle(
                      fontFamily: Icons.arrow_back_rounded.fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface),
                ))),
        centerTitle: true,
        title: Text(
          "Importa/Esporta",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 30,
                        spreadRadius: -8),
                  ],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    SettingWidget(
                      prefixIcon: Icons.upload_rounded,
                      onTap:
                          isLoadingImport == false && isLoadingExport == false
                              ? importData
                              : null,
                      title: "Importa CSV",
                      subTitle: "Importa le tue spese da un file .csv",
                      prefixIconSize: 35,
                    ),
                    SettingWidget(
                      onTap:
                          isLoadingImport == false && isLoadingExport == false
                              ? exportOldData
                              : null,
                      prefixIcon: Icons.download_rounded,
                      title: "Esporta CSV",
                      subTitle: "Scarica un file .csv delle tue spese",
                      prefixIconSize: 35,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
