import 'package:consumo/lista.dart';
import 'package:consumo/register.dart';

import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/list',
      routes: {
        '/register': (context) => const Register(),
        '/list': (context) => const Lista(),
      },
    );
  }
}
