import 'package:intl/intl.dart';

class ResumeModel {
  late String day;
  late int transactionSum;

  ResumeModel({
    required this.day,
    required this.transactionSum,
  });

  ResumeModel.fromMap(Map<String, dynamic> map) {
    day = DateFormat('d').format(DateTime.parse(map['date']));
    transactionSum = map['sum'];
  }
}
