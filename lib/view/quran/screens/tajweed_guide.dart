import 'package:flutter/material.dart';
import 'package:islamy/engines/quran/models/surah.dart';
import 'package:islamy/engines/quran/quran_manager.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/view/common/ayah_span.dart';

class TajweedGuide extends StatelessWidget {
  const TajweedGuide({super.key});
  Surah get surah =>
      QuranManager.getQuran(QuranStore.settings.defaultTextEdition).surahs[23];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    S.of(context).tajweed_guide,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
                const Divider(),
                Text.rich(
                  AyahSpan(
                    ayah: surah.ayahs[34],
                    includeNumber: false,
                  ),
                  locale: const Locale('ar'),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: DefaultTextStyle.merge(
                    style: Theme.of(context).textTheme.titleMedium,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan(text: '${S.of(context).surah} : '),
                              TextSpan(
                                text: surah.localizedName,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan(text: '${S.of(context).ayah} :'),
                              TextSpan(
                                text: '35',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Text(
                  S.of(context).tajweed_rules,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const _TajweedRules(),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(S.of(context).done),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }
}

class _TajweedRules extends StatelessWidget {
  const _TajweedRules();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(.8),
        1: FlexColumnWidth(.3),
      },
      border: TableBorder.all(
        color: Theme.of(context).dividerColor,
      ),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Text(
                S.of(context).rule_name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Text(
                S.of(context).rule_color,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        for (final TajweedRule rule in TajweedRule.rules)
          TableRow(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: Text(
                  Helper.translator.getString(rule.nameIdentifier),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: rule.color,
                  ),
                ),
              )
            ],
          ),
      ],
    );
  }
}
