import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvisibleAppBar extends AppBar {
  InvisibleAppBar({Key? key, SystemUiOverlayStyle? systemOverlayStyle})
      : super(key: key, systemOverlayStyle: systemOverlayStyle, shadowColor: Colors.transparent);

  @override
  Size get preferredSize => const Size.square(0);
}
