import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/sign_in_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/future_builder.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/utils/extensions.dart';

const _welcomeText = '''
Ahoj. Vítej ve Zpěvníku!

Nyní se můžeš přihlásit do${unbreakableSpace}svého uživatelského účtu. To ti zajistí automatickou synchronizaci seznamů písní a${unbreakableSpace}spoustu dalších výhod.''';

const _projectTitle = 'Projekt komunity Glow Space';
const _projectDescription = 'Projekt ProScholy.cz tvoří s${unbreakableSpace}láskou dobrovolníci z komunity Glow Space.';

const _animationDuration = Duration(milliseconds: 800);

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final height = mediaQuery.size.height - mediaQuery.padding.top;
    final width = mediaQuery.size.width;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          child: FutureBuilder(
            future: _init(context),
            builder: (_, snapshot) => AnimatedAlign(
              duration: _animationDuration,
              alignment: snapshot.isDone ? Alignment.bottomCenter : Alignment.center,
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 2 * kDefaultPadding),
                  Image.asset('assets/images/title.png', width: width / 2),
                  AnimatedAlign(
                    duration: _animationDuration,
                    alignment: Alignment.topCenter,
                    heightFactor: snapshot.isDone ? 1 : 0,
                    child: AnimatedOpacity(
                      duration: _animationDuration,
                      opacity: snapshot.isDone ? 1 : 0,
                      child: Column(
                        children: [
                          _buildSignInSection(context),
                          _buildProjectSection(context),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Section(
      margin: const EdgeInsets.all(2 * kDefaultPadding).copyWith(bottom: kDefaultPadding),
      padding: const EdgeInsets.all(2 * kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_welcomeText, style: textTheme.bodyMedium),
          const SizedBox(height: 2 * kDefaultPadding),
          const SignInButton(type: SignInButtonType.google),
          const SizedBox(height: kDefaultPadding),
          CustomFutureBuilder<bool>(
            future: SignInWithApple.isAvailable(),
            builder: (_, isAvailable) =>
                isAvailable ? SignInButton(type: SignInButtonType.apple, onSignIn: _signInWithApple) : Container(),
          ),
          const SizedBox(height: kDefaultPadding),
          SignInButton(type: SignInButtonType.noSignIn, onSignIn: () => _pushHomeScreen(context)),
        ],
      ),
    );
  }

  Widget _buildProjectSection(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Section(
      margin: const EdgeInsets.all(2 * kDefaultPadding).copyWith(top: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_projectTitle, style: textTheme.titleMedium),
          const SizedBox(height: kDefaultPadding),
          Text(_projectDescription, style: textTheme.bodyMedium),
          TextButton(
            child: const Text('Dozvědět se více'),
            onPressed: () => _learnMore(context),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.resolveWith((states) =>
                  states.contains(MaterialState.pressed) ? colorScheme.primary.withAlpha(0x80) : colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _init(BuildContext context) async {
    await context.read<DataProvider>().init();
    await context.read<SettingsProvider>().init();

    _pushHomeScreen(context);
  }

  void _signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print(credential);
  }

  void _pushHomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _learnMore(BuildContext context) {}
}
