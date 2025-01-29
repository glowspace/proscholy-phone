import 'package:flutter/material.dart';
import 'package:proscholy_common/components/custom/close_button.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/presentation/settings.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/providers/presentation.dart';
import 'package:proscholy_common/routing/safe_area_wrapper.dart';
import 'package:proscholy_common/utils/extensions.dart';

const _noExternalDisplayText =
    'Nebyl detekován žádný externí displej. Bude pouze upraveno zobrazení písní na${unbreakableSpace}tomto zařízení.';

class StartPresentationScreen extends StatefulWidget {
  const StartPresentationScreen({super.key});

  @override
  State<StartPresentationScreen> createState() => _StartPresentationScreenState();
}

class _StartPresentationScreenState extends State<StartPresentationScreen> with WidgetsBindingObserver {
  bool _onExternalDisplay = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    context.providers
        .read(presentationProvider)
        .onExternalDisplay
        .then((onExternalDisplay) => setState(() => _onExternalDisplay = onExternalDisplay));
  }

  @override
  void initState() {
    super.initState();

    context.providers
        .read(presentationProvider)
        .onExternalDisplay
        .then((onExternalDisplay) => setState(() => _onExternalDisplay = onExternalDisplay));

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final infoColorScheme = ColorScheme.fromSeed(seedColor: blue, brightness: Theme.of(context).brightness);

    return SafeAreaWrapper(
      child: Scaffold(
        appBar: AppBar(
          leading: const CustomCloseButton(),
          title: const Text('Promítat'),
          actions: [
            HighlightableWidget(
              onTap: () {
                context.providers.read(presentationProvider).start();
                context.pop();
              },
              padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(children: [
            if (!_onExternalDisplay)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: infoColorScheme.primary),
                  color: infoColorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(kDefaultRadius),
                ),
                margin: const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding, kDefaultPadding, 0),
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Row(children: [
                  Icon(Icons.info, color: infoColorScheme.onPrimaryContainer),
                  const SizedBox(width: kDefaultPadding),
                  const Expanded(child: Text(_noExternalDisplayText)),
                ]),
              ),
            PresentationSettingsWidget(onExternalDisplay: _onExternalDisplay),
          ]),
        ),
      ),
    );
  }
}
