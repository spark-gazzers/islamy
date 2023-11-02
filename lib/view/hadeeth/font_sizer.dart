import 'package:flutter/material.dart';
import 'package:islamy/utils/store.dart';

class FontSizer extends StatelessWidget {
  const FontSizer({
    required this.name,
    required this.defaultValue,
    this.tick = 0.5,
    super.key,
  });
  final String name;
  final double tick;
  final double defaultValue;
  double get size => Store.fontsSize[name] ?? defaultValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Store.fontsSize[name] = size + tick;
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('+'),
            ),
          ),
        ),
        ValueListenableBuilder<dynamic>(
          valueListenable: Store.fontsSize.listenable,
          builder: (BuildContext context, _, Widget? child) {
            return Text(size.toStringAsFixed(1));
          },
        ),
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Store.fontsSize[name] = size - tick;
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('-'),
            ),
          ),
        ),
      ],
    );
  }
}
