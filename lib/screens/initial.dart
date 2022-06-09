import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/sign_in_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/scaffold.dart';

const _welcomeText = '''
Ahoj. Vítej ve Zpěvníku!

Nyní se můžeš přihlásit do${unbreakableSpace}svého uživatelského účtu. To ti zajistí automatickou synchronizaci seznamu písní a${unbreakableSpace}spoustu dalších výhod.''';

const _projectTitle = 'Projekt komunity Glow Space';
const _projectDescription = 'Projekt ProScholy.cz tvoří s${unbreakableSpace}láskou dobrovolníci z komunity Glow Space.';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return PlatformScaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Column(children: [
            const Spacer(),
            Image.asset('assets/images/title.png', width: width / 2),
            const SizedBox(height: kDefaultMargin),
            Section(
              margin: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
              padding: const EdgeInsets.all(kDefaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_welcomeText, style: textTheme.bodyMedium),
                  const SizedBox(height: kDefaultMargin / 2),
                  const SignInButton(type: SignInButtonType.google),
                  const SizedBox(height: kDefaultMargin / 2),
                  const SignInButton(type: SignInButtonType.apple),
                  const SizedBox(height: kDefaultMargin / 2),
                  const SignInButton(type: SignInButtonType.noSignIn),
                ],
              ),
            ),
            const SizedBox(height: kDefaultMargin),
            Section(
              margin: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_projectTitle, style: textTheme.titleMedium),
                  const SizedBox(height: kDefaultMargin / 2),
                  Text(_projectDescription, style: textTheme.bodyMedium),
                  const SizedBox(height: kDefaultMargin / 2),
                  CupertinoButton(
                    child: Text('Dozvědět se více', style: textTheme.bodyLarge?.copyWith(color: blue)),
                    onPressed: () => _learnMore(context),
                    padding: EdgeInsets.zero,
                    minSize: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: kDefaultMargin),
          ]),
        ),
      ),
    );
  }

  void _learnMore(BuildContext context) {}
}
