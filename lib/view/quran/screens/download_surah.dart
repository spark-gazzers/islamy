import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/repository/cloud_quran.dart';

class DownloadSurahDialog extends StatefulWidget {
  final Edition edition;
  final Surah surah;
  const DownloadSurahDialog({
    Key? key,
    required this.edition,
    required this.surah,
  }) : super(key: key);

  @override
  State<DownloadSurahDialog> createState() => _DownloadSurahDialogState();
}

class _DownloadSurahDialogState extends State<DownloadSurahDialog> {
  Future? download;
  final StreamController<int> _downloadMeterController =
      StreamController<int>();
  late final Stream<int> _downloadMeter;
  @override
  void initState() {
    _downloadMeter = _downloadMeterController.stream.asBroadcastStream();
    super.initState();
  }

  DateTime? lastUpdate;
  _DownloadUpdate? lastDownload;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: download,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError &&
              snapshot.connectionState == ConnectionState.done) {
            return _AskToDownload(
              download: startDownload,
              surah: widget.surah,
              edition: widget.edition,
              hasError: true,
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _AskToDownload(
                download: startDownload,
                surah: widget.surah,
                edition: widget.edition,
              );
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:
              return StreamBuilder<int>(
                stream: _downloadMeter,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(S
                                  .of(context)
                                  .downloaded_count_ayah_out_of_total(
                                      snapshot.data ?? 0,
                                      widget.surah.ayahs.length)),
                              const SizedBox(height: 24.0),
                              LinearProgressIndicator(
                                value: (snapshot.data?.toDouble() ?? 0.0) /
                                    widget.surah.ayahs.length.toDouble(),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        });
  }

  void startDownload() {
    setState(
      () {
        download = CloudQuran.downloadSurah(
            edition: widget.edition,
            surah: widget.surah,
            onAyahDownloaded: (index) {
              _downloadMeterController.add(index);
            });
        download!.then((value) => Navigator.pop(context, widget.edition));
      },
    );
  }
}

class _AskToDownload extends StatelessWidget {
  final VoidCallback download;
  final Surah surah;
  final Edition edition;
  final bool hasError;
  const _AskToDownload({
    Key? key,
    required this.download,
    this.hasError = false,
    required this.surah,
    required this.edition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(hasError
          ? S.of(context).download_failed_due_to_unstable_internet_connection
          : S
              .of(context)
              .in_order_to_play_this_surah_in_this_edition_now_or_later_we_need_to_download_it_first(
                surah.localizedName,
                edition.localizedName,
              )),
      actions: [
        CupertinoDialogAction(
          child:
              Text(hasError ? S.of(context).try_again : S.of(context).download),
          isDefaultAction: true,
          onPressed: download,
        ),
        CupertinoDialogAction(
          child: Text(S.of(context).cancel),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _DownloadUpdate {
  final int total;
  final int downloaded;

  const _DownloadUpdate({
    required this.total,
    required this.downloaded,
  });
}
