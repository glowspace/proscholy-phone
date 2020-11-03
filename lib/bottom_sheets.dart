import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/tags_provider.dart';
import 'package:zpevnik/screens/filters/widget.dart';

void showFilters(BuildContext context, TagsProvider tagsProvider) {
  FocusScope.of(context).unfocus();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) => SizedBox(
      height: 0.67 * MediaQuery.of(context).size.height,
      child: ChangeNotifierProvider.value(
        value: tagsProvider,
        child: FiltersWidget(),
      ),
    ),
    useRootNavigator: true,
  );
}
