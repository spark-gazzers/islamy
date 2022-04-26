import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/quran_page.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/utils/store.dart';
import 'package:islamy/view/common/ayah_span.dart';
import 'package:islamy/view/quran/screens/download_surah.dart';
import 'package:sliver_bottom_bar/sliver_bottom_bar.dart';

/// The main quran reader screen.
///
/// This screen should contain sections for all enabled [Format] and
/// it's selected [Edition] with it's respective features and an audio players
/// controller that would ask the user to download the [Surah]
/// if it's not downloaded yet .
class QuranSurahReader extends StatefulWidget {
  const QuranSurahReader({
    Key? key,
    required this.surah,
    required this.edition,
    this.ayah,
  }) : super(key: key);

  final Surah surah;
  final Edition edition;
  final Ayah? ayah;

  @override
  State<QuranSurahReader> createState() => _QuranSurahReaderState();
}

class _QuranSurahReaderState extends State<QuranSurahReader> {
  late final PageController _pageController;
  late final TheHolyQuran quran;
  final List<QuranPage> _pages = <QuranPage>[];
  @override
  void initState() {
    super.initState();
    // TODO(psyonixFx): should support from bookmark later
    const int start = 0;
    _pageController = PageController(initialPage: start);
    quran = QuranManager.getQuran(widget.edition);
    _pages.addAll(
      quran.pages.sublist(
        widget.surah.ayahs.first.page - 1,
        widget.surah.ayahs.last.page,
      ),
    );
  }

  void _reload() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SurahAudioPlayer(
        edition: widget.edition,
        surah: widget.surah,
      ),
      appBar: CupertinoNavigationBar(
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                final Edition text = QuranStore.settings.defaultTextEdition;
                final Edition audio = QuranStore.settings.defaultAudioEdition;
                final NavigatorState navigator = Navigator.of(context);
                await Navigator.pushNamed(
                  context,
                  'quran_settings',
                  arguments: <String, dynamic>{
                    'fullscreenDialog': true,
                  },
                );
                if (text != QuranStore.settings.defaultTextEdition ||
                    audio != QuranStore.settings.defaultAudioEdition) {
                  navigator
                    ..pop()
                    ..pushNamed(
                      'surah_reader_screen',
                      arguments: <String, dynamic>{
                        'surah': widget.surah,
                        'edition': QuranStore.settings.defaultTextEdition,
                        'fullscreenDialog': true,
                      },
                    );
                }
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Directionality(
        textDirection: widget.edition.direction.direction,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int index) => PageReader(
            page: _pages[index],
            surah: widget.surah,
            edition: widget.edition,
            playCallback: (_) {},
          ),
        ),
      ),
    );
  }
}

/// A widget that should render the [QuranPage] as it is in the original quran.
class PageReader extends StatelessWidget {
  const PageReader({
    Key? key,
    required this.page,
    required this.edition,
    required this.playCallback,
    required this.surah,
  }) : super(key: key);

