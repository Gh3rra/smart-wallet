/* import 'package:mobile/common/services/local_storage_service.dart';
import 'package:mobile/model/wallet_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WalletsLocalStorage {
  String tablename = "wallets";

  Future<void> createTable(Database database) async {
    database.execute('''CREATE TABLE $tablename(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        color INTEGER NOT NULL,
        order_index INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL
      )''');
  }

  Future<void> insertWallets({required List<WalletModel> wallets}) async {
    try {
      final db = await LocalStorageService().database;
      final batch = db.batch();
      for (var element in wallets) {
        await db.insert(tablename, element.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      batch.commit();
    } catch (e) {
      print("ERRORE IN INSERT LOCAL: $e");
    }
  }

  Future<List<WalletModel>> getWallets() async {
    List<WalletModel> wallets = [];
    try {
      final db = await LocalStorageService().database;
      final result = await db.query(tablename);
      for (var element in result) {
        wallets.add(WalletModel.fromMap(element));
      }
    } catch (e) {
      print("ERRORE IN GET LOCAL: $e");
    }
    return wallets;
  }
}
 */