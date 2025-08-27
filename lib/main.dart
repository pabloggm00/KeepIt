import 'package:flutter/material.dart';
import 'package:keepit/app_colors.dart';
import 'package:keepit/screens/home_screen.dart';

void main() {
  runApp(const KeepItApp());
}

class KeepItApp extends StatelessWidget {
  const KeepItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KeepIt',
      theme: ThemeData(
        primaryColor: AppColors.background,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
