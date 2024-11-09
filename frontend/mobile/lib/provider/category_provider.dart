import 'package:flutter/material.dart';
import 'package:mobile/services/db.dart';

class CategoryProvider with ChangeNotifier {
  Map<String, Map<String, dynamic>> incomesCategory = {};
  Map<String, Map<String, dynamic>> expensesCategory = {};
  bool isLoading = false;

  Future<void> fetchCategories() async {
    isLoading = true;
    var incomes = await Db().userDoc.collection("incomesCategory").get();
    var expenses = await Db().userDoc.collection("expensesCategory").get();
    for (var element in incomes.docs) {
      incomesCategory[element.id] = {
        "name": element["name"],
        "icon": element["icon"],
      };
    }
    for (var element in expenses.docs) {
      expensesCategory[element.id] = {
        "name": element["name"],
        "icon": element["icon"],
      };
    }
    isLoading = false;

    notifyListeners();
  }

  initialize() {
    fetchCategories();
  }
}
