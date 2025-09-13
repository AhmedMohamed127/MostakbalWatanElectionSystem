import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../data/db_helper.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  Future<void> signUp({required String id, required String name, required String phone}) async {
    final db = await AppDatabase().database;
    await db.insert('users', {'id': id, 'name': name, 'phone': phone},
        conflictAlgorithm: ConflictAlgorithm.abort);
    _currentUser = AppUser(id: id, name: name, phone: phone);
    notifyListeners();
  }

  Future<bool> signIn({required String id}) async {
    final db = await AppDatabase().database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) {
      return false;
    }
    _currentUser = AppUser.fromMap(rows.first);
    notifyListeners();
    return true;
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}



