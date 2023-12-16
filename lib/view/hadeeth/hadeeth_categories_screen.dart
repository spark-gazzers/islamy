import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/engines/hadeeth/hadeeth_manager.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_category.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_language.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/hadeeth/category_tile.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HadeethCategoryScreen extends StatefulWidget {
  const HadeethCategoryScreen({
    super.key,
    this.category,
    this.language,
  });
  final HadeethCategory? category;
  final HadeethLanguage? language;

  @override
  State<HadeethCategoryScreen> createState() => _HadeethCategoryScreenState();
}

class _HadeethCategoryScreenState extends State<HadeethCategoryScreen> {
  HadeethCategory? _category;
  late HadeethLanguage _language;
  @override
  void initState() {
    _category = widget.category;
    _language = widget.language ?? HadeethStore.settings.language;
    super.initState();
  }

  List<HadeethCategory> get _categories =>
      HadeethStore.subCategoriesOf(_category);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(_category?.title ?? S.of(context).hadeeth_roots),
            stretch: true,
            previousPageTitle: S.of(context).hadeeth,
          ),
          if (_category == null)
            SliverToBoxAdapter(
              child: ListTile(
                title: Text(
                  S
                      .of(context)
                      // ignore: lines_longer_than_80_chars
                      .hadeeths_are_divided_to_multiple_categories_with_roots_count_as_root_category_you_can_browse_or_search_right_through_them(
                        _categories.length,
                      ),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                leading: const Icon(Icons.info_outline),
              ),
            ),
          SliverPinnedHeader(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'hadeeths_search',
                  arguments: <String, dynamic>{'scope': widget.category},
                );
              },
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: AbsorbPointer(child: CupertinoSearchTextField()),
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index.isOdd) return const Divider();
              return CategoryTile(
                category: _categories[index ~/ 2],
                langauge: _language,
              );
            },
            itemCount: (_categories.length * 2) - 1,
          ),
        ],
      ),
    );
  }
}
