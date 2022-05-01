part of helper;

class _Translator {
  const _Translator._();
  static const _Translator instance = _Translator._();
  Future<void> init() async {}
  String getString(String key) {
    switch (Store.locale.languageCode) {
      case 'en_US':
        try {
          return (en_msg.messages.messages[key] as String Function()).call();
        } catch (_) {
          throw UnimplementedError(
            'The key $key is not yet implemented in'
            ' the ${Store.locale.languageCode} locale.',
          );
        }
      default:
        throw UnimplementedError(
          'The ${Store.locale.languageCode} is not supported yet',
        );
    }
  }
}
