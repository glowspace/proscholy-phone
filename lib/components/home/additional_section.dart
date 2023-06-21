import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        InkWell(
          onTap: () => context.push('/user'),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(icon: Icons.person, text: 'Uživatelský účet', trailingtext: 'Patrik Dobiáš'),
          ),
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => context.push('/user'),
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
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
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => launch(context, proscholyUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(icon: Icons.language, text: 'Webová verze', trailingIcon: Icons.open_in_new),
          ),
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => launch(context, theme.platform.isIos ? feedbackIOSUrl : feedbackAndroidUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(icon: Icons.feedback, text: 'Zpětná vazba', trailingIcon: Icons.open_in_new),
          ),
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => launch(context, addSongUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(icon: Icons.add, text: 'Přidat píseň', trailingIcon: Icons.open_in_new),
          ),
        ),
        const Divider(height: 0),
        InkWell(
          onTap: () => launch(context, dontaionsUrl),
          child: const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: IconItem(icon: Icons.favorite, text: 'Darovat', trailingIcon: Icons.open_in_new, iconColor: red),
          ),
        ),
      ],
    );
  }
}
