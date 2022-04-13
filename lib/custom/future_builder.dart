import 'package:flutter/material.dart';
import 'package:zpevnik/platform/components/progress_indicator.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(BuildContext, Widget)? wrapperBuilder;
  // TODO: find out how to use T without optional for void T
  final Widget Function(BuildContext, T?) builder;

  const CustomFutureBuilder({Key? key, this.future, this.wrapperBuilder, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wrapperBuilder = this.wrapperBuilder ?? (_, child) => child;

    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return wrapperBuilder(context, Text('${snapshot.error}'));
          } else {
            return wrapperBuilder(context, builder(context, snapshot.data));
          }
        } else {
          return wrapperBuilder(context, const Center(child: PlatformProgressIndicator()));
        }
      },
    );
  }
}
