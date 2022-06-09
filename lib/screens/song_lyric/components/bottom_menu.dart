import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/scroll.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_settings.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/theme.dart';

class BottomMenu extends StatefulWidget {
  final LyricsController lyricsController;
  final ScrollProvider? scrollProvider;

  const BottomMenu({Key? key, required this.lyricsController, this.scrollProvider}) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  late bool _collapsed;

  @override
  void initState() {
    super.initState();

    _collapsed = false;

    // final settingsProvider = context.read<SettingsProvider>();

    // _collapsed = ValueNotifier(settingsProvider.bottomOptionsCollapsed);
    // _collapsed.addListener(settingsProvider.toggleBottomOptionsCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      transform: Matrix4.translationValues(1, 0, 0), // just to hide right border
      padding: const EdgeInsets.only(left: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        border: Border.all(color: appTheme.borderColor),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(100)),
      ),
      child: Row(children: _options(context)),
    );
  }

  List<Widget> _options(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2);

    return [
      AnimatedSize(
        duration: kDefaultAnimationDuration,
        child: SizedBox(
          width: _collapsed ? 0 : null,
          child: Row(children: [
            Highlightable(child: const Icon(Icons.tune), padding: padding, onTap: () => _showSettings(context)),
            if (widget.lyricsController.songLyric.hasExternals)
              Highlightable(
                child: const Icon(Icons.headset),
                padding: padding,
                onTap: () => _showExternals(context),
              ),
            AnimatedSize(
              duration: kDefaultAnimationDuration,
              child: SizedBox(
                width: widget.scrollProvider?.isScrolling.value ?? false ? null : 0,
                child: Row(children: [
                  Highlightable(
                    child: const Icon(Icons.add),
                    padding: padding,
                    onTap: widget.scrollProvider?.faster,
                  ),
                  Highlightable(
                    child: const Icon(Icons.remove),
                    padding: padding,
                    onTap: widget.scrollProvider?.slower,
                  ),
                ]),
              ),
            ),
            Highlightable(
              child: Icon(widget.scrollProvider?.isScrolling.value ?? false ? Icons.stop : Icons.arrow_downward),
              padding: padding,
              onTap: widget.scrollProvider?.canScroll ?? false ? widget.scrollProvider?.toggleScroll : null,
            ),
          ]),
        ),
      ),
      AnimatedRotation(
        turns: _collapsed ? 0 : 0.5,
        duration: kDefaultAnimationDuration,
        child: Highlightable(
          child: const Icon(Icons.arrow_back),
          padding: padding,
          onTap: _toggleCollapsed,
        ),
      )
    ];
  }

  void _toggleCollapsed() => setState(() => _collapsed = !_collapsed);

  void _showSettings(BuildContext context) {
    showPlatformBottomSheet(
      context: context,
      builder: (_) => SongLyricSettingsWidget(lyricsController: widget.lyricsController),
      height: 0.5 * MediaQuery.of(context).size.height,
    );
  }

  void _showExternals(BuildContext context) {
    // context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.MAX);
  }
}
