import 'package:flutter/material.dart';
import 'views/drum_screen.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, child) {
        final themeService = ThemeService();
        return MaterialApp(
          title: 'Fluttering Drums',
          debugShowCheckedModeBanner: false,
          themeMode: themeService.themeMode,
          theme: themeService.getLightTheme(),
          darkTheme: themeService.getDarkTheme(),
          home: const DrumScreen(),
        );
      },
    );
  }
}
