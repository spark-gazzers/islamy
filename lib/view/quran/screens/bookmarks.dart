import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/engines/quran/models/bookmark.dart';
import 'package:islamy/engines/quran/models/surah.dart';
import 'package:islamy/engines/quran/quran_manager.dart';

class BookmarksList extends StatelessWidget {
  const BookmarksList({super.key});
  List<Bookmark> get bookmarks {
    final List<Bookmark> bookmarks = QuranStore.settings.bookmarks;
    if (QuranStore.settings.autosavedBookmark != null) {
      bookmarks.insert(0, QuranStore.settings.autosavedBookmark!);
    }
    return bookmarks;
  }

  bool get isEmpty => QuranStore.settings.bookmarks.isEmpty;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
      builder: (BuildContext context, _, Widget? child) {
        if (isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BookmarkTile(bookmark: QuranStore.settings.autosavedBookmark!),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Icon(
                        Icons.collections_bookmark,
                        size: 80,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      S.of(context).no_bookmarks_here_yet,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return ListView.separated(
          itemCount: bookmarks.length,
          itemBuilder: (BuildContext context, int index) => _BookmarkTile(
            bookmark: bookmarks[index],
          ),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
      valueListenable: QuranStore.settings.bookmarksListenable,
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  const _BookmarkTile({required this.bookmark});
  final Bookmark bookmark;
  static DateFormat get _bookmarkDateFormat => DateFormat('MMMMd hh:mm a');
  bool get isAutosave => QuranStore.settings.autosavedBookmark == bookmark;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isAutosave
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
      ),
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(
          'surah_reader_screen_from_bookmark',
          arguments: <String, dynamic>{
            'bookmark': bookmark,
          },
        ),
        isThreeLine: false,
        trailing: const Icon(Icons.arrow_forward_ios),
        title: Text(
          '''${QuranManager.getQuran(QuranStore.settings.defaultTextEdition).surahs.singleWhere((Surah element) => element.number == bookmark.surah).localizedName}, ${bookmark.page}''',
        ),
        subtitle: Text(
          isAutosave
              ? S
                  .of(context)
                  .autosaved_at(_bookmarkDateFormat.format(bookmark.createdAt))
              : S.of(context).bookmarked_at(
                  _bookmarkDateFormat.format(bookmark.createdAt)),
        ),
      ),
    );
  }
}
