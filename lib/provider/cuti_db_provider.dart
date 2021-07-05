import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:karyawan/data/db/cuti_database_helper.dart';
import 'package:karyawan/data/db/employee_database_helper.dart';
import 'package:karyawan/data/model/cuti.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:karyawan/utils/result_state.dart';

class CutiDbProvider extends ChangeNotifier {
  final CutiDatabaseHelper databaseHelper;
  final EmployeeDatabaseHelper employeeDatabaseHelper;

  CutiDbProvider({@required this.databaseHelper, @required this.employeeDatabaseHelper}){
    _getCuti();
  }

  String _message = '';
  String get message => _message;

  List<Cuti> _cuti = [];
  List<Cuti> get cuti => _cuti;

  ResultState _state;
  ResultState get state => _state;

  ResultState _stateEmployee;
  ResultState get stateEmployee => _stateEmployee;

  ResultState _stateCutiLebih;
  ResultState get stateCutiLebih => _stateCutiLebih;

  ResultState _stateSisa;
  ResultState get stateSisa => _stateSisa;

  List<Employee> _employee = [];
  List<Employee> get employee => _employee;

  List<Employee> _employeeCuti = [];
  List<Employee> get employeeCuti => _employeeCuti;

  List<Employee> _employeeCutiLebih = [];
  List<Employee> get employeeCutiLebih => _employeeCutiLebih;

  List<Employee> _employeeSisa = [];
  List<Employee> get employeeSisa => _employeeSisa;

  List<Sisa> _sisa=[];
  List<Sisa> get sisa => _sisa;

  void _getCuti() async {
    _cuti = await databaseHelper.getCuti();
    if (_cuti.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void getCutiEmployee() async {
    _employee = await employeeDatabaseHelper.getEmployee();
    if (_employee.length > 0) {
      _employeeCuti=[];
      for(int i=0;i<_employee.length;i++){
        for(int j=0;j<_cuti.length;j++) {
          if (_employee[i].noInduk == _cuti[j].noInduk) {
            if (!_employeeCuti.contains(_employee[i])) {
              _employeeCuti.add(_employee[i]);
            }
          }
        }
      }
      if (_employeeCuti.length > 0) {
        _stateEmployee = ResultState.HasData;
      } else {
        _stateEmployee = ResultState.NoData;
        _message = 'Empty Data';
      }
    } else {
      _stateEmployee = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void getCutiLebihEmployee() async {
    _employee = await employeeDatabaseHelper.getEmployee();
    if (_employee.length > 0) {

      var map = Map();
      _cuti.forEach((item) {
        if(!map.containsKey(item.noInduk)) {
          map[item.noInduk] = 1;
        } else {
          map[item.noInduk] +=1;
        }
      });

      List<String> dataCount = [];
      map.forEach((key, value) {
        if(value>1){
          dataCount.add(key);
        }
      });

      _employeeCutiLebih=[];
      for(int i=0;i<_employee.length;i++){
        for(int j=0;j<dataCount.length;j++) {
          if (_employee[i].noInduk == dataCount[j]) {
            if (!_employeeCutiLebih.contains(_employee[i])) {
              _employeeCutiLebih.add(_employee[i]);
            }
          }
        }
      }
      if (_employeeCutiLebih.length > 0) {
        _stateCutiLebih = ResultState.HasData;
      } else {
        _stateCutiLebih = ResultState.NoData;
        _message = 'Empty Data';
      }
    } else {
      _stateCutiLebih = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void getCutiSisaEmployee() async {
    _employee = await employeeDatabaseHelper.getEmployee();
    if (_employee.length > 0) {

      var map = Map();
      _cuti.forEach((item) {
        if(!map.containsKey(item.noInduk)) {
          map[item.noInduk] = int.parse(item.lamaCuti);
        } else {
          map[item.noInduk] += int.parse(item.lamaCuti);
        }
      });

      _sisa=[];
      for(int i=0;i<_employee.length;i++){
        if(map.containsKey(employee[i].noInduk)){
          Sisa data = Sisa(
            noInduk: employee[i].noInduk,
            sisa: 12-map[employee[i].noInduk],
          );
          _sisa.add(data);
        } else {
          Sisa data = Sisa(
          noInduk: employee[i].noInduk,
          sisa: 12,
        );
        _sisa.add(data);
        }
      }

      if (_sisa.length > 0) {
        _stateSisa = ResultState.HasData;
      } else {
        _stateSisa = ResultState.NoData;
        _message = 'Empty Data';
      }
    } else {
      _stateSisa = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  Future<List<Cuti>> getCutiByid(String id) async {
    List<Cuti> data = await databaseHelper.getCutiId(id);
    return data;
  }

  Future<bool> isCuti(String id) async {
    final favoriteRestaurant = await databaseHelper.getCutiById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void addCuti(Cuti article) async {
    try {
      await databaseHelper.insertCuti(article);
      _getCuti();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void updateCuti(Cuti article) async {
    try {
      await databaseHelper.updateCuti(article);
      _getCuti();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void removeCuti(String url) async {
    try {
      await databaseHelper.removeCuti(url);
      _getCuti();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}