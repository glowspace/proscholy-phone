import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final AppTheme shared = AppTheme._();

  Color textColor(BuildContext context) => _isLight(context) ? Color(0xff222222) : Color(0xffdddddd);

  Color chordColor(BuildContext context) => _isLight(context) ? Color(0xff3961ad) : Color(0xff4dc0b5);

  // filters theme
  Color _filtersTextColor(BuildContext context) => _isLight(context) ? Color(0xff222529) : Color(0xffdddad6);

  Color filtersSectionSeparatorColor(BuildContext context) => _isLight(context) ? Color(0xffe8e8e8) : Color(0xff171717);

  Color filterBorderColor(BuildContext context) => _isLight(context) ? Color(0xffd1d1d1) : Color(0xff2e2e2e);

  TextStyle filtersSectionTitleTextStyle(BuildContext context) => Theme.of(context).textTheme.headline5.copyWith(
        color: _filtersTextColor(context),
      );

  TextStyle filterTextStyle(BuildContext context) => Theme.of(context).textTheme.bodyText1.copyWith(
        color: _filtersTextColor(context),
      );

  bool _isLight(BuildContext context) => MediaQuery.platformBrightnessOf(context) == Brightness.light;
}
