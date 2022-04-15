import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/utils/store.dart';
import 'package:islamy/view/common/rounded_icon.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: Brightness.dark,
        heroTag: 'profile_navigation_bar_tag',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).profile),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 91.0),
          ClipOval(
            child: Container(
              color: Colors.black,
              width: 100,
              height: 100,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 24.0),
            child: Text(
              'Ahmed Ali',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 28.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: Store.muteNotficationListner,
                  builder: (_, __, ___) {
                    return ListTile(
                      leading: const RoundedIcon(Iconsax.notification),
                      title: Text(S.of(context).mute_notifications),
                      trailing: CupertinoSwitch(
                          value: Store.muteNotfication,
                          onChanged: (_) {
                            Store.muteNotfication = !Store.muteNotfication;
                          }),
                      onTap: () {
                        Store.muteNotfication = !Store.muteNotfication;
                      },
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: Store.localeListner,
                  builder: (_, __, ___) {
                    return ListTile(
                      leading: const RoundedIcon(Iconsax.global),
                      title: Text(S.of(context).language),
                      trailing: Text(
                        Helper.localization.nameOf(Store.locale),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'select_language');
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const RoundedIcon(Iconsax.book_saved),
                  title: Text(S.of(context).quran_settings),
                  trailing: const Icon(CupertinoIcons.forward),
                  onTap: () {
                    Navigator.pushNamed(context, 'quran_settings');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
