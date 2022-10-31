import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/drill_list/view-model/drill_view_model.dart';
import 'package:badger_frontend/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DashboardViewModel>(create: (context) => DashboardViewModel()),
        Provider<DrillViewModel>(create: (context) => DrillViewModel())
      ],
      child: MaterialApp(
        theme: getThemeData(),
        home: const Dashboard(),
      ),
    );
  }
}
