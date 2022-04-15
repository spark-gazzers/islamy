import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/quran/quran_player_controller.dart';
import 'package:islamy/view/common/surah_icon.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
    final quran = QuranStore.getQuran(QuranStore.settings.defaultTextEdition)!;
    quran.surahs.sort((s1, s2) => s1.number.compareTo(s2.number));
    return quran;
  }

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
      itemBuilder: (context, index) => _SurahListTile(
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
  final Surah surah;
  const _SurahListTile({
    Key? key,
    required this.surah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        TheHolyQuran quran =
            QuranStore.getQuran(QuranStore.settings.defaultAudioEdition)!;
        // start by stopping if it's not for this surah
        if (!QuranPlayerContoller.instance.isForSurah(quran, surah)) {
          await QuranPlayerContoller.instance.stop();
          // if it's downloaed start the preperations
          if (await QuranStore.isSurahDownloaded(
              QuranStore.settings.defaultAudioEdition, surah)) {
            await QuranPlayerContoller.instance.prepareForSurah(quran, surah);
          }
        }
        Navigator.pushNamed(context, 'surah_reader_screen', arguments: {
          'surah': surah,
          'edition': QuranStore.settings.defaultTextEdition,
          'fullscreenDialog': true,
        });
      },
      leading: SurahIcon(
        color: Theme.of(context).primaryColor,
        number: surah.number,
      ),
      title: Text(surah.englishName),
      subtitle: Text(
        surah.revelationType.name +
            ' - ' +
            surah.ayahs.length.toString() +
            ' ' +
            S.of(context).ayah,
      ),
      trailing: Text(
        surah.name.replaceAll('\n', 'replace'),
        softWrap: false,
        locale: const Locale('ar'),
        style: const TextStyle(
          fontFamily: 'QuranFont',
          fontSize: 26.0,
        ),
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
    );
  }
}
