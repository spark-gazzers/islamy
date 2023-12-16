import 'package:flutter/material.dart';
import 'package:islamy/engines/hadeeth/hadeeth_manager.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_category.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_language.dart';
import 'package:islamy/generated/l10n/l10n.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({required this.category, super.key, this.langauge});
  final HadeethLanguage? langauge;
  final HadeethCategory category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.title),
      trailing: const Icon(Icons.arrow_forward_ios),
      subtitle: Text('$childrenCount '
          '${hasSubs ? S.of(context).category : S.of(context).hadeeth}'),
      onTap: () {
        Navigator.of(context).pushNamed(
          hasSubs ? 'hadeeth_category' : 'hadeeths_screen',
          arguments: <String, Object?>{
            'language': langauge,
            'category': category,
          },
        );
      },
    );
  }

  bool get hasSubs =>
      HadeethStore.subCategoriesOf(category, language: langauge).isNotEmpty;

  String get childrenCount {
    return HadeethStore.subCategoriesOf(category, language: langauge)
        .length
        .toString();
  }
}
