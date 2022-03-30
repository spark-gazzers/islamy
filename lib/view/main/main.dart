import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/profile/profile.dart';
import 'package:islamy/view/quran/quran_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this, initialIndex: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const ProfileScreen(),
          const QuranScreen(),
          for (var i = 0; i < 2; i++) const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Builder(builder: (context) {
        return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return BottomNavigationBar(
                currentIndex: _controller.index,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: const Color(0xffbababa),
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                onTap: (index) {
                  _controller.animateTo(index);
                },
                items: [
                  BottomNavigationBarItem(
                    label: S.of(context).home,
                    activeIcon: const Icon(Iconsax.home_15),
                    icon: const Icon(Iconsax.home_14),
                  ),
                  BottomNavigationBarItem(
                    label: S.of(context).quran,
                    icon: const Icon(Iconsax.book_square),
                    activeIcon: const Icon(Iconsax.book_square5),
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
            });
      }),
    );
  }
}
