import 'package:badger_frontend/common/auth/auth_phone_model.dart';
import 'package:badger_frontend/auth/view-model/login_view_model.dart';
import 'package:badger_frontend/auth/view/auth_phone_login.dart';
import 'package:badger_frontend/auth/view/auth_phone_verify.dart';
import 'package:badger_frontend/common/auth/auth_model.dart';
import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/record_video/view_model/record_video_view_model.dart';
import 'package:badger_frontend/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drill_evaluation/view-model/drill_evaluation_view_model.dart';

void main() async {
  /* Initialise widgets library */
  WidgetsFlutterBinding.ensureInitialized();

  /* Initialise plugins */
  await Firebase.initializeApp();

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
        // TODO: Ensure we have a proper provider structure
        Provider<BadgerAuthPhoneModel>(
            create: (context) => BadgerAuthPhoneModel()),
      ],
      child:
          const AuthGuard(), // MaterialApp(theme: getThemeData(), routes: const Routes()),
    );
  }
}

class AuthGuard extends StatelessWidget {
  const AuthGuard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<BadgerAuth>(context);

    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, AsyncSnapshot<BadgerAuthState> authState) {
        final BadgerAuthState? state = authState.data;

        if (state == null) return const Loading();
        if (state.isLoggedIn()) return const LoggedInApp();

        return const LoggedOutApp();
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Loading'),
        ),
      ),
    );
  }
}

class LoggedInApp extends StatelessWidget {
  const LoggedInApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getThemeData(),
      home: const Dashboard(),
    );
  }
}

class LoggedOutApp extends StatelessWidget {
  const LoggedOutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getThemeData(),
      home: const AuthPhoneLogin(),
      routes: {
        '/auth/phone/verify': (context) => const AuthPhoneVerify(),
      },
    );
  }
}
