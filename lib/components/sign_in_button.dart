import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

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

  TextStyle get style {
    switch (this) {
      case SignInButtonType.google:
        return const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black);
      case SignInButtonType.apple:
        return const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white);
      case SignInButtonType.noSignIn:
        return TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey.shade800);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case SignInButtonType.google:
        return Colors.white;
      case SignInButtonType.apple:
        return Colors.black;
      case SignInButtonType.noSignIn:
        return Colors.white;
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

  Widget get logo {
    switch (this) {
      case SignInButtonType.google:
        return Image.asset('assets/images/logos/google.png', height: 32);
      case SignInButtonType.apple:
        return Image.asset('assets/images/logos/apple_light.png', height: 32);
      case SignInButtonType.noSignIn:
        return SizedBox(
          width: 32,
          height: 32,
          child: Icon(CupertinoIcons.person_crop_circle, color: Colors.grey.shade800, size: 20),
        );
    }
  }
}

class SignInButton extends StatefulWidget {
  final SignInButtonType type;

  const SignInButton({Key? key, required this.type}) : super(key: key);

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return Highlightable(
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        decoration: BoxDecoration(
          color: widget.type.backgroundColor,
          borderRadius: BorderRadius.circular(kDefaultRadius),
          border: widget.type.border,
        ),
        child: Row(
          children: [
            widget.type.logo,
            const SizedBox(width: kDefaultPadding / 2),
            Text(widget.type.text, style: widget.type.style, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
