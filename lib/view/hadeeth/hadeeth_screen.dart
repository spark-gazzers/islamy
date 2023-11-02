import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_details.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_language.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/utils/store.dart';
import 'package:islamy/view/hadeeth/font_sizer.dart';
import 'package:islamy/view/hadeeth/widgets/hadeeth_language_selector.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class HadeethScreen extends StatefulWidget {
  const HadeethScreen({required this.hadeeth, super.key});
  final HadeethDetails hadeeth;

  @override
  State<HadeethScreen> createState() => _HadeethScreenState();
}

class _HadeethScreenState extends State<HadeethScreen> {
  late HadeethDetails _details;

  @override
  void initState() {
    _details = widget.hadeeth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SuperCupertinoNavigationBar(
        largeTitle: const Text(''),
        trailing: HadeethLanguageSelector(
          accept: (HadeethLanguage selected) {
            return true;
          },
        ),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FontSizer(
                      name: 'title',
                      defaultValue:
                          Theme.of(context).textTheme.titleLarge!.fontSize!,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ValueListenableBuilder<dynamic>(
                              valueListenable: Store.fontsSize.listenable,
                              builder:
                                  (BuildContext context, _, Widget? child) {
                                return Text(
                                  _details.hadeeth,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize:
                                            Store.fontsSize['hadeeth_title'],
                                      ),
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  if (_details.explanation != null)
                    _Section(
                      title: S.of(context).explanation,
                      text: _details.explanation,
                      sizerName: 'explanation',
                      defaultSize:
                          Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                  if (_details.hints.isNotEmpty) ...<Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 40,
                      ),
                      child: Divider(),
                    ),
                    _Section(
                      title: S.of(context).hints,
                      textBody: ListView.builder(
                        itemBuilder: (BuildContext context, int index) =>
                            Text('● ${_details.hints[index]}'),
                        itemCount: _details.hints.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    )
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 40,
                    ),
                    child: Divider(),
                  ),
                  _Section(
                    title: S.of(context).attribution,
                    text: _details.attribution,
                    oneLine: true,
                  ),
                  if (_details.reference != null) ...<Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 40,
                      ),
                      child: Divider(),
                    ),
                    _Section(
                      title: S.of(context).reference,
                      text: _details.reference,
                    )
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 40,
                    ),
                    child: Divider(),
                  ),
                  _Section(
                    title: S.of(context).grade,
                    text: _details.grade,
                    oneLine: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    this.text,
    this.textBody,
    this.sizerName,
    this.defaultSize,
    this.oneLine = false,
  });
  final String title;
  final String? text;
  final Widget? textBody;
  final bool oneLine;
  final String? sizerName;
  final double? defaultSize;
  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium;
    final TextStyle? bodyStyle = Theme.of(context).textTheme.bodyLarge;
    if (oneLine) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: titleStyle,
          ),
          Text(
            text!,
            style: bodyStyle,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: titleStyle,
            ),
            if (sizerName != null)
              FontSizer(
                name: sizerName!,
                defaultValue: defaultSize!,
              )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        ValueListenableBuilder<dynamic>(
          valueListenable: Store.fontsSize.listenable,
          builder: (BuildContext context, _, Widget? child) {
            return textBody ??
                Text(
                  text!,
                  style: sizerName == null
                      ? bodyStyle
                      : bodyStyle?.copyWith(
                          fontSize: Store.fontsSize[sizerName!],
                        ),
                  textAlign: TextAlign.justify,
                );
          },
        )
      ],
    );
  }
}
