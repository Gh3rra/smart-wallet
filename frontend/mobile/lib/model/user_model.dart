// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String surname;
  final double totalBalance;
  final double totalWallet;
  final int darkTheme;
  final int capsLock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.totalBalance,
    required this.totalWallet,
    required this.darkTheme,
    required this.capsLock,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? surname,
    double? totalBalance,
    double? totalWallet,
    int? darkTheme,
    int? capsLock,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      totalBalance: totalBalance ?? this.totalBalance,
      totalWallet: totalWallet ?? this.totalWallet,
      darkTheme: darkTheme ?? this.darkTheme,
      capsLock: capsLock ?? this.capsLock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'surname': surname,
      'total_balance': totalBalance,
      'total_wallet': totalWallet,
      'dark_theme': darkTheme,
      'caps_lock': capsLock,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      surname: map['surname'] ?? "",
      totalBalance: map['total_balance'] ?? 0,
      totalWallet: map['total_wallet'] ?? 0,
      darkTheme: map['dark_theme'] != null && map['dark_theme'] == true ? 1 : 0,
      capsLock: map['caps_lock'] != null && map['caps_lock'] == true ? 1 : 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.surname == surname &&
        other.totalBalance == totalBalance &&
        other.totalWallet == totalWallet &&
        other.darkTheme == darkTheme &&
        other.capsLock == capsLock &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        totalBalance.hashCode ^
        totalWallet.hashCode ^
        darkTheme.hashCode ^
        capsLock.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isSynced.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, surname: $surname, totalBalance: $totalBalance, totalWallet: $totalWallet, darkTheme: $darkTheme, capsLock: $capsLock, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}
