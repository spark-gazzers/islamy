// ignore_for_file: library_private_types_in_public_api

part of hadeeth;

/// Storage handler for most of the requests made with [HadeethEnc].
///
/// This store uses [Hive] DB to store everyting.
class HadeethStore {
  const HadeethStore._();

  /// static instance that provides the necessary meta about [Juz]
  /// and getters/setters for the default edition for each type.
  static const _HadeethSettings settings = _HadeethSettings.instance;

  static late final Box<HadeethLanguage> _languagesBox;
  static late final Box<HadeethCategory> _categoriesBox;
  static late final Box<Hadeeth> _hadeethsBox;
  static late final Box<HadeethDetails> _hadeethDetailsBox;
  static late final Box<String> _debugBox;

  /// Checks weather everything that needs to be downloaded at the bare
  /// minimum are ready or not
  static bool isReady() =>
      listLanguages().isNotEmpty && listCategories().isNotEmpty;

  /// initializer for the [HadeethStore] [Box]s and register
  /// every [TypeAdapter<T>] for each type needed.
  static Future<bool> init() async {
    _registerAdapters();
    await _HadeethSettings._init();
    _languagesBox = await _getBox<HadeethLanguage>('hadeeth_languages');
    _categoriesBox = await _getBox<HadeethCategory>('hadeeth_categories');
    _hadeethsBox = await _getBox<Hadeeth>('hadeeths');
    _debugBox = await _getBox<String>('hadeeth_debug');
    _hadeethDetailsBox = await _getBox<HadeethDetails>('hadeeth_details');

    return isReady();
  }

  static void addDebugData(String data) {
    _addAll(values: [data], box: _debugBox);
  }

  static List<String> get debugList => _debugBox.values.toList();

  static void _registerAdapters() {
    // Hadeeth adapters typeId should start from 10

    Hive
          // typeId == 10
          ..registerAdapter(HadeethLanguageAdapter())

          // typeId == 11
          ..registerAdapter(HadeethCategoryAdapter())

          // typeId == 12
          ..registerAdapter(HadeethAdapter())

          // typeId == 13
          ..registerAdapter(HadeethDetailsAdapter())

          // typeId == 14
          ..registerAdapter(WordsMeaningAdapter())
        //
        ;
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
  static List<HadeethCategory> listCategories() =>
      _categoriesBox.values.toList();
  static List<HadeethCategory> listRoots() => _categoriesBox.values
      .toList()
      .where((HadeethCategory category) => category.parentId == null)
      .toList();
  static List<Hadeeth> listHadeeths({HadeethLanguage? langauge}) {
    List<Hadeeth> hadeeths = _hadeethsBox.values.toList();
    if (langauge != null) {
      hadeeths = hadeeths
          .where((Hadeeth hadeeth) => hadeeth.languageCode == langauge.code)
          .toList();
    }
    return hadeeths;
  }

  static List<HadeethDetails> _listHadeethDetails({HadeethLanguage? langauge}) {
    List<HadeethDetails> hadeeths = _hadeethDetailsBox.values.toList();
    if (langauge != null) {
      hadeeths = hadeeths
          .where((HadeethDetails hadeeth) => hadeeth.language == langauge.code)
          .toList();
    }
    return hadeeths;
  }

  static HadeethDetails? getDetails({
    required String id,
    HadeethLanguage? language,
  }) {
    language ??= settings.language;
    try {
      return _listHadeethDetails(langauge: language)
          .singleWhere((HadeethDetails details) => details.id == id);
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  static Future<void> _addLanguages(List<HadeethLanguage> languages) =>
      _addAll(values: languages, box: _languagesBox);

  static Future<void> _addCategories(List<HadeethCategory> categories) =>
      _addAll(values: categories, box: _categoriesBox);

  static Future<void> addDetails(List<HadeethDetails> details) =>
      _addAll(values: details, box: _hadeethDetailsBox);

  static Future<void> _addHadeeths(List<Hadeeth> hadeeths) {
    final List<Hadeeth> memory = listHadeeths();
    for (final Hadeeth hadeeth in hadeeths) {
      if (memory.contains(hadeeth)) {
        throw ArgumentError('The hadeeth with ID:${hadeeth.id} and '
            'language:${hadeeth.languageCode} already exists');
      }
    }
    return _addAll(values: hadeeths, box: _hadeethsBox);
  }

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

class _HadeethSettings {
  const _HadeethSettings._();
  static const _HadeethSettings instance = _HadeethSettings._();
  static late final Box<String?> _settingsBox;
  static Future<void> _init() async {
    _settingsBox = await HadeethStore._getBox<String?>('hadeeth_settings');
  }

  String? _readValue({required String name}) => _settingsBox.get(name);
  Future<void> _saveValue({required String name, required String? value}) =>
      HadeethStore._saveValue(name: name, value: value, box: _settingsBox);

  /// Getter for the selected hadeeth languages, defaults to EN
  HadeethLanguage get language {
    return HadeethStore.listLanguages().singleWhere((HadeethLanguage language) {
      return language.code.toLowerCase() ==
          ((_readValue(name: 'language') ?? 'en').toLowerCase());
    });
  }

  String? get debugLanguage => _readValue(name: 'language');

  void debugBox() {
    HadeethStore._hadeethsBox.clear();
    print(HadeethStore.listHadeeths().length);
  }

  set language(HadeethLanguage language) =>
      _saveValue(name: 'language', value: language.code);
}
