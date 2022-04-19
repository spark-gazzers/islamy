import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/view/profile/screens/download_quran.dart';

class SelectEditionDelegate extends StatelessWidget {
  const SelectEditionDelegate({
    Key? key,
    required this.selected,
    required this.choices,
    required this.onSelected,
    required this.title,
    required this.propertyName,
  }) : super(key: key);

  final Edition? selected;
  final String title;
  final String propertyName;
  final List<Edition> choices;
  final void Function(Edition) onSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        previousPageTitle: S.of(context).quran,
        brightness: Brightness.dark,
      ),
      child: ListView.separated(
        itemBuilder: (_, int index) => _EditionListTile(
          propertyName: propertyName,
          edition: choices[index],
          onSelected: onSelected,
          isSelected: choices[index] == selected,
        ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: choices.length,
      ),
    );
  }
}

class _EditionListTile extends StatelessWidget {
  const _EditionListTile({
    Key? key,
    required this.edition,
    required this.isSelected,
    required this.onSelected,
    required this.propertyName,
  }) : super(key: key);

  final Edition edition;
  final bool isSelected;
  final void Function(Edition) onSelected;
  final String propertyName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      title: Text(edition.localizedName),
      leading: QuranManager.isQuranDownloaded(edition)
          ? const Icon(Icons.download_done)
          : const Icon(Icons.download),
      subtitle: Text(Helper.localization.nameOf(Locale(edition.language))),
      trailing:
          isSelected ? const Icon(CupertinoIcons.check_mark_circled) : null,
      onTap: () async {
        final NavigatorState navigator = Navigator.of(context);
        if (!QuranManager.isQuranDownloaded(edition)) {
          final Edition? ret = await showCupertinoModalPopup<Edition>(
            context: context,
            builder: (_) => DownloadQuranEditionSheet(edition: edition),
          );
          if (ret != null) {
            onSelected(edition);
            navigator.pop();
            // ignoring here cause there is no possible way to close the screen
            // after disposing the sheet without completing this method body
            // ignore: use_build_context_synchronously
            Helper.messages.showSuccess(
              navigator.context,
              S.current
                  // ignore: lines_longer_than_80_chars
                  .edition_was_downloaded_succefully_and_selected_for_edition_type(
                edition.localizedName,
                propertyName,
              ),
            );
            return;
          }
        } else {
          onSelected(edition);
          Navigator.pop(context);
        }
      },
    );
  }
}
