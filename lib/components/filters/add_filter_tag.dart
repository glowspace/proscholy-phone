import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/filters/filters.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _addFilterRadius = 7;

class AddFilterTag extends StatelessWidget {
  const AddFilterTag({super.key});

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
        child: Highlightable(
          highlightBackground: true,
          borderRadius: BorderRadius.circular(_addFilterRadius),
          onTap: () => _showFilters(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding / 3,
              horizontal: kDefaultPadding / 2,
            ),
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

  void _showFilters(BuildContext context) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SizedBox(
        height: 2 / 3 * MediaQuery.of(context).size.height,
        child: const FiltersWidget(),
      ),
      routeSettings: const RouteSettings(name: '/filters'),
    );
  }
}
