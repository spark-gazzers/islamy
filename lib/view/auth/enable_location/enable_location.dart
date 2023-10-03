import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perms;

/// This screen is for asking for [perms.Permission.locationWhenInUse]
/// after the onboarding.
class EnableLocation extends StatefulWidget {
  const EnableLocation({super.key});

  @override
  State<EnableLocation> createState() => _EnableLocationState();
}

class _EnableLocationState extends State<EnableLocation> {
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
                const Image(
                  height: 252.96,
                  image: AssetImage('assets/images/on_boarding_location.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 69.5,
                    vertical: 32,
                  ),
                  child: Text(
                    S
                        .of(context)
                        // ignore: lines_longer_than_80_chars
                        .you_can_skip_this_now_but_if_you_do_some_feature_wont_work,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'sign_in_with_server',
                      child: ElevatedButton(
                        onPressed: () async {
                          final Location location = Location();
                          PermissionStatus permissionGranted;
                          permissionGranted = await location.hasPermission();

                          if (permissionGranted == PermissionStatus.denied) {
                            permissionGranted =
                                await location.requestPermission();
                          }
                          switch (permissionGranted) {
                            case PermissionStatus.granted:
                            case PermissionStatus.grantedLimited:
                              if (mounted) {
                                Navigator.pushReplacementNamed(context, 'main');
                              }
                              break;
                            case PermissionStatus.denied:
                              // ignore: use_build_context_synchronously
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (_) => const _AssuringLater(),
                              );
                              break;
                            case PermissionStatus.deniedForever:
                              // ignore: use_build_context_synchronously
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (_) => const _PermenantlyDenied(),
                              );
                              break;
                          }
                        },
                        child: Text(
                          S.of(context).enable_location,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'main',
                        (_) => false,
                      );
                    },
                    child: Text(S.of(context).skip.toUpperCase()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AssuringLater extends StatelessWidget {
  const _AssuringLater();

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(S.of(context).enable_location),
      message: Text(
        S
            .of(context)
            .you_can_skip_this_now_but_if_you_do_some_feature_wont_work,
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(S.of(context).try_again),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              'main',
              (_) => false,
            );
          },
          isDestructiveAction: true,
          child: Text(S.of(context).skip),
        ),
      ],
    );
  }
}

class _PermenantlyDenied extends StatelessWidget {
  const _PermenantlyDenied();

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(S.of(context).permanently_denied),
      message: Text(
        S
            .of(context)
            // ignore: lines_longer_than_80_chars
            .the_permisiion_permanently_denied_which_can_cause_some_features_to_malfunction,
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            perms.openAppSettings();
            Navigator.pop(context);
          },
          isDefaultAction: true,
          child: Text(S.of(context).open_settings),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              'main',
              (_) => false,
            );
          },
          isDestructiveAction: true,
          child: Text(S.of(context).skip),
        ),
      ],
    );
  }
}
