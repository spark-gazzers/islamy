import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SurahIcon extends StatelessWidget {
  const SurahIcon({Key? key, required this.number, this.color})
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
