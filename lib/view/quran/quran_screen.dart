import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/common/sliding_segmented_control.dart';
import 'package:islamy/view/quran/screens/juzs.dart';
import 'package:islamy/view/quran/screens/surahs.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

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
        middle: Text(S.of(context).the_holly_quran),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SlidingSegmentedControl(
              tabs: [
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
              children: [
                SurahsListScreen(
                  key: _surahsKey,
                ),
                JuzsListScreen(
                  onSelected: (i) {
                    _controller.animateTo(0);
                    _surahsKey.currentState!.animateTo(i);
                  },
                ),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
