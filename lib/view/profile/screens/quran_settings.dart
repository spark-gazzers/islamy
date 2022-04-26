import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/quran_manager.dart';

/// This screen is responsible of changing a all of the preferences of the
/// [QuranPlayerContoller] and the default [Edition] for each [Format].
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
                  _SelectEditionTile(
                    delegate: 'select_text_quran',
                    title: S.of(context).text_edition,
                    edition: () => QuranStore.settings.defaultTextEdition,
                  ),
                  _SelectEditionTile(
                    delegate: 'select_audio_quran',
                    title: S.of(context).audio_edition,
                    edition: () => QuranStore.settings.defaultAudioEdition,
                  ),
                  _SelectEditionTile(
                    delegate: 'select_interpretation_quran',
                    title: S.of(context).interpretation_edition,
                    edition: () =>
                        QuranStore.settings.defaultInterpretationEdition,
                  ),
                  _SelectEditionTile(
                    delegate: 'select_translation_quran',
                    title: S.of(context).translation_edition,
                    edition: () =>
                        QuranStore.settings.defaultTranslationEdition,
                  ),
                  _SelectEditionTile(
                    delegate: 'select_transliteration_quran',
                    title: S.of(context).transliteration_edition,
                    edition: () =>
                        QuranStore.settings.defaultTransliterationEdition,
                  ),
                ],
              ),
              CupertinoFormSection(
                header: Text(S.of(context).quran_reader),
                children: <Widget>[
                  ValueListenableBuilder<dynamic>(
                    valueListenable:
                        QuranStore.settings.shouldReadBasmlaOnSelectionListner,
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
                          QuranStore.settings.shouldReadBasmlaOnSelection =
                              !QuranStore.settings.shouldReadBasmlaOnSelection;
                        },
                        trailing: CupertinoSwitch(
                          value:
                              QuranStore.settings.shouldReadBasmlaOnSelection,
                          onChanged: (_) {
                            QuranStore.settings.shouldReadBasmlaOnSelection =
                                !QuranStore
                                    .settings.shouldReadBasmlaOnSelection;
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

class _SelectEditionTile extends StatefulWidget {
  const _SelectEditionTile({
    Key? key,
    required this.delegate,
    required this.title,
    required this.edition,
  }) : super(key: key);

  final Edition? Function() edition;
  final String delegate;
  final String title;

  @override
  State<_SelectEditionTile> createState() => _SelectEditionTileState();
}

class _SelectEditionTileState extends State<_SelectEditionTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(widget.title),
          if (widget.edition() == null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: Chip(
                label: Text(S.of(context).disabled),
                padding: EdgeInsets.zero,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
            )
        ],
      ),
      trailing: const Icon(CupertinoIcons.forward),
      onTap: () async {
        await Navigator.pushNamed(context, widget.delegate);
        setState(() {});
      },
    );
  }
}
