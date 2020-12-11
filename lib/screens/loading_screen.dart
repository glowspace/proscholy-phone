import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/status_bar_wrapper.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLight = MediaQuery.platformBrightnessOf(context) == Brightness.light;

    final backgroundImage =
        isLight ? const AssetImage('$imagesPath/background.png') : const AssetImage('$imagesPath/background_dark.png');
    final titleImage =
        isLight ? const AssetImage('$imagesPath/title.png') : const AssetImage('$imagesPath/title_dark.png');

    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
      child: StatusBarWrapper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Transform.translate(
                offset: Offset(0, 0.2 * size.height),
                child: Image(image: titleImage),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(bottom: kDefaultPadding),
                child: Column(children: [
                  Container(padding: EdgeInsets.only(bottom: kDefaultPadding), child: ProgressIndicator()),
                  Text('Probíhá příprava písní.', style: AppTheme.of(context).bodyTextStyle),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget with PlatformWidgetMixin {
  @override
  Widget androidWidget(BuildContext context) => CircularProgressIndicator();

  @override
  Widget iOSWidget(BuildContext context) => CupertinoActivityIndicator();
}
