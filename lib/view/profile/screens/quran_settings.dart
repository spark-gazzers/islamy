import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/store.dart';

class QuranSettingsScreen extends StatefulWidget {
  const QuranSettingsScreen({Key? key}) : super(key: key);

  @override
  State<QuranSettingsScreen> createState() => _QuranSettingsScreenState();
}

class _QuranSettingsScreenState extends State<QuranSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).quran_settings),
        previousPageTitle: S.of(context).profile,
        brightness: Brightness.dark,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              CupertinoFormSection(
                header: Text(S.of(context).quran_editions),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, 'select_text_quran');
                    },
                    title: Text(S.of(context).text_edition),
                    trailing: const Icon(CupertinoIcons.forward),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, 'select_audio_quran');
                    },
                    title: Text(S.of(context).audio_edition),
                    trailing: const Icon(CupertinoIcons.forward),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'select_interpretation_quran',
                      );
                    },
                    title: Text(S.of(context).interpretation_edition),
                    trailing: const Icon(CupertinoIcons.forward),
                  ),
                  GestureDetector(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'select_translation_quran',
                        );
                      },
                      title: Text(S.of(context).translation_edition),
                      trailing: const Icon(CupertinoIcons.forward),
                    ),
                  ),
                  GestureDetector(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'select_transliteration_quran',
                        );
                      },
                      title: Text(S.of(context).transliteration_edition),
                      trailing: const Icon(CupertinoIcons.forward),
                    ),
                  ),
                ],
              ),
              CupertinoFormSection(
                header: Text(S.of(context).quran_reader),
                children: <Widget>[
                  ValueListenableBuilder<dynamic>(
                    valueListenable: Store.shouldReadBasmlaOnSelectionListner,
                    builder: (_, __, ___) {
                      return ListTile(
                        title:
                            Text(S.of(context).should_read_basmla_on_selection),
                        subtitle: Text(
                          S
                              .of(context)
                              // ignore: lines_longer_than_80_chars
                              .note_this_will_not_stop_the_reader_from_reading_the_basmala_on_the_start_of_the_surah,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Store.shouldReadBasmlaOnSelection =
                              !Store.shouldReadBasmlaOnSelection;
                        },
                        trailing: CupertinoSwitch(
                          value: Store.shouldReadBasmlaOnSelection,
                          onChanged: (_) {
                            Store.shouldReadBasmlaOnSelection =
                                !Store.shouldReadBasmlaOnSelection;
                          },
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
