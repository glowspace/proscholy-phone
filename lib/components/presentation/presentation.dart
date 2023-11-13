import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/presentation.dart';

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

    return Container(
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
                  ? QuillProvider(
                      configurations: QuillConfigurations(
                        controller: QuillController(
                          document: _deserializeMarkdownToDocument(presentingText),
                          selection: const TextSelection.collapsed(offset: 0),
                        ),
                      ),
                      child: QuillEditor.basic(
                        configurations: const QuillEditorConfigurations(
                          padding: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                          readOnly: true,
                          scrollable: false,
                          autoFocus: false,
                          expands: false,
                          showCursor: false,
                        ),
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

  Document _deserializeMarkdownToDocument(String serializedDelta) {
    if (serializedDelta.isEmpty) return Document();

    final value = jsonDecode(serializedDelta);

    return Document.fromJson(value);
  }
}
