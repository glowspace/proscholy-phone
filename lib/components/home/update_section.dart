import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/url_launcher.dart';

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
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
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
                            HighlightableTextButton(
                              onTap: () => launch(
                                context,
                                '$reportUrl?summary=Chyba při aktualizaci písní&description=${snapshot.error}',
                              ),
                              foregroundColor: red,
                              child: const Text('Nahlásit chybu'),
                            ),
                          if (snapshot.hasData && updatedCount > 0)
                            HighlightableTextButton(
                              onTap: () => context.push('/updated_song_lyrics'),
                              foregroundColor: theme.colorScheme.primary,
                              child: const Text('Zobrazit'),
                            ),
                        ],
                      ),
                    ),
                    if (snapshot.isDone && isShowing)
                      HighlightableIconButton(
                        onTap: () => setState(() => _isHidden = true),
                        icon: const Icon(Icons.close),
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
