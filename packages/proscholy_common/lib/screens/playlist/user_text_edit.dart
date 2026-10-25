import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:proscholy_common/components/custom/close_button.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/navigation/scaffold.dart';
import 'package:proscholy_common/components/playlist/user_text.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/user_text.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/utils/extensions.dart';

class UserTextEditScreen extends StatefulWidget {
  final UserText? userText;

  const UserTextEditScreen({super.key, this.userText});

  @override
  State<UserTextEditScreen> createState() => _UserTextEditScreenState();
}

class _UserTextEditScreenState extends State<UserTextEditScreen> {
  late final _nameController = TextEditingController(text: widget.userText?.name);

  late final _controller = QuillController(
    document: decodeUserText(widget.userText?.content ?? ''),
    selection: const TextSelection.collapsed(offset: 0),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScaffold(
      appBar: AppBar(
        leading: const CustomCloseButton(),
        title: TextField(
          controller: _nameController,
          style: theme.appBarTheme.titleTextStyle,
          autofocus: true,
          decoration: const InputDecoration(border: InputBorder.none, hintText: 'Název'),
        ),
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _nameController,
            builder: (_, value, _) => HighlightableWidget(
              onTap: () => _editOrPop(value.text),
              padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
              isEnabled: value.text.isNotEmpty,
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: QuillSimpleToolbar(
                controller: _controller,
                config: QuillSimpleToolbarConfig(
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
            ),
            const Divider(),
            Expanded(
              child: QuillEditor.basic(
                controller: _controller,
                config: QuillEditorConfig(
                  padding: EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editOrPop(String name) {
    final UserText userText;

    if (widget.userText == null) {
      // it is stored when it is added to playlist
      userText = UserText(name: name, content: encodeUserText(_controller.document));
    } else {
      userText = widget.userText!.copyWith(name: name, content: encodeUserText(_controller.document));

      context.providers.read(appDependenciesProvider).store.box<UserText>().put(userText);
    }

    context.pop(userText);
  }
}
