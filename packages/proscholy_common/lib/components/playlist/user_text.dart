import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:proscholy_common/components/song_lyric/utils/auto_scroll.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/user_text.dart';

// content of user text is quill document in json
Document decodeUserText(String content) => content.isEmpty ? Document() : Document.fromJson(jsonDecode(content));

String encodeUserText(Document document) => jsonEncode(document.toDelta().toJson());

class UserTextWidget extends StatelessWidget {
  final UserText userText;
  final AutoScrollController autoScrollController;

  const UserTextWidget({super.key, required this.userText, required this.autoScrollController});

  @override
  Widget build(BuildContext context) {
    return UserTextContent(
      content: userText.content,
      scrollController: autoScrollController,
      padding:
          const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding) +
          EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
    );
  }
}

class UserTextContent extends StatefulWidget {
  final String content;
  final EdgeInsetsGeometry padding;
  final ScrollController? scrollController;

  const UserTextContent({super.key, required this.content, required this.padding, this.scrollController});

  @override
  State<UserTextContent> createState() => _UserTextContentState();
}

class _UserTextContentState extends State<UserTextContent> {
  late var _controller = _createController();

  @override
  void didUpdateWidget(UserTextContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.content != oldWidget.content) {
      _controller.dispose();
      _controller = _createController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      scrollController: widget.scrollController,
      config: QuillEditorConfig(padding: widget.padding, showCursor: false),
    );
  }

  QuillController _createController() {
    return QuillController(
      document: decodeUserText(widget.content),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }
}
