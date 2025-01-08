// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:mobile/common/utils/utils.dart';
import 'package:mobile/model/category_model.dart';

class TransactionModel {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final int categoryId;
  final CategoryModel category;
  final Type type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.category,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    DateTime? date,
    int? categoryId,
    CategoryModel? category,
    Type? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      categoryId: map['category_id'],
      category: CategoryModel.fromMap(map["category"]),
      type: map['type'] == "entrata" ? Type.entrata : Type.uscita,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, date: $date, categoryId: $categoryId, category: $category, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.date == date &&
        other.categoryId == categoryId &&
        other.category == category &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        categoryId.hashCode ^
        category.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isSynced.hashCode;
  }
}
