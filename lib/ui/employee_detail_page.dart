import 'package:flutter/material.dart';
import 'package:karyawan/common/navigation.dart';
import 'package:karyawan/common/styles.dart';
import 'package:karyawan/data/model/cuti.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:karyawan/provider/cuti_db_provider.dart';
import 'package:karyawan/provider/employee_db_provider.dart';
import 'package:provider/provider.dart';

import 'add_employee.dart';

class EmployeeDetailPage extends StatelessWidget {
  static const routeName = '/employee_detail';

  final String id;

  const EmployeeDetailPage({
    @required this.id
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<EmployeeDbProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<Employee>(
            future: provider.getEmployeeByid(id.toString()),
            builder: (context, snapshot) {
              var employee = snapshot.data ?? null;
              return Scaffold(
                appBar: _appBar2(employee),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(employee.address),
                            Divider(color: Colors.grey),
                            Text('No induk : ${employee.noInduk}'),
                            SizedBox(height: 10),
                            Text('Tanggal lahir : ${employee.birthDate}'),
                            SizedBox(height: 10),
                            Text('Tanggal bergabung : ${employee.joinDate}'),
                            Divider(color: Colors.grey),
                            _buildConsumerCuti(employee),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0,10.0,0,0),
                              child: Material(
                                borderRadius: BorderRadius.circular(30.0),
                                shadowColor: Colors.lightBlueAccent.shade100,
                                elevation: 5.0,
                                color: primaryColor,
                                child:
                                MaterialButton(
                                  minWidth: 180.0,
                                  height: 42.0,
                                  child: Text('Edit Data Karyawan',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)
                                  ),
                                  onPressed: () {
                                    Navigation.intentWithData(
                                        AddEmployee.routeName, id);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  Consumer<CutiDbProvider> _buildConsumerCuti(Employee employee) {
    return Consumer<CutiDbProvider>(
      builder: (context, providerCuti, child) {
        providerCuti.getCutiSisaEmployee();
        return FutureBuilder<List<Cuti>>(
          future: providerCuti.getCutiByid(employee.noInduk.toString()),
          builder: (context, snapshot) {
            List<Cuti> cuti = snapshot.data;
            String _tglCuti = "";
            String _keterangan = "";
            String _lamaCuti = "";
            if(cuti!=null ) {
              for (int i = 0; i < cuti.length; i++) {
                if (i == 0) {
                  _tglCuti = cuti[i].tglCuti;
                } else {
                  _tglCuti = _tglCuti + " & " + cuti[i].tglCuti;
                }
              }
              for (int i = 0; i < cuti.length; i++) {
                if (i == 0) {
                  _lamaCuti = cuti[i].lamaCuti+" hari";
                } else {
                  _lamaCuti = _lamaCuti + " & " + cuti[i].lamaCuti+" hari";
                }
              }
              for (int i = 0; i < cuti.length; i++) {
                if (i == 0) {
                  _keterangan = cuti[i].keterangan;
                } else {
                  _keterangan = _keterangan + " & " + cuti[i].keterangan;
                }
              }
            }
            List<Sisa> sisaList = providerCuti.sisa;
            String _sisa = "";
            if(sisaList!=null){
              for (int i = 0; i < sisaList.length; i++) {
                if(sisaList[i].noInduk==employee.noInduk) {
                  _sisa = sisaList[i].sisa.toString()+" hari";
                }
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal cuti : $_tglCuti'),
                SizedBox(height: 10),
                Text('Lama cuti : $_lamaCuti'),
                SizedBox(height: 10),
                Text('Keterangan : $_keterangan'),
                SizedBox(height: 10),
                Text('Sisa cuti : $_sisa'),
                Divider(color: Colors.grey),
              ],
            );
          },
        );
      },
    );
  }

  AppBar _appBar2(Employee state) {
    return AppBar(
      title: Text("Detail Karyawan",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
      actions: <Widget>[
        Consumer<EmployeeDbProvider>(
          builder: (context, provider, child) {
            return FutureBuilder<bool>(
              future: provider.isEmployee(state.id.toString()),
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 26.0,
                  ),
                  onPressed: () {
                    provider.removeEmployee(state.id.toString());
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

