part of quran;

class QuranPlayerContoller extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  /// The static instance to access the player
  static late final QuranPlayerContoller instance;

  ///Returns the length of the provided audio file
  static Future<Duration> lengthOf(String path) async =>
      (await _lengthCalculator.setFilePath(path))!;

  ///The underlaying audio player
  final AudioPlayer _player = AudioPlayer();

  /// This player should never play instead only be used to calculate audio length
  static final AudioPlayer _lengthCalculator = AudioPlayer();

  ///The current [surah]'s ayahs positions in duration
  final Map<int, Duration> _positions = <int, Duration>{};

  ///The current player [TheHolyQuran]
  TheHolyQuran? _quran;

  ///The current player [Surah]
  Surah? _surah;

  /// The current ayah notifier
  ValueNotifier<int>? _currentAyah;

  ValueNotifier<bool>? _isPlaying;
  ValueNotifier<bool> get isPlaying => _isPlaying!;

  /// The current playing ayah number.
  ///
  ///
  ///
  /// Note if this [value] points to 0 then this means it's on the basmala part
  ///
  /// Will throw [LateInitializationError] if [prepareForSurah] is not called yet
  ValueNotifier<int> get currentAyah => _currentAyah!;

  /// The current position of the player.
  Duration get duration => _player.position;

  /// The current position of the player as value from 0 .. 1.0.
  double get durationValue =>
      _player.position.inMicroseconds.toDouble() /
      total.inMicroseconds.toDouble();

  ///The value stream of the current played duration in 0.0 to 1.0 value
  Stream<double>? _valueStream;

  ///The value stream of the current played duration in 0.0 to 1.0 value
  ///
  /// Will throw [LateInitializationError] if [prepareForSurah] is not called yet
  Stream<double>? get valueStream => _valueStream;

  /// This constuctor must only be called once and that should be in the init project
  QuranPlayerContoller._() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  static Future<void> init() async {
    instance = await AudioService.init<QuranPlayerContoller>(
      builder: () => QuranPlayerContoller._(),
    );
  }

  Duration? _total;
  Duration get total => _total ?? Duration.zero;
  Future<void> _loadPositions() async {
    final directory =
        await QuranStore._getDirectoryForSurah(_quran!.edition, _surah!);
    File durationsJson = File(directory.path +
        Platform.pathSeparator +
        QuranManager.durationJsonFileName);
    Map results = json.decode(durationsJson.readAsStringSync());
    results = results.map((key, value) => MapEntry<int, Duration>(
        int.parse(key), duration_formater.parseDuration(value)));
    Map<int, Duration> positions = results.cast<int, Duration>();
    Duration total = Duration.zero;
    for (var item in positions.entries) {
      total += item.value;
    }
    _total = total;
    List<MapEntry<int, Duration>> entries = positions.entries.toList();
    entries.sort((e1, e2) => e1.key.compareTo(e2.key));
    for (var i = 0; i < entries.length; i++) {
      Duration position = Duration.zero;
      for (var current = 0; current < i; current++) {
        position += entries[current].value;
      }
      positions[entries[i].key] = position;
    }
    _positions.clear();
    _positions.addAll(positions);
  }

  bool isForSurah(TheHolyQuran quran, Surah surah) =>
      quran == _quran && surah == _surah;

  ///The necessary preparations for the player to provide the values of the default
  ///streams and notifiers if needed and stop the current player if it's not belonging
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
    final source = await SurahAudioSource.create(quran: quran, surah: surah);
    Duration? total = await _player.setAudioSource(source);
    // setting the new total duration
    _total = total!;
    // load the new positions
    await _loadPositions();

    // creating the new current ayah notifier and disposing the old one
    _currentAyah?.dispose();
    // starting from zero means that it's on basmala
    _currentAyah = ValueNotifier<int>(0);
    // creating the transformer for the new value stream
    StreamTransformer<Duration, double> _durationToValueTransformer =
        StreamTransformer<Duration, double>.fromHandlers(
      handleData: (Duration duration, EventSink<double> sink) async {
        var percentage = _percentageOfDuration(duration);
        sink.add(percentage);
      },
    );
    _valueStream =
        _player.positionStream.transform(_durationToValueTransformer);
    // listening to the new ayah change
    _player.positionStream.listen((duration) {
      // get the ayah number based on the duration played from [_positions]
      int index = _positions.entries
          .lastWhere((element) => element.value <= duration)
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
    _player.playingStream.distinct().listen((event) {
      _isPlaying!.value = event;
    });
    // setting the player to the top manually
    await _player.seek(Duration.zero, index: 0);
    // assuring the controller state change to stop and back to the top
    _valueStream!.listen((percentage) async {
      if (percentage >= 1.0) {
        await _player.stop();
        await _player.seek(Duration.zero, index: 0);
      }
    });
  }

  double _percentageOfDuration(Duration duration) {
    double ret =
        duration.inMicroseconds.toDouble() / total.inMicroseconds.toDouble();
    return math.min<double>(1.0, ret);
  }

  @override
  @protected
  Future<void> playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.value = mediaItem as SurahMediaItem;
    AudioSource source = await SurahAudioSource.create(
        quran: mediaItem.quran, surah: mediaItem.surah);
    await _player.stop();
    await _player.setAudioSource(source);
    await _player.seek(Duration.zero, index: 0);
    await _player.play();
  }

  @override
  Future<void> skipToNext() => _player.seek(_positions[currentAyah.value + 1]);

  @override
  Future<void> skipToPrevious() =>
      _player.seek(_positions[currentAyah.value - 1]);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> seekToAyah(Ayah ayah) => seek(_positions[ayah.numberInSurah]!);

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
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.pause,
        MediaAction.play,
      },
      androidCompactActionIndices: const [0, 1, 3],
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
