import 'package:flutter/material.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_common_constants.dart';
import '../../common/router/routes.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../diary/diary_page.dart';
import '../home/home_page.dart';
import 'widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.page, super.key});

  final String? page;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Selected navigation item index and item
  ({int index, NavigationItem? item})? _selectedNavigationItem;

  // Widgets mapped with their corresponding titles
  Map<String?, Widget> get _widgets => {
        context.localization?.home: HomePage(
          customAppBarKey: _customAppBarKey,
          key: _homePageKey,
        ),
        context.localization?.diary: const DiaryPage(),
        '': const SizedBox.shrink(),
        context.localization?.mealPlan: const Center(child: Text('Meal Plan')),
        context.localization?.progress: const Center(child: Text('Progress')),
      };

  final GlobalKey<CustomAppBarWidgetState> _customAppBarKey =
      GlobalKey<CustomAppBarWidgetState>();

  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();

  int get defaultIndex => widget.page != null
      ? _widgets.keys.toList().indexWhere((element) => element == widget.page)
      : 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hides the custom app bar menu
        _customAppBarKey.currentState?.hideMenu();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.gray50,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            NotchFABWidget(onTapQuickAction: _navigateOnAction),
        bottomNavigationBar: BottomNavigationWidget(
          selectedPage: _selectedNavigationItem?.item?.name ?? widget.page,
          onNavigationItemChange: (item, index) {
            setState(() {
              _selectedNavigationItem = (index: index, item: item);
            });
          },
        ),
        body: IndexedStack(
          index: _selectedNavigationItem?.index ?? defaultIndex,
          children: _widgets.values.toList(),
        ),
      ),
    );
  }

  void _navigateOnAction(String? action) {
    // Check the value of e.text against context.localization and perform actions accordingly.
    //
    // Action for when the text matches the 'scan' localization.
    if (action == context.localization?.foodScanner) {
      Navigator.pushNamed(
        context,
        Routes.foodScanPage,
        arguments: {
          AppCommonConstants.dateTime: _homePageKey.currentState?.selectedDate
        },
      );
    }
    // Action for when the text matches the 'search' localization.
    else if (action == context.localization?.textSearch) {
      Navigator.pushNamed(context, Routes.foodSearchPage, arguments: false);
    }
    // Action for when the text matches the 'favourite' localization.
    else if (action == context.localization?.favourite) {
    }
    // Default action if none of the above conditions are met.
    else {}
  }
}
