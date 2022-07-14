import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:zpevnik/components/highlightable_property.dart';
import 'package:zpevnik/constants.dart';

class CustomTextScreen extends StatefulWidget {
  const CustomTextScreen({Key? key}) : super(key: key);

  @override
  State<CustomTextScreen> createState() => _CustomTextScreenState();
}

class _CustomTextScreenState extends State<CustomTextScreen> {
  final _nameController = TextEditingController();
  final _quillController = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Název',
          ),
        ),
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _nameController,
            builder: (_, value, __) => TextButton(
              onPressed: value.text.isEmpty ? null : () => print(_quillController.document.toDelta()),
              child: const Text('Uložit'),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: HighlightableForegroundColor(context),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: kDefaultPadding / 2),
              child: Theme(
                data: theme.copyWith(canvasColor: theme.scaffoldBackgroundColor),
                child: QuillToolbar.basic(
                  iconTheme: QuillIconTheme(iconSelectedFillColor: Theme.of(context).colorScheme.primary),
                  controller: _quillController,
                  multiRowsDisplay: false,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: kDefaultPadding / 2),
                padding: const EdgeInsets.all(kDefaultPadding),
                color: Theme.of(context).canvasColor,
                child: QuillEditor.basic(controller: _quillController, readOnly: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
