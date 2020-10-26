import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zpevnik/providers/update_provider.dart';

class LoadingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Theme.of(context).brightness == Brightness.light
                ? 'assets/images/background.png'
                : 'assets/images/background_dark.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Center(
              child: Consumer<UpdateProvider>(
                  builder: (context, provider, _) =>
                      Text(provider.progressInfo)),
            ),
          ),
        ),
      );
}
