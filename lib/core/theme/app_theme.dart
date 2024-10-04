import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.blue,
        elevation: 0,
        titleTextStyle: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.roboto(
          color: Colors.black87,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.roboto(
          color: Colors.black54,
          fontSize: 14,
        ),
      ),
    );
  }

  // Add dark theme if needed
}
