import 'package:flutter/material.dart';

class UserMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
          child: Column(
        children: [
          Text(
            'Nastavení',
          ),
          Text(
            'Webová verze',
          ),
          Text(
            'Zpětná vazba',
          ),
          Text(
            'Přidat píseň',
          ),
          Text(
            'O projektu',
          ),
        ],
      ));
}
