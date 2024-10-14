// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/utils/category.dart';
import 'package:mobile/utils/utils.dart';

class Db {
  String id = AuthService().userId;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> setCategory({required String userId}) async {
    try {
      CollectionReference<Map<String, dynamic>> incomesCollection =
          db.collection("users").doc(userId).collection("incomesCategory");
      CollectionReference<Map<String, dynamic>> expensesCollection =
          db.collection("users").doc(userId).collection("expensesCategory");

      for (var element in incomesCategory) {
        await incomesCollection.doc().set({
          "icon": element["icon"],
          "name": element["name"],
        });
      }
      for (var element in expensesCategory) {
        await expensesCollection.doc().set({
          "icon": element["icon"],
          "name": element["name"],
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(
      {required String email,
      required String name,
      required String surname}) async {
    double totalBilance = 0;
    double totalWallet = 0;
    double walletAmount = 0;
    try {
      await db.collection("users").doc(id).set({
        "name": name,
        "surname": surname,
        "email": email,
        "totalBilance": totalBilance,
        "totalWallet": totalWallet,
        "updateAt": Timestamp.fromDate(DateTime.now())
      });
      await db.collection("users").doc(id).collection("wallets").doc().set({
        "amount": walletAmount,
        "color": getRandomColorValue(),
        "order": 0,
        "name": "Contanti",
      });
      await setCategory(userId: id);
      print("CREATED");
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      db.collection("users").doc(id).delete();
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addWallet(
      {required String name,
      required double amount,
      required int color}) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc =
          db.collection("users").doc(id);
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

      print("CREATED");
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
      DocumentReference<Map<String, dynamic>> userDoc =
          db.collection("users").doc(id);
      DocumentReference<Map<String, dynamic>> walletDoc =
          userDoc.collection("wallets").doc(walletId);
      double differenceAmount = formatDouble(newAmount - oldAmount);
      print("difference is = $differenceAmount");

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

      print("UPDATED");
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
      DocumentReference<Map<String, dynamic>> userDoc =
          db.collection("users").doc(id);
      DocumentReference<Map<String, dynamic>> walletDoc =
          userDoc.collection("wallets").doc(walletId);

      await db.runTransaction(
        (transaction) async {
          var userElement = await transaction.get(userDoc);
          await addTotalWallet(
              userDoc: userDoc,
              userElement: userElement,
              amount: -amount,
              transaction: transaction);
          transaction.delete(walletDoc);
          await resetWalletOrder(walletId: walletId, transaction: transaction);
        },
      ).then(
        (value) => print(value),
      );

      print("DELETED");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> resetWalletOrder(
      {required String walletId, required Transaction transaction}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> walletDoc = await db
          .collection("users")
          .doc(id)
          .collection("wallets")
          .doc(walletId)
          .get();
      print(walletDoc.data());
      print("ORA RESETTO");
      List<QueryDocumentSnapshot<Map<String, dynamic>>> wallets = await db
          .collection("users")
          .doc(id)
          .collection("wallets")
          .orderBy("order", descending: false)
          .startAfterDocument(walletDoc)
          .get()
          .then(
            (value) => value.docs,
          );
      print("SICURO?");

      for (var element in wallets) {
        print(element.reference);
        transaction.update(element.reference, {"order": element["order"] - 1});
      }
    } catch (e) {
      print("RESET: $e");
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
        await db
            .collection("users")
            .doc(id)
            .collection("expensesCategory")
            .doc()
            .set({
          "name": name,
          "icon": icon.codePoint,
        });
      } else {
        await db
            .collection("users")
            .doc(id)
            .collection("incomesCategory")
            .doc()
            .set({
          "name": name,
          "icon": icon.codePoint,
        });
      }

      print("CREATED CATEOGORY");
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCategory(BuildContext context,
      {required String type,
      required String categoryId,
      required String categoryName}) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc =
          db.collection("users").doc(id);
      List<QueryDocumentSnapshot<Map<String, dynamic>>> categoryTransactions =
          await userDoc
              .collection("transactions")
              .where("category.name", isEqualTo: categoryName)
              .get()
              .then(
                (value) => value.docs,
              );
      if (categoryTransactions.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Attenzione"),
            content: Text(
                "Sono presenti delle transazioni per la categoria selezionata. Prima di procedere con l'eliminazione cambia la categoria delle transazioni."),
          ),
        );
      } else {
        if (type == "ENTRATA") {
          await userDoc.collection("incomesCategory").doc(categoryId).delete();
        } else {
          await userDoc.collection("expensesCategory").doc(categoryId).delete();
        }
      }

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
    required String? walletId,
    required DateTime date,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc =
          db.collection("users").doc(id);
      DocumentReference<Map<String, dynamic>> transactionDoc =
          userDoc.collection("transactions").doc();
      DocumentReference<Map<String, dynamic>> categoryDoc = type == "ENTRATA"
          ? userDoc.collection("incomesCategory").doc(categoryId)
          : userDoc.collection("expensesCategory").doc(categoryId);
      DocumentReference<Map<String, dynamic>>? walletDoc =
          walletId != null ? userDoc.collection("wallets").doc(walletId) : null;

      await db.runTransaction(
        (transaction) async {
          var categoryElement = await transaction.get(categoryDoc);
          var userElement = await transaction.get(userDoc);

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
            "category": {
              "id": categoryElement.id,
              "name": categoryElement["name"],
              "icon": categoryElement["icon"]
            },
            "date": Timestamp.fromDate(date),
            "type": type
          });
        },
      ).then(
        (value) => print(value),
      );

      print("CREATED TRANSACTION");
    } catch (e) {
      print(e);
      throw Exception(e.toString());
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
      DocumentReference<Map<String, dynamic>> userDoc =
          db.collection("users").doc(id);
      DocumentReference<Map<String, dynamic>> transactionDoc =
          userDoc.collection("transactions").doc(transactionId);
      DocumentReference<Map<String, dynamic>> categoryDoc = type == "ENTRATA"
          ? userDoc.collection("incomesCategory").doc(categoryId)
          : userDoc.collection("expensesCategory").doc(categoryId);
      double differenceAmount = formatDouble(newAmount - oldAmount);
      print("difference is = $differenceAmount");

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
            "category": {
              "id":categoryElement.id,
              "name": categoryElement["name"],
              "icon": categoryElement["icon"]
            },
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
      DocumentReference<Map<String, dynamic>> userDoc =
          db.collection("users").doc(id);
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

      print("DELETED");
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
      print("totale bilancio= $totalBilance");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
