import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class RecentlyOpenedHadeeths extends StatelessWidget {
  const RecentlyOpenedHadeeths({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SuperCupertinoNavigationBar(
        largeTitle: Text(
          S.of(context).hadeeth,
          style: const TextStyle(inherit: true),
        ),
        appBarType: AppBarType.LargeTitleWithoutSearch,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: ListTile(
              autofocus: true,
              enabled: true,
              leading: const Icon(Icons.library_books_outlined),
              onTap: () => Navigator.of(context).pushNamed('hadeeth_category'),
              title: Text(
                S
                    .of(context)
                    .browse_over_400_category_including_more_than_a_thousand_hadeeths,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 40,
              ),
              child: Text(
                S.of(context).recently_opened,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
