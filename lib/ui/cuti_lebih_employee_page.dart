import 'package:flutter/material.dart';
import 'package:karyawan/provider/cuti_db_provider.dart';
import 'package:karyawan/ui/add_employee.dart';
import 'package:karyawan/utils/result_state.dart';
import 'package:karyawan/widgets/card_article3.dart';
import 'package:karyawan/widgets/pop_menu.dart';
import 'package:provider/provider.dart';

class CutiLebihEmployeeListPage extends StatelessWidget {
  static const routeName = '/cuti_lebih_employee_list';

  const CutiLebihEmployeeListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karyawan cuti lebih dari 2x',
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
      body: Consumer<CutiDbProvider>(
        builder: (context, provider, child) {
          provider.getCutiLebihEmployee();
          if (provider.stateCutiLebih == ResultState.HasData) {
            return ListView.builder(
              padding: EdgeInsets.all(3.0),
              itemCount: provider.employeeCutiLebih.length,
              itemBuilder: (context, index) {
                return CardArticle(article: provider.employeeCutiLebih[index], );
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
}
