// ignore_for_file: library_private_types_in_public_api

part of hadeeth;

/// Storage handler for most of the requests made with [HadeethEnc].
///
/// This store uses [Hive] DB to store everyting.
class HadeethStore {
  const HadeethStore._();

  /// static instance that provides the necessary meta about [Juz]
  /// and getters/setters for the default edition for each type.
  // static const _QuranSettings settings = _QuranSettings.instance;

  static late final Box<HadeethLanguage> _languagesBox;

  /// Checks weather everything that needs to be downloaded at the bare
  /// minimum are ready or not
  static bool isReady() => listLanguages().isNotEmpty;

  /// initializer for the [HadeethStore] [Box]s and register
  /// every [TypeAdapter<T>] for each type needed.
  static Future<bool> init() async {
    _registerAdapters();
    // await _QuranSettings._init();
    _languagesBox = await _getBox('hadeeth_languages');
    return isReady();
  }

  static void _registerAdapters() {
    // Hadeeth adapters typeId should start from 10

    Hive
        // typeId == 10
        .registerAdapter(HadeethLanguageAdapter());
  }

  static Future<Box<T>> _getBox<T>(String boxName) async {
    Box<T> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
    } else {
      box = await Hive.openBox<T>(boxName);
    }

    if (!box.isOpen) {
      await Hive.openBox<T>(box.name);
    }
    return box;
  }

  static List<HadeethLanguage> listLanguages() => _languagesBox.values.toList();

  static Future<void> _addLanguages(List<HadeethLanguage> languages) =>
      _addAll(values: languages, box: _languagesBox);

  static Future<void> _saveValue<T>({
    required String name,
    required T? value,
    required Box<T?> box,
  }) async {
    await box.delete(name);
    await box.put(name, value);
  }

  static Future<void> _addAll<T>({
    required List<T> values,
    required Box<T> box,
  }) async {
    await box.addAll(values);
  }

  static T? _readValue<T>({
    required String name,
    required Box<T> box,
  }) {
    final T? results = box.get(name);
    return results;
  }
}

// class _QuranSettings {
//   const _QuranSettings._();
//   static const _QuranSettings instance = _QuranSettings._();
//   static late final Box<String?> _settingsBox;
//   static late final Box<Bookmark> _bookmarksBox;
//   static late final List<Juz> _juzData;
//   static Future<void> _init() async {
//     _settingsBox = await HadeethStore._getBox<String?>('quran_settings');
//     _bookmarksBox = await HadeethStore._getBox<Bookmark>('bookmarks');
//     final String data =
//         await rootBundle.loadString('assets/config/juz_data.json');
//     _juzData = Juz.listFromRawJson(data);
//   }

//   List<Juz> get juzData => _juzData;

//   QuranMeta get meta => QuranMeta.fromRawJson(_settingsBox.get('quran_meta')!);

//   set meta(QuranMeta meta) =>
//       _saveValue(name: 'quran_meta', value: meta.toRawJson());

//   ////// Editions Selections
//   Edition get defaultTextEdition {
//     return HadeethStore.listTextEditions().singleWhere(
//       (Edition element) =>
//           element.identifier ==
//           (_readValue(name: 'default_text_edition') ?? 'quran-uthmani'),
//     );
//   }

//   set defaultTextEdition(Edition edition) {
//     _saveValue(
//       name: 'default_text_edition',
//       value: edition.identifier,
//     );
//   }

//   Edition get defaultAudioEdition {
//     final List<Edition> editions = HadeethStore.listAudioEditions().toList();

//     return editions.singleWhere(
//       (Edition element) =>
//           element.identifier ==
//           (_readValue(name: 'default_audio_edition') ??
//               editions.first.identifier),
//     );
//   }

//   set defaultAudioEdition(Edition edition) {
//     _saveValue(
//       name: 'default_audio_edition',
//       value: edition.identifier,
//     );
//   }

//   ValueListenable<dynamic> get _defaultAudioEditionListener =>
//       _settingsBox.listenable(keys: <String>['default_audio_edition']);
//   Edition? get defaultInterpretationEdition {
//     final String? id = _readValue(name: 'default_interpretation_edition');
//     if (id == null) return null;
//     final List<Edition> editions =
//         HadeethStore.listInterpretationEditions().toList();

//     return editions.singleWhere(
//       (Edition element) => element.identifier == id,
//     );
//   }

//   set defaultInterpretationEdition(Edition? edition) {
//     _saveValue(
//       name: 'default_interpretation_edition',
//       value: edition?.identifier,
//     );
//   }

//   Edition? get defaultTranslationEdition {
//     final String? id = _readValue(name: 'default_translation_edition');
//     if (id == null) return null;
//     final List<Edition> editions =
//         HadeethStore.listTranslationEditions().toList();

