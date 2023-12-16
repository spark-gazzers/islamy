import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/engines/quran/models/ayah.dart';
import 'package:islamy/engines/quran/models/edition.dart';
import 'package:islamy/engines/quran/models/the_holy_quran.dart';
import 'package:islamy/engines/quran/quran_manager.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:proper_filesize/proper_filesize.dart';

/// A Dialog that request permission to download a specific [TheHolyQuran].
///
///
/// Note this class is also responsible of downloading the first [Ayah] of
/// Al-fatiha if the [Edition.format] is audio.
class DownloadQuranEditionDialog extends StatefulWidget {
  const DownloadQuranEditionDialog({
    required this.edition,
    super.key,
  });

  final Edition edition;

  @override
  State<DownloadQuranEditionDialog> createState() =>
      _DownloadQuranEditionDialogState();
}

class _DownloadQuranEditionDialogState
    extends State<DownloadQuranEditionDialog> {
  Future<TheHolyQuran>? download;
  final StreamController<_DownloadUpdate> _downloadMeterController =
      StreamController<_DownloadUpdate>();
  late final Stream<_DownloadUpdate> _downloadMeter;
  @override
  void initState() {
    _downloadMeter = _downloadMeterController.stream.asBroadcastStream();
    super.initState();
  }

  DateTime? lastUpdate;
  _DownloadUpdate? lastDownload;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TheHolyQuran>(
      future: download,
      builder: (BuildContext context, AsyncSnapshot<TheHolyQuran> snapshot) {
        if (snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          return _AskToDownload(download: startDownload, hasError: true);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _AskToDownload(download: startDownload);
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.done:
            return StreamBuilder<_DownloadUpdate>(
              stream: _downloadMeter,
              builder: (
                BuildContext context,
                AsyncSnapshot<_DownloadUpdate> snapshot,
              ) {
                double value = 0;
                if (snapshot.data != null) {
                  value = snapshot.data!.downloaded.toDouble() /
                      snapshot.data!.total.toDouble();
                }
                int speed = 0;
                if (lastUpdate != null && lastDownload != null) {
                  final Duration diff = DateTime.now().difference(lastUpdate!);
                  speed = (lastDownload!.downloaded.toDouble() -
                              snapshot.data!.downloaded.toDouble())
                          .abs() ~/
                      (1e+6 / diff.inMicroseconds);
                }
                lastUpdate = DateTime.now();
                lastDownload = snapshot.data;
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .1,
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IntrinsicHeight(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '${(value * 100).toStringAsFixed(2)}%',
                                  ),
                                  Text(
                                    '${ProperFilesize.generateHumanReadableFilesize(speed, decimals: 0)}/S',
                                  ),
                                  const Spacer(),
                                  const VerticalDivider(),
                                  Text(
                                    // ignore: lines_longer_than_80_chars
                                    '${ProperFilesize.generateHumanReadableFilesize(
                                      snapshot.data?.downloaded ?? 0,
                                      decimals: 2,
                                      base: Bases.Metric,
                                    )}'
                                    '/${ProperFilesize.generateHumanReadableFilesize(
                                      snapshot.data?.total ?? 0,
                                      decimals: 2,
                                      base: Bases.Metric,
                                    )}',
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            LinearProgressIndicator(
                              value: value,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
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
      },
    );
  }

  void startDownload() {
    setState(
      () {
        download = QuranManager.downloadQuran(
          edition: widget.edition,
          onReceiveProgress: (int part, int all) {
            _downloadMeterController
                .add(_DownloadUpdate(downloaded: part, total: all));
          },
        );
        download!.then(
          (TheHolyQuran value) => Navigator.pop(context, widget.edition),
        );
      },
    );
  }
}

class _AskToDownload extends StatelessWidget {
  const _AskToDownload({
    required this.download,
    this.hasError = false,
  });

  final VoidCallback download;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        hasError
            ? S.of(context).download_failed_due_to_unstable_internet_connection
            : S
                .of(context)
                // ignore: lines_longer_than_80_chars
                .in_order_to_use_this_edition_now_or_later_we_need_to_download_it_first,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: download,
          child:
              Text(hasError ? S.of(context).try_again : S.of(context).download),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(S.of(context).cancel),
        ),
      ],
    );
  }
}

class _DownloadUpdate {
  const _DownloadUpdate({
    required this.total,
    required this.downloaded,
  });

  final int total;
  final int downloaded;
}
