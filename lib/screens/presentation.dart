import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/presentation_settings.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  late final StreamSubscription<dynamic> _stream;

  String _presentedSongLyricId = '';
  String _presentedSongLyricName = '';
  String _presentedLyrics = '';
  PresentationSettings _presentationSettings = defaultPresentationSettings;

  @override
  void initState() {
    super.initState();

    _stream = Presentation().getDataStream().listen((event) {
      if (event is String) {
        setState(() => _presentedLyrics = event);
      } else if (event is Map<dynamic, dynamic>) {
        if (event.containsKey('id')) {
          _presentedSongLyricName = event['name'] as String;
          _presentedSongLyricId = event['id'] as String;
        } else {
          setState(() => _presentationSettings = PresentationSettings.fromJson(event.cast()));
        }
      }
    });
  }

  @override
  void dispose() {
    _stream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _presentationSettings.showBackground
        ? (_presentationSettings.darkMode ? Colors.black : Colors.white)
        : Colors.transparent;
    final textColor = _presentationSettings.darkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(children: [
        if (_presentationSettings.showName && _presentedLyrics.isNotEmpty)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(2 * kDefaultPadding),
              child: Text(
                _presentedSongLyricName,
                style: TextStyle(fontSize: _presentationSettings.fontSize.toDouble(), color: textColor),
              ),
            ),
          ),
        Center(
          child: Text(
            _presentationSettings.allCapital ? _presentedLyrics.toUpperCase() : _presentedLyrics,
            style: TextStyle(fontSize: _presentationSettings.fontSize.toDouble(), color: textColor),
          ),
        ),
        if (_presentedLyrics.isNotEmpty)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(2 * kDefaultPadding),
              child: Text(
                _presentedSongLyricId,
                style: TextStyle(fontSize: _presentationSettings.fontSize.toDouble(), color: textColor),
              ),
            ),
          ),
        if (_presentedLyrics.isNotEmpty)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(2 * kDefaultPadding),
              child: Image.asset('assets/images/songbooks/default.png', width: 192),
            ),
          ),
      ]),
    );
  }
}