  final QuranPage page;
  final Surah surah;
  final Edition edition;
  final void Function(Ayah ayah) playCallback;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      physics: const AlwaysScrollableScrollPhysics(),
      restorationId: '${edition.identifier}-${surah.number}-${page.pageNumber}',
      child: ValueListenableBuilder<dynamic>(
        valueListenable: Store.quranRenderSettingListenable,
        builder: (_, __, ___) {
          return DefaultTextStyle(
            style: TextStyle(
              fontFamily: Store.quranFont,
              fontSize: Store.quranFontSize,
              color: Colors.black,
            ),
            child: Column(
              children: <Widget>[
                for (int i = 0; i < page.inlines.length; i++)
                  SurahInlineReader(
                    inline: page.inlines[i],
                    edition: edition,
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
    Key? key,
    required this.inline,
    required this.edition,
    required this.selected,
  }) : super(key: key);

  final SurahInline inline;
  final Edition edition;
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
                      Store.highlightAyahOnPlayer
                      // and this is the selected surah
                      &&
                      selected,
            ),
          Text.rich(
            TextSpan(
              children: _buildAyahsSpans(context),
              locale: Locale(edition.language),
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
          Store.highlightAyahOnPlayer &&
          selected;
      // ignore: prefer_function_declarations_over_variables
      final VoidCallback onTap = () async {
        if (!isListenable || selected) return;
        await QuranPlayerContoller.instance.seekToAyah(ayah);
        QuranPlayerContoller.instance.play();
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
            onLongTap: onLongTap,
            onTap: onTap,
            ayah: ayah.copyWith(
              text: ayah.text.replaceFirst(
                QuranManager.getQuran(edition).surahs.first.ayahs.first.text,
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
            onLongTap: onLongTap,
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
            fontFamily: Store.quranFont,
            fontSize: Store.quranFontSize,
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
    Key? key,
    required this.surah,
    required this.selected,
  }) : super(key: key);

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

/// This part of the UI is the responsible controlling the played audio
/// and notifying the screen if the [QuranPlayerContoller] surah is changed.
class SurahAudioPlayer extends StatelessWidget {
  const SurahAudioPlayer({
    Key? key,
    required this.edition,
    required this.surah,
    this.ayah,
  }) : super(key: key);

  final Edition edition;
  final Surah surah;
  final Ayah? ayah;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: AbstractSliverBottomBar(
        startsExpanded: true,
        snap: true,
        mainBody: (BuildContext context, Animation<double> animation) =>
            _AudioSlider(
          surah: surah,
          transitionAnimation: animation,
        ),
        afterBody: (BuildContext context, Animation<double> animation) =>
            _BottomActionsBars(
          surah: surah,
          scrollAnimation: animation,
        ),
      ),
    );
  }
}

class _AudioSlider extends StatefulWidget {
  const _AudioSlider({
    Key? key,
    required this.surah,
    required this.transitionAnimation,
  }) : super(key: key);
  final Animation<double> transitionAnimation;
  final Surah surah;
  @override
  State<_AudioSlider> createState() => _AudioSliderState();
}

class _AudioSliderState extends State<_AudioSlider> {
  double? _dragValue;
  bool get isForThisSurah {
    final TheHolyQuran quran =
        QuranManager.getQuran(QuranStore.settings.defaultAudioEdition);
    return QuranPlayerContoller.instance.isForSurah(quran, widget.surah);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      child: StreamBuilder<double>(
        stream:
            isForThisSurah ? QuranPlayerContoller.instance.valueStream : null,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          final double position = _dragValue ??
              snapshot.data ??
              (isForThisSurah
                  ? QuranPlayerContoller.instance.durationValue
                  : 0.0);
          final FormattedLengthDuration formatter =
              Helper.formatters.formatLengthDuration(
            isForThisSurah
                ? QuranPlayerContoller.instance.duration
                : Duration.zero,
            isForThisSurah
                ? QuranPlayerContoller.instance.total
                : Duration.zero,
          );
          return AnimatedBuilder(
            animation: widget.transitionAnimation,
            builder: (BuildContext context, Widget? child) {
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (isForThisSurah)
                        _ClippedText(
                          label: formatter.start,
                          value: widget.transitionAnimation.value,
                        ),
                      Expanded(
                        child: Slider.adaptive(
                          value: position,
                          onChanged: (double value) {
                            // making the _value not null means
                            // it's currently active
                            setState(() {
                              _dragValue = value;
                              QuranPlayerContoller.instance
                                  .fakePositionFromValue(_dragValue);
                            });
                          },
                          onChangeEnd: (double value) {
                            QuranPlayerContoller.instance.seekToValue(value);
                            setState(() {
                              _dragValue = null;
                              QuranPlayerContoller.instance
                                  .fakePositionFromValue(_dragValue);
                            });
                          },
                        ),
                      ),
                      if (isForThisSurah)
                        _ClippedText(
                          label: formatter.end,
                          value: widget.transitionAnimation.value,
                        ),
                    ],
                  ),
                  if (isForThisSurah)
                    ClipRect(
                      child: Align(
                        heightFactor: 1 - widget.transitionAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(formatter.start),
                              Text(formatter.end),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ClippedText extends StatelessWidget {
  const _ClippedText({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);
  final double value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        widthFactor: value,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(label),
        ),
      ),
    );
  }
}

class _BottomActionsBars extends StatefulWidget {
  const _BottomActionsBars({
    Key? key,
    required this.surah,
    required this.scrollAnimation,
  }) : super(key: key);
  final Surah surah;
  final Animation<double> scrollAnimation;
  @override
  State<_BottomActionsBars> createState() => _BottomActionsBarsState();
}

class _BottomActionsBarsState extends State<_BottomActionsBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animationView;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationView = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
    if (QuranPlayerContoller.instance.isForSurah(audioQuran, widget.surah)) {
      _listenToPlayer();
    }
  }

  TheHolyQuran get audioQuran =>
      QuranManager.getQuran(QuranStore.settings.defaultAudioEdition);
  void _listenToPlayer() {
    QuranPlayerContoller.instance.isPlaying.addListener(() {
      if (mounted) {
        if (QuranPlayerContoller.instance.isPlaying.value) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: const IconThemeData(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width *
              .1 *
              widget.scrollAnimation.value,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            LongPressedIconButton(
              onUpdate: () {
                if (Store.quranFontSize > 15) Store.quranFontSize -= .5;
              },
              icon: Icons.text_decrease,
            ),
            IconButton(
              splashRadius: 150,
              onPressed: QuranPlayerContoller.instance.skipToPrevious,
              icon: const Icon(Iconsax.previous5),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                splashRadius: 150,
                onPressed: _resume,
                iconSize: 45,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _animationView,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
              ),
            ),
            IconButton(
              splashRadius: 150,
              onPressed: QuranPlayerContoller.instance.skipToNext,
              icon: const Icon(Iconsax.next5),
            ),
            LongPressedIconButton(
              icon: Icons.text_increase,
              onUpdate: () {
                if (Store.quranFontSize < 40) Store.quranFontSize += .5;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resume() async {
    // if surah not downloaded, download it
    if (!(await QuranManager.isSurahDownloaded(
      audioQuran.edition,
      widget.surah,
    ))) {
      showCupertinoModalPopup<Edition>(
        context: context,
        builder: (_) => DownloadSurahDialog(
          edition: audioQuran.edition,
          surah: audioQuran.surahs.singleWhere(
            (Surah element) => element.number == widget.surah.number,
          ),
        ),
      ).then((Edition? value) {
        if (value != null) _resume();
      });
      return;
    }
    // if the player is not for this surah or this edition
    if (!QuranPlayerContoller.instance.isForSurah(audioQuran, widget.surah)) {
      // prepare for this surah first
      await QuranPlayerContoller.instance
          .prepareForSurah(audioQuran, widget.surah);
      // reload the screen for each part to prepare on it's own
      // or finishing up if the screen is off loaded
      if (!mounted) return;
      context.findAncestorStateOfType<_QuranSurahReaderState>()!._reload();
      // this widget preparing
      _listenToPlayer();
    }
    // reverse action play if it's not and pause if playing
    if (!QuranPlayerContoller.instance.isPlaying.value) {
      QuranPlayerContoller.instance.play();
    } else {
      QuranPlayerContoller.instance.pause();
    }
  }
}

class LongPressedIconButton extends StatefulWidget {
  const LongPressedIconButton({
    Key? key,
    required this.icon,
    required this.onUpdate,
  }) : super(key: key);
  final IconData icon;
  final VoidCallback onUpdate;

  @override
  State<LongPressedIconButton> createState() => _LongPressedIconButtonState();
}

class _LongPressedIconButtonState extends State<LongPressedIconButton> {
  static const Duration _startingSpacer = Duration(milliseconds: 300);
  bool _isDown = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        onLongPress: () {
          Duration spacer = _startingSpacer;
          _isDown = true;
          Future.doWhile(() async {
            await Future<void>.delayed(spacer);
            if (spacer.inMilliseconds > 100) {
              spacer =
                  Duration(microseconds: (spacer.inMicroseconds * .9).toInt());
            }
            widget.onUpdate();
            return _isDown;
          });
        },
        onLongPressEnd: (_) {
          _isDown = false;
        },
        onTap: widget.onUpdate,
        child: Icon(widget.icon),
      ),
    );
  }
}
