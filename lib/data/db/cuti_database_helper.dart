import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:karyawan/data/model/cuti.dart';
import 'package:sqflite/sqflite.dart';

class CutiDatabaseHelper {
  static CutiDatabaseHelper _databaseHelper;
  static Database _database;

  CutiDatabaseHelper._createObject();

  factory CutiDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = CutiDatabaseHelper._createObject();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  static const String _tblCuti = 'cuti';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/cuti.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblCuti (
                 id TEXT PRIMARY KEY,
                 no_induk TEXT,
                 tgl_cuti TEXT,
                 lama_cuti TEXT,
                 keterangan TEXT
               ) 
            ''');
        await _loadCuti(db);
      },
      version: 1,
    );
    return db;
  }

  _loadCuti(Database db) async {
    Batch batch = db.batch();

    String dataJson = await rootBundle.loadString('assets/cuti.json');
    List dataList = json.decode(dataJson);

    dataList.forEach((val) {
      Cuti cuti = Cuti.fromJson(val);
      batch.insert(_tblCuti, cuti.toJson());
    });

    await batch.commit();
  }

  Future<void> insertCuti(Cuti article) async {
    final db = await database;
    await db.insert(_tblCuti, article.toJson());
  }

  Future<List<Cuti>> getCuti() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tblCuti);
    return results.map((res) => Cuti.fromJson(res)).toList();
  }

  Future<List<Cuti>> getCutiId(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tblCuti,
      where: 'no_induk = ?',
      whereArgs: [id],
    );
    return results.map((res) => Cuti.fromJson(res)).toList();
  }

  Future<Map> getCutiById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tblCuti,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeCuti(String id) async {
    final db = await database;

    await db.delete(
      _tblCuti,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCuti(Cuti article) async {
    final db = await database;
    await db.update(_tblCuti, article.toJson());
  }
}