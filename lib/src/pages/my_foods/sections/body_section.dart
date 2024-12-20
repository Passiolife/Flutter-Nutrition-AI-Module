import 'package:flutter/material.dart';

import '../custom_foods/custom_foods_page.dart';
import '../favorites/favorites_page.dart';
import '../recipes/ui/recipes_page.dart';

class BodySection extends StatefulWidget {
  const BodySection({required this.index, super.key});

  final int index;

  @override
  State<BodySection> createState() => _BodySectionState();
}

class _BodySectionState extends State<BodySection> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late PageController _pageController;

  late final List<Widget> _tabsWidget = [
    const CustomFoodsPage(),
    const RecipesPage(),
    const FavoritesPage(),
  ];

  bool _isTabChange = false;


  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.index,
      length: 3,
      vsync: this,
    );
    _pageController = PageController(initialPage: widget.index);

    _pageController.addListener(() {
      if(!_isTabChange) {
        _tabController.animateTo(
          _pageController.page?.round() ?? 0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      }
    });

    _tabController.addListener(() {
      _isTabChange = true;
      _pageController.animateToPage(
        _tabController.index ?? 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: _pageController,
        children: _tabsWidget,
        onPageChanged: (page) {
          _tabController.animateTo(
            page,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        },
      ),
    );
  }
}
