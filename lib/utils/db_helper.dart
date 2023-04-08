import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "UserHostInfo.db";
  static const _databaseVersion = 1;

  static const table = 'userinfo';

  static const columnId = 'id';
  static const columnHost = 'hostname';
  static const columnUname = 'uname';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnHost TEXT NOT NULL,
            $columnUname TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return db != null ? await db.insert(table, row) : -1;
  }

  Future<List<Map>?> queryAllRows() async {
    Database? db = await instance.database;
    if (db != null) {
      List<Map> result = await db.rawQuery('SELECT * FROM $table');
      debugPrint("*****88 ${result.length}");
      return result;
    } else {
      return null;
    }
  }

  Future<int> getCount() async {
    //database connection
    Database? db = await instance.database;
    var x = await db!.rawQuery('SELECT COUNT (*) from $table');
    int? count = Sqflite.firstIntValue(x);
    return count ?? -1;
  }

  Future<int> deleteItem(int id) async {
    //returns number of items deleted
    final db = await instance.database;

    if (db != null) {
      int result = await db!.delete(table, //table name
          where: "id = ?",
          whereArgs: [id] // use whereArgs to avoid SQL injection
          );

      return result;
    } else {
      return -1;
    }
  }
}
