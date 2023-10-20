import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/presentation.dart';

class SongLyricPresentation extends StatelessWidget {
  final PresentationData presentationData;
  final bool onExternalDisplay;

  const SongLyricPresentation({super.key, required this.presentationData, this.onExternalDisplay = true});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width - mediaQuery.padding.horizontal;

    final backgroundColor = (presentationData.settings.showBackground && onExternalDisplay
        ? (presentationData.settings.darkMode ? Colors.black : Colors.white)
        : null);
    final textColor = onExternalDisplay ? (presentationData.settings.darkMode ? Colors.white : Colors.black) : null;

    final presentingLyrics =
        presentationData.settings.allCapital ? presentationData.lyrics.toUpperCase() : presentationData.lyrics;
    final textScaleFactor = _computeTextScaleFactor(context, presentingLyrics, presentationData.settings.showName);

    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          if (presentationData.settings.showName && presentationData.lyrics.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Text(
                  presentationData.songLyricName,
                  style: textTheme.bodyMedium?.copyWith(color: textColor),
                  textScaleFactor: textScaleFactor,
                ),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: Text(
                presentingLyrics,
                style: textTheme.bodyMedium?.copyWith(color: textColor),
                textScaleFactor: textScaleFactor,
              ),
            ),
          ),
          if (onExternalDisplay && presentationData.lyrics.isNotEmpty)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(2 * kDefaultPadding),
                child: Text(
                  '${presentationData.songLyricId}',
                  style: textTheme.bodyMedium?.copyWith(color: textColor),
                  textScaleFactor: width / 400,
                ),
              ),
            ),
          if (onExternalDisplay && presentationData.lyrics.isNotEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(2 * kDefaultPadding),
                child: Image.asset('assets/images/songbooks/default.png', width: width / 20),
              ),
            ),
        ],
      ),
    );
  }

  double _computeTextScaleFactor(BuildContext context, String lyrics, bool showingName) {
    final size = MediaQuery.sizeOf(context);

    double textScaleFactor = 20;

    while (true) {
      final textPainter = TextPainter(
        text: TextSpan(text: lyrics, style: Theme.of(context).textTheme.bodyMedium),
        textDirection: TextDirection.ltr,
        textScaleFactor: textScaleFactor,
      );

      textPainter.layout();

      // for some reason mediaQuery is not aware of added padding from scaffold here, so make sure the used width is correct
      if (min(size.width, kScaffoldMaxWidth) - (onExternalDisplay ? 12 : 4) * kDefaultPadding >
              textPainter.size.width &&
          size.height - (showingName ? 19 : 16) * kDefaultPadding > textPainter.size.height) {
        return textScaleFactor;
      }

      textScaleFactor -= 0.1;
    }
  }
}
