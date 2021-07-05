import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeDatabaseHelper {
  static EmployeeDatabaseHelper _databaseHelper;
  static Database _database;

  EmployeeDatabaseHelper._createObject();

  factory EmployeeDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = EmployeeDatabaseHelper._createObject();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  static const String _tblEmployee = 'employee';

  Future<Database> _initializeDb() async {

    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/employee.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblEmployee (
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 no_induk TEXT,
                 name TEXT,
                 address TEXT,
                 birth_date TEXT,
                 join_date TEXT
               ) 
            ''');
        await _loadEmployee(db);
      },
      version: 1,
    );
    return db;
  }

  _loadEmployee(Database db) async {
    Batch batch = db.batch();

    String dataJson = await rootBundle.loadString('assets/employee.json');
    List dataList = json.decode(dataJson);

    dataList.forEach((val) {
      Employee employee = Employee.fromJson(val);
      batch.insert(_tblEmployee, employee.toJson());
    });

    await batch.commit();
  }

  Future<void> insertEmployee(Employee article) async {
    final db = await database;
    await db.insert(_tblEmployee, article.toJson());
  }

  Future<void> updateEmployee(Employee article) async {
    final db = await database;
    await db.update(
      _tblEmployee,
      article.toJson(),
      where: 'id = ?',
      whereArgs: [article.id],);
  }

  Future<List<Employee>> getEmployee() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tblEmployee);
    return results.map((res) => Employee.fromJson(res)).toList();
  }

  Future<List<Employee>> getFirstEmployee() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tblEmployee);
    return results.map((res) => Employee.fromJson(res)).toList();
  }

  Future<List<Employee>> getEmployeeId(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tblEmployee,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.map((res) => Employee.fromJson(res)).toList();
  }

  Future<Map> getEmployeeById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tblEmployee,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeEmployee(String id) async {
    final db = await database;

    await db.delete(
      _tblEmployee,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}