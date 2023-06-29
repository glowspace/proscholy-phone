import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';

const _noInternetMessage =
    'Noty jsou dostupné pouze přes internet. Zkontrolujte prosím připojení k${unbreakableSpace}internetu.';

class JpgScreen extends StatelessWidget {
  final External jpg;

  const JpgScreen({super.key, required this.jpg});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(leading: const CustomBackButton(), title: Text(jpg.name)),
      body: PhotoView(
        backgroundDecoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        imageProvider: CachedNetworkImageProvider(jpg.url ?? ''),
        loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, error, __) => Center(
          child: Text(error is SocketException ? _noInternetMessage : error.toString(), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
