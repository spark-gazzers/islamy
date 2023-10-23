import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/engines/quran/models/juz.dart';
import 'package:islamy/engines/quran/models/surah.dart';
import 'package:islamy/view/common/sliding_segmented_control.dart';
import 'package:islamy/view/quran/screens/bookmarks.dart';
import 'package:islamy/view/quran/screens/juzs.dart';
import 'package:islamy/view/quran/screens/surahs.dart';

/// A screen that lets the user start playing/reading
/// the quran from either selecting a [Juz],[Surah]
/// or a previously created bookmark.
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  final GlobalKey<SurahsListScreenState> _surahsKey =
      GlobalKey<SurahsListScreenState>();
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        brightness: Brightness.dark,
        middle: Text(S.of(context).the_holly_quran),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SlidingSegmentedControl(
              tabs: <Widget>[
                Tab(child: Text(S.of(context).surah)),
                Tab(child: Text(S.of(context).juz)),
                Tab(child: Text(S.of(context).bookmarks)),
              ],
              controller: _controller,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                SurahsListScreen(
                  key: _surahsKey,
                ),
                JuzsListScreen(
                  onSelected: (int i) {
                    _controller.animateTo(0);
                    _surahsKey.currentState!.animateTo(i);
                  },
                ),
                const BookmarksList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
