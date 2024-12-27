import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_colors.dart';
import '../../common/router/navigation_route_observer.dart';
import '../../common/router/routes.dart';
import '../../common/extension/context_extension.dart';
import '../../common/widgets/app_tab_bar.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import 'bloc/my_foods_bloc.dart';
import 'custom_foods/custom_foods_page.dart';
import 'favorites/favorites_page.dart';
import 'recipes/ui/recipes_page.dart';

class MyFoodsPage extends StatefulWidget {
  const MyFoodsPage({required this.page, super.key});

  final int page;

  static MaterialPageRoute route({int page = 0}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.myFoods),
      builder: (_) => MyFoodsPage(page: page),
    );
  }

  static Future navigate({
    required BuildContext context,
    bool isReplace = false,
    int page = 0,
  }) async {
    if (isReplace) {
      if (NavigationRouteObserver.instance.contains(Routes.myFoods)) {
        bool isRemoved = false;
        return await Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.myFoods,
          (route) {
            final isCurrent = route.settings.name == Routes.myFoods;
            if (isCurrent && !isRemoved) {
              isRemoved = true;
              return false;
            }
            return isRemoved;
          },
          arguments: page,
        );
      } else {
        return await Navigator.pushReplacementNamed(
          context,
          Routes.myFoods,
          arguments: page,
        );
      }
    }
    return await Navigator.pushNamed(context, Routes.myFoods, arguments: page);
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
      initialIndex: widget.page,
      length: 3,
      vsync: this,
    );
    _pageController = PageController(initialPage: widget.page);
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
