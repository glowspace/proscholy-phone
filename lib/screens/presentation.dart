import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:presentation_displays/secondary_display.dart';

class PresentationScreen extends StatefulWidget {
  final String presentedLyrics;

  const PresentationScreen({
    super.key,
    required this.presentedLyrics,
  });

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  late String _presentedLyrics = widget.presentedLyrics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(_presentedLyrics, style: const TextStyle(fontSize: 64)),
      ),
    );
  }
}
