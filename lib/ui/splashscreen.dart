import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karyawan/common/styles.dart';
import 'package:karyawan/ui/list_employee_page.dart';

class Splashscreen extends StatefulWidget {
  static const routeName = '/splashscreen';

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  Timer _timer;
  int _start = 5;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment : MainAxisAlignment.center,
          crossAxisAlignment : CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/logo_karyawan.png', width: 200, height: 200),
            SizedBox(height: 10.0),
            Text(
              "Karyawan",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
        ],
        ),
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    const _oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      _oneSec,
          (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          Navigator.pushReplacementNamed(context, EmployeeListPage.routeName);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}