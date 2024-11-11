import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MigrationRepository {
  static MigrationRepository? _migrationRepositorys;
  static late Database _database;

  MigrationRepository._internal() {
    _migrationRepositorys = this;
  }

  factory MigrationRepository() =>
      _migrationRepositorys ?? MigrationRepository._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  } // satu koneksi

  Future<Database> _initializeDb() async {
    var db = openDatabase(
      join(await getDatabasesPath(), 'myapp_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE transactions (
            id INTEGER PRIMARY KEY,
            name TEXT,
            category INTEGER,
            amount INTEGER,
            date DATE,
            description TEXT
          )''',
        );
        await db.execute(
          '''CREATE TABLE schedules (
            id INTEGER PRIMARY KEY,
            name TEXT,
            category INTEGER,
            amount INTEGER,
            day INTEGER,
            month INTEGER,
            year INTEGER,
            isNotified INTEGER,
            description TEXT
          )''',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> createDatabase() async {
    final Database _ = await database;
  }
}
