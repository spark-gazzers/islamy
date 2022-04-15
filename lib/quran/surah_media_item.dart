import 'package:audio_service/audio_service.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';

class SurahMediaItem extends MediaItem {
  final TheHolyQuran quran;
  final Surah surah;
  SurahMediaItem({
    required this.quran,
    required this.surah,
    required Duration? duration,
  }) : super(
            id: idOd(quran, surah),
            title: surah.localizedName,
            album: quran.edition.localizedName,
            artist: S.current.app_name,
            playable: true,
            rating: const Rating.newHeartRating(true),
            genre: S.current.the_holly_quran,
            artUri: QuranManager.artWork.absolute.uri,
            duration: duration,
            extras: {
              S.current.number_in_quran: surah.number,
              S.current.juz: QuranStore.settings.juzData
                  .firstWhere((element) => element.containsSurah(surah.number))
                  .index,
            });

  factory SurahMediaItem.fromMedia(MediaItem item) {
    if (item is SurahMediaItem) {
      return item;
    }
    String identifier = item.id.split('#')[0];
    int surahNumber = int.parse(item.id.split('#')[1]);
    TheHolyQuran quran = QuranStore.getQuran(QuranStore.listEditions()
        .singleWhere((element) => element.identifier == identifier))!;

    return SurahMediaItem(
      quran: quran,
      surah:
          quran.surahs.singleWhere((element) => element.number == surahNumber),
      duration: item.duration,
    );
  }

  static String idOd(
    TheHolyQuran quran,
    Surah surah,
  ) =>
      quran.edition.identifier + '#' + surah.number.toString();

  static TheHolyQuran quranFromID(String id) =>
      QuranStore.getQuran(QuranStore.listEditions().singleWhere(
          (element) => element.identifier == id.split('#').first))!;
  static Surah surahFromID(String id) => quranFromID(id).surahs.singleWhere(
        (element) => element.number == int.parse(id.split('#')[1]),
      );
}
