import 'package:flutter/material.dart';

class AppColors {
  // Fondo principal oscuro
  static const Color background = Color.fromARGB(255, 2, 2, 33); 
  static const Color surface = Color(0xFF2C2C2E); 
  static const Color surfaceDark = Color(0xFF000000); 
  static const Color drawerBg = Color.fromARGB(255, 21, 12, 55);
  static const Color pickerColor = Color.fromARGB(255, 168, 171, 198);

  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF); 
  static const Color textSecondary = Color(0xFF8E8E93); 

  //Icons
  static const Color iconsPrimary = Colors.white;

  // Botones
  static const Color textButton = Color(0xFFFFFFFF);
  static const Gradient gradientButtonPrimary = LinearGradient(
    colors: [Color(0xFF0A84FF), Color(0xFF5AC8FA)], 
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

   static const Gradient gradientButtonSecondary = LinearGradient(
    colors: [Color.fromARGB(255, 78, 137, 22), Color.fromARGB(255, 15, 121, 1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient gradientCardObjects = LinearGradient(
    colors: [Color.fromARGB(255, 12, 13, 90), Color.fromARGB(255, 31, 7, 48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

    static const Gradient gradientCardCategory = LinearGradient(
    colors: [Color.fromARGB(255, 12, 13, 90), Color.fromARGB(255, 31, 7, 44)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

    static const Gradient gradientCardUbicaciones = LinearGradient(
    colors: [Color.fromARGB(255, 12, 13, 90), Color.fromARGB(255, 30, 7, 44)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color acceptButton = Color.fromARGB(255, 58, 129, 60);

  // Bordes de botones 
  static const Color borderButton = Color(0xFFFFFFFF); 

  static const Color accent = Colors.red;

  static const Color iconSpeedDial = Color.fromARGB(255, 15, 121, 1);
  static const Color iconSpeedDialBg = Color.fromARGB(255, 3, 4, 59);

  static const Color transparentColor = Color.fromARGB(4, 0, 0, 0);
}

class AppTextStyles {
  // Títulos principales de la app 
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle dropdownText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Subtítulos 
  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 190, 190, 190),
  );

  static const TextStyle drawerText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 251, 251, 251),
  );

  // Texto normal dentro de cards o listas
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  // Texto de botones
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textButton,
  );

  // Texto pequeño o de etiquetas
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Texto destacado o de alerta 
  static const TextStyle accent = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
