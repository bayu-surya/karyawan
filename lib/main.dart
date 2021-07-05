import 'package:flutter/material.dart';
import 'package:karyawan/common/navigation.dart';
import 'package:karyawan/common/styles.dart';
import 'package:karyawan/data/db/cuti_database_helper.dart';
import 'package:karyawan/data/db/employee_database_helper.dart';
import 'package:karyawan/provider/cuti_db_provider.dart';
import 'package:karyawan/provider/employee_db_provider.dart';
import 'package:karyawan/ui/add_employee.dart';
import 'package:karyawan/ui/cuti_employee_page.dart';
import 'package:karyawan/ui/cuti_lebih_employee_page.dart';
import 'package:karyawan/ui/employee_detail_page.dart';
import 'package:karyawan/ui/first_employee_page.dart';
import 'package:karyawan/ui/list_employee_page.dart';
import 'package:karyawan/ui/sisa_cuti_employee_page.dart';
import 'package:karyawan/ui/splashscreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => EmployeeDbProvider(databaseHelper: EmployeeDatabaseHelper()),),
          ChangeNotifierProvider(
            create: (_) => CutiDbProvider(
                databaseHelper: CutiDatabaseHelper(),
                employeeDatabaseHelper: EmployeeDatabaseHelper()
            ),),
        ],
        child: MaterialApp(
          title: 'Karyawan',
          theme: ThemeData(
            primaryColor: primaryColor,
            accentColor: secondaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: myTextTheme,
            appBarTheme: AppBarTheme(
              textTheme: myTextTheme.apply(bodyColor: Colors.black),
              elevation: 0,
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: primaryColor,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
            ),
          ),
          navigatorKey: navigatorKey,
          initialRoute: Splashscreen.routeName,
          routes: {
            Splashscreen.routeName: (context) => Splashscreen(),
            EmployeeListPage.routeName: (context) => EmployeeListPage(),
            FirstEmployeeListPage.routeName: (context) => FirstEmployeeListPage(),
            CutiEmployeeListPage.routeName: (context) => CutiEmployeeListPage(),
            CutiLebihEmployeeListPage.routeName: (context) => CutiLebihEmployeeListPage(),
            SisaCutiEmployeeListPage.routeName: (context) => SisaCutiEmployeeListPage(),
            EmployeeDetailPage.routeName: (context) => EmployeeDetailPage(
              id: ModalRoute.of(context).settings.arguments,
            ),
            AddEmployee.routeName: (context) => AddEmployee(
              id: ModalRoute.of(context).settings.arguments,
            ),
          },
        ),
      );
  }
}


