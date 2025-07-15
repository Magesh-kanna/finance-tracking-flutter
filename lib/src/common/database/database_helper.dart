import 'package:path/path.dart';
import 'package:paywize/src/features/payout/data/models/payout_model.dart';
import 'package:sqflite/sqflite.dart';

class PaywizeDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'payouts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE payouts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            beneficiaryname TEXT,
            account TEXT,
            ifsc TEXT,
            amount REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertPayout(PayoutModel payout) async {
    final db = await database;
    await db.insert(
      'payouts',
      payout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deletePayout(int id) async {
    final db = await database;
    await db.delete('payouts', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<PayoutModel>> getAllPayouts() async {
    final db = await database;
    final result = await db.query('payouts', orderBy: 'date DESC');
    return result.map((map) => PayoutModel.fromMap(map)).toList();
  }

  static Stream<List<PayoutModel>> watchAllPayouts() async* {
    while (true) {
      final db = await database;
      final result = await db.query('payouts', orderBy: 'date DESC');
      final payouts = result.map((map) => PayoutModel.fromMap(map)).toList();
      yield payouts;
    }
  }
}
