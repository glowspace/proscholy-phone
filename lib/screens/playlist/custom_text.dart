import 'dart:convert';

import 'package:flutter/material.dart' hide ListenableBuilder;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/router.dart';

class CustomTextScreen extends StatefulWidget {
  final CustomText? customText;

  const CustomTextScreen({super.key, this.customText});

  @override
  State<CustomTextScreen> createState() => _CustomTextScreenState();
}

class _CustomTextScreenState extends State<CustomTextScreen> {
  late final _nameController = TextEditingController(text: widget.customText?.name);

  late final _controller = QuillController(
    document: _deserializeMarkdownToDocument(widget.customText?.content ?? ''),
    selection: const TextSelection.collapsed(offset: 0),
  );

  late bool _isEditting = widget.customText == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: IgnorePointer(
          ignoring: !_isEditting,
          child: TextField(
            key: Key('$_isEditting'),
            controller: _nameController,
            style: theme.appBarTheme.titleTextStyle,
            autofocus: _isEditting,
            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Název'),
          ),
        ),
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _nameController,
            builder: (_, value, __) => Highlightable(
              onTap: () => _editOrPop(context, value.text),
              padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
              isEnabled: value.text.isNotEmpty,
              icon: Icon(_isEditting ? Icons.check : Icons.edit),
            ),
          ),
        ],
      ),
      hideNavigationRail: context.isPlaylist,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          if (_isEditting)
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: QuillToolbar.basic(
                controller: _controller,
                showClearFormat: false,
                showCodeBlock: false,
                showFontFamily: false,
                showFontSize: false,
                showInlineCode: false,
                showQuote: false,
                showSearchButton: false,
                showSubscript: false,
                showSuperscript: false,
                showBackgroundColorButton: false,
              ),
            ),
          const Divider(),
          Expanded(
            child: QuillEditor(
              key: Key('$_isEditting'),
              controller: _controller,
              autoFocus: false,
              focusNode: FocusNode(),
              scrollController: ScrollController(),
              expands: false,
              scrollable: true,
              showCursor: _isEditting,
              padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
              readOnly: !_isEditting,
            ),
          ),
        ]),
      ),
    );
  }

  void _editOrPop(BuildContext context, String name) {
    if (widget.customText != null) {
      // TODO: save this and notify somehow playst about it
      setState(() => _isEditting = !_isEditting);
    } else {
      context.pop(ProviderScope.containerOf(context)
          .read(playlistsProvider.notifier)
          .createCustomText(name: name, content: _serializeDocumentToMarkdown(_controller.document) ?? ''));
    }
  }

  String? _serializeDocumentToMarkdown(Document document) {
    return jsonEncode(document.toDelta().toJson()).toString();
  }

  Document _deserializeMarkdownToDocument(String serializedDelta) {
    if (serializedDelta.isEmpty) return Document();

    final value = jsonDecode(serializedDelta);

    return Document.fromJson(value);
  }
}
