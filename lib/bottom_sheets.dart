import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/tags_provider.dart';
import 'package:zpevnik/screens/components/higlightable_row.dart';
import 'package:zpevnik/screens/filters/widget.dart';

void showFilters(BuildContext context, TagsProvider tagsProvider) {
  FocusScope.of(context).unfocus();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) => SizedBox(
      height: 0.67 * MediaQuery.of(context).size.height,
      child: ChangeNotifierProvider.value(
        value: tagsProvider,
        child: FiltersWidget(),
      ),
    ),
    useRootNavigator: true,
  );
}

void showPlaylists(BuildContext context, List<Playlist> playlists) {
  FocusScope.of(context).unfocus();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) => SizedBox(
      height: 0.67 * MediaQuery.of(context).size.height,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          children: [
            HighlightableRow(title: 'Nový playlist', icon: Icons.add, onPressed: () => showAlert(context)),
          ],
        ),
      ),
    ),
    useRootNavigator: true,
  );
}

void showAlert(BuildContext context) => showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vytvořit playlist'),
          content: Container(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Název',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Zrušit', style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Vytvořit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
