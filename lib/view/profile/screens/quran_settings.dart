import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';

class QuranSettingsScreen extends StatefulWidget {
  const QuranSettingsScreen({Key? key}) : super(key: key);

  @override
  State<QuranSettingsScreen> createState() => _QuranSettingsScreenState();
}

class _QuranSettingsScreenState extends State<QuranSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).quran_settings),
        previousPageTitle: S.of(context).profile,
        brightness: Brightness.dark,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CupertinoFormSection(
          header: Text(S.of(context).quran_reader),
          children: [
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, 'select_text_quran');
              },
              title: Text(S.of(context).text_edition),
              trailing: const Icon(CupertinoIcons.forward),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, 'select_audio_quran');
              },
              title: Text(S.of(context).audio_edition),
              trailing: const Icon(CupertinoIcons.forward),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, 'select_interpretation_quran');
              },
              title: Text(S.of(context).interpretation_edition),
              trailing: const Icon(CupertinoIcons.forward),
            ),
            GestureDetector(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, 'select_translation_quran');
                },
                title: Text(S.of(context).translation_edition),
                trailing: const Icon(CupertinoIcons.forward),
              ),
            ),
            GestureDetector(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, 'select_transliteration_quran');
                },
                title: Text(S.of(context).transliteration_edition),
                trailing: const Icon(CupertinoIcons.forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
