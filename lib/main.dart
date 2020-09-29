import 'package:flutter/material.dart';
import 'preRegistrationScreen.dart';
import 'registrationScreen.dart';

void main() => runApp(DNSTestApp());

class DNSTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DNS Test App',
        home: PreRegistrationScreen(),
        routes: {
          RegistrationScreen.routeName: (context) => RegistrationScreen(),
          PreRegistrationScreen.routeName: (context) => PreRegistrationScreen(),
        });
  }
}


