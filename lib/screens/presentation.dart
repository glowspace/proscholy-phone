import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric/presentation.dart';
import 'package:zpevnik/models/presentation.dart';
import 'package:zpevnik/utils/services/presentation.dart';

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
        stream: PresentationService.instance.getDataStream(),
        builder: (_, dataSnaphost) => SongLyricPresentation(
          presentationData: dataSnaphost.data ?? defaultPresentationData,
        ),
      ),
    );
  }
}
