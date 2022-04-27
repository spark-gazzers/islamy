import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/view/common/long_pressed_icon_button.dart';
import 'package:islamy/view/quran/screens/download_surah.dart';
import 'package:islamy/view/quran/screens/quran_features_reader.dart';
import 'package:islamy/view/quran/screens/script_quran.dart';
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
    this.ayah,
  }) : super(key: key);

  final Surah surah;
  final Ayah? ayah;

  @override
  State<QuranSurahReader> createState() => _QuranSurahReaderState();
}

class _QuranSurahReaderState extends State<QuranSurahReader> {
  late bool _isScriptVersion;
  @override
  void initState() {
    _isScriptVersion = true;
    super.initState();
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
              onPressed: () {
                setState(() {
                  _isScriptVersion = !_isScriptVersion;
                });
              },
              icon: Icon(
                _isScriptVersion ? Icons.translate : Iconsax.book_1,
              ),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
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
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        reverseDuration: const Duration(milliseconds: 700),
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        child: _isScriptVersion
            ? ScriptQuranReader(surah: widget.surah)
            : QuranFeaturesReader(surah: widget.surah),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            SharedAxisTransition(
          animation: animation,
          secondaryAnimation: ReverseAnimation(animation),
          transitionType: SharedAxisTransitionType.scaled,
          fillColor: Colors.transparent,
          child: child,
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
    required this.surah,
    this.ayah,
  }) : super(key: key);

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
    _animationController.value =
        QuranPlayerContoller.instance.isPlaying.value ? 1 : 0;
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
              onUpdate: () => QuranStore.settings.quranFontSize -= .5,
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
              onUpdate: () => QuranStore.settings.quranFontSize += .5,
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
