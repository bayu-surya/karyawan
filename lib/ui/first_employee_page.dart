import 'package:flutter/material.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:karyawan/provider/employee_db_provider.dart';
import 'package:karyawan/ui/add_employee.dart';
import 'package:karyawan/utils/date_time_helper.dart';
import 'package:karyawan/utils/result_state.dart';
import 'package:karyawan/widgets/card_article2.dart';
import 'package:karyawan/widgets/pop_menu.dart';
import 'package:provider/provider.dart';

class FirstEmployeeListPage extends StatelessWidget {
  static const routeName = '/first_employee_list';

  const FirstEmployeeListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List 3 karyawan pertama',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 26.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEmployee(),
                ),
              );
            },
          ),
          PopMenu(),
        ],
      ),
      body:
      Consumer<EmployeeDbProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.HasData) {
            return ListView.builder(
              padding: EdgeInsets.all(3.0),
              itemCount: getFirstEmployee(provider.employee).length,
              itemBuilder: (context, index) {
                return CardArticle(article:getFirstEmployee(provider.employee)[index], jenis: "first");
              },
            );
          } else {
            return Center(
              child: Text(provider.message),
            );
          }
        },
      ),
    );
  }

  List<Employee> getFirstEmployee(List<Employee> _dataMentah) {

    List<Employee> _employeeSort=[];
    List<Employee> _data=_dataMentah;
    for(int i=0;i<_data.length;i++){
      Employee item = new Employee(
          id: _data[i].id,
          noInduk: _data[i].noInduk,
          name: _data[i].name,
          address: _data[i].address,
          birthDate: _data[i].birthDate,
          joinDate: DateTimeHelper.formatDateSort(_data[i].joinDate)
      );
      _employeeSort.add(item);
    }

    _employeeSort.sort((a, b) => a.joinDate.compareTo(b.joinDate));

    List<Employee> _employeeFirst=[];
    for(int i=0;i<3;i++){
      for(int j=0;j<_data.length;j++) {
        if (_employeeSort[i].id==_data[j].id){
          _employeeFirst.add(_data[j]);
        }
      }
    }

    return _employeeFirst;
  }
}
