import 'package:flutter/material.dart';
import 'package:islamy/quran/models/bookmark.dart';
import 'package:islamy/quran/quran_manager.dart';

class BookmarksList extends StatelessWidget {
  const BookmarksList({Key? key}) : super(key: key);
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
  const _BookmarkTile({Key? key, required this.bookmark}) : super(key: key);
  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
