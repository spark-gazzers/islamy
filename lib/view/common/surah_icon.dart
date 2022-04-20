import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget that shows [int] as icons to provide as the specified
///  in the design below using [ThemeData.primaryColor] as the icon color and
/// the [number] text.
// TODO(psyonixFx): add the doc design asset
class IslamicStarIcon extends StatelessWidget {
  const IslamicStarIcon({Key? key, required this.number, this.color})
      : super(key: key);

  final int number;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Stack(
        children: <Align>[
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/surah_icon.svg',
              color: color ?? Theme.of(context).primaryColor,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
