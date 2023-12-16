import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:islamy/engines/hadeeth/hadeeth_manager.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_language.dart';

class HadeethLanguageSelector extends StatelessWidget {
  const HadeethLanguageSelector({
    required this.accept,
    super.key,
    this.selected,
    this.available,
  });
  final HadeethLanguage? selected;
  final List<HadeethLanguage>? available;
  final bool Function(HadeethLanguage selected) accept;

  HadeethLanguage get language => selected ?? HadeethStore.settings.language;
  List<HadeethLanguage> get languages =>
      available ?? HadeethStore.listLanguages();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
      valueListenable: HadeethStore.settings.languageListner,
      builder: (BuildContext context, Object? value, Widget? child) {
        return PopupMenuButton<HadeethLanguage>(
          initialValue: language,
          itemBuilder: (BuildContext context) => HadeethStore.listLanguages()
              .map(
                (HadeethLanguage language) => PopupMenuItem<HadeethLanguage>(
                  value: language,
                  child: createLanguageRow(language),
                ),
              )
              .toList(),
          onSelected: (HadeethLanguage value) {
            if (accept(value)) {
              HadeethStore.settings.language = value;
            }
          },
          child: createLanguageRow(language),
        );
      },
    );
  }

  Row createLanguageRow(HadeethLanguage language) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Builder(
            builder: (BuildContext context) {
              Widget child;
              try {
                child = Flag.fromString(
                  language.code,
                );
              } catch (e) {
                child = const Placeholder();
              }

              return Container(
                height: 25,
                width: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: child,
                ),
              );
            },
          ),
          const SizedBox(
            width: 24,
          ),
          Text('${language.native} (${language.code})'),
        ],
      );
  // TODO: check the appropriate flag when you get back online.
  // Widget flag(HadeethLanguage language) {
  //   switch (language.code) {
  //     case 'ar':

  //     break;
  //     case 'en':
  //     break;
  //     case 'fr':
  //     break;
  //     case 'es':
  //     break;
  //     case 'tr':
  //     break;
  //     case 'ur':
  //     break;
  //     case 'id':
  //     break;
  //     case 'bs':
  //     break;
  //     case 'ru':
  //     break;
  //     case 'bn':
  //     break;
  //     case 'zh':
  //     break;
  //     case 'fa':
  //     break;
  //     case 'tl':
  //     break;
  //     case 'hi':
  //     break;
  //     case 'vi':
  //     break;
  //     case 'si':
  //     break;
  //     case 'ug':
  //     break;
  //     case 'ku':
  //     break;
  //     case 'ha':
  //     break;
  //     case 'pt':
  //     break;
  //     case 'ml':
  //     break;
  //     case 'te':
  //     break;
  //     case 'sw':
  //     break;
  //     case 'ta':
  //     break;
  //     case 'my':
  //     break;
  //     case 'th':
  //     break;
  //     case 'de':
  //     break;
  //     case 'ja':
  //     break;
  //     case 'ps':
  //     break;
  //     case 'as':
  //     break;
  //     case 'sq':
  //     break;
  //     default:
  //   }
  // }
}
