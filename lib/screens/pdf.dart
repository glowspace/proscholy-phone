import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';

const _noInternetMessage =
    'Noty jsou dostupné pouze přes internet. Zkontrolujte prosím připojení k${unbreakableSpace}internetu.';

class PdfScreen extends StatelessWidget {
  final External pdf;

  const PdfScreen({Key? key, required this.pdf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pdf.name), leading: const CustomBackButton()),
      body: const PDF().cachedFromUrl(
        pdf.url ?? '',
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(
          child: Text(error is SocketException ? _noInternetMessage : error.toString(), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
