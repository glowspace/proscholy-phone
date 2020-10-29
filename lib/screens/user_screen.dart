import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

import 'components/user_menu.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with PlatformStateMixin {
  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: _searchWidget(context),
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: _searchWidget(context),
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => SafeArea(
        child: Column(
          children: [
            Spacer(),
            Row(
              children: [
                Text('Ostatní'),
                Spacer(),
                GestureDetector(
                  onTap: () => _showOptions(context),
                  child: Icon(Icons.menu),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _searchWidget(BuildContext context) => SearchWidget();

  void _showOptions(BuildContext context) => showCupertinoModalBottomSheet(
        context: context,
        builder: (context, scrollController) => SizedBox(
          height: 0.67 * MediaQuery.of(context).size.height,
          child: UserMenuWidget(),
        ),
      );
}
