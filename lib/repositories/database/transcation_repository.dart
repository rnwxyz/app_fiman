import 'package:app_fiman/models/resume_model.dart';
import 'package:app_fiman/utils/constants/contant.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/transaction_model.dart';

class TransactionRepository {
  static TransactionRepository? _transactionRepository;
  static late Database _database;

  TransactionRepository._internal() {
    _transactionRepository = this;
  }

  factory TransactionRepository() =>
      _transactionRepository ?? TransactionRepository._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  final String _tableName = 'transactions';

  Future<Database> _initializeDb() async {
    var db = openDatabase(
      join(await getDatabasesPath(), 'myapp_db.db'),
      version: 1,
    );
    return db;
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final Database db = await database;
    final result = await db.insert(_tableName, transaction.toMap());
    return result;
  }

  Future<List<TransactionModel>> getTransactions(
    int offset,
    String search,
    String sort,
    int categoryId,
  ) async {
    final Database db = await database;
    const limit = 10;
    String condition = 'name LIKE ?';
    List<String> args = ['%$search%'];
    String orderBy = 'id DESC';

    if (categoryId != 0) {
      condition += ' AND category = ?';
      args.add(categoryId.toString());
    }

    if (sort != '') {
      orderBy = 'date $sort';
    }

    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      orderBy: orderBy,
      limit: limit,
      offset: offset * limit,
      where: condition,
      whereArgs: args,
    );
    return results.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<TransactionModel> getTransactionById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.map((e) => TransactionModel.fromMap(e)).first;
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    final result = await db.update(
      _tableName,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    return result;
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    final result = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> getTransactionSum() async {
    final db = await database;
    final pemasukan = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT SUM(amount) FROM $_tableName where category = $pemasukanId'),
    );
    final pengeluaran = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT SUM(amount) FROM $_tableName where category = $pengeluaranId'),
    );

    final result = (pemasukan ?? 0) - (pengeluaran ?? 0);
    return result;
  }

  Future<List<ResumeModel>> getTransactionResumeThisMonth() async {
    final db = await database;
    final String param = DateFormat('yyyy-MM').format(DateTime.now());
    final result = await db.rawQuery(
        'SELECT SUM(CASE WHEN category = 1 THEN amount ELSE amount*-1 END) as sum, date FROM $_tableName where date LIKE "%$param%" GROUP BY date');
    return result.map((e) => ResumeModel.fromMap(e)).toList();
  }
}
