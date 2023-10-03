import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/store.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(S.of(context).select_language),
          ),
          ListView(
            children: const [
              _LanguageTile(
                locale: Locale('En'),
                name: 'English',
              ),
              _LanguageTile(
                locale: Locale('Ar'),
                name: 'Arabic',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.locale, required this.name});
  final Locale locale;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Store.locale = locale;
        Navigator.pop(context);
      },
      title: Text(name),
      trailing: locale == Store.locale
          ? Icon(
              Icons.done,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }
}
