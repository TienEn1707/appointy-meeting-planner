import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 2;
  static const String _tableName = 'tasks';
  static const String _companyTableName = 'company_tb';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('DB not null');
      return;
    }
    try {
      String path = '${await getDatabasesPath()}task.db';
      debugPrint('In DB path');
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (Database db, int version) async {
          debugPrint('Creating new one');
          await db.execute('CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'company_name STRING, note TEXT, date STRING, '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, color INTEGER, '
              'isCompleted INTEGER)');

          await db.execute('CREATE TABLE $_companyTableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'companyName STRING)');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
                'ALTER TABLE $_tableName ADD COLUMN isCompleted INTEGER DEFAULT 0');
          }
        },
      );
      print('DB create/open');
    } catch (e) {
      print('Error during create/open DB: $e');
    }
  }

  // Untuk Meeting
  static Future<List<Map<String, dynamic>>> query() async {
    print('Query function called');
    return await _db!.query(_tableName);
  }

  static Future<int> insert(Task? task) async {
    print('Insert function called');
    try {
      return await _db!.insert(_tableName, task!.toJson());
    } catch (e) {
      print('Error during insert: $e');
      return -1;
    }
  }

  static Future<int> updateTask(Task task) async {
    return await _db!.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> updateTaskCompletion(int id, bool isCompleted) async {
    print('UpdateTaskCompletion function called');
    return await _db!.update(
      _tableName,
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> delete(Task task) async {
    print('Delete function called');
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> deleteAll() async {
    print('DeleteAll function called');
    return await _db!.delete(_tableName);
  }

  // Untuk Company
  static Future<List<Map<String, dynamic>>> queryCompanies() async {
    print('QueryCompanies function called');
    return await _db!.query(_companyTableName);
  }

  static Future<int> insertCompany(String companyName) async {
    print('InsertCompany function called');
    try {
      return await _db!.insert(_companyTableName, {'companyName': companyName});
    } catch (e) {
      print('Error during insert company: $e');
      return -1;
    }
  }

  static Future<int> updateCompany(int id, String newCompanyName) async {
    print('UpdateCompany function called');
    return await _db!.update(
      _companyTableName,
      {'companyName': newCompanyName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteCompany(int id) async {
    print('DeleteCompany function called');
    return await _db!.delete(
      _companyTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
