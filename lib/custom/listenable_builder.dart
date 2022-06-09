import 'package:flutter/material.dart';

/// based on [ValueListenableBuilder], but supports rebuilding part when change notifier changes
class ListenableBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final T provider;
  final Widget Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  const ListenableBuilder({
    Key? key,
    required this.provider,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListenableBuilderState<T>();
}

class _ListenableBuilderState<T extends ChangeNotifier> extends State<ListenableBuilder<T>> {
  late T provider;

  @override
  void initState() {
    super.initState();
    provider = widget.provider;
    widget.provider.addListener(_update);
  }

  @override
  void didUpdateWidget(ListenableBuilder<T> oldWidget) {
    if (oldWidget.provider != widget.provider) {
      oldWidget.provider.removeListener(_update);
      provider = widget.provider;
      widget.provider.addListener(_update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() => provider = widget.provider);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, provider, widget.child);
  }
}
