import 'package:app_fiman/utils/constants/contant.dart';

class TransactionModel {
  int? id;
  late String name;
  late int amount;
  late DateTime date;
  late int category;
  String? categoryName;
  String? description;

  TransactionModel({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    this.categoryName,
    this.description,
  });

  TransactionModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    amount = map['amount'];
    date = DateTime.parse(map['date']);
    category = map['category'];
    categoryName = map['category'] == pemasukanId ? 'Pemasukan' : 'Pengeluaran';
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
    };
  }
}
