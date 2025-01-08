// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class WalletModel {
  final int id;
  final String name;
  final double amount;
  final Color color;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  WalletModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  WalletModel copyWith({
    int? id,
    String? name,
    double? amount,
    Color? color,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      color: color ?? this.color,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'color': color.value,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
   
    return WalletModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      amount: map['amount'] ?? 0,
      color: Color(map['color'] ?? ""),
      orderIndex: map['order_index'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant WalletModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.color == color &&
        other.orderIndex == orderIndex &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        amount.hashCode ^
        color.hashCode ^
        orderIndex.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isSynced.hashCode;
  }

  @override
  String toString() {
    return 'WalletModel(id: $id, name: $name, amount: $amount, color: $color, orderIndex: $orderIndex, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}
