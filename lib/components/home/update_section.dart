import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/utils/updater.dart';
import 'package:zpevnik/utils/extensions.dart';

class UpdateSection extends StatefulWidget {
  const UpdateSection({Key? key}) : super(key: key);

  @override
  State<UpdateSection> createState() => _UpdateSectionState();
}

class _UpdateSectionState extends State<UpdateSection> {
  late final Future<int> _updateFuture;

  bool _isHidden = false;

  @override
  void initState() {
    super.initState();

    _updateFuture = context.read<DataProvider>().update();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return FutureBuilder<int>(
      future: _updateFuture,
      builder: (context, snapshot) {
        final updatedCount = snapshot.data ?? 0;
        final isShowing = snapshot.isDone ? !_isHidden && (snapshot.hasError || updatedCount > 0) : true;

        final String text;

        if (snapshot.hasData && updatedCount > 0) {
          text = 'Počet aktualizovaných písní: ${snapshot.data}';
        } else if (snapshot.hasError) {
          text = 'Nastala chyba při aktualizaci';
        } else {
          text = 'Probíhá stahování písní';
        }

        return AnimatedCrossFade(
          crossFadeState: isShowing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: kDefaultAnimationDuration,
          firstChild: Container(
            padding: const EdgeInsets.only(bottom: 2 * kDefaultPadding),
            child: Section(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(text, style: textTheme.bodyMedium),
                          if (snapshot.isDone && isShowing) const SizedBox(height: kDefaultPadding / 2),
                          if (snapshot.hasError)
                            Highlightable(
                              onTap: () => launchUrl(Uri.parse(
                                  '$reportUrl?summary=Chyba při aktualizaci písní&description=${snapshot.error}')),
                              child: Text('Nahlásit chybu', style: textTheme.bodyMedium?.copyWith(color: red)),
                            ),
                          if (snapshot.hasData && updatedCount > 0)
                            Highlightable(
                              onTap: () => NavigationProvider.of(context).pushNamed('/updated_song_lyrics'),
                              child: Text(
                                'Zobrazit',
                                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (snapshot.isDone && isShowing)
                      Highlightable(
                        onTap: () => setState(() => _isHidden = true),
                        child: const Icon(Icons.close),
                      )
                  ]),
                  if (!snapshot.isDone)
                    Container(
                      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                      child: const LinearProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
          secondChild: Container(),
        );
      },
    );
  }
}
