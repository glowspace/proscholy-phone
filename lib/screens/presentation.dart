import 'package:flutter/material.dart';
import 'package:zpevnik/components/presentation/presentation.dart';
import 'package:zpevnik/models/presentation.dart';
import 'package:zpevnik/utils/services/presentation.dart';

// this screen is only used for external monitors
class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: PresentationService.instance.getDataStream(),
        builder: (_, dataSnaphost) => Presentation(
          presentationData: dataSnaphost.data ?? defaultPresentationData,
        ),
      ),
    );
  }
}
