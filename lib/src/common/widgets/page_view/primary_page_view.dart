import 'package:flutter/material.dart';

import 'base_page_view.dart';

class PrimaryPageView extends StatelessWidget {
  const PrimaryPageView({
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
  Widget build(BuildContext context) {
    return BasePageView(
      initialPage: initialPage,
      controller: controller,
      onPageChanged: onPageChanged,
      children: children,
    );
  }
}
