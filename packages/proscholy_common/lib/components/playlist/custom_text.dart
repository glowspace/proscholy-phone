import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:proscholy_common/components/song_lyric/utils/auto_scroll.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/custom_text.dart';

class CustomTextWidget extends StatelessWidget {
  final CustomText customText;
  final AutoScrollController autoScrollController;

  const CustomTextWidget({super.key, required this.customText, required this.autoScrollController});

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: QuillController(
        document: _deserializeMarkdownToDocument(customText.content),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      ),
      scrollController: autoScrollController,
      config: QuillEditorConfig(
        padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
      ),
    );
  }

  Document _deserializeMarkdownToDocument(String serializedDelta) {
    if (serializedDelta.isEmpty) return Document();

    final value = jsonDecode(serializedDelta);

    return Document.fromJson(value);
  }
}
