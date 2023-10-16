import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:zpevnik/components/song_lyric/presentation.dart';
import 'package:zpevnik/models/presentation.dart';

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
        stream: Presentation().getDataStream().map((event) => PresentationData.fromJson(jsonDecode(event))),
        builder: (_, dataSnaphost) => SongLyricPresentation(
          presentationData: dataSnaphost.data ?? defaultPresentationData,
        ),
      ),
    );
  }
}
