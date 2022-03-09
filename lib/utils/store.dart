import 'package:hive_flutter/adapters.dart';

class Store {
  const Store._();
  static Future<void> init() async {
    await Hive.initFlutter();
  }
}
