import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_colors.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/app_tab_bar.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/sub_tab_bar.dart';
import 'bloc/my_foods_bloc.dart';
import 'custom_foods/custom_foods_page.dart';

class MyFoodsPage extends StatefulWidget {
  const MyFoodsPage({super.key});

  static Future navigate({
    required BuildContext context,
    bool isReplace = false,
  }) async {
    if (isReplace) {
      return await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MyFoodsPage(),
        ),
      );
    }
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyFoodsPage(),
      ),
    );
  }

  @override
  State<MyFoodsPage> createState() => _MyFoodsPageState();
}

class _MyFoodsPageState extends State<MyFoodsPage>
    with SingleTickerProviderStateMixin
    implements TabChangeListener {
  List<Tab> get _tabs => [
        Tab(
          text: context.localization?.customFoods ?? '',
        ),
        Tab(
          text: context.localization?.recipes ?? '',
        ),
      ];

  List<Widget> get _tabsWidget => [
        const CustomFoodsPage(),
        Container(),
      ];

  final _bloc = MyFoodsBloc();

  TabController? _tabController;
  PageController? _pageController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();

    _tabController?.addListener(() {
      _pageController?.animateToPage(
        _tabController?.index ?? 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController?.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Column(
        children: [
          CustomAppBarWidget(
            title: context.localization?.myFoods,
            isMenuVisible: false,
          ),
          AppTabBar(
            tabs: _tabs,
            controller: _tabController,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _tabsWidget,
              onPageChanged: (page) {
                _tabController?.animateTo(
                  page,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linear,
                );
              },
            ),
          ),
          (context.bottomPadding + 8).verticalSpace,
        ],
      ),
    );
  }

  @override
  void onTabChange(String tab) {}
}
