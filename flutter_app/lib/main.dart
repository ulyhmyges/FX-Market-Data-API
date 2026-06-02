import 'package:flutter/material.dart';
import 'package:pricer_app/views/auth_gate.dart';
import 'package:pricer_app/views/login_form.dart';
import 'package:pricer_app/views/logout.dart';
import 'package:pricer_app/views/option_pricer_form.dart';
import 'package:pricer_app/views/subscribe_form.dart';
import 'package:pricer_app/views/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Option Pricer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGateWidget(),
        '/subscribe': (context) => SubscribeFormWidget(),
        '/login': (context) => LoginFormWidget(),
        '/logout': (context) => LogoutWidget(),
        '/welcome': (context) => Welcome(title: 'Option Pricer'),
        '/option/pricer' : (context) => OptionPricerForm()
      },
    );
  }
}
