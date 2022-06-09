import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/scaffold.dart';

const _welcomeText = '''
Ahoj. Vítej ve Zpěvníku!

Nyní se můžeš přihlásit do svého uživatelského účtu. To ti zajistí automatickou synchronizaci seznamu písní a spoustu dalších výhod.''';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(kDefaultPadding),
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          child: Column(
            children: [
              const Text(_welcomeText),
            ],
          ),
        ),
      ]),
    );
  }
}
