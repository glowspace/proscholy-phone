import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:zpevnik/constants.dart';

class ReorderableRow extends StatelessWidget {
  final Key key;
  final Widget child;

  ReorderableRow({this.key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => ReorderableItem(key: key, childBuilder: _childBuilder);

  Widget _childBuilder(BuildContext context, ReorderableItemState state) => Opacity(
        opacity: state == ReorderableItemState.placeholder ? 0 : (state == ReorderableItemState.dragProxy ? 0.75 : 1),
        child: Container(
          child: Row(children: [
            ReorderableListener(
              child: Container(
                padding: EdgeInsets.only(left: kDefaultPadding),
                child: Icon(Icons.drag_handle, color: Theme.of(context).textTheme.caption.color),
              ),
            ),
            Expanded(child: child),
          ]),
        ),
      );
}
