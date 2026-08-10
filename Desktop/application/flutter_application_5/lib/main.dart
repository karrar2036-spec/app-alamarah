import 'package:flutter/material.dart';
import 'core/widgets/splash_screen.dart';

void main() {
  runApp(const UniversityApp());
}

class UniversityApp extends StatefulWidget {
  const UniversityApp({super.key});

  static _UniversityAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_UniversityAppState>()!;
  }

  @override
  State<UniversityApp> createState() => _UniversityAppState();
}

class _UniversityAppState extends State<UniversityApp> {
  ThemeMode _themeMode = ThemeMode.light;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جامعة العمارة الأهلية',

      // هذا هو المتحكم الفعلي بالثيم
      themeMode: _themeMode,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A192F),
          brightness: Brightness.light,
          primary: const Color(0xFF0A192F),
          secondary: const Color(0xFFD4AF37),
          surface: const Color(0xFFF8FAFC),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAFC),
          foregroundColor: Color(0xFF0A192F),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.dark,
          primary: const Color(0xFF38BDF8),
          secondary: const Color(0xFFFDE047),
          surface: const Color(0xFF0F172A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),
        ),
      ),

      home: SplashScreen(
        onToggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