//     return editions.singleWhere(
//       (Edition element) => element.identifier == id,
//     );
//   }

//   set defaultTranslationEdition(Edition? edition) {
//     _saveValue(
//       name: 'default_translation_edition',
//       value: edition?.identifier,
//     );
//   }

//   Edition? get defaultTransliterationEdition {
//     final String? id = _readValue(name: 'default_transliteration_edition');
//     if (id == null) return null;
//     final List<Edition> editions =
//         HadeethStore.listTransliterationEditions().toList();

//     return editions.singleWhere(
//       (Edition element) => element.identifier == id,
//     );
//   }

//   set defaultTransliterationEdition(Edition? edition) {
//     _saveValue(
//       name: 'default_transliteration_edition',
//       value: edition?.identifier,
//     );
//   }

//   String? _readValue({required String name}) => _settingsBox.get(name);
//   Future<void> _saveValue({required String name, required String? value}) =>
//       HadeethStore._saveValue(name: name, value: value, box: _settingsBox);

//   /// The quran font family.
//   String get quranFont => _readValue(name: 'quran_font') ?? 'QuranFont 3';

//   set quranFont(String font) => _saveValue(name: 'quran_font', value: font);

//   /// The quran font size.
//   double get quranFontSize =>
//       double.parse(_readValue(name: 'quran_font_size') ?? '26.0');

//   set quranFontSize(double size) {
//     if (size <= HadeethStore.maxFontSize && size >= HadeethStore.minFontSize) {
//       _saveValue(
//         name: 'quran_font_size',
//         value: size.toString(),
//       );
//       return;
//     }
//     if (size < HadeethStore.minFontSize && size != HadeethStore.minFontSize) {
//       quranFontSize = HadeethStore.minFontSize;
//     }
//     if (size > HadeethStore.maxFontSize && size != HadeethStore.maxFontSize) {
//       quranFontSize = HadeethStore.maxFontSize;
//     }
//   }

//   ValueListenable<dynamic> get quranRenderSettingListenable =>
//       _settingsBox.listenable(
//         keys: <String>[
//           'quran_font_size',
//           'quran_font',
//           'highlight_ayah_on_player'
//         ],
//       );

//   /// Wether the [QuranPlayerContoller] should read basmala when
//   /// playing a single ayah.
//   bool get shouldReadBasmlaOnSelection =>
//       (_readValue(name: 'should_read_basmla_on_selection') ?? '1') == '1';

//   set shouldReadBasmlaOnSelection(bool value) {
//     _saveValue(
//       name: 'should_read_basmla_on_selection',
//       value: value ? '1' : '0',
//     );
//   }

//   /// Notifier for changes on the [shouldReadBasmlaOnSelection].
//   ValueListenable<Box<dynamic>> get shouldReadBasmlaOnSelectionListner =>
//       _settingsBox
//           .listenable(keys: <String>['should_read_basmla_on_selection']);

//   /// Wether the [QuranPlayerContoller] should read basmala when
//   /// playing a single ayah.
//   bool get highlightAyahOnPlayer =>
//       (_readValue(name: 'highlight_ayah_on_player') ?? '1') == '1';

//   set highlightAyahOnPlayer(bool value) {
//     _saveValue(name: 'highlight_ayah_on_player', value: value ? '1' : '0');
//   }

//   /// Notifier for changes on the [highlightAyahOnPlayer].
//   ValueListenable<Box<dynamic>> get highlightAyahOnPlayerListner =>
//       _settingsBox.listenable(keys: <String>['highlight_ayah_on_player']);

//   /// The auto-saved bookmark generated after every user interaction.
//   Bookmark? get autosavedBookmark {
//     return _bookmarksBox.get('auto_saved');
//   }

//   set autosavedBookmark(Bookmark? bookmark) {
//     _bookmarksBox.put('auto_saved', bookmark!);
//   }

//   /// Get all of the user created [Bookmark]s.
//   List<Bookmark> get bookmarks {
//     final List<Bookmark> bookmarks = _bookmarksBox.values.toList()
//       ..removeWhere((Bookmark element) => element == autosavedBookmark)
//       ..sort(
//         (Bookmark b1, Bookmark b2) => b1.createdAt.compareTo(b2.createdAt),
//       );
//     return bookmarks;
//   }

//   /// Add a [Bookmark] object, no checks happens when it's inserted if
//   /// it's unique or not
//   void addBookmark(Bookmark bookmark) {
//     _bookmarksBox.add(bookmark);
//   }

//   /// Remove the specified book
//   void removeBookmark(Bookmark bookmark) {
//     _bookmarksBox.delete(bookmark.key);
//   }

//   /// Bookmarks listenable.
//   ValueListenable<dynamic> get bookmarksListenable =>
//       _bookmarksBox.listenable();
// }
