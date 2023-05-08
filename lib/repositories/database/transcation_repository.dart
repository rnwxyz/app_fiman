import 'package:app_fiman/models/transaction_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            name TEXT,
            category INTEGER,
            amount INTEGER,
            date DATE,
            description TEXT
        )''',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final Database db = await database;
    final result = await db.insert(_tableName, transaction.toMap());
    return result;
  }

  Future<List<TransactionModel>> getTransactions() async {
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(_tableName, orderBy: 'id DESC');
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
}
