import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/engines/hadeeth/hadeeth_manager.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_category.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/hadeeth/hadeeth_tile.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HadeethsScreen extends StatefulWidget {
  const HadeethsScreen({
    required this.category,
    super.key,
  });
  final HadeethCategory category;

  @override
  State<HadeethsScreen> createState() => _HadeethsScreenState();
}

class _HadeethsScreenState extends State<HadeethsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  List<Hadeeth> get hadeeths => HadeethStore.listHadeeths()
      .where(
        (Hadeeth hadeeth) =>
            hadeeth.category == widget.category.id &&
            hadeeth.languageCode == HadeethStore.settings.language.code,
      )
      .toList();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              widget.category.title,
            ),
            stretch: true,
            previousPageTitle: S.of(context).hadeeth,
          ),
          SliverPinnedHeader(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  controller: _searchController,
                  focusNode: _searchNode,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
              animation: _searchController,
              builder: (BuildContext context, Widget? child) {
                return SliverList.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if (index.isOdd) return const Divider();
                    return HadeethTile(
                      hadeeth: hadeeths[index ~/ 2],
                    );
                  },
                  itemCount: (hadeeths.length * 2) - 1,
                );
              }),
        ],
      ),
    );
  }
}
