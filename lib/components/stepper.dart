import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/settings.dart';

const _stepperBorderRadius = 16.0;

class Stepper extends StatelessWidget {
  final String title;
  final SongLyric songLyric;

  final bool isEnabled;

  const Stepper({
    super.key,
    required this.title,
    required this.songLyric,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    const leftButtonBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(_stepperBorderRadius),
      bottomLeft: Radius.circular(_stepperBorderRadius),
    );

    const rightButtonBorderRadius = BorderRadius.only(
      topRight: Radius.circular(_stepperBorderRadius),
      bottomRight: Radius.circular(_stepperBorderRadius),
    );

    return Row(
      children: [
        Expanded(
          child: Text(title, style: textTheme.bodyMedium?.copyWith(color: isEnabled ? null : theme.disabledColor)),
        ),
        SizedBox(
          width: 112,
          child: Consumer(
            builder: (_, ref, __) => IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: leftButtonBorderRadius,
                      border: Border.all(color: isEnabled ? theme.dividerColor : theme.disabledColor),
                    ),
                    child: Highlightable(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2,
                        vertical: kDefaultPadding / 4,
                      ),
                      borderRadius: leftButtonBorderRadius,
                      highlightBackground: true,
                      isEnabled: isEnabled,
                      onTap: () => ref.read(songLyricSettingsProvider(songLyric).notifier).changeTransposition(-1),
                      child: Icon(Icons.remove, color: isEnabled ? null : theme.disabledColor),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(color: isEnabled ? theme.dividerColor : theme.disabledColor),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${ref.watch(songLyricSettingsProvider(songLyric).select((songLyricSettings) => songLyricSettings.transposition))}',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(color: isEnabled ? null : theme.disabledColor),
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: rightButtonBorderRadius,
                      border: Border.all(color: isEnabled ? theme.dividerColor : theme.disabledColor),
                    ),
                    child: Highlightable(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2,
                        vertical: kDefaultPadding / 4,
                      ),
                      borderRadius: rightButtonBorderRadius,
                      highlightBackground: true,
                      isEnabled: isEnabled,
                      onTap: () => ref.read(songLyricSettingsProvider(songLyric).notifier).changeTransposition(1),
                      child: Icon(Icons.add, color: isEnabled ? null : theme.disabledColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}