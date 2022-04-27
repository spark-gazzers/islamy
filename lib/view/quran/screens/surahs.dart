import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/view/common/surah_icon.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// A screen that lists all of the quran [Surah] and let the user open
/// and read the [Surah] upon selecting.
class SurahsListScreen extends StatefulWidget {
  const SurahsListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SurahsListScreen> createState() => SurahsListScreenState();
}

class SurahsListScreenState extends State<SurahsListScreen>
    with AutomaticKeepAliveClientMixin {
  final ItemScrollController _controller = ItemScrollController();
  @override
  void initState() {
    super.initState();
  }

  TheHolyQuran get quran {
    final TheHolyQuran quran =
        QuranManager.getQuran(QuranStore.settings.defaultTextEdition);
    quran.surahs.sort((Surah s1, Surah s2) => s1.number.compareTo(s2.number));
    return quran;
  }

  /// Animate the scrollable widget to selected [Surah] index.
  void animateTo(int index) {
    _controller.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollablePositionedList.separated(
      itemScrollController: _controller,
      itemBuilder: (BuildContext context, int index) => _SurahListTile(
        surah: quran.surahs[index],
      ),
      itemCount: quran.surahs.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SurahListTile extends StatelessWidget {
  const _SurahListTile({
    Key? key,
    required this.surah,
  }) : super(key: key);

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final TheHolyQuran quran =
            QuranManager.getQuran(QuranStore.settings.defaultAudioEdition);
        // start by stopping if it's not for this surah
        if (!QuranPlayerContoller.instance.isForSurah(quran, surah)) {
          await QuranPlayerContoller.instance.stop();
          // if it's downloaed start the preperations
          // so the user can read a real durations in the slider.
          if (await QuranManager.isSurahDownloaded(
            QuranStore.settings.defaultAudioEdition,
            surah,
          )) {
            await QuranPlayerContoller.instance.prepareForSurah(quran, surah);
          }
        }
        // ignoring cause reading surah directory/preperations are almost sync ops.
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(
          context,
          'surah_reader_screen',
          arguments: <String, dynamic>{
            'surah': surah,
            'fullscreenDialog': true,
          },
        );
      },
      leading: IslamicStarIcon(
        color: Theme.of(context).primaryColor,
        number: surah.number,
      ),
      title: Text(surah.englishName),
      subtitle: Text(
        '${surah.revelationType.name} '
        '-'
        ' ${surah.ayahs.length} ${S.of(context).ayah}',
      ),
      trailing: Text(
        surah.name.replaceAll('\n', 'replace'),
        softWrap: false,
        locale: const Locale('ar'),
        style: const TextStyle(
          fontFamily: 'QuranFont',
          fontSize: 26,
        ),
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
    );
  }
}
