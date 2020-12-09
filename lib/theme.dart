import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppThemeNew extends InheritedWidget {
  final Brightness brightness;
  final TargetPlatform platform; // for easier debugging

  const AppThemeNew({
    @required Widget child,
    this.brightness = Brightness.light,
    @required this.platform,
  }) : super(child: child);

  CupertinoThemeData get cupertinoTheme => CupertinoThemeData(
        brightness: brightness,
        primaryColor: iconColor,
      );

  ThemeData get materialTheme => (isLight ? ThemeData.light() : ThemeData.dark()).copyWith(
        platform: platform,
        primaryColor: isLight ? Colors.white : Colors.black,
        primaryIconTheme: IconThemeData(color: iconColor),
        backgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: fillColor),
      );

  TextStyle get bodyTextStyle => isIOS
      ? cupertinoTheme.textTheme.textStyle.copyWith(color: textColor, fontSize: 15)
      : materialTheme.textTheme.bodyText1.copyWith(color: textColor, fontSize: 16);

  TextStyle get titleTextStyle => isIOS ? bodyTextStyle.copyWith(fontSize: 21) : materialTheme.textTheme.headline5;

  TextStyle get subTitleTextStyle => isIOS ? bodyTextStyle.copyWith(fontSize: 17) : materialTheme.textTheme.subtitle1;

  TextStyle get placeholderTextStyle => bodyTextStyle.copyWith(
        color: isLight ? Color(0xff9aa0a5) : Color(0xff655f5a),
      );

  TextStyle get captionTextStyle => bodyTextStyle.copyWith(
        color: isLight ? Color(0xff636365) : Color(0xff9c9c9a),
        fontSize: 13,
      );

  Color get backgroundColor => isLight ? Color(0xffffffff) : Color(0xff000000);
  Color get fillColor => isIOS ? CupertinoColors.systemFill : (isLight ? Color(0xffffffff) : Color(0xff252525));

  Color get textColor => isLight ? Color(0xff222222) : Color(0xffdddddd);
  Color get chordColor => isLight ? Color(0xff3961ad) : Color(0xff4dc0b5);

  Color get borderColor => isLight ? Color(0xffd1d1d1) : Color(0xff2e2e2e);

  Color get highlightColor => isLight ? Color(0xffdfdfdf) : Color(0xff202020);
  Color get selectedRowColor => isLight ? Color(0x15005af7) : Color(0x3300f7de);

  Color get iconColor => isLight ? Color(0xff5e6368) : Color(0xffa19c97);
  Color get disabledColor => isLight ? Color(0xffd7d7d7) : Color(0xff282828);

  bool get isLight => brightness == Brightness.light;

  bool get isIOS => platform == TargetPlatform.iOS;

  @override
  bool updateShouldNotify(AppThemeNew oldWidget) => brightness != oldWidget.brightness;

  static AppThemeNew of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}

class AppTheme {
  AppTheme._();

  static final AppTheme shared = AppTheme._();

  final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    primaryIconTheme: IconThemeData(color: Color(0xff222222)),
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Color(0xff222222))),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
  );

  final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.black,
    primaryIconTheme: IconThemeData(color: Color(0xffdddddd)),
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Color(0xffdddddd))),
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Colors.black,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xff252525)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color(0xff101010)),
  );

  Color textColor(BuildContext context) => isLight(context) ? Color(0xff222222) : Color(0xffdddddd);

  Color chordColor(BuildContext context) => isLight(context) ? Color(0xff3961ad) : Color(0xff4dc0b5);

  Color appBarDividerColor(BuildContext context) => isLight(context) ? Color(0xff888888) : Color(0xff777777);

  Color borderColor(BuildContext context) => isLight(context) ? Color(0xff7d8185) : Color(0xff827e7a);

  Color highlightColor(BuildContext context) => isLight(context) ? Color(0xffdfdfdf) : Color(0xff202020);

  // selector theme

  Color selectedRowBackgroundColor(BuildContext context) => isLight(context) ? Color(0x15005af7) : Color(0x3300f7de);

  Color selectedRowColor(BuildContext context) => chordColor(context);

  Color selectedColor(BuildContext context) => isLight(context) ? Color(0xff9a9a9a) : Color(0xff656565);

  Color unSelectedColor(BuildContext context) => isLight(context) ? Color(0xffd7d7d7) : Color(0xff282828);

  // search theme

  Color searchFieldIconColor(BuildContext context) => isLight(context) ? Color(0xff5e6368) : Color(0xffa19c97);

  Color _searchFieldPlaceholderColor(BuildContext context) => isLight(context) ? Color(0xff9aa0a5) : Color(0xff655f5a);

  TextStyle searchFieldPlaceholderColorTextStyle(BuildContext context) =>
      AppThemeNew.of(context).bodyTextStyle.copyWith(
            color: _searchFieldPlaceholderColor(context),
          );

  // filters theme
  Color filtersTextColor(BuildContext context) => isLight(context) ? Color(0xff222529) : Color(0xffdddad6);

  Color filtersSectionSeparatorColor(BuildContext context) => isLight(context) ? Color(0xffe8e8e8) : Color(0xff171717);

  Color filterBorderColor(BuildContext context) => isLight(context) ? Color(0xffd1d1d1) : Color(0xff2e2e2e);

  bool isLight(BuildContext context) => MediaQuery.platformBrightnessOf(context) == Brightness.light;
}
