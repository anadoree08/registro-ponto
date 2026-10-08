import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const RegistroPontoApp());
}

class RegistroPontoApp extends StatelessWidget {
  const RegistroPontoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Ponto',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
