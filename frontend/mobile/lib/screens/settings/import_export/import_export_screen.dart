import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/loading_export_widget.dart';
import 'package:mobile/common/widgets/loading_import_widget.dart';
import 'package:mobile/screens/settings/components/setting_widget.dart';

class ImportExportScreen extends StatefulWidget {
  const ImportExportScreen({super.key});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen> {
  bool isLoadingExport = false;
  bool isLoadingImport = false;
  double i = 0;
  double percentage = 0;
  bool isTooLong = false;

  exportOldData() async {
    setState(() {
      isLoadingExport = true;
    });
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("users")
        .doc()
        .collection("transactions")
        .orderBy("date", descending: true)
        .get();
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          print("MO TI FACCIO LO SHOW");
          return LoadingExportWidget(context: context, docs: data.docs);
        });

    setState(() {
      isLoadingExport = false;
    });
  }

  startImport() async {
    await showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return LoadingImportWidget(context: context);
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
                              ? startImport
                              : null,
                      title: "Importa CSV",
                      subTitle: "Importa le tue spese da un file .csv",
                      prefixIconSize: 35,
                    ),
                    SettingWidget(
                      onTap: isLoadingImport == false &&
                              isLoadingExport == false
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  content: const Text(
                                    "Funzionalità non ancora disponibile!",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  actions: [
                                    TextButton(
                                      child:  Text("OK",style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.onSurface),),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
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
