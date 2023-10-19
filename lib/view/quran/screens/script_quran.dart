import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/quran_page.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/view/common/ayah_span.dart';

/// A widget that should render the [QuranPage] as it is in the original quran.
class ScriptQuranReader extends StatefulWidget {
  const ScriptQuranReader({required this.surah, super.key});
  final Surah surah;
  @override
  State<ScriptQuranReader> createState() => _ScriptQuranReaderState();
}

class _ScriptQuranReaderState extends State<ScriptQuranReader> {
  late final PageController _pageController;
  @override
  void initState() {
    // TODO(psyonixFx): should support from bookmark later
    const int start = 0;
    _pageController = PageController(initialPage: start);
    super.initState();
  }

  List<QuranPage> get _pages =>
      QuranManager.getQuran(QuranStore.settings.defaultTextEdition)
          .pages
          .sublist(
            widget.surah.ayahs.first.page - 1,
            widget.surah.ayahs.last.page,
          );
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: QuranStore.settings.defaultTextEdition.direction.direction,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) => ScriptPageReader(
          page: _pages[index],
          surah: widget.surah,
          playCallback: (_) {},
        ),
      ),
    );
  }
}

class ScriptPageReader extends StatelessWidget {
  const ScriptPageReader({
    required this.page,
    required this.playCallback,
    required this.surah,
    super.key,
  });

  final QuranPage page;
  final Surah surah;
  final void Function(Ayah ayah) playCallback;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      physics: const AlwaysScrollableScrollPhysics(),
      child: ValueListenableBuilder<dynamic>(
        valueListenable: QuranStore.settings.quranRenderSettingListenable,
        builder: (_, __, ___) {
          return DefaultTextStyle(
            style: TextStyle(
              fontFamily: QuranStore.settings.quranFont,
              fontSize: QuranStore.settings.quranFontSize,
              color: Colors.black,
            ),
            child: Column(
              children: <Widget>[
                for (int i = 0; i < page.inlines.length; i++)
                  SurahInlineReader(
                    inline: page.inlines[i],
                    selected: surah == page.inlines[i].surah,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// This widget divides the UI into widget for every inline, part for the surah
/// header if applicaple and a part for the [SurahInline.ayahs].
class SurahInlineReader extends StatelessWidget {
  const SurahInlineReader({
    required this.inline,
    required this.selected,
    super.key,
  });

  final SurahInline inline;
  final bool selected;

  int get currentIndex =>
      isListenable ? QuranPlayerContoller.instance.currentAyah!.value : 0;
  TheHolyQuran get quran =>
      QuranManager.getQuran(QuranStore.settings.defaultAudioEdition);
  bool get isListenable {
    return QuranPlayerContoller.instance.isForSurah(quran, inline.surah) &&
        QuranPlayerContoller.instance.currentAyah != null;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isListenable) {
      final ValueNotifier<int> listenable =
          QuranPlayerContoller.instance.currentAyah!;
      child = ValueListenableBuilder<int>(
        // why using the notifier as key? flutter doesn't provide a way to
        // obtain the state of the [ValueNotifier<T>] yet! And when
        // the [State.didUpdateWidget] starts on the [ValueNotifier<int>] state
        // it automatically removes the listener which will throw
        // an assertaion error.
        key: ValueKey<ValueNotifier<int>>(listenable),
        valueListenable: listenable,
        builder: (BuildContext context, int value, Widget? child) =>
            childrenBuilder(context),
      );
    } else {
      child = childrenBuilder(context);
    }
    if (!selected) {
      child = Opacity(
        opacity: .25,
        child: child,
      );
    }
    return child;
  }

  Widget childrenBuilder(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (inline.start)
            _SurahTitle(
              surah: inline.surah,
              selected:
                  // if the current ayah equals 0
                  currentIndex == 0
                      // and the highlight option is enabled
                      &&
                      QuranStore.settings.highlightAyahOnPlayer
                      // and this is the selected surah
                      &&
                      selected,
            ),
          Text.rich(
            TextSpan(
              children: _buildAyahsSpans(context),
              locale: Locale(QuranStore.settings.defaultTextEdition.language),
            ),
            textAlign: TextAlign.center,
          )
        ],
      );

  List<InlineSpan> _buildAyahsSpans(BuildContext context) {
    final List<InlineSpan> spans = <InlineSpan>[];
    for (final Ayah ayah in inline.ayahs) {
      final bool isSelected = isListenable &&
          ayah.numberInSurah == currentIndex &&
          QuranStore.settings.highlightAyahOnPlayer &&
          selected;
      // ignore: prefer_function_declarations_over_variables
      final VoidCallback onTap = () async {
        if (!isListenable || !selected) return;
        await QuranPlayerContoller.instance.playFromAyah(ayah);
      };
      // ignore: prefer_function_declarations_over_variables
      final VoidCallback? onLongTap =
          selected ? () => _openContextMenue(context, ayah) : null;
      // if it's basmla remove basmala but the first
      // ayah in Baraa is not a basmala
      if (ayah.numberInSurah == 1 &&
          inline.surah.number != 1 &&
          inline.surah.number != 9) {
        spans.add(
          AyahSpan(
            isSelected: isSelected,
            // TODO: Find a way OUT of the span to add long tap event.
            // onLongTap: onLongTap,
            onTap: onTap,
            ayah: ayah.copyWith(
              text: ayah.text.replaceFirst(
                QuranManager.getQuran(QuranStore.settings.defaultTextEdition)
                    .surahs
                    .first
                    .ayahs
                    .first
                    .text,
                '',
              ),
            ),
          ),
        );
      } else {
        spans.add(
          AyahSpan(
            ayah: ayah,
            isSelected: isSelected,
            // TODO: Find a way OUT of the span to add long tap event.
            // onLongTap: onLongTap,
            onTap: onTap,
          ),
        );
      }
    }
    return spans;
  }

  void _openContextMenue(BuildContext context, Ayah ayah) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text.rich(
          AyahSpan(
            ayah: ayah,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: QuranStore.settings.quranFont,
            fontSize: QuranStore.settings.quranFontSize,
          ),
        ),
        actions: <Widget>[
          // TODO(psyonixFx): add the actual actions
          CupertinoActionSheetAction(
            onPressed: () {},
            child: const Text('data'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: Text(S.of(context).cancel),
        ),
      ),
    );
  }
}

class _SurahTitle extends StatelessWidget {
  const _SurahTitle({
    required this.surah,
    required this.selected,
  });

  final Surah surah;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 4 + (selected ? 4 : 0),
      color: selected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.primaryContainer,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 15,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Builder(
                  builder: (BuildContext context) {
                    return Material(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      color: Colors.transparent,
                      elevation: 0,
                      child: DefaultTextStyle.merge(
                        style: DefaultTextStyle.of(context).style,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(S.of(context).count),
                            Text(
                              surah.ayahs.length.toString(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: Card(
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  elevation: 0,
                  child: Center(
                    child: Text(
                      surah.name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize:
                                DefaultTextStyle.of(context).style.fontSize! +
                                    4,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Builder(
                  builder: (BuildContext context) {
                    return Material(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      color: Colors.transparent,
                      elevation: 0,
                      child: DefaultTextStyle.merge(
                        style: DefaultTextStyle.of(context).style,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(S.of(context).order),
                            Text(
                              surah.number.toString(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
