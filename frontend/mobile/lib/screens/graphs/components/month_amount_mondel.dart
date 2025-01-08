// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MonthAmountMondel {
  DateTime date;
  double amount;
  String name;
  MonthAmountMondel({
    required this.date,
    required this.amount,
    required this.name,
  });

  MonthAmountMondel copyWith({
    DateTime? date,
    double? amount,
    String? name,
  }) {
    return MonthAmountMondel(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'name': name,
    };
  }

  factory MonthAmountMondel.fromMap(Map<String, dynamic> map) {
    return MonthAmountMondel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      amount: map['amount'] as double,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthAmountMondel.fromJson(String source) => MonthAmountMondel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MonthAmountMondel(date: $date, amount: $amount, name: $name)';

  @override
  bool operator ==(covariant MonthAmountMondel other) {
    if (identical(this, other)) return true;
  
    return 
      other.date == date &&
      other.amount == amount &&
      other.name == name;
  }

  @override
  int get hashCode => date.hashCode ^ amount.hashCode ^ name.hashCode;
}
