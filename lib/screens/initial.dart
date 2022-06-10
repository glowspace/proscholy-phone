import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/sign_in_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/scaffold.dart';

const _welcomeText = '''
Ahoj. Vítej ve Zpěvníku!

Nyní se můžeš přihlásit do${unbreakableSpace}svého uživatelského účtu. To ti zajistí automatickou synchronizaci seznamů písní a${unbreakableSpace}spoustu dalších výhod.''';

const _projectTitle = 'Projekt komunity Glow Space';
const _projectDescription = 'Projekt ProScholy.cz tvoří s${unbreakableSpace}láskou dobrovolníci z komunity Glow Space.';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);

    final height = mediaQuery.size.height - mediaQuery.padding.top;
    final width = mediaQuery.size.width;

    return Scaffold(
      body: Container(
        height: height,
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 2 * kDefaultPadding),
            Image.asset('assets/images/title.png', width: width / 2),
            Section(
              margin: const EdgeInsets.all(2 * kDefaultPadding).copyWith(bottom: kDefaultPadding),
              padding: const EdgeInsets.all(2 * kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_welcomeText, style: textTheme.bodyMedium),
                  const SizedBox(height: 2 * kDefaultPadding),
                  const SignInButton(type: SignInButtonType.google),
                  const SizedBox(height: kDefaultPadding),
                  const SignInButton(type: SignInButtonType.apple),
                  const SizedBox(height: kDefaultPadding),
                  SignInButton(type: SignInButtonType.noSignIn, onSignedIn: () => _pushHomeScreen(context)),
                ],
              ),
            ),
            Section(
              margin: const EdgeInsets.all(2 * kDefaultPadding).copyWith(top: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_projectTitle, style: textTheme.titleMedium),
                  const SizedBox(height: kDefaultPadding),
                  Text(_projectDescription, style: textTheme.bodyMedium),
                  const SizedBox(height: kDefaultPadding),
                  CupertinoButton(
                    child: Text('Dozvědět se více', style: textTheme.bodyLarge?.copyWith(color: blue)),
                    onPressed: () => _learnMore(context),
                    padding: EdgeInsets.zero,
                    minSize: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: kDefaultPadding),
          ]),
        ),
      ),
    );
  }

  void _pushHomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _learnMore(BuildContext context) {}
}
