import 'package:flutter/material.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/view/common/surah_icon.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class JuzsListScreen extends StatefulWidget {
  const JuzsListScreen({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  final void Function(int number) onSelected;

  @override
  State<JuzsListScreen> createState() => _JuzsListScreenState();
}

class _JuzsListScreenState extends State<JuzsListScreen>
    with AutomaticKeepAliveClientMixin {
  final ItemScrollController _controller = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollablePositionedList.separated(
      itemScrollController: _controller,
      itemBuilder: (_, int index) => ListTile(
        leading: SurahIcon(number: QuranStore.settings.juzData[index].index),
        title: Text(QuranStore.settings.juzData[index].localizedName),
        trailing: Text(
          QuranStore.settings.juzData[index].otherName,
          style: QuranStore.settings.juzData[index].otherName ==
                  QuranStore.settings.juzData[index].name
              ? const TextStyle(
                  fontFamily: 'QuranFont',
                  fontSize: 26,
                )
              : null,
        ),
        onTap: () {
          widget.onSelected(
            QuranStore.settings.juzData[index].surahsRange.start,
          );
        },
      ),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: QuranStore.settings.juzData.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
