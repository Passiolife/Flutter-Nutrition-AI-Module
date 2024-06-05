import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_colors.dart';
import '../../common/util/context_extension.dart';
import '../diary/diary_page.dart';
import '../favorites/favorites_page.dart';
import '../food_scan/food_scan_page.dart';
import '../food_search/food_search_page.dart';
import '../home/home_page.dart';
import '../meal_plan/meal_plan_page.dart';
import '../progress/progress_page.dart';
import 'bloc/dashboard_bloc.dart';
import 'widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.page, super.key});

  final int? page;

  // Static method to navigate to the DashboardPage.
  static Future<void> navigate(BuildContext context,
      {int? page, bool removeUntil = false}) async {
    if (removeUntil) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage(page: page)),
        (route) => false,
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage(page: page)),
      );
    }
  }

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Selected navigation item index and item
  int _selectedNavigationItem = 0;

  // Widgets mapped with their corresponding titles
  Map<String?, Widget> get _widgets => {
        context.localization?.home: const HomePage(),
        context.localization?.diary: const DiaryPage(),
        '': const SizedBox.shrink(),
        context.localization?.mealPlan: const MealPlanPage(),
        context.localization?.progress: const ProgressPage(),
      };

  final _bloc = DashboardBloc();

  @override
  void initState() {
    if (widget.page != null) {
      _selectedNavigationItem = widget.page!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is PageUpdateState) {
            _selectedNavigationItem = state.index;
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.gray50,
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton:
                NotchFABWidget(onTapQuickAction: _navigateOnAction),
            bottomNavigationBar: BottomNavigationWidget(
              selectedPage: _selectedNavigationItem,
              onNavigationItemChange: (index) {
                if (index != _selectedNavigationItem) {
                  _bloc.add(PageUpdateEvent(index: index));
                }
              },
            ),
            body: IndexedStack(
              key: UniqueKey(),
              index: _selectedNavigationItem,
              children: _widgets.values.toList(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateOnAction(String? action) async {
    // Check the value of e.text against context.localization and perform actions accordingly.
    //
    // Action for when the text matches the 'scan' localization.
    if (action == context.localization?.foodScanner) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodScanPage(selectedDateTime: DateTime.now()),
          maintainState: false,
        ),
      );
    }
    // Action for when the text matches the 'search' localization.
    else if (action == context.localization?.textSearch) {
      FoodSearchPage.navigate(context, needsReturn: false);
    }
    // Action for when the text matches the 'favourite' localization.
    else if (action == context.localization?.favourites) {
      await FavoritesPage.navigate(context: context);
      _bloc.add(const RefreshEvent());
    }
    // Default action if none of the above conditions are met.
    else {}
  }
}
