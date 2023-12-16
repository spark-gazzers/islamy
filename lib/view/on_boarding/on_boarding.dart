import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/engines/hadeeth/hadeeth_manager.dart';
import 'package:islamy/engines/quran/quran_manager.dart';
import 'package:islamy/generated/l10n/l10n.dart';

/// The first timer welcoming scrreen that explains the essence of the app.
class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 109),
                const Image(
                  height: 252.96,
                  filterQuality: FilterQuality.high,
                  image: AssetImage('assets/images/on_boarding.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    S.of(context).manage_your_daily_islamic_habits,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 69.5),
                  child: Text(
                    S
                        .of(context)
                        // ignore: lines_longer_than_80_chars
                        .islamy_lets_you_manage_your_daily_islamic_habits_with_ease,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const _ContinueSection()
          ],
        ),
      ),
    );
  }
}

class _ContinueSection extends StatefulWidget {
  const _ContinueSection();

  @override
  State<_ContinueSection> createState() => _ContinueSectionState();
}

class _ContinueSectionState extends State<_ContinueSection> {
  Stream<String>? _currentLibs;
  bool _hasError = false;
  final Set<String> passedDownloads = <String>{};
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Stream<String> _startDownloading() async* {

    yield* QuranManager.downloadInit();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (HadeethStore.listLanguages().isEmpty) {
      yield S.current.downloading_x(S.current.available_hadeeth_languages);
      await HadeethManager.downloadHadeethLanguages();
    }
    if (HadeethStore.listCategories().isEmpty) {
      yield S.current.downloading_x(S.current.hadeeth_categories);
      await HadeethManager.downloadHadeethCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder<String>(
            stream: _currentLibs,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (passedDownloads.length > 1)
                    AnimatedList(
                      key: _listKey,
                      initialItemCount: passedDownloads.length - 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (
                        BuildContext context,
                        int index,
                        Animation<double> animation,
                      ) {
                        animation = Tween<double>(begin: 0, end: 1)
                            .chain(CurveTween(curve: Curves.ease))
                            .animate(animation);
                        final Animation<Offset> position = Tween<Offset>(
                                begin: const Offset(0, 1), end: Offset.zero)
                            .animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: position,
                            child: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: passedDownloads.elementAt(index),
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.done,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                ],
                              ),
                              key: ValueKey<String>(
                                passedDownloads.elementAt(index),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  if (_currentLibs != null || _hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: _hasError
                                  ?  passedDownloads.last
                                  : (snapshot.data ?? S.of(context).loading),
                            ),
                            WidgetSpan(
                              child: _hasError
                                  ? Icon(
                                      Icons.error_outline,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    )
                                  : const CupertinoActivityIndicator(
                                      animating: true,
                                    ),
                            )
                          ],
                        ),
                        key: ValueKey<String>(
                          snapshot.data ?? S.of(context).loading,
                        ),
                      ),
                    ),
                  if (_currentLibs == null)
                    Container(
                      margin: EdgeInsets.only(
                        bottom: _hasError ? 16 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: _hasError
                            ? Theme.of(context).colorScheme.errorContainer
                            : null,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: Text(
                          _hasError
                              ? S
                                  .of(context)
                                  // ignore: lines_longer_than_80_chars
                                  .it_seems_like_there_is_an_issue_connecting_to_the_server_check_the_connecting_and_try_again
                              : S.of(context).tab_continue_to_start_your_journy,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _hasError
                                ? Theme.of(context).colorScheme.onErrorContainer
                                : null,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  if (_currentLibs == null)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _currentLibs =
                              _startDownloading().asBroadcastStream();

                          _currentLibs!.listen((String event) {
                            passedDownloads.add(event);
                            _listKey.currentState?.removeAllItems(
                              (BuildContext context,
                                      Animation<double> animation) =>
                                  SizedBox.fromSize(),
                              duration: Duration.zero,
                            );
                            _listKey.currentState
                                ?.insertAllItems(0, passedDownloads.length - 1);
                          }, onDone: () {
                            if (!_hasError) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'main', (_) => false);
                            }
                          }, onError: (_) {
                            _hasError = true;
                            _currentLibs = null;
                            WidgetsBinding.instance.addPostFrameCallback(
                              (Duration timeStamp) {
                                setState(() {});
                                return;
                              },
                            );
                          });
                        });
                      },
                      child: Text(
                        _hasError
                            ? S.of(context).try_again
                            : S.of(context).continue_,
                      ),
                    ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
