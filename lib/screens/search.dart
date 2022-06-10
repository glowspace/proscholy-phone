import 'package:flutter/material.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vyhledávání', style: theme.textTheme.titleLarge),
              const SizedBox(height: kDefaultPadding / 2),
              SearchField(isInsideSearchScreen: true),
            ],
          ),
        ),
      ),
    );
  }
}
