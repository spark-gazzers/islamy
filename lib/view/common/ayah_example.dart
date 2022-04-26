import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/view/common/ayah_span.dart';

class AyahExample extends StatefulWidget {
  const AyahExample({Key? key, this.fontFamily}) : super(key: key);
  final String? fontFamily;
  @override
  State<AyahExample> createState() => _AyahExampleState();
}

class _AyahExampleState extends State<AyahExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animationView;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationView =
        CurvedAnimation(parent: _animationController, curve: Curves.ease);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              S.of(context).example,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            IconButton(
              onPressed: () {
                switch (_animationController.status) {
                  case AnimationStatus.dismissed:
                  case AnimationStatus.reverse:
                    _animationController.forward();
                    break;
                  case AnimationStatus.forward:
                  case AnimationStatus.completed:
                    _animationController.reverse();
                    break;
                }
              },
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationView,
              ),
            ),
          ],
        ),
        SizeTransition(
          sizeFactor: _animationView,
          child: Center(
            child: ValueListenableBuilder<dynamic>(
              valueListenable: QuranStore.settings.quranRenderSettingListenable,
              builder: (BuildContext context, _, Widget? child) => Text.rich(
                AyahSpan(
                  includeNumber: false,
                  ayah: QuranManager.getQuran(
                    QuranStore.settings.defaultTextEdition,
                  ).surahs.first.ayahs.first,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
