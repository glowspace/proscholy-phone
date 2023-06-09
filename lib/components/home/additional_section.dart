import 'package:flutter/material.dart';
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
      title: Text('Další možnosti', style: theme.textTheme.titleLarge),
      child: Column(children: [
        InkWell(
          onTap: () => launch(context, proscholyUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(text: 'Webová verze', icon: Icons.language, trailingIcon: Icons.open_in_new),
          ),
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => launch(context, theme.platform.isIos ? feedbackIOSUrl : feedbackAndroidUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(text: 'Zpětná vazba', icon: Icons.feedback, trailingIcon: Icons.open_in_new),
          ),
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => launch(context, addSongUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(text: 'Přidat píseň', icon: Icons.add, trailingIcon: Icons.open_in_new),
          ),
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => launch(context, dontaionsUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(text: 'Darovat', icon: Icons.favorite, trailingIcon: Icons.open_in_new, iconColor: red),
          ),
        ),
      ]),
    );
  }
}
