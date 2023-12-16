import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/engines/quran/models/edition.dart';
import 'package:islamy/engines/quran/models/enums.dart';
import 'package:islamy/engines/quran/quran_manager.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/form_controls.dart';
import 'package:islamy/view/common/ayah_example.dart';
import 'package:islamy/view/common/long_pressed_icon_button.dart';

/// This screen is responsible of changing a all of the preferences of the
/// [QuranPlayerContoller] and the default [Edition] for each [Format].
class QuranSettingsScreen extends StatefulWidget {
  const QuranSettingsScreen({super.key});

  @override
  State<QuranSettingsScreen> createState() => _QuranSettingsScreenState();
}

class _QuranSettingsScreenState extends State<QuranSettingsScreen> {
  bool get shouldAddPopIcon {
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    return route is CupertinoPageRoute && route.fullscreenDialog;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text(S.of(context).quran_settings),
          previousPageTitle: S.of(context).profile,
          brightness: Brightness.dark,
          leading: shouldAddPopIcon
              ? IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              : null),
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
                    title: S.of(context).script_edition,
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
                  ValueListenableBuilder<dynamic>(
                    valueListenable:
                        QuranStore.settings.highlightAyahOnPlayerListner,
                    builder: (_, __, ___) {
                      return ListTile(
                        title: Text(
                          S.of(context).highlight_the_currently_played_ayah,
                        ),
                        subtitle: Text(
                          S
                              .of(context)
                              // ignore: lines_longer_than_80_chars
                              .enabling_this_will_highlight_the_ayah_and_change_the_page_when_the_page_changes,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          QuranStore.settings.highlightAyahOnPlayer =
                              !QuranStore.settings.highlightAyahOnPlayer;
                        },
                        trailing: CupertinoSwitch(
                          value: QuranStore.settings.highlightAyahOnPlayer,
                          onChanged: (_) {
                            QuranStore.settings.highlightAyahOnPlayer =
                                !QuranStore.settings.highlightAyahOnPlayer;
                          },
                        ),
                      );
                    },
                  ),
                  const _FontSizeTile(),
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
    required this.delegate,
    required this.title,
    required this.edition,
  });

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

class _FontSizeTile extends StatefulWidget {
  const _FontSizeTile();

  @override
  State<_FontSizeTile> createState() => __FontSizeTileState();
}

class __FontSizeTileState extends State<_FontSizeTile>
    with FormControls<_FontSizeTile> {
  @override
  void initState() {
    controllers[S.current.quran_font_size]!.text =
        QuranStore.settings.quranFontSize.toString();

    QuranStore.settings.quranRenderSettingListenable.addListener(updateField);
    super.initState();
  }

  @override
  void dispose() {
    QuranStore.settings.quranRenderSettingListenable
        .removeListener(updateField);
    super.dispose();
  }

  void updateField() {
    if (mounted) {
      controllers[S.current.quran_font_size]!.value =
          controllers[S.current.quran_font_size]!
              .value
              .copyWith(text: QuranStore.settings.quranFontSize.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${S.of(context).quran_font_size} :',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Center(
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(45),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              child: SizedBox(
                width: 250,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      autofocus: false,
                      focusNode: nodes[S.current.quran_font_size],
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      controller: controllers[S.of(context).quran_font_size],
                      validator: fontSizeValidator,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlignVertical: TextAlignVertical.bottom,
                      onChanged: (String str) {
                        const List<String> english = <String>[
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '0'
                        ];
                        const List<String> arabic = <String>[
                          '١',
                          '٢',
                          '٣',
                          '٤',
                          '٥',
                          '٦',
                          '٧',
                          '٨',
                          '٩',
                          '٠'
                        ];
                        for (int i = 0; i < arabic.length; i++) {
                          str = str.replaceAll(arabic[i], english[i]);
                        }
                        controllers[S.of(context).quran_font_size]!.value =
                            controllers[S.of(context).quran_font_size]!
                                .value
                                .copyWith(text: str);
                        if (fontSizeValidator(str) == null) {
                          QuranStore.settings.quranFontSize = double.parse(str);
                        }
                      },
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        helperText: S
                            .of(context)
                            // ignore: lines_longer_than_80_chars
                            .this_font_will_be_only_applied_to_script_edition_of_quran,
                        helperMaxLines: 2,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            LongPressedIconButton(
                              icon: Icons.text_decrease,
                              onUpdate: () {
                                nodes[S.current.quran_font_size]!.unfocus();
                                QuranStore.settings.quranFontSize -= .5;
                              },
                            ),
                            const VerticalDivider(),
                          ],
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const VerticalDivider(),
                            LongPressedIconButton(
                              icon: Icons.text_increase,
                              onUpdate: () {
                                QuranStore.settings.quranFontSize += .5;
                                nodes[S.current.quran_font_size]!.unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const AyahExample(),
        ],
      ),
    );
  }
}
