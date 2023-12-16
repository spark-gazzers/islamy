import 'package:flutter/cupertino.dart';
import 'package:islamy/generated/l10n/l10n.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CupertinoActivityIndicator(
          animating: true,
        ),
        Text(S.of(context).loading)
      ],
    );
  }
}
