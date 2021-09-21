import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';

class PlatformProgressIndicator extends StatelessWidget with PlatformMixin {
  @override
  Widget buildAndroid(BuildContext context) => CircularProgressIndicator();

  @override
  Widget buildIos(BuildContext context) => CupertinoActivityIndicator();
}
