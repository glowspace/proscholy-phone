import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/song_lyric/utils/auto_scroll.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/user_text.dart';
import 'package:proscholy_common/providers/display_screen_status.dart';

class UserTextWidget extends ConsumerWidget {
  final UserText userText;
  final AutoScrollController autoScrollController;

  const UserTextWidget({super.key, required this.userText, required this.autoScrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuillEditor.basic(
      controller: QuillController(
        document: _deserializeMarkdownToDocument(userText.content),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      ),
      scrollController: autoScrollController,
      config: QuillEditorConfig(
        padding:
            const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding) +
            EdgeInsets.only(
              bottom: ref.watch(displayScreenStatusProvider.select((status) => status.fullScreen))
                  ? MediaQuery.paddingOf(context).bottom
                  : 0,
            ),
      ),
    );
  }

  Document _deserializeMarkdownToDocument(String serializedDelta) {
    if (serializedDelta.isEmpty) return Document();

    final value = jsonDecode(serializedDelta);

    return Document.fromJson(value);
  }
}
