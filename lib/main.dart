import 'package:flutter/material.dart';
import 'package:philip_capital_india/screens/mobile_step.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhillipCapital',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const PhillipCapitalOnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
