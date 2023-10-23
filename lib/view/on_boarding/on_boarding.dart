import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/engines/quran/quran_manager.dart';

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
  static const Duration _microInterActionDuration = Duration(milliseconds: 300);
  Stream<String>? _currentLibs;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedSwitcher(
            duration: _microInterActionDuration,
            reverseDuration: _microInterActionDuration,
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            ),
            child: _currentLibs == null || _hasError
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
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
                                    .it_seems_like_there_is_an_issue_connecting_to_the_server_check_the_connecting_and_try_again
                                : S
                                    .of(context)
                                    .tab_continue_to_start_your_journy,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _hasError
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer
                                  : null,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _hasError = false;
                            _currentLibs = QuranManager.downloadInit();
                            _currentLibs!.listen(
                              (String event) {},
                              onDone: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'main', (_) => false);
                              },
                              onError: (_) {
                                setState(() {
                                  _hasError = true;
                                });
                                return;
                              },
                            );
                          });
                        },
                        child: Text(
                          S.of(context).continue_,
                        ),
                      ),
                    ],
                  )
                : StreamBuilder<String>(
                    key: ValueKey<Stream<String>>(_currentLibs!),
                    stream: _currentLibs,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Column(
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: _microInterActionDuration,
                            reverseDuration: _microInterActionDuration,
                            child: Text(
                              snapshot.data ?? S.of(context).loading,
                              key: ValueKey<String>(
                                  snapshot.data ?? S.of(context).loading),
                            ),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) =>
                                    FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: CupertinoActivityIndicator(
                              animating: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
