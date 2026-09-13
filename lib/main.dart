import 'package:flutter/material.dart';
import 'features/navigation/main_navigation.dart';

void main() {
  runApp(const SakinahApp());
}

class SakinahApp extends StatelessWidget {
  const SakinahApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سكينة - Sakinah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E), // لون إسلامي هادئ (Teal)
          brightness: Brightness.light,
        ),
        fontFamily: 'Cairo', // خط عربي جذاب (يمكن تخصيصه لاحقاً)
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Cairo',
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigationScreen(),
    );
  }
}

