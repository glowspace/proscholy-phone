import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zpevnik/components/logo.dart';
import 'package:zpevnik/constants.dart';

class PresentationScreen extends StatelessWidget {
  final String presentedLyrics;

  const PresentationScreen({super.key, required this.presentedLyrics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(child: Text(presentedLyrics, style: const TextStyle(fontSize: 128))),
        Positioned(
          bottom: 2 * kDefaultPadding,
          right: 2 * kDefaultPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/songbooks/default.png', width: 192),
              const SizedBox(width: kDefaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Zpěvník', style: GoogleFonts.roboto(fontSize: 64, fontWeight: FontWeight.w700)),
                  Text('ProScholy.cz', style: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400)),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
