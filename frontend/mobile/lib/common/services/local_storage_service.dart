/* import 'package:mobile/common/services/categories_local_storage.dart';
import 'package:mobile/common/services/transactions_local_storage.dart';
import 'package:mobile/common/services/users_local_storage.dart';
import 'package:mobile/common/services/wallets_local_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorageService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "smart_wallet.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        TransactionsLocalStorage().createTable(db);
        UserLocalStorage().createTable(db);
        CategoriesLocalStorage().createTable(db);
        WalletsLocalStorage().createTable(db);
      },
    );
  }
}
 */