import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide ListenableBuilder;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/custom_text/utils/attributions.dart';
import 'package:zpevnik/components/playlist/custom_text/utils/controller.dart';
import 'package:zpevnik/components/playlist/custom_text/floating_toolbar.dart';
import 'package:zpevnik/components/playlist/custom_text/toolbar.dart';
import 'package:zpevnik/models/custom_text.dart';

class CustomTextScreen extends StatefulWidget {
  final CustomText? customText;

  const CustomTextScreen({super.key, this.customText});

  @override
  State<CustomTextScreen> createState() => _CustomTextScreenState();
}

class _CustomTextScreenState extends State<CustomTextScreen> {
  late final _nameController = TextEditingController(text: widget.customText?.name);

  late final _document = deserializeMarkdownToDocument(widget.customText?.content ?? '');

  late final _editor = DocumentEditor(document: _document);
  late final _composer = DocumentComposer();
  final _docLayoutKey = GlobalKey();
  final _focusNode = FocusNode();

  late final _controller = CustomTextController(
    _editor,
    _composer,
    CommonEditorOperations(
      editor: _editor,
      composer: _composer,
      documentLayoutResolver: () => _docLayoutKey.currentState as DocumentLayout,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Název',
          ),
        ),
        actions: [
          Consumer(
            builder: (_, ref, __) => ValueListenableBuilder<TextEditingValue>(
              valueListenable: _nameController,
              builder: (_, value, __) => Highlightable(
                onTap: value.text.isEmpty
                    ? null
                    : () => context.pop((name: value.text, content: serializeDocumentToMarkdown(_editor.document))),
                icon: const Icon(Icons.check),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SuperEditor(
              editor: _editor,
              composer: _composer,
              documentLayoutKey: _docLayoutKey,
              focusNode: _focusNode,
              componentBuilders: defaultComponentBuilders,
              stylesheet: defaultStylesheet.copyWith(inlineTextStyler: (attributions, existingStyle) {
                final defaultTextStyle = defaultInlineTextStyler(attributions, existingStyle);

                final colorAttribution = attributions.firstWhereOrNull((attribution) => attribution is ColorAttribution)
                    as ColorAttribution?;

                if (colorAttribution != null) return defaultTextStyle.copyWith(color: colorAttribution.color);

                return defaultTextStyle;
              }),
              androidToolbarBuilder: (_) => FloatingToolbar(controller: _controller),
              iOSToolbarBuilder: (_) => FloatingToolbar(controller: _controller),
            ),
            CustomTextToolbar(controller: _controller),
          ],
        ),
      ),
    );
  }
}
