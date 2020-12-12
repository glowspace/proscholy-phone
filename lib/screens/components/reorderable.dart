import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class Reorderable extends StatelessWidget {
  final Key key;
  final Widget child;

  Reorderable({this.key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => ReorderableItem(key: key, childBuilder: _childBuilder);

  Widget _childBuilder(BuildContext context, ReorderableItemState state) => Opacity(
        opacity: state == ReorderableItemState.placeholder ? 0 : (state == ReorderableItemState.dragProxy ? 0.75 : 1),
        child: Container(child: child),
      );
}
