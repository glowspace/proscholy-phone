import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/screens/components/custom_icon_button.dart';
import 'package:zpevnik/screens/favorite_screen.dart';
import 'package:zpevnik/theme.dart';
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
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FavoriteScreen()),
                      ),
                      behavior: HitTestBehavior.translucent,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: kDefaultPadding),
                            child: Icon(Icons.star),
                          ),
                          Text('Písně s hvězdičkou'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
        ),
      );

  Widget _searchWidget(BuildContext context) => SearchWidget(
        placeholder: 'Zadejte název seznamu písní',
        leading: CustomIconButton(
          onPressed: null,
          icon: Icon(Icons.search, color: AppTheme.shared.searchFieldIconColor(context)),
        ),
      );

  void _showOptions(BuildContext context) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        builder: (context) => SizedBox(
          height: 0.5 * MediaQuery.of(context).size.height,
          child: UserMenuWidget(),
        ),
      );
}
