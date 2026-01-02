import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/presentation.dart';

class Presentation extends StatelessWidget {
  final PresentationData presentationData;
  final bool onExternalDisplay;

  const Presentation({super.key, required this.presentationData, this.onExternalDisplay = true});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width - mediaQuery.padding.horizontal;

    final backgroundColor =
        (onExternalDisplay ? (presentationData.settings.darkMode ? Colors.black : Colors.white) : null);
    final textColor = onExternalDisplay ? (presentationData.settings.darkMode ? Colors.white : Colors.black) : null;

    final presentingText = (presentationData.songLyricId != null && presentationData.settings.allCapital)
        ? presentationData.text.toUpperCase()
        : presentationData.text;
    final textScaleFactor = onExternalDisplay
        ? _computeTextScaleFactor(
            context,
            // for lyrics compute scale factor so there are no line breaks, there can be line breaks for custom text and bible verse
            presentationData.songLyricId == null ? 'Na počátku stvořil Bůh nebe a zemi.' : presentingText,
            presentationData.settings.showName,
          )
        : mediaQuery.textScaleFactor;

    if (!presentationData.settings.isVisible) return Container(color: backgroundColor);

    return RotatedBox(
      quarterTurns: switch(presentationData.settings.rotation) {
        PresentationRotation.none => 0,
        PresentationRotation.right90 => 1,
        PresentationRotation.upsideDown => 2,
        PresentationRotation.left90 => 3,
        _ => 0,
      },
      child: Container(
      color: backgroundColor,
      child: Stack(
        children: [
          if (presentationData.settings.showName && presentingText.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Text(
                  presentationData.name,
                  style: textTheme.bodyMedium?.copyWith(color: textColor),
                  textScaleFactor: textScaleFactor,
                ),
              ),
            ),
          Align(
            alignment: switch (presentationData.settings.alignment) {
              PresentationAlignment.top => Alignment.topCenter,
              PresentationAlignment.bottom => Alignment.bottomCenter,
              _ => Alignment.center,
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: (presentationData.settings.showName ? 4 : 1) * textScaleFactor * kDefaultPadding,
                bottom: (onExternalDisplay ? 1 : 8) * textScaleFactor * kDefaultPadding,
              ),
              child: presentationData.isCustomText
                  ? QuillEditor.basic(
                      controller: QuillController(
                        document: _deserializeMarkdownToDocument(presentingText),
                        selection: const TextSelection.collapsed(offset: 0),
                        readOnly: true,
                      ),
                      config: QuillEditorConfig(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
                        showCursor: false,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                      child: Text(
                        presentingText,
                        style: textTheme.bodyMedium?.copyWith(color: textColor),
                        textScaleFactor: textScaleFactor,
                      ),
                    ),
            ),
          ),
          if (onExternalDisplay && presentingText.isNotEmpty && presentationData.songLyricId != null)
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
          if (onExternalDisplay && presentingText.isNotEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(2 * kDefaultPadding),
                child: Image.asset('$imagesPath/songbooks/default.png', width: width / 20, package: 'proscholy_common'),
              ),
            ),
        ],
      ),
      ),
    );
  }

  double _computeTextScaleFactor(BuildContext context, String lyrics, bool showingName) {
    final size = MediaQuery.sizeOf(context);

    double textScaleFactor = 20;
    double? bestScaleFactor;
    int? lines;

    while (true) {
      final textPainter = TextPainter(
        text: TextSpan(text: lyrics, style: Theme.of(context).textTheme.bodyMedium),
        textDirection: TextDirection.ltr,
        textScaleFactor: textScaleFactor,
        textWidthBasis: TextWidthBasis.longestLine,
      );

      textPainter.layout();

      final int numLines = textPainter.computeLineMetrics().length;

      // for some reason mediaQuery is not aware of added padding from scaffold here, so make sure the used width is correct
      if (size.width - (onExternalDisplay ? 3 : 1) * kDefaultPadding * textScaleFactor > textPainter.size.width &&
          size.height - (showingName ? 5 : 4) * kDefaultPadding * textScaleFactor > textPainter.size.height) {
        if (bestScaleFactor == null) {
          bestScaleFactor = textScaleFactor;
          lines = numLines;
        } else {
          if (textScaleFactor < bestScaleFactor - kMaxScaleStepDown) {
            return bestScaleFactor;
          }
          if (numLines < lines!) {
            return textScaleFactor;
          }
        }
      }

      textScaleFactor -= 0.2;
    }
  }

  Document _deserializeMarkdownToDocument(String serializedDelta) {
    if (serializedDelta.isEmpty) return Document();

    final value = jsonDecode(serializedDelta);

    return Document.fromJson(value);
  }
}
