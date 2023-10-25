import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/custom_text.dart';

class CustomTextWidget extends StatelessWidget {
  final CustomText customText;
  final AutoScrollController autoScrollController;

  const CustomTextWidget({super.key, required this.customText, required this.autoScrollController});

  @override
  Widget build(BuildContext context) {
    return QuillProvider(
      configurations: QuillConfigurations(
          controller: QuillController(
            document: _deserializeMarkdownToDocument(customText.content),
            selection: const TextSelection.collapsed(offset: 0),
          ),
          editorConfigurations: const QuillEditorConfigurations(readOnly: true)),
      child: QuillEditor(
        padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
        scrollController: autoScrollController,
        focusNode: FocusNode(),
        autoFocus: false,
        expands: false,
        scrollable: true,
        showCursor: false,
      ),
    );
  }

  Document _deserializeMarkdownToDocument(String serializedDelta) {
    if (serializedDelta.isEmpty) return Document();

    final value = jsonDecode(serializedDelta);

    return Document.fromJson(value);
  }
}
