import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zpevnik/providers/update_provider.dart';
import 'package:zpevnik/screens/content.dart';
import 'package:zpevnik/screens/loading.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Main();
}

class _Main extends State<Main> {
  UpdateProvider _updateProvider;

  @override
  void initState() {
    super.initState();

    _updateProvider = UpdateProvider();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Zpěvník',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
        ),
        home: FutureBuilder<void>(
          future: _updateProvider.update(),
          builder: (context, snapshot) => snapshot.hasData
              ? ChangeNotifierProvider.value(
                  value: _updateProvider,
                  child: LoadingWidget(),
                )
              : ContentWidget(),
        ),
      );
}
