import 'package:flutter/material.dart';
import 'views/auth/login_page.dart';

void main() {
  runApp(const PerpusKlasikkuApp());
}

class PerpusKlasikkuApp extends StatelessWidget {
  const PerpusKlasikkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpus Klasikku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1F1F1F),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
          surface: Color(0xFF1E1E1E),
        ),
        fontFamily: 'Sans', // Atau font bawaan
      ),
      home: const LoginPage(),
    );
  }
}