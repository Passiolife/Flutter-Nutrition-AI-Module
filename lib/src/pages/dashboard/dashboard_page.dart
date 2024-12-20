import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_colors.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/overlay_widget.dart';
import '../advisor/advisor_page.dart';
import '../diary/diary_page.dart';
import '../food_scan/food_scan_page.dart';
import '../food_search/food_search_page.dart';
import '../home/home_page.dart';
import '../meal_plan/meal_plan_page.dart';
import '../my_foods/my_foods_page.dart';
import '../progress/progress_page.dart';
import '../use_image/select_photo/select_photo_page.dart';
import '../use_image/take_photo/take_photo_page.dart';
import '../voice_logging/voice_logging_page.dart';
import 'bloc/dashboard_bloc.dart';
import 'token_usage/bloc/token_usage_bloc.dart';
import 'token_usage/token_usage_widget.dart';
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
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => DashboardBloc(),
            child: DashboardPage(page: page),
          ),
        ),
        (route) => route.isFirst,
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => DashboardBloc(),
            child: DashboardPage(page: page),
          ),
        ),
      );
    }
  }

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Selected navigation item index and item
  int _selectedNavigationItem = 0;

  Widget? _getPage(int index) {
    switch (index) {
      case 1:
        return DiaryPage(key: UniqueKey(),);
      case 2:
        return const SizedBox.shrink();
      case 3:
        return MealPlanPage(key: UniqueKey(),);
      case 4:
        return ProgressPage(key: UniqueKey(),);
      default:
        return HomePage(key: UniqueKey(),);
    }
  }

  DashboardBloc get _bloc => BlocProvider.of<DashboardBloc>(context);

  final OverlayUtil _overlayUtil = OverlayUtil();

  @override
  void initState() {
    if (widget.page != null) {
      _selectedNavigationItem = widget.page!;
    }
    _bloc.add(const RequestTokenTrackingEvent());
    TokenUsageBloc.instance.add(const StartListeningEvent());

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
          } else if (state is TokenTrackingUpdateState) {
            _handleTokenTrackingSuccessState(context: context, state: state);
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
            body: _getPage(_selectedNavigationItem),
            /*IndexedStack(
              index: _selectedNavigationItem,
              children: _widgets.values.toList(),
            ),*/
          );
        },
      ),
    );
  }

  Future<void> _navigateOnAction(String? action) async {
    // Check the value of e.text against context.localization and perform actions accordingly.
    //
    // Action for when the text matches the 'scan' localization.
    if (action == context.localization?.scanABarcode) {
      FoodScanPage.navigate(context);
    }
    // Action for when the text matches the 'search' localization.
    else if (action == context.localization?.textSearch) {
      FoodSearchPage.navigate(context, needsReturn: false);
    } else if (action == context.localization?.voiceLogging) {
      VoiceLoggingPage.navigate(context);
    } else if (action == context.localization?.takePhotos) {
      TakePhotoPage.navigate(context);
    } else if (action == context.localization?.selectPhotos) {
      SelectPhotoPage.navigate(context);
    }
    else if (action == context.localization?.aiAdvisor) {
      await AdvisorPage.navigate(context);
      _bloc.add(const RefreshEvent());
    } else if (action == context.localization?.myFoods) {
      await MyFoodsPage.navigate(context: context);
      _bloc.add(const RefreshEvent());
    }
    // Default action if none of the above conditions are met.
    else {}
  }

  void _handleTokenTrackingSuccessState({
    required TokenTrackingUpdateState state,
    required BuildContext context,
  }) {
    if (state.enabled) {
      _overlayUtil.show(
        context: context,
        child: TokenUsageWidget(_overlayUtil),
      );
    } else {
      _overlayUtil.remove();
    }
  }
}
