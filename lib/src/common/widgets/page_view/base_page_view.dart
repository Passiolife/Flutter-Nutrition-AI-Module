import 'package:flutter/material.dart';

class BasePageView extends StatefulWidget {
  const BasePageView({
    required this.children,
    this.initialPage = 0,
    this.controller,
    this.onPageChanged,
    super.key,
  });

  final int initialPage;
  final PageController? controller;
  final List<Widget> children;
  final ValueChanged<int>? onPageChanged;

  @override
  State<BasePageView> createState() => _BasePageViewState();
}

class _BasePageViewState extends State<BasePageView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        widget.controller ?? PageController(initialPage: widget.initialPage);
    _setListener();
  }

  @override
  void didUpdateWidget(covariant BasePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.initialPage != oldWidget.initialPage) {
      _removeListener();
      _pageController.animateToPage(widget.initialPage, duration: Duration(milliseconds: 250), curve: Curves.linear);
      _setListener();
    }
  }

  @override
  void dispose() {
    _removeListener();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: widget.children,
    );
  }

  void _setListener() {
    _pageController.addListener(_listener);
  }

  void _removeListener() {
    _pageController.removeListener(_listener);
  }

  void _listener() {
    widget.onPageChanged?.call(_pageController.page!.round());
  }
}
