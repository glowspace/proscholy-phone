import 'dart:convert';

import 'package:flutter/material.dart' hide ListenableBuilder;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:quill_markdown/quill_markdown.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/custom_text.dart';
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

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: TextField(
          controller: _nameController,
          style: theme.appBarTheme.titleTextStyle,
          autofocus: true,
          decoration: const InputDecoration(border: InputBorder.none, hintText: 'Název'),
        ),
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _nameController,
            builder: (_, value, __) => Highlightable(
              onTap: () => context.pop((name: value.text, content: _serializeDocumentToMarkdown(_controller.document))),
              padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
              isEnabled: value.text.isNotEmpty,
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          QuillToolbar.basic(
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
          const Divider(height: kDefaultPadding),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              focusNode: _focusNode,
              padding: const EdgeInsets.all(kDefaultPadding),
              readOnly: false,
            ),
          ),
        ]),
      ),
    );
  }

  String? _serializeDocumentToMarkdown(Document document) {
    final convertedValue = jsonEncode(document.toDelta().toJson());

    return quillToMarkdown(convertedValue);
  }

  Document _deserializeMarkdownToDocument(String markdown) {
    final delta = markdownToQuill(markdown);

    if (delta == null) return Document();

    final value = jsonDecode(delta);

    if (value.isEmpty) return Document();

    return Document.fromJson(value);
  }
}
