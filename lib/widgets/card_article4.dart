import 'package:flutter/material.dart';
import 'package:karyawan/common/navigation.dart';
import 'package:karyawan/data/model/cuti.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:karyawan/provider/employee_db_provider.dart';
import 'package:karyawan/ui/employee_detail_page.dart';
import 'package:provider/provider.dart';

class CardArticle extends StatelessWidget {

  final Employee article;
  final Sisa sisa;

  const CardArticle({
    Key key, @required this.article, this.sisa,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeDbProvider>(
      builder: (context, providerEmployee, child) {
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
                      Text("sisa cuti : "+sisa.sisa.toString()+" hari" ?? "",
                        style: TextStyle(
                            fontSize: 12),
                      ),
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
  }
}
