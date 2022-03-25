import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perms;

class EnableLocation extends StatelessWidget {
  const EnableLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 109),
                Padding(
                  padding: const EdgeInsets.all(32.0),
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
                    vertical: 32.0,
                  ),
                  child: Text(
                    S
                        .of(context)
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
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'sign_in_with_server',
                      child: ElevatedButton(
                        onPressed: () async {
                          Location location = Location();
                          PermissionStatus _permissionGranted;
                          _permissionGranted = await location.hasPermission();

                          if (_permissionGranted == PermissionStatus.denied) {
                            _permissionGranted =
                                await location.requestPermission();
                          }
                          switch (_permissionGranted) {
                            case PermissionStatus.granted:
                            case PermissionStatus.grantedLimited:
                              Navigator.pushReplacementNamed(
                                  context, 'landing');
                              break;
                            case PermissionStatus.denied:
                              showCupertinoModalPopup(
                                context: context,
                                builder: (_) => const _AssuringLater(),
                              );
                              break;
                            case PermissionStatus.deniedForever:
                              showCupertinoModalPopup(
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
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'landing', (route) => false);
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
  const _AssuringLater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(S.of(context).enable_location),
      message: Text(S
          .of(context)
          .you_can_skip_this_now_but_if_you_do_some_feature_wont_work),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(S.of(context).try_again),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'landing', (route) => false);
          },
          child: Text(S.of(context).skip),
          isDestructiveAction: true,
        ),
      ],
    );
  }
}

class _PermenantlyDenied extends StatelessWidget {
  const _PermenantlyDenied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(S.of(context).permanently_denied),
      message: Text(S
          .of(context)
          .the_permisiion_permanently_denied_which_can_cause_some_features_to_malfunction),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            perms.openAppSettings();
            Navigator.pop(context);
          },
          child: Text(S.of(context).open_settings),
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'landing', (route) => false);
          },
          child: Text(S.of(context).skip),
          isDestructiveAction: true,
        ),
      ],
    );
  }
}
