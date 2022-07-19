import 'package:flutter/material.dart';
import 'package:zpevnik/components/bottom_navigation_bar.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/songbook/songbooks_list_view.dart';
import 'package:zpevnik/utils/extensions.dart';

class SongbooksScreen extends StatelessWidget {
  const SongbooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('Zpěvníky', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      bottomNavigationBar: MediaQuery.of(context).isTablet ? null : const CustomBottomNavigationBar(),
      body: const SafeArea(child: SongbooksListView()),
    );
  }
}
