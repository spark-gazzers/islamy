import 'package:flutter/cupertino.dart';

/// Simple button to provide as long as pressed action UI.
///
/// The widget dosn't allow customizing the UI using parameter so consider
/// wrapping with specified theme.
class LongPressedIconButton extends StatefulWidget {
  const LongPressedIconButton({
    Key? key,
    required this.icon,
    required this.onUpdate,
  }) : super(key: key);

  /// The shown icon.
  final IconData icon;

  /// Will be called when tapped once or if the button is long pressed
  /// then it will be called repeatedly until the user lift up.
  final VoidCallback onUpdate;

  @override
  State<LongPressedIconButton> createState() => _LongPressedIconButtonState();
}

class _LongPressedIconButtonState extends State<LongPressedIconButton> {
  static const Duration _startingSpacer = Duration(milliseconds: 300);
  bool _isDown = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        onLongPress: () {
          Duration spacer = _startingSpacer;
          _isDown = true;
          Future.doWhile(() async {
            await Future<void>.delayed(spacer);
            if (spacer.inMilliseconds > 100) {
              spacer =
                  Duration(microseconds: (spacer.inMicroseconds * .9).toInt());
            }
            widget.onUpdate();
            return _isDown;
          });
        },
        onLongPressEnd: (_) {
          _isDown = false;
        },
        onTap: widget.onUpdate,
        child: Icon(widget.icon),
      ),
    );
  }
}
