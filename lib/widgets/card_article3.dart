import 'package:flutter/material.dart';
import 'package:karyawan/common/navigation.dart';
import 'package:karyawan/data/model/cuti.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:karyawan/provider/cuti_db_provider.dart';
import 'package:karyawan/provider/employee_db_provider.dart';
import 'package:karyawan/ui/employee_detail_page.dart';
import 'package:provider/provider.dart';

class CardArticle extends StatelessWidget {

  final Employee article;

  const CardArticle({
    Key key, @required this.article,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeDbProvider>(
      builder: (context, providerEmployee, child) {
        return Consumer<CutiDbProvider>(
          builder: (context, provider, child) {
            return FutureBuilder<List<Cuti>>(
              future: provider.getCutiByid(article.noInduk.toString()),
              builder: (context, snapshot) {
                List<Cuti> cuti = snapshot.data;
                String _tglCuti = "";
                String _keterangan = "";
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
                      _keterangan = cuti[i].keterangan;
                    } else {
                      _keterangan = _keterangan + " & " + cuti[i].keterangan;
                    }
                  }
                }
                return GestureDetector(
                  onTap: () {
                    Navigation.intentWithData(
                        EmployeeDetailPage.routeName, article.id.toString());
                  },
                  child: Card(
                    elevation: 1.7,
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text(article.name ?? "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                              SizedBox(height: 5),
                              Text(article.noInduk ?? "",
                                style: TextStyle(
                                    fontSize: 12),
                              ),
                              SizedBox(height: 5),
                              cuti!=null ?
                              Text("tanggal cuti : "+_tglCuti ?? "",
                                style: TextStyle(
                                    fontSize: 12),
                              ) :
                              SizedBox(height: 0),
                              SizedBox(height: 5),
                              cuti!=null ?
                              Text("keterangan : "+_keterangan ?? "",
                                style: TextStyle(
                                    fontSize: 12),
                              ):
                              SizedBox(height: 0),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.grey,
                            size: 26.0,
                          ),
                          onPressed: () {
                            providerEmployee.removeEmployee(article.id.toString());
                          },
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
