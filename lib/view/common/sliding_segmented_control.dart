import 'package:flutter/material.dart';

class SlidingSegmentedControl extends StatelessWidget {
  final TabController? controller;
  final List<Widget> tabs;
  final bool isScrollable;
  const SlidingSegmentedControl({
    Key? key,
    this.controller,
    required this.tabs,
    this.isScrollable = false,
  }) : super(key: key);

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
          Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBar(
          tabs: tabs,
          controller: _controller(context),
          isScrollable: isScrollable,
          labelStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xff2A4250),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14.0,
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
