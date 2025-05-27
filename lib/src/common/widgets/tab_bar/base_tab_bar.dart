import 'package:flutter/material.dart';

class BaseTabBar extends StatefulWidget {
  const BaseTabBar({
    required this.tabs,
    this.controller,
    this.onTap,
    this.initialIndex = 0,
    this.padding = EdgeInsets.zero,
    this.isEnable = true,
    super.key,
  });

  final List<Tab> tabs;
  final int initialIndex;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final EdgeInsets padding;
  final bool isEnable;

  @override
  State<BaseTabBar> createState() => _BaseTabBarState();
}

class _BaseTabBarState extends State<BaseTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = widget.controller ??
        TabController(
          initialIndex: widget.initialIndex,
          length: widget.tabs.length,
          vsync: this,
        );
  }

  @override
  void didUpdateWidget(covariant BaseTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _tabController.animateTo(widget.initialIndex);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isEnable,
      child: TabBar(
        padding: widget.padding,
        controller: _tabController,
        tabs: widget.tabs,
        onTap: _onTabChange,
      ),
    );
  }

  void _onTabChange(int value) {
    _tabController.animateTo(value, duration: Duration(milliseconds: 500), curve: Curves.linear);
    widget.onTap?.call(value);
  }
}
