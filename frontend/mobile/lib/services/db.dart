// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/utils/category.dart';
import 'package:mobile/utils/utils.dart';

class Db {
  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> userDoc =
      FirebaseFirestore.instance.collection("users").doc(AuthService().userId);

  Future<void> createUser(
      {required String email,
      required String name,
      required String surname}) async {
    double totalBilance = 0;
    double totalWallet = 0;
    double walletAmount = 0;
    try {
      DocumentReference walletDoc = userDoc.collection("wallets").doc();
      CollectionReference<Map<String, dynamic>> incomesCollection =
          userDoc.collection("incomesCategory");
      CollectionReference<Map<String, dynamic>> expensesCollection =
          userDoc.collection("expensesCategory");

      var batch = db.batch();

      batch.set(userDoc, {
        "name": name,
        "surname": surname,
        "email": email,
        "totalBilance": totalBilance,
        "totalWallet": totalWallet,
        "updateAt": Timestamp.fromDate(DateTime.now()),
        "titleCapsLock": false
      });
      batch.set(walletDoc, {
        "amount": walletAmount,
        "color": getRandomColorValue(),
        "order": 0,
        "name": "Contanti",
      });

      for (var element in incomesCategory) {
        batch.set(incomesCollection.doc(), {
          "icon": element["icon"],
          "name": element["name"],
        });
      }
      for (var element in expensesCategory) {
        batch.set(expensesCollection.doc(), {
          "icon": element["icon"],
          "name": element["name"],
        });
      }
      await batch.commit();

      //print("CREATED");
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  // IMPORTANTE RICORDATI DI GESTIRE LA REAUTENTICAZIONE PER CONFERMARE L'ELIMINAZIONE
  Future<void> deleteAccount() async {
    try {
      var batch = db.batch();

      batch.delete(userDoc);
      print("ELIMINATO DAL DB");
      await Future.delayed(const Duration(seconds: 10));
      await FirebaseAuth.instance.currentUser!.delete();
      print("ELIMINATO ANCHE DA AUTH");

      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addWallet(
      {required String name,
      required double amount,
      required int color}) async {
    try {
      DocumentReference<Map<String, dynamic>> walletDoc =
          userDoc.collection("wallets").doc();
      int walletsLength = await userDoc.collection("wallets").get().then(
            (value) => value.docs.length,
          );
      await db.runTransaction(
        (transaction) async {
          var userElement = await transaction.get(userDoc);
          await addTotalWallet(
              userDoc: userDoc,
              userElement: userElement,
              amount: amount,
              transaction: transaction);
          transaction.set(walletDoc, {
            "name": name,
            "amount": amount,
            "color": color,
            "order": walletsLength
          });
        },
      ).then(
        (value) => print(value),
      );

      //print("CREATED");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> editWallet({
    required String walletId,
    required String name,
    required double oldAmount,
    required double newAmount,
    required int color,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> walletDoc =
          userDoc.collection("wallets").doc(walletId);
      double differenceAmount = formatDouble(newAmount - oldAmount);
      //print("difference is = $differenceAmount");

      await db.runTransaction(
        (transaction) async {
          var userElement = await transaction.get(userDoc);
          await addTotalWallet(
              userDoc: userDoc,
              userElement: userElement,
              amount: differenceAmount,
              transaction: transaction);
          transaction.update(walletDoc, {
            "name": name,
            "amount": newAmount,
            "color": color,
          });
        },
      ).then(
        (value) => print(value),
      );

      // print("UPDATED");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> deleteWallet({
    required String walletId,
    required double amount,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> walletDoc =
          userDoc.collection("wallets").doc(walletId);

      await db.runTransaction(
        (transaction) async {
          DocumentSnapshot walletSnapshot = await walletDoc.get();
          List<QueryDocumentSnapshot<Map<String, dynamic>>> wallets =
              await userDoc
                  .collection("wallets")
                  .orderBy("order", descending: false)
                  .startAfterDocument(walletSnapshot)
                  .get()
                  .then(
                    (value) => value.docs,
                  );
          for (var element in wallets) {
            await transaction.get(element.reference);
          }
          var userElement = await transaction.get(userDoc);
          await addTotalWallet(
              userDoc: userDoc,
              userElement: userElement,
              amount: -amount,
              transaction: transaction);
          transaction.delete(walletDoc);
          await resetWalletOrder(wallets: wallets, transaction: transaction);
        },
      ).then(
        (value) => print(value),
      );

      //print("DELETED");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> resetWalletOrder(
      {required List<QueryDocumentSnapshot<Map<String, dynamic>>> wallets,
      required Transaction transaction}) async {
    try {
      for (var element in wallets) {
        print(element.reference);
        transaction.update(element.reference, {"order": element["order"] - 1});
      }
    } catch (e) {
      // print("RESET: $e");
      throw Exception(e.toString());
    }
  }

  Future<void> addTotalWallet(
      {required DocumentReference<Map<String, dynamic>> userDoc,
      required DocumentSnapshot<Map<String, dynamic>> userElement,
      required double amount,
      required Transaction transaction}) async {
    try {
      double totalWallet = userElement["totalWallet"].toDouble();
      transaction
          .update(userDoc, {"totalWallet": formatDouble(totalWallet + amount)});
      print("totale= $totalWallet");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addCategory(
      {required String name,
      required IconData icon,
      required String type}) async {
    try {
      if (type != "ENTRATA") {
        await userDoc.collection("expensesCategory").doc().set({
          "name": name,
          "icon": icon.codePoint,
        });
      } else {
        await userDoc.collection("incomesCategory").doc().set({
          "name": name,
          "icon": icon.codePoint,
        });
      }

      //print("CREATED CATEOGORY");
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCategory(
    BuildContext context, {
    required String type,
    required String categoryId,
  }) async {
    try {
      db.runTransaction(
        (transaction) async {
          List<QueryDocumentSnapshot<Map<String, dynamic>>>
              categoryTransactions = await userDoc
                  .collection("transactions")
                  .where("categoryId", isEqualTo: categoryId)
                  .get()
                  .then(
                    (value) => value.docs,
                  );

          if (categoryTransactions.isNotEmpty) {
            for (var element in categoryTransactions) {
              transaction.get(element.reference);
            }
            await showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text("Attenzione"),
                content: Text(
                    "Sono presenti delle transazioni per la categoria selezionata. Prima di procedere con l'eliminazione cambia la categoria delle transazioni."),
              ),
            );
          } else {
            DocumentReference categoryDoc;
            if (type == "ENTRATA") {
              categoryDoc =
                  userDoc.collection("incomesCategory").doc(categoryId);
            } else {
              categoryDoc =
                  userDoc.collection("expensesCategory").doc(categoryId);
            }
            transaction.delete(categoryDoc);
          }
        },
      );

      print("DELETED CATEGORY");
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTransaction({
    required String type,
    required String title,
    required double amount,
    required String categoryId,
    String? walletId,
    required DateTime date,
  }) async {
    Stopwatch stopwatch = Stopwatch()..start();
    Stopwatch transStopwatch = Stopwatch();
    try {
      DocumentReference<Map<String, dynamic>> transactionDoc =
          userDoc.collection("transactions").doc();
      DocumentReference<Map<String, dynamic>> categoryDoc = type == "ENTRATA"
          ? userDoc.collection("incomesCategory").doc(categoryId)
          : userDoc.collection("expensesCategory").doc(categoryId);
      DocumentReference<Map<String, dynamic>>? walletDoc =
          walletId != null ? userDoc.collection("wallets").doc(walletId) : null;

      await db.runTransaction(
        (transaction) async {
          Stopwatch getStopwatch = Stopwatch()..start();

          var categoryElement = await transaction.get(categoryDoc);
          var userElement = await transaction.get(userDoc);
          getStopwatch.stop();
          print("GET TERMINATO IN ${getStopwatch.elapsed}");
          //add or sub to specific wallet enad total wallet

          if (walletDoc != null) {
            var walletElement = await transaction.get(walletDoc);

            await addAmountWallet(
                userDoc: userDoc,
                userElement: userElement,
                type: type,
                amount: amount,
                transaction: transaction,
                walletDoc: walletDoc,
                walletElement: walletElement);
          }

          await addTotalBilance(
              type: type,
              userDoc: userDoc,
              userElement: userElement,
              amount: amount,
              transaction: transaction);

          transaction.set(transactionDoc, {
            "title": title,
            "amount": amount,
            "categoryId": categoryElement.id,
            "date": Timestamp.fromDate(date),
            "type": type
          });
          transStopwatch.start();
        },
      );
      transStopwatch.stop();
      print("TERMINATO IN ${transStopwatch.elapsed}");
      stopwatch.stop();
      print("ADD RANSACTION TERMINATO IN ${stopwatch.elapsed}");
      //print("CREATED TRANSACTION");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> addTransactionAndCategory({
    required String type,
    required String title,
    required double amount,
    required String cateryName,
    required int categoryIcon,
    required String categoryType,
    required DateTime date,
  }) async {
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      DocumentReference<Map<String, dynamic>> transactionDoc =
          userDoc.collection("transactions").doc();
      DocumentReference<Map<String, dynamic>> categoryDoc =
          userDoc.collection(categoryType).doc();

      await db.runTransaction(
        (transaction) async {
          var userElement = await transaction.get(userDoc);
          await addTotalBilance(
              type: type,
              userDoc: userDoc,
              userElement: userElement,
              amount: amount,
              transaction: transaction);
          transaction
              .set(categoryDoc, {"name": cateryName, "icon": categoryIcon});
          transaction.set(transactionDoc, {
            "title": title,
            "amount": amount,
            "categoryId": categoryDoc.id,
            "date": Timestamp.fromDate(date),
            "type": type
          });
        },
      );
      stopwatch.stop();
      print("ADD RANSACTION and CATEGORY TERMINATO IN ${stopwatch.elapsed}");
      //print("CREATED TRANSACTION");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> addTransactionsFromImport({
    required String type,
    required String title,
    required double amount,
    required String categoryName,
    required int categoryIcon,
    required DateTime date,
  }) async {
    try {
      //DEFINIAMO SE È ENTRATA O USCITA PER LA CATEGORIA
      String categoryType =
          type == "ENTRATA" ? "incomesCategory" : "expensesCategory";
      //CERCHIAMO SE LA CATEGORIA ESISTE GIÀ
      List<QueryDocumentSnapshot<Map<String, dynamic>>> categoryList =
          await userDoc
              .collection(categoryType)
              .where("name", isEqualTo: categoryName)
              .get()
              .then(
                (value) => value.docs,
              );

      //SE LA CATEGORIA GIÀ ESISTE
      if (categoryList.isNotEmpty) {
        DocumentSnapshot categoryElement = categoryList.first;
        await addTransaction(
            type: type,
            title: title,
            amount: formatDouble(amount),
            categoryId: categoryElement.id,
            date: date);
      }
      //SE LA CATEGORIA NON ESISTE
      else {
        // AGGIUNGO LA TRANSACTION ALLA LISTA SENZA AGGIUNGERE L'ID CATEGORIA
        await addTransactionAndCategory(
            type: type,
            title: title,
            amount: formatDouble(amount),
            categoryIcon: categoryIcon,
            cateryName: categoryName,
            categoryType: categoryType,
            date: date);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editTransaction({
    required String transactionId,
    required String title,
    required String type,
    required DateTime date,
    required double oldAmount,
    required double newAmount,
    required String categoryId,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> transactionDoc =
          userDoc.collection("transactions").doc(transactionId);
      DocumentReference<Map<String, dynamic>> categoryDoc = type == "ENTRATA"
          ? userDoc.collection("incomesCategory").doc(categoryId)
          : userDoc.collection("expensesCategory").doc(categoryId);
      double differenceAmount = formatDouble(newAmount - oldAmount);
      //print("difference is = $differenceAmount");

      await db.runTransaction(
        (transaction) async {
          var userElement = await transaction.get(userDoc);
          var categoryElement = await transaction.get(categoryDoc);
          await addTotalBilance(
              type: type,
              userDoc: userDoc,
              userElement: userElement,
              amount: differenceAmount,
              transaction: transaction);
          transaction.update(transactionDoc, {
            "title": title,
            "amount": newAmount,
            "categoryId": categoryElement.id,
            "date": Timestamp.fromDate(date)
          });
        },
      ).then(
        (value) => print(value),
      );

      print("UPDATED TRNASACTION");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTransaction({
    required String transactionId,
    required String type,
    required double amount,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> walletDoc =
          userDoc.collection("transactions").doc(transactionId);

      await db.runTransaction(
        (transaction) async {
          var userElement = await transaction.get(userDoc);
          await addTotalBilance(
              type: type,
              userDoc: userDoc,
              userElement: userElement,
              amount: -amount,
              transaction: transaction);
          transaction.delete(walletDoc);
        },
      ).then(
        (value) => print(value),
      );

      //print("DELETED");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> addAmountWallet(
      {required String type,
      required double amount,
      required DocumentReference<Map<String, dynamic>> walletDoc,
      required DocumentSnapshot<Map<String, dynamic>> walletElement,
      required DocumentReference<Map<String, dynamic>> userDoc,
      required DocumentSnapshot<Map<String, dynamic>> userElement,
      required Transaction transaction}) async {
    try {
      double walletAmount = walletElement["amount"].toDouble();
      if (type == "ENTRATA") {
        transaction
            .update(walletDoc, {"amount": formatDouble(walletAmount + amount)});
        await addTotalWallet(
            userDoc: userDoc,
            userElement: userElement,
            amount: amount,
            transaction: transaction);
      } else {
        transaction
            .update(walletDoc, {"amount": formatDouble(walletAmount - amount)});
        await addTotalWallet(
            userDoc: userDoc,
            userElement: userElement,
            amount: -amount,
            transaction: transaction);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addTotalBilance(
      {required DocumentSnapshot<Map<String, dynamic>> userElement,
      required DocumentReference<Map<String, dynamic>> userDoc,
      required String type,
      required double amount,
      required Transaction transaction}) async {
    try {
      double totalBilance = userElement["totalBilance"].toDouble();
      type == "ENTRATA"
          ? transaction.update(
              userDoc, {"totalBilance": formatDouble(totalBilance + amount)})
          : transaction.update(
              userDoc, {"totalBilance": formatDouble(totalBilance - amount)});
      //print("totale bilancio= $totalBilance");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> setCapsLock({required bool value}) async {
    try {
      await userDoc.update({"titleCapsLock": value});
    } catch (e) {
      print(e);
    }
  }
}
