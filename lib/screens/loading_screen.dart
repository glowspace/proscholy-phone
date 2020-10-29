import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/utils/platform.dart';

class LoadingScreen extends StatelessWidget with PlatformWidgetMixin {
  @override
  Widget androidWidget(BuildContext context) => _content(context, Theme.of(context).brightness);

  @override
  Widget iOSWidget(BuildContext context) => _content(context, MediaQuery.platformBrightnessOf(context));

  Widget _content(BuildContext context, Brightness brightness) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                brightness == Brightness.light ? 'assets/images/background.png' : 'assets/images/background_dark.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Transform.translate(
            offset: Offset(0, 0.2 * MediaQuery.of(context).size.height),
            child: brightness == Brightness.light
                ? Image.asset('assets/images/title.png')
                : Image.asset('assets/images/title_dark.png'),
          ),
        ),
      );
}
