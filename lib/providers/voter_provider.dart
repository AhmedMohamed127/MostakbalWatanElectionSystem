import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../data/db_helper.dart';
import '../models/voter.dart';

class VoterProvider extends ChangeNotifier {
  List<Voter> _voters = [];
  List<Voter> get voters => _voters;

  Future<void> loadAll({String? search}) async {
    final db = await AppDatabase().database;
    String? where;
    List<Object?>? whereArgs;
    if (search != null && search.trim().isNotEmpty) {
      where = 'nationalId LIKE ? OR fullName LIKE ?';
      final like = '%${search.trim()}%';
      whereArgs = [like, like];
    }
    final rows = await db.query('voters', where: where, whereArgs: whereArgs, orderBy: 'id DESC');
    _voters = rows.map((e) => Voter.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addVoter(Voter voter) async {
    final db = await AppDatabase().database;
    final id = await db.insert('voters', voter.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
    _voters.insert(0, voter.copyWith(localId: id));
    notifyListeners();
  }

  Future<void> setVoted(int localId, bool voted) async {
    final db = await AppDatabase().database;
    await db.update('voters', {'isVoted': voted ? 1 : 0}, where: 'id = ?', whereArgs: [localId]);
    final idx = _voters.indexWhere((v) => v.localId == localId);
    if (idx != -1) {
      _voters[idx] = _voters[idx].copyWith(isVoted: voted);
      notifyListeners();
    }
  }

  Future<void> setProcessConfirmed(int localId, bool confirmed) async {
    final db = await AppDatabase().database;
    await db.update('voters', {'isProcessConfirmed': confirmed ? 1 : 0}, where: 'id = ?', whereArgs: [localId]);
    final idx = _voters.indexWhere((v) => v.localId == localId);
    if (idx != -1) {
      _voters[idx] = _voters[idx].copyWith(isProcessConfirmed: confirmed);
      notifyListeners();
    }
  }
}



