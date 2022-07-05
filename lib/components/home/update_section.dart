import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/utils/updater.dart';

class UpdateSection extends StatelessWidget {
  const UpdateSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updater = context.read<DataProvider>().updater;

    return ValueListenableBuilder<UpdaterState>(
      valueListenable: updater.state,
      builder: (context, value, __) => updater.isUpdating ? _buildUpdateInfo(context, value) : Container(),
    );
  }

  Widget _buildUpdateInfo(BuildContext context, UpdaterState state) {
    final textTheme = Theme.of(context).textTheme;

    final Text text;

    if (state is UpdaterStateLoading) {
      text = Text('Probíhá stahování písní', style: textTheme.bodyMedium);
    } else if (state is UpdaterStateUpdating) {
      text = Text('Probíhá stahování písní ($state)', style: textTheme.bodyMedium);
    } else if (state is UpdaterStateDone) {
      text = Text('Bylo aktualizováno ${state.updatedCount} písní', style: textTheme.bodyMedium);
    } else {
      text = Text('', style: textTheme.bodyMedium);
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 2 * kDefaultPadding),
      child: Section(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: text),
              if (state is UpdaterStateDone)
                Highlightable(
                  onTap: () => context.read<DataProvider>().updater.state.value = UpdaterStateIdle(),
                  child: const Icon(Icons.close),
                )
            ]),
            if (state is UpdaterStateUpdating)
              Container(
                padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(kDefaultRadius)),
                child: LinearProgressIndicator(value: state.current / state.count),
              )
          ],
        ),
      ),
    );
  }
}
