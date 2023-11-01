import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/engines/hadeeth/hadeeth_manager.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_category.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/common/sliding_segmented_control.dart';
import 'package:islamy/view/hadeeth/category_tile.dart';
import 'package:islamy/view/hadeeth/hadeeth_tile.dart';
import 'package:pinput/pinput.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    required this.scope,
    super.key,
  });
  final HadeethCategory? scope;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  Future<void>? _search;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;

  List<Hadeeth> hadeethSearchResults = <Hadeeth>[];
  List<HadeethCategory> categoriesSearchResults = <HadeethCategory>[];

  List<HadeethCategory> get _scope {
    final Set<HadeethCategory> results = _getSubs(widget.scope).toSet();
    final Set<HadeethCategory> subs = <HadeethCategory>{};
    do {
      results.addAll(subs);
      subs.clear();
      for (final HadeethCategory parent in results) {
        subs.addAll(_getSubs(parent));
      }
      subs.removeAll(results);
    } while (subs.isNotEmpty);
    return results.toList();
  }

  List<HadeethCategory> get _categoriesSearchResults => _scope
      .where((HadeethCategory element) => element.title
          .trim()
          .toLowerCase()
          .contains(_searchController.text.trim().toLowerCase()))
      .toList();

  List<Hadeeth> get _hadeethSearchResults {
    Iterable<Hadeeth> results = HadeethStore.listHadeeths();
    // only hadeeths in the _scope categories.
    final Iterable<String> categories =
        _scope.map((HadeethCategory category) => category.id);
    results = results.where(
      (Hadeeth hadeeth) => categories.contains(hadeeth.category),
    );

    return results
        .where((Hadeeth hadeeth) => hadeeth.title
            .trim()
            .toLowerCase()
            .contains(_searchController.text.trim().toLowerCase()))
        .toList();
  }

  bool get shouldSearch => _searchController.length >= 3;
  List<HadeethCategory> _getSubs(HadeethCategory? parent) {
    return HadeethStore.listCategories()
        .where((HadeethCategory category) => category.parentId == parent?.id)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: const Duration(milliseconds: 300),
      initialIndex: 0,
    );
  }

  Future<void> _startSearch() async {
    hadeethSearchResults = _hadeethSearchResults;
    categoriesSearchResults = _categoriesSearchResults;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              S.of(context).hadeeth_search,
            ),
            stretch: true,
            previousPageTitle: S.of(context).hadeeth,
          ),
          SliverPinnedHeader(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CupertinoSearchTextField(
                      onChanged: (_) {
                        setState(() {
                          _search = _startSearch();
                        });
                      },
                      onTap: () {
                        // _scrollController.animateTo(0,
                        //     duration: const Duration(milliseconds: 300),
                        //     curve: Curves.ease);
                      },
                      controller: _searchController,
                      focusNode: _searchNode,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SlidingSegmentedControl(
                    isScrollable: false,
                    tabs: <Widget>[
                      Tab(child: Text(S.of(context).categories)),
                      Tab(child: Text(S.of(context).hadeeths)),
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ),
        ],
        body: FutureBuilder<void>(
          future: _search,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return const SizedBox.shrink();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator(
                animating: true,
              );
            }
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _searchController,
                  builder: (BuildContext context, Widget? child) {
                    if (!(shouldSearch && categoriesSearchResults.isNotEmpty)) {
                      return const SizedBox.shrink();
                    }
                    return ListView.separated(
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryTile(
                          category: categoriesSearchResults[index],
                        );
                      },
                      itemCount: categoriesSearchResults.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _searchController,
                  builder: (BuildContext context, Widget? child) {
                    if (!(shouldSearch && hadeethSearchResults.isNotEmpty)) {
                      return const SizedBox.shrink();
                    }
                    return ListView.separated(
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      itemBuilder: (BuildContext context, int index) {
                        return HadeethTile(
                          hadeeth: hadeethSearchResults[index],
                        );
                      },
                      itemCount: hadeethSearchResults.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchNode.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
