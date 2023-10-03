import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/view/common/ayah_span.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Reader for [QuranContentType.tafsir],[QuranContentType.translation]
/// and [QuranContentType.transliteration] if the edition type is enabled.
class QuranFeaturesReader extends StatefulWidget {
  const QuranFeaturesReader({required this.surah, super.key});

  final Surah surah;
  @override
  State<QuranFeaturesReader> createState() => _QuranFeaturesReaderState();
}

class _QuranFeaturesReaderState extends State<QuranFeaturesReader> {
  final ItemScrollController _controller = ItemScrollController();

  @override
  void didUpdateWidget(covariant QuranFeaturesReader oldWidget) {
    QuranPlayerContoller.instance.currentAyah?.removeListener(_goToAyah);
    QuranPlayerContoller.instance.currentAyah?.addListener(_goToAyah);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    QuranPlayerContoller.instance.currentAyah?.addListener(_goToAyah);
    super.dispose();
  }

  void _goToAyah() {
    if (QuranPlayerContoller.instance.currentAyah != null && mounted) {
      _controller.scrollTo(
        index: QuranPlayerContoller.instance.currentAyah!.value - 1,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      itemScrollController: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (BuildContext context, int index) => AyahListTile(
        ayah: widget.surah.ayahs[index],
        surah: widget.surah,
      ),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: widget.surah.ayahs.length,
    );
  }
}

class AyahListTile extends StatelessWidget {
  const AyahListTile({
    required this.ayah,
    required this.surah,
    super.key,
  });
  final Ayah ayah;
  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      builder: (BuildContext context, int value, Widget? child) => DecoratedBox(
        decoration: BoxDecoration(
          color: value == ayah.number
              ? Theme.of(context).colorScheme.secondaryContainer
              : Colors.transparent,
        ),
        child: child,
      ),
      valueListenable:
          QuranPlayerContoller.instance.currentAyah ?? ValueNotifier<int>(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Directionality(
            textDirection:
                QuranStore.settings.defaultTextEdition.direction.direction,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ValueListenableBuilder<dynamic>(
                    valueListenable:
                        QuranStore.settings.quranRenderSettingListenable,
                    builder: (BuildContext context, _, Widget? child) =>
                        Text.rich(
                      AyahSpan(ayah: ayah),
                      textDirection: QuranStore
                          .settings.defaultTextEdition.direction.direction,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._viewFor(
            QuranStore.settings.defaultInterpretationEdition,
            S.of(context).interpretation,
          ),
          ..._viewFor(
            QuranStore.settings.defaultTranslationEdition,
            S.of(context).translation,
          ),
          ..._viewFor(
            QuranStore.settings.defaultTransliterationEdition,
            S.of(context).transliteration,
          ),
        ],
      ),
    );
  }

  List<Widget> _viewFor(Edition? edition, String title) => <Widget>[
        if (edition != null)
          _AyahEditionView(
            ayah: ayah,
            surah: surah,
            edition: edition,
            title: title,
          ),
      ];
}

class _AyahEditionView extends StatefulWidget {
  const _AyahEditionView({
    required this.ayah,
    required this.surah,
    required this.edition,
    required this.title,
  });
  final Ayah ayah;
  final Edition edition;
  final String title;
  final Surah surah;

  @override
  State<_AyahEditionView> createState() => _AyahEditionViewState();
}

class _AyahEditionViewState extends State<_AyahEditionView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animationView;
  late final ScrollNotificationObserverState _observer;
  bool _lazyInited = false;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..value = 0;
    _animationView =
        CurvedAnimation(parent: _animationController, curve: Curves.ease);

    super.initState();
  }

  String get ayah {
    final TheHolyQuran quran = QuranManager.getQuran(widget.edition);
    final Surah surah = quran.surahs
        .singleWhere((Surah element) => element.number == widget.surah.number);
    return surah.ayahs
        .singleWhere((Ayah element) => element.number == widget.ayah.number)
        .text;
  }

  void _onDrag(ScrollNotification notification) {
    _animationController.reverse();
  }

  void _lazyInit() {
    if (!_lazyInited) {
      _lazyInited = true;
      _observer = ScrollNotificationObserver.of(context)..addListener(_onDrag);
    }
  }

  @override
  void dispose() {
    _observer.removeListener(_onDrag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _lazyInit();
    return AnimatedBuilder(
      animation: _animationView,
      builder: (_, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                switch (_animationController.status) {
                  case AnimationStatus.dismissed:
                  case AnimationStatus.reverse:
                    _animationController.forward();
                    break;
                  case AnimationStatus.forward:
                  case AnimationStatus.completed:
                    _animationController.reverse();
                    break;
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection: widget.edition.direction.direction,
              child: ClipRect(
                child: Align(
                  heightFactor: _animationView.value,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          ayah,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
