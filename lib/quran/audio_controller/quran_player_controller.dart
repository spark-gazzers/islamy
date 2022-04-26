part of quran;

/// The main audio player class with ability to control native audio services
///
/// to use this class you must always use the [QuranPlayerContoller.instance]
/// then call [prepareForSurah] on it before starting anything else.
class QuranPlayerContoller extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  /// This constuctor must only be called once and that should
  /// be in the init project
  QuranPlayerContoller._() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  /// The static instance to access the player
  static late final QuranPlayerContoller instance;

  ///Returns the length of the provided audio file
  static Future<Duration> lengthOf(String path) async =>
      (await _lengthCalculator.setFilePath(path))!;

  ///The underlaying audio player
  final AudioPlayer _player = AudioPlayer();

  /// This player should never play instead only be used
  /// to calculate audio length
  static final AudioPlayer _lengthCalculator = AudioPlayer();

  ///The current [Surah]'s ayahs positions in duration
  final List<MapEntry<int, Duration>> _positions = <MapEntry<int, Duration>>[];

  ///The current player [TheHolyQuran]
  TheHolyQuran? _quran;

  ///The current player [Surah]
  Surah? _surah;

  /// The current ayah notifier
  ValueNotifier<int>? _currentAyah;

  ValueNotifier<bool>? _isPlaying;

  /// Easy access Notifier to tell wether the player i currently playing or not
  ///
  ///
  /// Will throw [TypeError] for casting [Null]
  /// if [prepareForSurah] is not called yet
  ValueNotifier<bool> get isPlaying => _isPlaying!;

  /// The current playing ayah number.
  ///
  ///
  ///
  /// Note if this [ValueNotifier.value] points to 0 then this means
  /// it's on the basmala part
  ///
  /// Will be null if not prepared for a surah yet
  ValueNotifier<int>? get currentAyah => _currentAyah;

  /// The current position of the player.
  Duration get duration => _player.position;

  /// The current position of the player as value from 0 .. 1.0.
  double get durationValue {
    if (total != Duration.zero) {
      return _player.position.inMicroseconds.toDouble() /
          total.inMicroseconds.toDouble();
    } else {
      return 0;
    }
  }

  ///The value stream of the current played duration in 0.0 to 1.0 value
  Stream<double>? _valueStream;

  ///The value stream of the current played duration in 0.0 to 1.0 value
  Stream<double>? get valueStream => _valueStream;

  /// The init method which should be only called once during the app startup
  static Future<void> init() async {
    instance = await AudioService.init<QuranPlayerContoller>(
      builder: QuranPlayerContoller._,
    );
  }

  Duration? _total;

  /// The total audio length in [Duration].
  ///
  /// Will return [Duration.zero] if the player is not associated
  /// with a [Surah] yet
  Duration get total => _total ?? Duration.zero;
  Future<void> _loadPositions() async {
    final Directory directory =
        await QuranStore._getDirectoryForSurah(_quran!.edition, _surah!);
    final File durationsJson = File(
      directory.path +
          Platform.pathSeparator +
          QuranManager.durationJsonFileName,
    );
    Map<dynamic, dynamic> results =
        json.decode(durationsJson.readAsStringSync()) as Map<dynamic, dynamic>;
    results = results.map<int, Duration>(
      (dynamic key, dynamic value) => MapEntry<int, Duration>(
        int.parse(key as String),
        duration_formater.parseDuration(value as String),
      ),
    );
    final Map<int, Duration> positions = results.cast<int, Duration>();
    Duration total = Duration.zero;
    for (final MapEntry<int, Duration> item in positions.entries) {
      total += item.value;
    }
    _total = total;
    final List<MapEntry<int, Duration>> entries = positions.entries.toList()
      ..sort(
        (MapEntry<int, Duration> e1, MapEntry<int, Duration> e2) =>
            e1.key.compareTo(e2.key),
      );
    for (int i = 0; i < entries.length; i++) {
      Duration position = Duration.zero;
      for (int current = 0; current < i; current++) {
        position += entries[current].value;
      }
      positions[entries[i].key] = position;
    }
    _positions
      ..clear()
      ..addAll(positions.entries)
      ..sort(
        (MapEntry<int, Duration> e1, MapEntry<int, Duration> e2) =>
            e1.key.compareTo(e2.key),
      );
  }

  /// faking the [currentAyah] value by changing it to the [Ayah] index
  /// of the duration equilevant from the provided [value]
  void fakePositionFromValue(double? value) {
    if (value != null) {
      final Duration duration = Duration(
        microseconds: (total.inMicroseconds.toDouble() * value).toInt(),
      );
      currentAyah!.value = indexFromDuration(duration);
    } else {
      currentAyah!.value = indexFromDuration(duration);
    }
  }

  /// Get the current ayah index from the provided [duration] using the stored
  /// positions json.
  int indexFromDuration(Duration duration) => _positions
      .lastWhere(
        (MapEntry<int, Duration> element) => element.value <= duration,
      )
      .key;

  /// Check wether the current state of this player is meant
  /// for this [quran] & [surah]
  bool isForSurah(TheHolyQuran quran, Surah surah) =>
      quran == _quran && surah == _surah;

  /// The necessary preparations for the player to provide the values
  /// of the default streams and notifiers if needed and stop the
  /// current player if it's not belonging
  Future<void> prepareForSurah(TheHolyQuran quran, Surah surah) async {
    // return if it's already for the same surah of the same quran
    if (isForSurah(quran, surah)) return;
    // stop immediately and start preparing for the new surah
    await _player.stop();
    // change the current surah and quran to provided one's
    _quran = quran;
    _surah = surah;
    // start the preparations for the new surah
    // setting the new source and getting the total length
    final SurahAudioSource source =
        await SurahAudioSource.create(quran: quran, surah: surah);
    final Duration? total = await _player.setAudioSource(source);
    // setting the new total duration
    _total = total;
    // load the new positions
    await _loadPositions();

    // creating the new current ayah notifier and disposing the old one
    _currentAyah?.dispose();
    // starting from zero means that it's on basmala

    _currentAyah =
        ValueNotifier<int>(surah.number == 1 || surah.number == 9 ? 1 : 0);
    // creating the transformer for the new value stream
    final StreamTransformer<Duration, double> _durationToValueTransformer =
        StreamTransformer<Duration, double>.fromHandlers(
      handleData: (Duration duration, EventSink<double> sink) async {
        final double percentage = _percentageOfDuration(duration);
        sink.add(percentage);
      },
    );
    _valueStream =
        _player.positionStream.transform(_durationToValueTransformer);
    // listening to the new ayah change
    _player.positionStream.listen((Duration duration) {
      // get the ayah number based on the duration played from [_positions]

      final int index = _positions
          .lastWhere(
            (MapEntry<int, Duration> element) => element.value <= duration,
          )
          .key;
      // notifying if needed
      if (_currentAyah!.value != index) {
        _currentAyah!.value = index;
      }
    });
    //create a new isPlaying and disposing the old one
    _isPlaying?.dispose();
    _isPlaying = ValueNotifier<bool>(false);
    // listen to the playing events
    _player.playingStream.distinct().listen((bool event) {
      _isPlaying!.value = event;
    });
    // setting the player to the top manually
    await _player.seek(Duration.zero, index: 0);
    // assuring the controller state change to stop and back to the top
    _valueStream!.listen((double percentage) async {
      if (percentage >= 1.0) {
        await _player.stop();
        await _player.seek(Duration.zero, index: 0);
      }
    });
  }

  double _percentageOfDuration(Duration duration) {
    final double ret =
        duration.inMicroseconds.toDouble() / total.inMicroseconds.toDouble();
    return math.min<double>(1, ret);
  }

  @override
  @protected
  Future<void> playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.value = mediaItem as SurahMediaItem;
    final AudioSource source = await SurahAudioSource.create(
      quran: mediaItem.quran,
      surah: mediaItem.surah,
    );
    await _player.stop();
    await _player.setAudioSource(source);
    await _player.seek(Duration.zero, index: 0);
    await _player.play();
  }

  @override
  Future<void> skipToNext() {
    if (_currentAyah!.value == _positions.last.key) {
      return stop();
    }

    return _player.seek(
      _positions
          .singleWhere(
            (MapEntry<int, Duration> element) =>
                element.key == currentAyah!.value + 1,
          )
          .value,
    );
  }

  @override
  Future<void> skipToPrevious() {
    if (_currentAyah!.value == _positions.first.key) {
      return stop();
    }
    return _player.seek(
      _positions
          .singleWhere(
            (MapEntry<int, Duration> element) =>
                element.key == currentAyah!.value - 1,
          )
          .value,
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  /// Convenient method to seek to a specific [ayah] in the surah
  ///
  ///
  /// The player reads the position of the ayah from the
  /// [QuranManager.durationJsonFileName] associated with
  /// the surah directory made during the build
  Future<void> seekToAyah(Ayah ayah) => seek(
        _positions
            .singleWhere(
              (MapEntry<int, Duration> element) => element.key == ayah.number,
            )
            .value,
      );

  /// Convenient method to seek to a [double] value that represents
  /// a percentage of the total audio file length
  Future<void> seekToValue(double value) =>
      seek(Duration(microseconds: (value * total.inMicroseconds).toInt()));

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: <MediaControl>[
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const <MediaAction>{
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.pause,
        MediaAction.play,
      },
      androidCompactActionIndices: const <int>[0, 1, 3],
      processingState: const <ProcessingState, AudioProcessingState>{
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
