import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/store.dart';

class DefaultSetupsScreen extends StatelessWidget {
  const DefaultSetupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                const Image(
                  filterQuality: FilterQuality.high,
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                ),
                Text(
                  'iSlamy',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                _SetupTile(
                  name: S.of(context).language,
                  route: 'route',
                  listenable: Store.localeListner,
                  valueToString: () => Store.locale.languageCode,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SetupTile extends StatefulWidget {
  const _SetupTile({
    required this.name,
    required this.route,
    required this.listenable,
    required this.valueToString,
    // ignore: unused_element
    super.key,
  });
  final String name;
  final String route;
  final ValueListenable<dynamic> listenable;
  final String Function() valueToString;

  @override
  State<_SetupTile> createState() => _SetupTileState();
}

class _SetupTileState extends State<_SetupTile> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
      builder: (_, __, ___) {
        return ListTile(
          title: Text(widget.name),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).pushNamed(widget.route);
          },
          subtitle: Text(widget.valueToString()),
        );
      },
      valueListenable: widget.listenable,
    );
  }
}
