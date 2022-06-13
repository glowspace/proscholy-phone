import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

class UpdateSection extends StatelessWidget {
  const UpdateSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updater = context.read<DataProvider>().updater;

    return ValueListenableBuilder<int>(
      valueListenable: updater.updateProgress,
      builder: (_, value, __) => updater.isUpdating
          ? Container(
              padding: const EdgeInsets.only(bottom: 2 * kDefaultPadding),
              child: Section(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Probíhá stahování písní ($value/${updater.updatingSongLyricsCount})'),
                    const SizedBox(height: kDefaultPadding / 2),
                    LinearProgressIndicator(value: value / updater.updatingSongLyricsCount)
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
