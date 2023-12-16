import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget that shows [int] as icons to provide as the specified
///  in the design below using [ThemeData.primaryColor] as the icon color and
/// the [number] text.
// TODO(psyonixFx): add the doc design asset
class IslamicStarIcon extends StatelessWidget {
  const IslamicStarIcon({
    required this.number,
    super.key,
    this.color,
    this.style,
    this.size = 38,
  });

  final int number;
  final double size;
  final Color? color;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Stack(
        children: <Align>[
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/surah_icon.svg',
              width: size,
              colorFilter: ColorFilter.mode(
                  color ?? Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              child: Text(
                number.toString(),
                style: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
