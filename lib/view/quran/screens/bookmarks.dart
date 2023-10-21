import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/bookmark.dart';
import 'package:islamy/quran/quran_manager.dart';

class BookmarksList extends StatelessWidget {
  const BookmarksList({super.key});
  List<Bookmark> get bookmarks {
    final List<Bookmark> bookmarks = QuranStore.settings.bookmarks;
    if (QuranStore.settings.autosavedBookmark != null) {
      bookmarks.insert(0, QuranStore.settings.autosavedBookmark!);
    }
    return bookmarks;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
      builder: (BuildContext context, _, Widget? child) {
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
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(
        'surah_reader_screen_from_bookmark',
        arguments: <String, dynamic>{
          'data': <String, dynamic>{
            'bookmark': bookmark,
          },
        },
      ),
      isThreeLine: false,
      trailing: const Icon(Icons.arrow_forward_ios),
      title: Text(
        '''${QuranManager.getQuran(QuranStore.settings.defaultTextEdition).surahs[bookmark.surah].localizedName}, ${bookmark.page}''',
      ),
      subtitle: Text(
        S.of(context).bookmarked_at(
              _bookmarkDateFormat.format(bookmark.createdAt),
            ),
      ),
    );
  }
}
