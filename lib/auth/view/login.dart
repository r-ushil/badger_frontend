import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:badger_frontend/drill_list/view/drill_list.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/logo.dart';
import 'package:badger_frontend/auth/view/widgets/welcome_header.dart';

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
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(child: Column(
          children: const <Widget>[
            Center(child: Logo()),
            WelcomeHeader(),
            SizedBox(height: 50), // margin welcome text
            Padding(padding: EdgeInsets.only(right: 150.0), child: Text("Phone Number", style: TextStyle(fontSize: 20, color: Colors.grey))),
            SizedBox(height: 10), // margin before textbox
            SizedBox(width: 300, child: TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.phone, color: Colors.grey), filled: true, fillColor: Colors.white12))),

            /*Padding(padding: const EdgeInsets.only(left: 50.0), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:const <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text("Phone Number", style: TextStyle(fontSize: 20))),
                  SizedBox(height: 10), // margin before textbox
                  SizedBox(width: 300, child: TextField(decoration: InputDecoration(filled: true, fillColor: Colors.grey, hintText: "Phone number"))),
                ])
            )*/

          ])),
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
