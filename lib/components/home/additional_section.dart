import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/url_launcher.dart';

class AdditionalSection extends StatelessWidget {
  const AdditionalSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Section(
      title: Text('Další', style: theme.textTheme.titleLarge),
      child: Column(children: [
        Highlightable(
          onTap: () => launch(proscholyUrl),
          highlightBackground: true,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: const IconItem(text: 'Webová verze', icon: Icons.language, trailingIcon: Icons.open_in_new),
        ),
        const Divider(height: kDefaultPadding),
        Highlightable(
          onTap: () => launch(theme.platform.isIos ? feedbackIOSUrl : feedbackAndroidUrl),
          highlightBackground: true,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: const IconItem(text: 'Zpětná vazba', icon: Icons.feedback, trailingIcon: Icons.open_in_new),
        ),
        const Divider(height: kDefaultPadding),
        Highlightable(
          onTap: () => launch(addSongUrl),
          highlightBackground: true,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: const IconItem(text: 'Přidat píseň', icon: Icons.add, trailingIcon: Icons.open_in_new),
        ),
        const Divider(height: kDefaultPadding),
        Highlightable(
          onTap: () => launch(dontaionsUrl),
          highlightBackground: true,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: const IconItem(text: 'Darovat', icon: Icons.favorite, trailingIcon: Icons.open_in_new, iconColor: red),
        ),
      ]),
    );
  }
}
