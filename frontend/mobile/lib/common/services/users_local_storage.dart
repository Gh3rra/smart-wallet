/* import 'package:mobile/common/services/local_storage_service.dart';
import 'package:mobile/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserLocalStorage {
  String tablename = "users";

Future<void> createTable(Database database) async {
    database.execute('''CREATE TABLE $tablename(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        surname TEXT NOT NULL,
        total_balance REAL NOT NULL,
        total_wallet REAL NOT NULL,
        dark_theme INT NOT NULL,
        caps_lock INT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL
      )''');
  }
  

  Future<void> insertUser({required UserModel userModel}) async {
    final db = await LocalStorageService().database;
    await db.insert(tablename, userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUserData() async {
    final db = await LocalStorageService().database;
    final result = await db.query(tablename, limit: 1);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null;
    }
  }
}
 */