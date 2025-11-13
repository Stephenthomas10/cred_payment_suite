import 'package:flutter/material.dart';
import 'screens/refunds_page.dart';

void main() {
  runApp(const CredPaymentSuiteApp());
}

class CredPaymentSuiteApp extends StatelessWidget {
  const CredPaymentSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6C4DF5); // CRED-style purple
    const background = Color(0xFFFAF6FF); // soft lilac
    const cardBg = Colors.white;

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRED Payment Suite',
      theme: baseTheme.copyWith(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: cardBg,
          foregroundColor: Colors.black87,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        // ✅ FIXED: CardThemeData instead of CardTheme
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          margin: EdgeInsets.zero,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        chipTheme: baseTheme.chipTheme.copyWith(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          labelStyle: const TextStyle(fontSize: 12),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: StadiumBorder(),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            side: const BorderSide(color: primary, width: 1),
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const RefundsPage(),
    );
  }
}
