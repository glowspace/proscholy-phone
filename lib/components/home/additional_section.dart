import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/url_launcher.dart';

class AdditionalSection extends StatelessWidget {
  const AdditionalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Section(
      outsideTitle: 'Další možnosti',
      outsideTitleLarge: true,
      margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      children: [
        // Highlightable(
        //   highlightBackground: true,
        //   padding: const EdgeInsets.all(kDefaultPadding),
        //   onTap: () => context.push('/user'),
        //   child: const IconItem(icon: Icons.person, text: 'Uživatelský účet', trailingtext: 'Patrik Dobiáš'),
        // ),
        // const Divider(),
        Highlightable(
          highlightBackground: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          onTap: () => context.push('/settings'),
          child: Consumer(
            builder: (_, ref, __) => IconItem(
              icon: Icons.settings,
              text: 'Nastavení aplikace',
              trailingtext: ref.read(
                appDependenciesProvider.select((appDependencies) => appDependencies.packageInfo.version),
              ),
            ),
          ),
        ),
        const Divider(),
        Highlightable(
          highlightBackground: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          onTap: () => launch(proscholyUrl),
          child: const IconItem(icon: Icons.language, text: 'Webová verze', trailingIcon: Icons.open_in_new),
        ),
        const Divider(),
        Highlightable(
          highlightBackground: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          onTap: () => launch(theme.platform.isIos ? feedbackIOSUrl : feedbackAndroidUrl),
          child: const IconItem(icon: Icons.feedback, text: 'Zpětná vazba', trailingIcon: Icons.open_in_new),
        ),
        const Divider(),
        Highlightable(
          highlightBackground: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          onTap: () => launch(addSongUrl),
          child: const IconItem(icon: Icons.add, text: 'Přidat píseň', trailingIcon: Icons.open_in_new),
        ),
        const Divider(),
        Highlightable(
          highlightBackground: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          onTap: () => launch(dontaionsUrl),
          child: const IconItem(icon: Icons.favorite, text: 'Darovat', trailingIcon: Icons.open_in_new, iconColor: red),
        ),
      ],
    );
  }
}
