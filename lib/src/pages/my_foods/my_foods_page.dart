import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_colors.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/app_tab_bar.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import 'bloc/my_foods_bloc.dart';
import 'custom_foods/custom_foods_page.dart';
import 'favorites/favorites_page.dart';
import 'recipes/ui/recipes_page.dart';

class MyFoodsPage extends StatefulWidget {
  const MyFoodsPage({required this.index, super.key});

  final int index;

  static Future navigate({
    required BuildContext context,
    bool isReplace = false,
    int index = 0,
  }) async {
    if (isReplace) {
      bool isPageInStack = false;

      // Check if MyFoodsPage is already in the stack
      Navigator.of(context).popUntil((route) {
        // Compare the runtimeType of the route's builder with MyFoodsPage
        if (route is MaterialPageRoute &&
            route.builder(context).runtimeType ==
                MyFoodsPage(index: index).runtimeType) {
          isPageInStack = true;
          return true; // Stop checking
        }
        return false; // Continue checking other routes
      });

      // If the page is not in the stack, navigate to it and remove previous routes
      if (!isPageInStack) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyFoodsPage(index: index)),
        );
      }

      bool isCurrentScreen = false;
      bool isCurrentScreenPopped = false;
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MyFoodsPage(index: index),
        ),
        (route) {
          if (isCurrentScreenPopped) {
            return true;
          }

          isCurrentScreen = route is MaterialPageRoute &&
              route.builder(context).runtimeType ==
                  MyFoodsPage(index: index).runtimeType;
          if (isCurrentScreen && !isCurrentScreenPopped) {
            isCurrentScreenPopped = true;
            return false;
          }
          return isCurrentScreen;
        },
      );
      /*Navigator.pop(context);
      return await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyFoodsPage(index: index),
        ),
      );*/
    }
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyFoodsPage(index: index),
      ),
    );
  }

  @override
  State<MyFoodsPage> createState() => _MyFoodsPageState();
}

class _MyFoodsPageState extends State<MyFoodsPage>
    with SingleTickerProviderStateMixin {
  List<Tab> get _tabs => [
        Tab(text: context.localization?.custom ?? ''),
        Tab(text: context.localization?.recipes ?? ''),
        Tab(text: context.localization?.favorites ?? ''),
      ];

  List<Widget> get _tabsWidget => [
        const CustomFoodsPage(),
        const RecipesPage(),
        const FavoritesPage(),
      ];

  final _bloc = MyFoodsBloc();

  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.index,
      length: 3,
      vsync: this,
    );
    _pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
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
            onTap: (page) {
              _pageController.jumpToPage(page);
            },
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _tabsWidget,
              onPageChanged: (page) {
                _tabController.animateTo(page);
              },
            ),
          ),
          (context.bottomPadding + 8).verticalSpace,
        ],
      ),
    );
  }
}
