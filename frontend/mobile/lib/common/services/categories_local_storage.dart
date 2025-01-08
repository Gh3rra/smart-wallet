/* import 'package:mobile/common/services/local_storage_service.dart';
import 'package:mobile/model/category_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesLocalStorage {
  String tablename = "categories";

  Future<void> createTable(Database database) async {
    database.execute('''CREATE TABLE $tablename(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL
      )''');
  }

  Future<void> insertCategory() async {}

  deleteCategory() {}

  Future<void> insertCategories(
      {required List<CategoryModel> categories}) async {
    final db = await LocalStorageService().database;
    final batch = db.batch();
    for (var element in categories) {
      await db.insert(tablename, element.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit();
  }

  getIncomeCategories() {}
  getExpenseCategories() {}
}
 */