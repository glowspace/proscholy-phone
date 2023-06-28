import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:zpevnik/components/playlist/custom_text/utils/attributions.dart';

/// Handles all possible actions on custom text.
class CustomTextController extends ChangeNotifier {
  final DocumentEditor editor;
  final DocumentComposer composer;
  final CommonEditorOperations commonOperations;

  CustomTextController(this.editor, this.composer, this.commonOperations);

  Color get color =>
      (composer.preferences.currentAttributions.firstWhereOrNull((attribution) => attribution is ColorAttribution)
              as ColorAttribution?)
          ?.color ??
      Colors.black;

  bool get canSelect => composer.selection?.isCollapsed ?? false;

  bool get canCopy => !(composer.selection?.isCollapsed ?? true);
  bool get canCut => !(composer.selection?.isCollapsed ?? true);
  bool get canPaste => composer.selection?.isCollapsed ?? false;

  bool get isBoldActive => composer.preferences.currentAttributions.contains(boldAttribution);
  bool get isItalicsActive => composer.preferences.currentAttributions.contains(italicsAttribution);
  bool get isUnderlineActive => composer.preferences.currentAttributions.contains(underlineAttribution);

  void select() => commonOperations.selectSurroundingWord();
  void selectAll() => commonOperations.selectAll();

  void copy() => commonOperations.copy();
  void cut() => commonOperations.cut();
  void paste() => commonOperations.paste();

  void toggleBold() => _toggleAttributions({boldAttribution});
  void toggleItalics() => _toggleAttributions({italicsAttribution});
  void toggleUnderline() => _toggleAttributions({underlineAttribution});

  void toggleUnorderedList() => _convertToListItem(ListItemType.unordered);
  void toggleOrderedList() => _convertToListItem(ListItemType.ordered);

  void indent() => commonOperations.indentListItem();
  void unindent() => commonOperations.unindentListItem();

  void changeColor(Color color) {
    commonOperations.removeAttributionsFromSelection({ColorAttribution(color: color)});
    _toggleAttributions({ColorAttribution(color: color)});
  }

  void _toggleAttributions(Set<Attribution> attributions) {
    if (composer.selection?.isCollapsed ?? true) {
      commonOperations.toggleComposerAttributions(attributions);
    } else {
      commonOperations.toggleAttributionsOnSelection(attributions);
    }

    notifyListeners();
  }

  void _convertToListItem(ListItemType listItemType) {
    final textNode = editor.document.getNodeById(composer.selection?.base.nodeId ?? '') as TextNode?;

    commonOperations.convertToListItem(listItemType, textNode?.text ?? AttributedText());
  }
}
