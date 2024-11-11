import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/schedule_model.dart';

class ScheduleRepository {
  static ScheduleRepository? _scheduleRepository;
  static late Database _database;

  ScheduleRepository._internal() {
    _scheduleRepository = this;
  }

  factory ScheduleRepository() =>
      _scheduleRepository ?? ScheduleRepository._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  } // satu koneksi

  final String _tableName = 'schedules';

  Future<Database> _initializeDb() async {
    var db = openDatabase(
      join(await getDatabasesPath(), 'myapp_db.db'),
      version: 1,
    );
    return db;
  }

  Future<int> insertSchedule(ScheduleModel transaction) async {
    final Database db = await database;
    final result = await db.insert(_tableName, transaction.toMap());
    return result;
  }

  Future<List<ScheduleModel>> getSchedule() async {
    final Database db = await database;
    String orderBy = 'id DESC';
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      orderBy: orderBy,
    );
    return results.map((e) => ScheduleModel.fromMap(e)).toList();
  }

  Future<List<ScheduleModel>> getNotification() async {
    final Database db = await database;
    final day = DateTime.now().day;
    final month = DateTime.now().month;
    final year = DateTime.now().year;

    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where:
          '(day = ? OR day IS NULL) AND (month = ? OR month IS NULL) AND (year = ? OR year IS NULL) and isNotified = 0',
      whereArgs: [day, month, year],
    );

    await db.update(
      _tableName,
      {'isNotified': 0},
      where:
          '(day != ? OR day IS NULL) AND (month != ? OR month IS NULL) AND (year != ? OR year IS NULL) and isNotified = 1',
      whereArgs: [day, month, year],
    );

    return results.map((e) => ScheduleModel.fromMap(e)).toList();
  }

  Future<int> readNotification(int id) async {
    final db = await database;
    final result = await db.update(
      _tableName,
      {
        'isNotified': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteSchedule(int id) async {
    final db = await database;
    final result = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }
}
