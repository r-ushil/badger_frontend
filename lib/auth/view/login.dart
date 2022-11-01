import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:badger_frontend/drill_list/view/drill_list.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/logo.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            Logo(),
            SizedBox(height: 50), // margin between logo and welcome text
            Text('WELCOME', textAlign: TextAlign.center, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DrillList()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //bottomNavigationBar: const BottomTabBar(),
    );
  }
}
