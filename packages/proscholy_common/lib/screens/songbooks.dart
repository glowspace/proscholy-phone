import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/custom/back_button.dart';
import 'package:proscholy_common/components/navigation/scaffold.dart';
import 'package:proscholy_common/components/songbook/songbooks_grid_view.dart';
import 'package:proscholy_common/providers/songbooks.dart';

class SongbooksScreen extends StatelessWidget {
  const SongbooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(leading: const CustomBackButton(), title: const Text('Zpěvníky')),
      body: SafeArea(
        child: Consumer(builder: (_, ref, __) => SongbooksGridView(songbooks: ref.watch(songbooksProvider))),
      ),
    );
  }
}
