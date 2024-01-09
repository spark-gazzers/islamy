import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/engines/hadeeth/hadeeth_manager.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_category.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/common/loading_widget.dart';
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
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (
              BuildContext context,
              TextEditingValue controller,
              Widget? child,
            ) {
              return FutureBuilder<List<Hadeeth>>(
                future: HadeethManager.listHadeeths(widget.category),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Hadeeth>> snapshot) {
                  Widget? widget;
                  if (snapshot.hasData != true ||
                      snapshot.connectionState != ConnectionState.done) {
                    widget = const Center(
                      child: LoadingWidget(),
                    );
                  }
                  if (snapshot.hasError) widget = const Center();

                  if (widget != null) {
                    return SliverFillRemaining(
                      child: widget,
                    );
                  }
                  return _buildHadeethsTile(snapshot.data!);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHadeethsTile(List<Hadeeth> hadeeths) {
    final List<Hadeeth> filtered = hadeeths
        .where((Hadeeth element) =>
            element.title.contains(_searchController.text.trim()))
        .toList();

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge,
                children: <InlineSpan>[
                  TextSpan(text: '${S.of(context).no_hadeeth_found_with} "'),
                  TextSpan(
                    text: _searchController.text.trim(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  TextSpan(text: '" ${S.of(context).in_the} "'),
                  TextSpan(
                    text: widget.category.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  TextSpan(
                    text:
                        '" ${S.of(context).category_maybe_try_a_more_generic_search}',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return SliverList.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd) return const Divider();
        return HadeethTile(
          hadeeth: filtered[index ~/ 2],
        );
      },
      itemCount: (filtered.length * 2) - 1,
    );
  }
}
