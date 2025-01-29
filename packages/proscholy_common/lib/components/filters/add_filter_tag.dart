import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/utils/extensions.dart';

const double _addFilterRadius = 7;

class AddFilterTag extends StatelessWidget {
  final Function() onTap;

  const AddFilterTag({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addFilterButtonColor = theme.brightness.isLight ? const Color(0xff848484) : const Color(0xff7b7b7b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4, vertical: 2),
      padding: const EdgeInsets.only(right: kDefaultPadding),
      child: DottedBorder(
        dashPattern: const [7, 3],
        color: addFilterButtonColor,
        borderType: BorderType.RRect,
        radius: const Radius.circular(_addFilterRadius),
        padding: EdgeInsets.zero,
        child: HighlightableWidget(
          highlightBackground: true,
          borderRadius: BorderRadius.circular(_addFilterRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: Row(children: [
              Icon(Icons.add, size: 12, color: addFilterButtonColor),
              const SizedBox(width: kDefaultPadding / 4),
              Text('Přidat filtr', style: theme.textTheme.labelMedium?.copyWith(color: addFilterButtonColor)),
            ]),
          ),
        ),
      ),
    );
  }
}
