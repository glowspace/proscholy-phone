import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/settings.dart';

class AppTheme extends StatefulWidget {
  final Widget child;

  const AppTheme({Key? key, required this.child}) : super(key: key);

  @override
  _AppThemeState createState() => _AppThemeState();

  static AppThemeData of(BuildContext context) => context.dependOnInheritedWidgetOfExactType()!;
}

class _AppThemeState extends State<AppTheme> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = WidgetsBinding.instance?.window.platformBrightness ?? Brightness.light;

    final isDarkMode = context.select<SettingsProvider, bool?>((provider) => provider.isDarkMode);
    if (isDarkMode != null) brightness = isDarkMode ? Brightness.dark : Brightness.light;

    return AppThemeData(
      brightness: brightness,
      child: widget.child,
    );
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    setState(() {});
  }
}

class AppThemeData extends InheritedWidget {
  final Brightness brightness;

  AppThemeData({required Widget child, required this.brightness}) : super(child: child);

  CupertinoThemeData get cupertinoTheme {
    return CupertinoThemeData(
      brightness: brightness,
      textTheme: CupertinoTextThemeData(primaryColor: iconColor),
    );
  }

  ThemeData get materialTheme {
    if (isLight)
      return ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      );

    return ThemeData.dark();
  }

  TextStyle? get bodyTextStyle {
    final textStyle = isIOS ? cupertinoTheme.textTheme.textStyle : materialTheme.textTheme.bodyText2;

    return textStyle?.copyWith(color: textColor, fontSize: 16);
  }

  TextStyle? get titleTextStyle => bodyTextStyle?.copyWith(fontSize: 21, fontWeight: FontWeight.bold);
  TextStyle? get subTitleTextStyle => bodyTextStyle?.copyWith(fontSize: 18);

  TextStyle? get captionTextStyle => bodyTextStyle?.copyWith(color: captionColor, fontSize: 14);
  TextStyle? get placeholderTextStyle => bodyTextStyle?.copyWith(color: placeholderColor);
  TextStyle? get commentTextStyle => captionTextStyle?.copyWith(fontStyle: FontStyle.italic, height: 1.5);
  TextStyle? get navBarTitleTextStyle =>
      isIOS ? bodyTextStyle?.copyWith(fontWeight: FontWeight.bold, fontSize: 17) : bodyTextStyle;

  Color get backgroundColor => isLight ? Color(0xffffffff) : Color(0xff000000);
  Color get fillColor => isIOS ? CupertinoColors.systemFill : (isLight ? Color(0xffffffff) : Color(0xff252525));
  Color get borderColor => isLight ? Color(0xffd1d1d1) : Color(0xff2e2e2e);

  Color get activeColor => isLight ? Color(0xff9a9a9a) : Color(0xff656565);
  Color get disabledColor => isLight ? Color(0xffd7d7d7) : Color(0xff282828);

  Color get textColor => isLight ? Color(0xff222222) : Color(0xffdddddd);
  Color get captionColor => isLight ? Color(0xff636365) : Color(0xff9c9c9a);
  Color get placeholderColor => isLight ? Color(0xff9aa0a5) : Color(0xff655f5a);
  Color get chordColor => isLight ? Color(0xff3961ad) : Color(0xff4dc0b5);

  Color get selectedRowColor => isLight ? Color(0x15005af7) : Color(0x3300f7de);

  Color get highlightColor => isLight ? Color(0xffdfdfdf) : Color(0xff202020);
  Color get iconColor => isLight ? Color(0xff5e6368) : Color(0xffa19c97);

  Color get filtersTextColor => isLight ? Color(0xff222529) : Color(0xffdddad6);
  Color get filtersSectionSeparatorColor => isLight ? Color(0xffe8e8e8) : Color(0xff272727);

  bool get isLight => brightness == Brightness.light;
  bool get isIOS => Platform.isIOS;

  @override
  bool updateShouldNotify(AppThemeData oldWidget) => brightness != oldWidget.brightness;
}
