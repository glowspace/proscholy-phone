import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:zpevnik/components/custom/close_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';

const _noInternetMessage =
    'Noty jsou dostupné pouze přes internet. Zkontrolujte prosím připojení k${unbreakableSpace}internetu.';

class PdfScreen extends StatelessWidget {
  final External pdf;

  const PdfScreen({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CustomCloseButton(), title: Text(pdf.name)),
      body: const PDF().cachedFromUrl(
        pdf.url ?? '',
        placeholder: (progress) => const Center(child: CircularProgressIndicator()),
        errorWidget: (error) => Center(
          child: Text(error is SocketException ? _noInternetMessage : '$error', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
