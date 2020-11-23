import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class LoadingScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);

    final backgroundImage =
        brightness == Brightness.light ? '$imagesPath/background.png' : '$imagesPath/background_dark.png';
    final titleImage = brightness == Brightness.light ? '$imagesPath/title.png' : '$imagesPath/title_dark.png';

    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Transform.translate(
          offset: Offset(0, 0.2 * MediaQuery.of(context).size.height),
          child: Image.asset(titleImage),
        ),
      ),
    );
  }
}
