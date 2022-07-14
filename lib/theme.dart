import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zpevnik/constants.dart';

const Color lightTitleColor = Color(0xff3d3636);
const Color darkTitleColor = Color(0xffc2c9c9);

const Color lightTextColor = Color(0xff282828);
const Color darkTextColor = Color(0xffd7d7d7);

const Color lightCommentColor = Color(0xff827c7c);
const Color darkCommentColor = Color(0xff7d8383);

const Color lightCaptionColor = Color(0xffa6a6a6);
const Color darkCaptionColor = Color(0xff595959);

class AppTheme {
  static ThemeData light() {
    final lightTheme = ThemeData.light();

    return lightTheme.copyWith(
      scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        shadowColor: Colors.grey,
        elevation: 1,
      ),
      textTheme: lightTheme.textTheme.copyWith(
        titleLarge: GoogleFonts.roboto(fontSize: 22, color: lightTextColor, fontWeight: FontWeight.w500),
        titleSmall: const TextStyle(fontSize: 16, color: lightTextColor, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 15, color: lightTextColor, fontWeight: FontWeight.w400),
        bodySmall: const TextStyle(fontSize: 14, color: lightTextColor, fontWeight: FontWeight.w500),
        labelLarge: GoogleFonts.roboto(fontSize: 14, color: lightCommentColor, fontWeight: FontWeight.w400),
        labelMedium: const TextStyle(fontSize: 12, color: lightCaptionColor, fontWeight: FontWeight.w400),
      ),
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    final darkTheme = ThemeData.dark();

    return darkTheme.copyWith(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSeed(seedColor: blue, brightness: Brightness.dark),
      appBarTheme: darkTheme.appBarTheme.copyWith(
        backgroundColor: Colors.black,
        shadowColor: Colors.grey,
        elevation: 1,
      ),
      textTheme: darkTheme.textTheme.copyWith(
        titleLarge: GoogleFonts.roboto(fontSize: 22, color: darkTextColor, fontWeight: FontWeight.w500),
        titleSmall: const TextStyle(fontSize: 16, color: darkTextColor, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 15, color: darkTextColor, fontWeight: FontWeight.w400),
        bodySmall: const TextStyle(fontSize: 14, color: darkTextColor, fontWeight: FontWeight.w500),
        labelLarge: GoogleFonts.roboto(fontSize: 14, color: darkCommentColor, fontWeight: FontWeight.w400),
        labelMedium: const TextStyle(fontSize: 12, color: darkCaptionColor, fontWeight: FontWeight.w400),
      ),
      splashFactory: NoSplash.splashFactory,
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
      useMaterial3: true,
    );
  }
}
