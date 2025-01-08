/* import 'dart:developer';

import 'package:mobile/common/services/local_storage_service.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionsLocalStorage {
  String tablename = "transactions";

  Future<void> createTable(Database database) async {
    database.execute('''CREATE TABLE $tablename(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL
      )''');
  }

  Future<void> insertTransactions(
      {required List<TransactionModel> transactions}) async {
    try {
      final db = await LocalStorageService().database;
      final batch = db.batch();
      for (var element in transactions) {
        db.insert(tablename, element.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      batch.commit();
    } catch (e) {
      print("INSERT TRANSACTIONS ERROR: $e");
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    List<TransactionModel> transactions = [];
    try {
      final db = await LocalStorageService().database;
      final result = await db.rawQuery('''
      select transactions.*, 
      categories.name as category_name, 
      categories.type as category_type,
      categories.icon as category_icon,
      categories.created_at as category_created_at,
      categories.is_synced as category_is_synced
      from transactions
      inner join categories on categories.id = transactions.category_id;
    ''');
      for (var element in result) {
        final rightElement = {
          ...element,
          "category": {
            "id": element["category_id"],
            "name": element["category_name"],
            "type": element["category_type"],
            "icon": element["category_icon"],
            "created_at": element["category_created_at"],
            "is_synced": element["category_is_synced"],
          }
        };
        transactions.add(TransactionModel.fromMap(rightElement));
      }
    } catch (e) {
      print("GET TRASNACTIONS ERROR: $e");
    }
    return transactions;
  }

  Future<void> getSome() async {
    try {
      final db = await LocalStorageService().database;
      final result = await db.rawQuery('''
      select transactions.*, 
      categories.name as category_name, 
      categories.type as category_type,
      categories.icon as category_icon,
      categories.created_at as category_created_at,
      categories.is_synced as category_is_synced
      from transactions
      inner join categories on categories.id = transactions.category_id;
    ''');
      for (var element in result) {
        final rightElement = {
          ...element,
          "category": {
            "id": element["category_id"],
            "name": element["category_name"],
            "type": element["category_type"],
            "icon": element["category_icon"],
            "created_at": element["category_created_at"],
            "is_synced": element["category_is_synced"],
          }
        };
        print(rightElement);
      }
    } catch (e) {
      print("GET TRASNACTIONS ERROR: $e");
    }
  }
}
 */