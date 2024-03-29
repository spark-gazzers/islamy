import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/hadeeth/recently_opened_hadeeths.dart';
import 'package:islamy/view/home/home.dart';
import 'package:islamy/view/profile/profile.dart';
import 'package:islamy/view/quran/quran_screen.dart';

/// The main landing screen which provides as only [TabBarView]
/// and a [BottomNavigationBar].
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
          QuranScreen(),
          RecentlyOpenedHadeeths(),
          HomeScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) {
              return BottomNavigationBar(
                currentIndex: _controller.index,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: const Color(0xffbababa),
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                onTap: _controller.animateTo,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    label: S.of(context).quran,
                    icon: const Icon(CupertinoIcons.book),
                    activeIcon: const Icon(CupertinoIcons.book_fill),
                  ),
                  BottomNavigationBarItem(
                    label: S.of(context).hadeeth,
                    activeIcon: const Icon(Iconsax.archive5),
                    icon: const Icon(Iconsax.archive),
                  ),
                  BottomNavigationBarItem(
                    label: S.of(context).prayers,
                    icon: const Icon(Iconsax.clock),
                    activeIcon: const Icon(Iconsax.clock5),
                  ),
                  BottomNavigationBarItem(
                    label: S.of(context).profile,
                    icon: const Icon(Iconsax.user),
                    activeIcon: const Icon(Icons.person),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
