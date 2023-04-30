import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/presentation.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  late final StreamSubscription<dynamic> _stream;

  PresentationData _presentationData = defaultPresentationData;

  @override
  void initState() {
    super.initState();

    _stream = Presentation().getDataStream().listen((event) {
      setState(() => _presentationData = PresentationData.fromJson(jsonDecode(event)));
    });
  }

  @override
  void dispose() {
    _stream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _presentationData.settings.showBackground
        ? (_presentationData.settings.darkMode ? Colors.black : Colors.white)
        : Colors.transparent;
    final textColor = _presentationData.settings.darkMode ? Colors.white : Colors.black;
    final width = MediaQuery.of(context).size.width;

    final fontSize = _computeFontSize(context, _presentationData.lyrics, _presentationData.settings.showName);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: _presentationData.settings.showName ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (_presentationData.settings.showName && _presentationData.lyrics.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(2 * kDefaultPadding),
                  child: Text(
                    _presentationData.songLyricName,
                    style: TextStyle(fontSize: width / 20, color: textColor),
                  ),
                ),
              Text(
                _presentationData.settings.allCapital
                    ? _presentationData.lyrics.toUpperCase()
                    : _presentationData.lyrics,
                style: TextStyle(fontSize: fontSize, color: textColor),
              ),
            ],
          ),
        ),
        if (_presentationData.lyrics.isNotEmpty)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(2 * kDefaultPadding),
              child: Text(
                '${_presentationData.songLyricId}',
                style: TextStyle(fontSize: width / 20, color: textColor),
              ),
            ),
          ),
        if (_presentationData.lyrics.isNotEmpty)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(2 * kDefaultPadding),
              child: Image.asset('assets/images/songbooks/default.png', width: width / 10),
            ),
          ),
      ]),
    );
  }

  double _computeFontSize(BuildContext context, String lyrics, bool showingName) {
    final size = MediaQuery.of(context).size;

    double fontSize = size.width / 20;

    while (true) {
      final textPainter = TextPainter(
        text: TextSpan(text: lyrics, style: TextStyle(fontSize: fontSize)),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      if (size.width - 10 * kDefaultPadding > textPainter.size.width &&
          size.height - (showingName ? 13 : 10) * kDefaultPadding > textPainter.size.height) {
        return fontSize;
      }

      fontSize -= 1;
    }
  }
}
