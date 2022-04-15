import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/view/profile/screens/download_quran.dart';

class SelectEditionDelegate extends StatelessWidget {
  final Edition? selected;
  final String title;
  final String propertyName;
  final List<Edition> choices;
  final void Function(Edition) onSelected;
  const SelectEditionDelegate({
    Key? key,
    required this.selected,
    required this.choices,
    required this.onSelected,
    required this.title,
    required this.propertyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        previousPageTitle: S.of(context).quran,
        brightness: Brightness.dark,
      ),
      child: ListView.separated(
        itemBuilder: (_, index) => _EditionListTile(
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
  final Edition edition;
  final bool isSelected;
  final void Function(Edition) onSelected;
  final String propertyName;

  const _EditionListTile({
    Key? key,
    required this.edition,
    required this.isSelected,
    required this.onSelected,
    required this.propertyName,
  }) : super(key: key);

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
        if (!QuranManager.isQuranDownloaded(edition)) {
          Edition? ret = await showCupertinoModalPopup<Edition>(
              context: context,
              builder: (_) => DownloadQuranEditionSheet(edition: edition));
          if (ret != null) {
            NavigatorState navigator = Navigator.of(context);
            onSelected(edition);
            navigator.pop();
            Helper.messages.showSuccess(
                navigator.context,
                S.current
                    .edition_was_downloaded_succefully_and_selected_for_edition_type(
                        edition.localizedName, propertyName));
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
