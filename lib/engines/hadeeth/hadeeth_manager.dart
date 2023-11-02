library hadeeth;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_category.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_details.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_language.dart';

part 'repository/cloud_hadeeth.dart';
part 'store/hadeeth_store.dart';

class HadeethManager {
  static Future<bool> init() {
    CloudHadeeth.init();
    return HadeethStore.init();
  }

  static bool isReady() => HadeethStore.isReady();

  static Future<void> downloadHadeethLanguages() async {
    final List<HadeethLanguage> languages = await CloudHadeeth.listLanguages();

    HadeethStore._addLanguages(languages);
  }

  static Future<void> downloadHadeethCategories() async {
    final List<HadeethCategory> categories =
        await CloudHadeeth.listCategories();
    HadeethStore._addCategories(categories);
  }
}
