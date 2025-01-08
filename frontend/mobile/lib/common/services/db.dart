// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/services/categories_local_storage.dart';
import 'package:mobile/common/services/transactions_local_storage.dart';
import 'package:mobile/common/services/users_local_storage.dart';
import 'package:mobile/common/services/wallets_local_storage.dart';
import 'package:mobile/common/utils/initial_categories.dart';
import 'package:mobile/common/utils/utils.dart';
import 'package:mobile/model/category_model.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/model/wallet_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class Db {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? _userId;
  UserModel? _user;

  String get userId {
    if (_userId != null) {
      return _userId!;
    }
    _userId = _supabase.auth.currentSession!.user.id;
    return _userId!;
  }

  Future<UserModel?> get user async {
    if (_user != null) {
      return _user;
    }
    _user = await getUserData();
    return _user;
  }

  Future<ThemeMode> getInitialTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final userData = await user;
      if (userData != null) {
        await prefs.setInt("darkTheme", userData.darkTheme);

        return userData.darkTheme == 1 ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      final darkTheme = prefs.getInt("darkTheme");

      return darkTheme == 1 ? ThemeMode.dark : ThemeMode.light;
    }

    return ThemeMode.light;
  }

  Future<void> resetPassword() async {
    String? email = _supabase.auth.currentSession!.user.email;
    if (email != null) {
      await _supabase.auth.resetPasswordForEmail(email);
    }
  }

  Future<void> changeEmail({required String email}) async {
    await _supabase.auth.admin
        .updateUserById(userId, attributes: AdminUserAttributes(email: email));
    print("CAMBIO DELLA MAIL $email");
  }

  Future<bool> getInitialCapsLock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final userData = await user;
      if (userData != null) {
        await prefs.setInt("capsLock", userData.capsLock);

        return userData.capsLock == 1 ? true : false;
      }
    } catch (e) {
      final capsLock = prefs.getInt("capsLock");
      return capsLock == 1 ? true : false;
    }
    return false;
  }

  Future<UserModel> getUserData() async {
    try {
      // Get user from supabase
      final user = await _supabase.from("users").select().eq("id", userId);
      // Convert in usermodel
      final userModel = UserModel.fromMap(user.first);
      // Save user locally
      //await UserLocalStorage().insertUser(userModel: userModel);
      await getCategories();

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  SupabaseStreamBuilder getUserStream() {
    // Get user from supabase
    final user = _supabase.from("users").stream(primaryKey: ["id"]);
    return user;
  }

  Future<void> updateNameAndSurname({
    required String name,
    required String surname,
  }) async {
    await _supabase
        .from("users")
        .update({"name": name, "surname": surname}).eq("id", userId);
  }

  SupabaseStreamBuilder getWalletsStream() {
    // Get user from supabase
    final wallets = _supabase
        .from("wallets")
        .stream(primaryKey: ["id"]).order("order_index", ascending: true);
    return wallets;
  }

  SupabaseStreamFilterBuilder getCategoriesStream() {
    final categoriesStream =
        _supabase.from("categories").stream(primaryKey: ["id"]);
    return categoriesStream;
  }

  Future<SupabaseStreamBuilder> getRecentDebitsAndCreditsStream() async {
    // Get user from supabase
    final List<int> debtsAndCreditsId = await _supabase
        .from("categories")
        .select("id")
        .inFilter('name', ['DEBITO', 'CREDITO']).then(
      (value) => value
          .map(
            (e) => e["id"] as int,
          )
          .toList(),
    );
    print("debtsAndCreditsId $debtsAndCreditsId");
    final transactions = _supabase
        .from("transactions")
        .stream(primaryKey: ["id"])
        .inFilter('category_id', debtsAndCreditsId)
        .order("date", ascending: false);
    return transactions;
  }

  Future<Map<String, dynamic>> getCategoryById({required int id}) async {
    final category = await _supabase.from("categories").select().eq("id", id);
    return category.first;
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> signUpWithEmailAndPassword(
      {required String name,
      required String surname,
      required String email,
      required String password}) async {
    try {
      await _supabase.auth.signUp(
          email: email,
          password: password,
          data: {"name": name, "surname": surname});
    } catch (e) {
      print(e);
    }
  }

  Future<List<WalletModel>> getWallets() async {
    try {
      List<WalletModel> wallets = [];
      final walletList = await _supabase.from("wallets").select();
      for (var wallet in walletList) {
        wallets.add(WalletModel.fromMap(wallet));
      }
      /* await WalletsLocalStorage().insertWallets(wallets: wallets); */
      return wallets;
    } catch (e) {
      rethrow;

      /* final wallets = await WalletsLocalStorage().getWallets();
      return wallets; */
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      List<CategoryModel> categories = [];
      final categoryList = await _supabase.from("categories").select();
      for (var category in categoryList) {
        categories.add(CategoryModel.fromMap(category));
      }
      return categories;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<CategoryModel>> getIncomeCategories() async {
    try {
      List<CategoryModel> categories = [];
      final categoryList =
          await _supabase.from("categories").select().eq("type", "entrata");
      for (var category in categoryList) {
        categories.add(CategoryModel.fromMap(category));
      }
      return categories;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  SupabaseStreamBuilder getIncomeCategoriesStream() {
    final categoriesStream = _supabase
        .from("categories")
        .stream(primaryKey: ["id"]).eq("type", "entrata");
    return categoriesStream;
  }

  SupabaseStreamBuilder getExpenseCategoriesStream() {
    final categoriesStream = _supabase
        .from("categories")
        .stream(primaryKey: ["id"]).eq("type", "uscita");
    return categoriesStream;
  }

  Future<List<CategoryModel>> getExpenseCategories() async {
    try {
      List<CategoryModel> categories = [];
      final categoryList =
          await _supabase.from("categories").select().eq("type", "uscita");
      for (var category in categoryList) {
        categories.add(CategoryModel.fromMap(category));
      }
      return categories;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  SupabaseStreamBuilder getTransactions() {
    try {
      final transactionsStream = _supabase
          .from("transactions")
          .stream(primaryKey: ["id"]).order("date", ascending: false);
      return transactionsStream;
      /* List<TransactionModel> transactions = [];
      final transactionsList = await _supabase
          .from("transactions")
          .select("*,category:categories(*)");
      for (var transaction in transactionsList) {
        transactions.add(TransactionModel.fromMap(transaction));
      }
      /* await TransactionsLocalStorage()
          .insertTransactions(transactions: transactions); */
      return transactions; */
    } catch (e) {
      rethrow;
      /* final transactions = await TransactionsLocalStorage().getTransactions();
      return transactions; */
    }
  }

  Future<List<TransactionModel>> getRecentTransactions() async {
    try {
      List<TransactionModel> transactions = [];
      final transactionsList = await _supabase
          .from("transactions")
          .select("*,category:categories(*)")
          .order(
            "date",
          )
          .limit(3);

      for (var transaction in transactionsList) {
        transactions.add(TransactionModel.fromMap(transaction));
      }

      return transactions;
    } catch (e) {
      print("GET TRASNSACTIONS ERROR : $e");
      rethrow;
    }
  }

  Future<List<TransactionModel>> getRecentDebitsAndCredits() async {
    try {
      List<TransactionModel> transactions = [];
      final transactionsList = await _supabase
          .from('transactions')
          .select('''
          *,
          category:categories!inner(*)
          ''')
          .inFilter('categories.name', ['DEBITI', 'CREDITI'])
          .order('date')
          .limit(3);

      for (var transaction in transactionsList) {
        transactions.add(TransactionModel.fromMap(transaction));
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> insertTransaction(
      {required String title,
      required Type type,
      required double amount,
      required int categoryId,
      required DateTime date,
      int? walletId}) async {
    try {
      if (walletId != null) {
        await _supabase.rpc('insert_transaction_and_update_balance', params: {
          "p_title": title,
          "p_type": type.name,
          "p_amount": amount,
          "p_category_id": categoryId,
          "p_date": date.toIso8601String(),
          'p_wallet_id': walletId
        });
      } else {
        await _supabase.rpc('insert_transaction_and_update_balance', params: {
          "p_title": title,
          "p_type": type.name,
          "p_amount": amount,
          "p_category_id": categoryId,
          "p_date": date.toIso8601String(),
        });
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> insertWallet(
    String name,
    double amount,
    Color color,
  ) async {
    try {
      await _supabase.rpc("insert_wallet",
          params: {"p_name": name, "p_amount": amount, "p_color": color.value});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> insertCategory({
    required String name,
    required Type type,
    required int icon,
  }) async {
    try {
      await _supabase
          .from("categories")
          .insert({"name": name, "type": type.name, "icon": icon});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteWallet({required int id}) async {
    try {
      await _supabase.rpc("delete_wallet", params: {"p_id": id});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteTransaction({required int id}) async {
    try {
      await _supabase
          .rpc("delete_transaction_and_update_balance", params: {"p_id": id});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteCategory(
    BuildContext context, {
    required int id,
  }) async {
    try {
      final categoryTransactions =
          await _supabase.from("transactions").select().eq("category_id", id);

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
        await _supabase.from("categories").delete().eq("id", id);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> editWallet({
    required int id,
    required String name,
    required double amount,
    required Color color,
  }) async {
    try {
      await _supabase.rpc("edit_wallet", params: {
        "p_id": id,
        "p_name": name,
        "p_amount": amount,
        "p_color": color.value
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> editTransaction({
    required int id,
    required String title,
    required double amount,
    required int categoryId,
    required DateTime date,
  }) async {
    try {
      await _supabase.rpc('edit_transaction_and_update_balance', params: {
        "p_id": id,
        "p_title": title,
        "p_amount": amount,
        "p_category_id": categoryId,
        "p_date": date.toIso8601String(),
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  String? getUserEmail() {
    final session = _supabase.auth.currentSession;
    return session?.user.email;
  }

  Future<void> importFromExcel({required Excel excel}) async {
    if (excel.tables.keys.length > 1) {
      throw Exception("Troppi Fogli");
    }

    final transactions = [];

    final categories = await getCategories();

    final sheetName = excel.tables.keys.first;
    for (var row in excel.tables[sheetName]!.rows) {
      if (row[0]!.value == null) {
        break;
      }

      final firstColumn = row[0]!.value as TextCellValue;
      String title = firstColumn.value.text!;

      final secondColumn = row[1]!.value;
      double amount = 0;
      switch (secondColumn) {
        case DoubleCellValue():
          amount = secondColumn.value;
          break;
        case IntCellValue():
          amount = secondColumn.value.toDouble();
          break;
        case TextCellValue():
          amount = double.parse(secondColumn.value.text!);
          break;
        default:
      }

      final thirdColumn = row[2]!.value;
      DateTime date = DateTime.now();

      switch (thirdColumn) {
        case DateCellValue():
          date = thirdColumn.asDateTimeUtc();
          break;
        case DateTimeCellValue():
          date = thirdColumn.asDateTimeUtc();
          break;
        default:
      }

      final fourthColumn = row[3]!.value as TextCellValue;
      String category = fourthColumn.value.text!;

      final fifthColumn = row[4]!.value as TextCellValue;
      Type type = fifthColumn.value.text!.toLowerCase() == 'entrata'
          ? Type.entrata
          : Type.uscita;

      int categoryId = categories.firstWhere(
        (element) {
          return element.name == category.toUpperCase() && element.type == type;
        },
        orElse: () {
          return categories.firstWhere(
            (element) => element.name == "ALTRO" && element.type == type,
          );
        },
      ).id;
      final transaction = {
        "title": title,
        "amount": amount,
        "date": date.toIso8601String(),
        "type": type.name,
        "category_id": categoryId,
        "user_id": userId
      };

      transactions.add(transaction);
    }
    await _supabase.rpc("insert_transactions_from_import",
        params: {"transactions": transactions});
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<bool> setCapsLock(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _supabase
          .from("users")
          .update({"caps_lock": value}).eq("id", userId);
      await prefs.setInt("capsLock", value == true ? 1 : 0);
    } catch (e) {
      print(e);
    }
    return value;
  }

  Future<ThemeMode> setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _supabase
          .from("users")
          .update({"dark_theme": value}).eq("id", userId);
      await prefs.setInt("darkTheme", value == true ? 1 : 0);
    } catch (e) {
      print(e);
    }
    return value == true ? ThemeMode.dark : ThemeMode.light;
  }
}
