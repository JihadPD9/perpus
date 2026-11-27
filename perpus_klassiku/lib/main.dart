import 'package:flutter/material.dart';

import 'routes/app_routing.dart';

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
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.amberAccent,
          surface: Color(0xFF1E1E1E),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRouting.splash,
      routes: AppRouting.routes,
      onGenerateRoute: AppRouting.onGenerateRoute,
      onUnknownRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Halaman tidak ditemukan.')),
        ),
      ),
    );
  }
}
