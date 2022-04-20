import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/utils/store.dart';

/// The screen that is responsible for selecting the app
/// language and store the new locale.
class LocalizationDelegateScreen extends StatelessWidget {
  const LocalizationDelegateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: S.of(context).profile,
        middle: Text(S.of(context).select_language),
        brightness: Brightness.dark,
      ),
      child: ListView.builder(
        itemCount: S.delegate.supportedLocales.length,
        itemBuilder: (BuildContext context, int index) {
          final bool isSelected = Helper.localization
              .equals(S.delegate.supportedLocales[index], Store.locale);
          return ListTile(
            selected: isSelected,
            leading: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              clipBehavior: Clip.hardEdge,
              child: Flag.fromString(
                S.delegate.supportedLocales[index].countryCode ?? 'ksa',
                fit: BoxFit.cover,
                height: 30,
                width: 35,
              ),
            ),
            title: Text(
              Helper.localization.nameOf(S.delegate.supportedLocales[index]),
            ),
            trailing: isSelected ? const Icon(Icons.done_all) : null,
            onTap: () {
              Store.locale = S.delegate.supportedLocales[index];
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
