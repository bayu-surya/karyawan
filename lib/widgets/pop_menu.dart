import 'package:flutter/material.dart';
import 'package:karyawan/ui/cuti_employee_page.dart';
import 'package:karyawan/ui/cuti_lebih_employee_page.dart';
import 'package:karyawan/ui/first_employee_page.dart';
import 'package:karyawan/ui/list_employee_page.dart';
import 'package:karyawan/ui/sisa_cuti_employee_page.dart';

class PopMenu extends StatelessWidget {

  const PopMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) {
          if(value==0){
            Navigator.pushReplacementNamed(context, EmployeeListPage.routeName);
          } if(value==1){
            Navigator.pushReplacementNamed(context, FirstEmployeeListPage.routeName);
          } if(value==2){
            Navigator.pushReplacementNamed(context, CutiEmployeeListPage.routeName);
          } if(value==3){
            Navigator.pushReplacementNamed(context, CutiLebihEmployeeListPage.routeName);
          } if(value==4){
            Navigator.pushReplacementNamed(context, SisaCutiEmployeeListPage.routeName);
          }
        },
        itemBuilder: (context) => [
          _popupMenuItem(0, 'List semua karyawan'),
          _popupMenuItem(1, '3 Karyawan pertama'),
          _popupMenuItem(2, 'Karyawan cuti'),
          _popupMenuItem(3, 'Karyawan cuti lebih dari 2x'),
          _popupMenuItem(4, 'Sisa cuti karyawan'),
        ]);
  }

  PopupMenuItem<int> _popupMenuItem(int value, String text) {
    return PopupMenuItem(
            value: value,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                ),
                Text(text)
              ],
            ));
  }
}
