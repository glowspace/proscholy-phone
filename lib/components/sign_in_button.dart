import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/utils/extensions.dart';

const _logosPath = 'assets/images/logos';

enum SignInButtonType {
  google,
  apple,
  noSignIn,
}

extension _SignInButtonTypeExtension on SignInButtonType {
  String get text {
    switch (this) {
      case SignInButtonType.google:
        return 'Přihlásit se účtem Google';
      case SignInButtonType.apple:
        return 'Přihlásit se účtem Apple';
      case SignInButtonType.noSignIn:
        return 'Pokračovat bez přihlášení';
    }
  }

  TextStyle style(ThemeData theme) {
    switch (this) {
      case SignInButtonType.google:
        return const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black);
      case SignInButtonType.apple:
        return TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: theme.brightness.isLight ? Colors.white : Colors.black,
        );
      case SignInButtonType.noSignIn:
        return TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.colorScheme.onBackground);
    }
  }

  Color backgroundColor(Brightness brightness) {
    switch (this) {
      case SignInButtonType.google:
        return Colors.white;
      case SignInButtonType.apple:
        return brightness.isLight ? Colors.black : Colors.white;
      case SignInButtonType.noSignIn:
        return Colors.transparent;
    }
  }

  BoxBorder? get border {
    switch (this) {
      case SignInButtonType.google:
        return Border.all(color: Colors.grey.shade300);
      case SignInButtonType.apple:
        return null;
      case SignInButtonType.noSignIn:
        return null;
    }
  }

  Widget logo(ThemeData theme) {
    switch (this) {
      case SignInButtonType.google:
        return Image.asset('$_logosPath/google.png', height: 32);
      case SignInButtonType.apple:
        return Image.asset(
          theme.brightness.isLight ? '$_logosPath/apple_light.png' : '$_logosPath/apple_dark.png',
          height: 32,
        );
      case SignInButtonType.noSignIn:
        return SizedBox(
          width: 32,
          height: 32,
          child: Icon(CupertinoIcons.person_crop_circle, color: theme.colorScheme.onBackground, size: 20),
        );
    }
  }
}

class SignInButton extends StatefulWidget {
  final SignInButtonType type;
  final Function()? onSignIn;

  const SignInButton({super.key, required this.type, this.onSignIn});

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: widget.type.backgroundColor(theme.brightness),
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: widget.type.border,
      ),
      clipBehavior: Clip.antiAlias,
      child: Highlightable(
        onTap: widget.onSignIn,
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 3),
        child: Row(
          children: [
            widget.type.logo(theme),
            const SizedBox(width: kDefaultPadding / 2),
            Expanded(child: Text(widget.type.text, style: widget.type.style(theme), maxLines: 2))
          ],
        ),
      ),
    );
  }
}
