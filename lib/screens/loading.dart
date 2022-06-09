import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleOffset = Offset(0, 0.2 * MediaQuery.of(context).size.height);
    final isDark = AppTheme.of(context).brightness == Brightness.dark;

    final backgroundImage = AssetImage(isDark ? '$imagesPath/background_dark.png' : '$imagesPath/background.png');
    final titleImage = AssetImage(isDark ? '$imagesPath/title_dark.png' : '$imagesPath/title.png');

    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          child: Column(children: [
            Transform.translate(offset: titleOffset, child: Image(image: titleImage)),
            Spacer(),
            Container(
              // TODO: check this on android emulator
              // padding: EdgeInsets.only(bottom: kDefaultPadding),
              child: _progressInfo(context),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _progressInfo(BuildContext context) {
    final textStyle = AppTheme.of(context).bodyTextStyle;

    return Column(children: [
      const CircularProgressIndicator.adaptive(),
      const SizedBox(height: kDefaultPadding / 2),
      Text('Probíhá příprava písní.', style: textStyle),
    ]);
  }
}
