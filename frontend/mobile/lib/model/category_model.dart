// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile/common/utils/utils.dart';

class CategoryModel {
  final int id;
  final String name;
  final Type type;
  final int icon;
  final DateTime createdAt;
  final int isSynced;
  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.createdAt,
    required this.isSynced,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    Type? type,
    int? icon,
    DateTime? createdAt,
    int? isSynced,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type == Type.entrata ? "ENTRATA" : "USCITA",
      'icon': icon,
      'created_at': createdAt.millisecondsSinceEpoch,
      'is_synced': isSynced,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      type: map['type'] == "entrata" ? Type.entrata : Type.uscita,
      icon: map['icon'] ?? "",
      createdAt: DateTime.parse(map['created_at']),
      isSynced: map['is_synced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, type: $type, icon: $icon, createdAt: $createdAt, isSynced: $isSynced)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.type == type &&
        other.icon == icon &&
        other.createdAt == createdAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        icon.hashCode ^
        createdAt.hashCode ^
        isSynced.hashCode;
  }
}
