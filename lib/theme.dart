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

const Color lightIconColor = Color(0xff595959);
const Color darkIconColor = Color(0xffa6a6a6);

class AppTheme {
  static ThemeData light() {
    final theme = ThemeData.light();

    final iconTheme = theme.iconTheme.copyWith(color: lightIconColor);

    return theme.copyWith(
      scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        shadowColor: Colors.grey,
        iconTheme: iconTheme,
        elevation: 1,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: GoogleFonts.roboto(fontSize: 22, color: lightTextColor, fontWeight: FontWeight.w500),
        titleMedium: const TextStyle(fontSize: 17, color: lightTextColor, fontWeight: FontWeight.w500),
        titleSmall: const TextStyle(fontSize: 16, color: lightTextColor, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 15, color: lightTextColor, fontWeight: FontWeight.w400),
        bodySmall: const TextStyle(fontSize: 14, color: lightCaptionColor, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.roboto(fontSize: 14, color: lightCommentColor, fontWeight: FontWeight.w400),
        labelMedium: const TextStyle(fontSize: 12, color: lightCaptionColor, fontWeight: FontWeight.w400),
      ),
      iconTheme: iconTheme,
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    final theme = ThemeData.dark();

    final iconTheme = theme.iconTheme.copyWith(color: darkIconColor);

    return theme.copyWith(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSeed(seedColor: blue, brightness: Brightness.dark),
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: Colors.black,
        shadowColor: Colors.grey,
        iconTheme: iconTheme,
        elevation: 1,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: GoogleFonts.roboto(fontSize: 22, color: darkTextColor, fontWeight: FontWeight.w500),
        titleMedium: const TextStyle(fontSize: 17, color: darkTextColor, fontWeight: FontWeight.w500),
        titleSmall: const TextStyle(fontSize: 16, color: darkTextColor, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 15, color: darkTextColor, fontWeight: FontWeight.w400),
        bodySmall: const TextStyle(fontSize: 14, color: darkCaptionColor, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.roboto(fontSize: 14, color: darkCommentColor, fontWeight: FontWeight.w400),
        labelMedium: const TextStyle(fontSize: 12, color: darkCaptionColor, fontWeight: FontWeight.w400),
      ),
      iconTheme: iconTheme,
      splashFactory: NoSplash.splashFactory,
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
      useMaterial3: true,
    );
  }
}
