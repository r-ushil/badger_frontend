import 'package:badger_frontend/auth/view/login.dart';
import 'package:badger_frontend/auth/view-model/login_view_model.dart';
import 'package:badger_frontend/common/auth/auth_model.dart';
import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:badger_frontend/record_video/view_model/record_video_view_model.dart';
import 'package:badger_frontend/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drill_evaluation/view-model/drill_evaluation_view_model.dart';

import "common/firebase/firebase.dart";

void main() async {
  /* Initialise widgets library */
  WidgetsFlutterBinding.ensureInitialized();

  /* Initialise plugins */
  await initializeFirebase();

  /* Bootstrap Flutter App */
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MultiProvider(
      providers: [
        Provider<LoginViewModel>(create: (context) => LoginViewModel()),
        Provider<DashboardViewModel>(create: (context) => DashboardViewModel()),
        Provider<DrillListViewModel>(create: (context) => DrillListViewModel()),
        Provider<DrillEvaluationViewModel>(
            create: (context) => DrillEvaluationViewModel()),
        ChangeNotifierProvider<RecordVideoViewModel>(
            create: (context) => RecordVideoViewModel()),
        Provider<BadgerAuth>(create: (context) => BadgerAuth()),
      ],
      child: MaterialApp(
        theme: getThemeData(),
        home: const Login(),
      ),
    );
  }
}
