import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/quran_page.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_player_controller.dart';
import 'package:islamy/quran/store/quran_store.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/utils/store.dart';
import 'package:islamy/view/common/ayah_span.dart';
import 'package:islamy/view/quran/screens/download_surah.dart';

class QuranSurahReader extends StatefulWidget {
  final Surah surah;
  final Edition edition;
  final Ayah? ayah;
  const QuranSurahReader({
    Key? key,
    required this.surah,
    required this.edition,
    this.ayah,
  }) : super(key: key);

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
    int start = 0;
    _pageController = PageController(initialPage: start);
    quran = QuranStore.getQuran(widget.edition)!;
    _pages.addAll(quran.pages.sublist(
        widget.surah.ayahs.first.page - 1, widget.surah.ayahs.last.page));
  }

  void _reload() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.name),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBar: SurahAudioPlayer(
        edition: widget.edition,
        surah: widget.surah,
      ),
      body: Directionality(
        textDirection: widget.edition.direction.direction,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          itemBuilder: (context, index) => PageReader(
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

class PageReader extends StatelessWidget {
  final QuranPage page;
  final Surah surah;
  final Edition edition;
  final void Function(Ayah ayah) playCallback;
  const PageReader({
    Key? key,
    required this.page,
    required this.edition,
    required this.playCallback,
    required this.surah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      restorationId: edition.identifier +
          '-' +
          surah.number.toString() +
          '-' +
          page.pageNumber.toString(),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: Store.quranFont,
          fontSize: Store.quranFontSize,
          color: Colors.black,
        ),
        child: Column(
          children: [
            for (var i = 0; i < page.inlines.length; i++)
              SurahInlineReader(
                inline: page.inlines[i],
                edition: edition,
                selected: surah == page.inlines[i].surah,
              ),
          ],
        ),
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      children: [
        if (inline.start) _SurahTitle(surah: inline.surah),
        Text.rich(
          TextSpan(
            children: _buildAyahsSpans,
            locale: Locale(edition.language),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
    if (!selected) {
      child = Opacity(
        opacity: .25,
        child: child,
      );
    }
    return child;
  }

  List<InlineSpan> get _buildAyahsSpans {
    final List<InlineSpan> spans = <InlineSpan>[];
    for (var ayah in inline.ayahs) {
      // if it's basmla remove basmala but the first ayah in Baraa is not a basmala
      if (ayah.numberInSurah == 1 &&
          inline.surah.number != 1 &&
          inline.surah.number != 9) {
        spans.add(AyahSpan(
          ayah: ayah.copyWith(
            text: ayah.text.replaceFirst(
                QuranStore.getQuran(edition)!.surahs.first.ayahs.first.text,
                ''),
          ),
          direction: edition.direction.direction,
        ));
      } else {
        spans.add(AyahSpan(
          ayah: ayah,
          direction: edition.direction.direction,
        ));
      }
    }
    // print('spans length:${spans.length}');
    // print('ayahs length:${inline.ayahs.length}');
    return spans;
  }
}

class _SurahTitle extends StatelessWidget {
  final Surah surah;
  const _SurahTitle({Key? key, required this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 8.0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shadowColor: Colors.white54,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(S.of(context).ayahs_count),
                  Text(
                    surah.ayahs.length.toString(),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  surah.name,
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize:
                            DefaultTextStyle.of(context).style.fontSize! + 4,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(S.of(context).order),
                  Text(
                    surah.number.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahAudioPlayer extends StatefulWidget {
  final Edition edition;
  final Surah surah;
  final Ayah? ayah;
  const SurahAudioPlayer({
    Key? key,
    required this.edition,
    required this.surah,
    this.ayah,
  }) : super(key: key);

  @override
  State<SurahAudioPlayer> createState() => _SurahAudioPlayerState();
}

class _SurahAudioPlayerState extends State<SurahAudioPlayer>
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
      QuranStore.getQuran(QuranStore.settings.defaultAudioEdition)!;
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
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(18),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AudioSlider(),
          IconTheme.merge(
            data: const IconThemeData(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    splashRadius: 145,
                    onPressed: QuranPlayerContoller.instance.skipToPrevious,
                    icon: const Icon(Iconsax.previous5),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: resume,
                      iconSize: 45,
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _animationView,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: QuranPlayerContoller.instance.skipToNext,
                    icon: const Icon(Iconsax.next5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resume() async {
    // if surah not downloaded, download it
    if (!(await QuranStore.isSurahDownloaded(
        QuranStore.settings.defaultAudioEdition, widget.surah))) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => DownloadSurahDialog(
          edition: QuranStore.settings.defaultAudioEdition,
          surah: QuranStore.getQuran(QuranStore.settings.defaultAudioEdition)!
              .surahs
              .singleWhere((element) => element.number == widget.surah.number),
        ),
      ).then((value) {
        if (value != null) resume();
      });
      return;
    }
    // if the player is not for this surah or this edition
    if (!QuranPlayerContoller.instance.isForSurah(audioQuran, widget.surah)) {
      // prepare for this surah first
      await QuranPlayerContoller.instance
          .prepareForSurah(audioQuran, widget.surah);
      // reload the screen for each part to prepare on it's own
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

class AudioSlider extends StatefulWidget {
  const AudioSlider({Key? key}) : super(key: key);

  @override
  State<AudioSlider> createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider> {
  double? _value;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: QuranPlayerContoller.instance.valueStream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        FormattedLengthDuration formatter = Helper.formatters
            .formatLengthDuration(QuranPlayerContoller.instance.duration,
                QuranPlayerContoller.instance.total);
        return Column(
          children: [
            Slider.adaptive(
              value: _value ??
                  snapshot.data ??
                  QuranPlayerContoller.instance.durationValue,
              // snapshot.data ?? controller?.playedPercentage ?? 0.0,
              onChanged: (value) {
                // making the _value not null means it's currently active
                setState(() {
                  _value = value;
                });
              },
              onChangeEnd: (value) {
                QuranPlayerContoller.instance.seekToValue(value);
                setState(() {
                  _value = null;
                });
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              child: DefaultTextStyle.merge(
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatter.start),
                    Text(formatter.end),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
