import 'package:app_fiman/utils/constants/contant.dart';

class ScheduleModel {
  int? id;
  late String name;
  late int amount;
  DateTime? date;
  late int category;
  int? day;
  int? month;
  int? year;
  String? categoryName;
  String? description;
  late bool isNotifed;

  ScheduleModel({
    this.id,
    required this.name,
    required this.amount,
    this.date,
    this.day,
    this.month,
    this.year,
    required this.category,
    this.categoryName,
    this.description,
    required this.isNotifed,
  });

  ScheduleModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    amount = map['amount'];
    day = map['day'];
    month = map['month'];
    year = map['year'];
    category = map['category'];
    categoryName = map['category'] == pemasukanId ? 'Pemasukan' : 'Pengeluaran';
    description = map['description'];
    isNotifed = map['isNotifed'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'description': description,
      'day': day,
      'month': month,
      'year': year,
      'isNotified': isNotifed ? 1 : 0,
    };
  }
}
