import 'package:flutter/cupertino.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/material.dart';

/// Wrapper around [TabBar] to create [CupertinoSlidingSegmentedControl]
/// like in the design below
/// using [ThemeData.primaryColor] selected color.
// TODO(psyonixFx): add the doc design assets
class SlidingSegmentedControl extends StatelessWidget {
  const SlidingSegmentedControl({
    Key? key,
    this.controller,
    required this.tabs,
    this.isScrollable = false,
  }) : super(key: key);

  final TabController? controller;
  final List<Widget> tabs;
  final bool isScrollable;
  TabController _controller(BuildContext context) =>
      controller ?? DefaultTabController.of(context)!;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 10,
      shadowColor: Colors.white54,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TabBar(
          tabs: tabs,
          controller: _controller(context),
          isScrollable: isScrollable,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xff2A4250),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
