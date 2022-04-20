import 'package:flutter/material.dart';

/// Wrapper around [Icon] to provide the icons as specified in the design below
/// using [ThemeData.primaryColor] as the icon color and
/// [Color(0xffdfefeb)] for the surrounding.
// TODO(psyonixFx): add the doc design assets
class RoundedIcon extends StatelessWidget {
  const RoundedIcon(this.icon, {Key? key}) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffdfefeb),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(8.87),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
