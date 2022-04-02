import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/surah.dart';

class QuranPage {
  final List<SurahInline> inlines;
  final int pageNumber;
  const QuranPage(this.pageNumber, this.inlines);

  @override
  String toString() {
    return 'page $pageNumber  lenght${inlines.length}';
  }

  @override
  operator ==(Object other) =>
      other is QuranPage && other.pageNumber == pageNumber;

  static List<QuranPage> formatQuran(List<Surah> surahs) {
    List<QuranPage> format = [];
    // ignore: prefer_const_constructors
    QuranPage page = QuranPage(1, []);
    SurahInline inline = SurahInline(ayahs: [], surah: surahs[0], start: true);
    for (Surah surah in surahs) {
      for (Ayah ayah in surah.ayahs) {
        if (ayah.page == page.pageNumber) {
          // add to the current inline
          inline.ayahs.add(ayah);
        } else {
          // if the inline is no empty complete the inline and the page
          if (inline.ayahs.isNotEmpty) {
            page.inlines.add(inline);
            format.add(page);
            page = QuranPage(ayah.page, []);
            inline = SurahInline(ayahs: [ayah], surah: surah, start: false);
          } else {
            // if the inline is empty complete start new inline and end the page

            inline.ayahs.add(ayah);
            format.add(page);
            page = QuranPage(ayah.page, []);
          }
        }
      }
      // complete the current inline
      page.inlines.add(inline);
      // start a new inline if applicable
      if (surahs.indexOf(surah) != surahs.length - 1) {
        inline = SurahInline(
            ayahs: [], surah: surahs[surahs.indexOf(surah) + 1], start: true);
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
  final List<Ayah> ayahs;
  final Surah surah;
  final bool start;

  SurahInline({
    required this.ayahs,
    required this.surah,
    required this.start,
  });
}
