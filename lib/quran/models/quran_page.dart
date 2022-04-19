import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/surah.dart';

class QuranPage {
  const QuranPage(this.pageNumber, this.inlines);

  final List<SurahInline> inlines;
  final int pageNumber;

  @override
  String toString() {
    return 'page $pageNumber  lenght${inlines.length}';
  }

  @override
  bool operator ==(Object other) =>
      other is QuranPage && other.pageNumber == pageNumber;

  static List<QuranPage> formatQuran(List<Surah> surahs) {
    final List<QuranPage> format = <QuranPage>[];
    // ignore: prefer_const_constructors
    QuranPage page = QuranPage(1, <SurahInline>[]);
    SurahInline inline = SurahInline(
      ayahs: <Ayah>[],
      surah: surahs[0],
      start: true,
    );
    for (final Surah surah in surahs) {
      for (final Ayah ayah in surah.ayahs) {
        if (ayah.page == page.pageNumber) {
          // add to the current inline
          inline.ayahs.add(ayah);
        } else {
          // if the inline is no empty complete the inline and the page
          if (inline.ayahs.isNotEmpty) {
            page.inlines.add(inline);
            format.add(page);
            page = QuranPage(ayah.page, <SurahInline>[]);
            inline =
                SurahInline(ayahs: <Ayah>[ayah], surah: surah, start: false);
          } else {
            // if the inline is empty complete start new inline and end the page

            inline.ayahs.add(ayah);
            format.add(page);
            page = QuranPage(ayah.page, <SurahInline>[]);
          }
        }
      }
      // complete the current inline
      page.inlines.add(inline);
      // start a new inline if applicable
      if (surahs.indexOf(surah) != surahs.length - 1) {
        inline = SurahInline(
          ayahs: <Ayah>[],
          surah: surahs[surahs.indexOf(surah) + 1],
          start: true,
        );
      } else {
        format.add(page);
      }
    }

    return format;
  }

  @override
  int get hashCode => pageNumber.hashCode;
}

class SurahInline {
  SurahInline({
    required this.ayahs,
    required this.surah,
    required this.start,
  });

  final List<Ayah> ayahs;
  final Surah surah;
  final bool start;
}
