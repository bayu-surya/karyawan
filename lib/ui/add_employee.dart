import 'package:flutter/material.dart';
import 'package:karyawan/common/styles.dart';
import 'package:karyawan/data/model/employee.dart';
import 'package:karyawan/provider/employee_db_provider.dart';
import 'package:karyawan/utils/date_time_helper.dart';
import 'package:karyawan/widgets/date_picker.dart';
import 'package:karyawan/widgets/edit_text.dart';
import 'package:provider/provider.dart';

class AddEmployee extends StatefulWidget {
  static const routeName = '/add_employee';

  final String id;

  const AddEmployee({
    this.id
  });

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {

  String _alertString = "";
  String _noInduk = "";
  String _name = "";
  String _address= "";
  final TextEditingController noIndukController= TextEditingController();
  final TextEditingController nameController= TextEditingController();
  final TextEditingController addressController= TextEditingController();
  final TextEditingController birthDateController= TextEditingController();
  final TextEditingController joinDateController= TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    noIndukController.dispose();
    nameController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    joinDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    DateTime currentDate = DateTime.now();
    Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
      final DateTime pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(1901),
          lastDate: DateTime(2100));
      if (pickedDate != null && pickedDate != currentDate)
        setState(() {
          currentDate = pickedDate;
          String data = DateTimeHelper.formatDate(currentDate);
          controller.text= data;
        });
    }

    final _logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 45.0,
      child: Image.asset('images/logo_karyawan.png', width: 200, height: 200),
    );

    final _loginButton = Consumer<EmployeeDbProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0,10.0,0,0),
          child: Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.lightBlueAccent.shade100,
            elevation: 5.0,
            color: primaryColor,
            child:
            MaterialButton(
              minWidth: 200.0,
              height: 42.0,
              child: Text(widget.id!=null? 'Edit Karyawan':'Tambah Karyawan',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)
              ),
              onPressed: () {
                if ( _noInduk=="" ) {
                  setState(() {
                    _alertString="Anda belum mengisi No Induk";
                  });
                } else if(_name==""){
                  setState(() {
                    _alertString="Anda belum mengisi Nama";
                  });
                } else if(_address==""){
                  setState(() {
                    _alertString="Anda belum mengisi Alamat";
                  });
                } else if(birthDateController.text==""){
                  setState(() {
                    _alertString="Anda belum mengisi Tanggal Lahir";
                  });
                } else if(joinDateController.text==""){
                  setState(() {
                    _alertString="Anda belum mengisi Tanggal Bergabung";
                  });
                } else {

                  Employee employee =  widget.id!=null?
                  Employee(
                      id: widget.id,
                      noInduk: _noInduk,
                      name: _name,
                      address: _address,
                      birthDate: birthDateController.text.toString(),
                      joinDate: joinDateController.text.toString()
                  ) :
                  Employee(
                    noInduk: _noInduk,
                    name: _name,
                    address: _address,
                    birthDate: birthDateController.text,
                    joinDate: joinDateController.text,
                  );
                  widget.id!=null?
                  provider.updateEmployee(employee)
                      :provider.addEmployee(employee);

                  noIndukController.clear();
                  nameController.clear();
                  addressController.clear();
                  birthDateController.clear();
                  joinDateController.clear();

                  _noInduk="";
                  _name="";
                  _address="";

                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );

    final _tittle = Padding (
      padding: EdgeInsets.fromLTRB(15.0,0,0,0),
      child: Text(
        widget.id!=null? 'Edit Karyawan':'Tambah Karyawan',
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );

    return Consumer<EmployeeDbProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<Employee>(
              future: provider.getEmployeeByid(widget.id.toString()),
              builder: (context, snapshot) {
                var employee = snapshot.data ?? null;
                if (widget.id!=null){
                  if(noIndukController.text=="") {
                    noIndukController.text = employee.noInduk;
                  } if(nameController.text=="") {
                    nameController.text = employee.name;
                  } if(addressController.text=="") {
                    addressController.text = employee.address;
                  } if(birthDateController.text=="") {
                    birthDateController.text = employee.birthDate;
                  } if(joinDateController.text=="") {
                    joinDateController.text = employee.joinDate;
                  }

                  if(_noInduk=="") {
                    _noInduk=employee.noInduk;
                  } if(_name=="") {
                    _name=employee.name;
                  } if(_address=="") {
                    _address=employee.address;
                  }
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Text( widget.id!=null? 'Edit Karyawan':'Tambah Karyawan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                  backgroundColor: Colors.white,
                  body: Center(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      children: <Widget>[
                        _logo,
                        SizedBox(height: 48.0),
                        _tittle,
                        SizedBox(height: 8.0),
                        EditText(text: "No Induk",
                            onChanged: (value) {
                              _noInduk=value;
                            },
                            textController: noIndukController),
                        SizedBox(height: 8.0),
                        EditText(text: "Nama",
                            onChanged: (value) {
                              _name=value;
                            },
                            textController: nameController),
                        SizedBox(height: 8.0),
                        EditText(text: "Alamat",
                            onChanged: (value) {
                              _address=value;
                            },
                            textController: addressController),
                        SizedBox(height: 8.0),
                        DatePicker(
                            text: "Tanggal Lahir",
                            textController: birthDateController,
                            onClick: () => _selectDate(context, birthDateController)),
                        SizedBox(height: 8.0),
                        DatePicker(
                            text: "Tanggal Bergabung",
                            textController: joinDateController,
                            onClick: () => _selectDate(context, joinDateController)),
                        SizedBox(height: 24.0),
                        _loginButton,
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '$_alertString',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    color: _alertString==""?
                    Colors.white :
                    Colors.redAccent,
                  ),
                );
              }
          );
        }
    );
  }
}