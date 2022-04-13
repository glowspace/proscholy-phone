import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';

class PlatformProgressIndicator extends StatelessWidget with PlatformMixin {
  const PlatformProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) => const CircularProgressIndicator();

  @override
  Widget buildIos(BuildContext context) => const CupertinoActivityIndicator();
}
