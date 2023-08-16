import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class BottomSheetSection extends StatelessWidget {
  final String title;
  final bool childrenPadding;
  final List<Widget> children;

  const BottomSheetSection({super.key, required this.title, this.childrenPadding = true, required this.children});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            childrenPadding ? 1.5 * kDefaultPadding : 0,
            kDefaultPadding,
            childrenPadding ? 1.5 * kDefaultPadding : 0,
            MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: childrenPadding ? 0 : 1.5 * kDefaultPadding),
                child: Text(title, style: Theme.of(context).textTheme.titleLarge),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
