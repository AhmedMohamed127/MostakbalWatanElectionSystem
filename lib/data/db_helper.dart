import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'mostakbal_watan.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            phone TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE voters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nationalId TEXT NOT NULL,
            fullName TEXT NOT NULL,
            registrarId TEXT NOT NULL,
            imagePath TEXT,
            isVoted INTEGER NOT NULL DEFAULT 0,
            isProcessConfirmed INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY(registrarId) REFERENCES users(id)
          );
        ''');
      },
    );
  }
}



