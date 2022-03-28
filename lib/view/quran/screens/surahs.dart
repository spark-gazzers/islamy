import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/text_quran.dart';
import 'package:islamy/quran/store/quran_store.dart';
import 'package:islamy/view/common/surah_icon.dart';

class SurahsListScreen extends StatelessWidget {
  const SurahsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TheHolyQuran quran =
        QuranStore.getQuran(QuranStore.settings.defaultTextEdition)!;
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) =>
          _SurahListTile(surah: quran.surahs[index]),
      itemCount: quran.surahs.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class _SurahListTile extends StatelessWidget {
  final Surah surah;
  const _SurahListTile({
    Key? key,
    required this.surah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IntrinsicWidth(
          child: ListTile(
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
          ),
        ),
        Expanded(
          child: Text(
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
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }
}
