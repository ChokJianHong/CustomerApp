import 'package:flutter/material.dart';

import 'package:customer_app/pages/Sign_In.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Themed App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A1078),
          primary: const Color(0xFF1A1521),
          secondary: const Color(0xFF4E31AA),
          tertiary: const Color(0xFF3795BD),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF4E31AA),
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontSize: 14,
            color: Color(0xFFFCFEFE),
            fontFamily: 'SF Pro',
          ),
        ),
      ),
      home: const SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
