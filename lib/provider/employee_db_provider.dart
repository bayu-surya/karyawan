import 'package:flutter/foundation.dart';
import 'package:karyawan/data/db/employee_database_helper.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:karyawan/utils/result_state.dart';

class EmployeeDbProvider extends ChangeNotifier {
  final EmployeeDatabaseHelper databaseHelper;

  EmployeeDbProvider({@required this.databaseHelper}){
    _getEmployee();
  }

  ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Employee> _employee = [];
  List<Employee> get employee => _employee;

  void _getEmployee() async {
    _employee = await databaseHelper.getEmployee();
    if (_employee.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  Future<Employee> getEmployeeByid(String id) async {
    List<Employee> data = await databaseHelper.getEmployeeId(id);
    return data.first;
  }

  Future<bool> isEmployee(String id) async {
    final favoriteRestaurant = await databaseHelper.getEmployeeById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void addEmployee(Employee article) async {
    try {
      await databaseHelper.insertEmployee(article);
      _getEmployee();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void updateEmployee(Employee article) async {
    try {
      await databaseHelper.updateEmployee(article);
      _getEmployee();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void removeEmployee(String url) async {
    try {
      await databaseHelper.removeEmployee(url);
      _getEmployee();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
