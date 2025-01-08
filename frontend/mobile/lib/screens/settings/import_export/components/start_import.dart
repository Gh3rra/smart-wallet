import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

showStartImportMessage(BuildContext context, Function importData) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
          child: Builder(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: AlertDialog(
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
                            await file.writeAsBytes(bytes.buffer.asUint8List());

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.download_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
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
                            await file.writeAsBytes(bytes.buffer.asUint8List());

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.download_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
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
                        importData();
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
            );
          }),
        );
      });
}
