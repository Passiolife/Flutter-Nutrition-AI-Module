import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_constants.dart';
import '../../common/extension/context_extension.dart';
import '../../common/router/routes.dart';
import '../../common/util/overlay_widget.dart';
import '../../common/util/preference_store.dart';
import '../advisor/advisor_page.dart';
import '../diary/diary_page.dart';
import '../food_search/food_search_page.dart';
import '../home/home_page_old.dart';
import '../meal_plan/meal_plan_page.dart';
import '../my_foods_old/my_foods_page.dart';
import '../progress/progress_page.dart';
import '../use_image/select_photo/select_photo_page.dart';
import '../use_image/take_photo/take_photo_page.dart';
import '../voice_logging/voice_logging_page.dart';
import 'bloc/dashboard_bloc.dart';
import 'token_usage/token_usage_widget.dart';
import 'widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.page, super.key});

  final int? page;

  static MaterialPageRoute route({int? page}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.dashboard),
      builder: (_) => BlocProvider(
        create: (context) => DashboardBloc(),
        child: DashboardPage(page: page),
      ),
    );
  }

  // Static method to navigate to the DashboardPage.
  static Future navigate(BuildContext context,
      {int? page, bool removeUntil = false}) async {
    if (removeUntil) {
      return await Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.dashboard,
        (route) => route.isFirst,
        arguments: page,
      );
    } else {
      return await Navigator.pushNamed(
        context,
        Routes.dashboard,
        arguments: page,
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
      case 0:
        return HomePage(key: UniqueKey());
      case 1:
        return DiaryPage(key: UniqueKey());
      case 2:
        return const SizedBox.shrink();
      case 3:
        return MealPlanPage(key: UniqueKey());
      case 4:
        return ProgressPage(key: UniqueKey());
      default:
        return const SizedBox.shrink();
    }
  }

  DashboardBloc get _bloc => BlocProvider.of<DashboardBloc>(context);

  final OverlayUtil _overlayUtil = OverlayUtilImpl();

  @override
  void initState() {
    if (widget.page != null) {
      _selectedNavigationItem = widget.page!;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // _checkTokenTrackingStatus(context: context);
    });
    super.initState();
  }

  @override
  dispose() {
    _overlayUtil.remove();
    super.dispose();
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
    if (action == context.localization.scanABarcode) {
      await Navigator.pushNamed(
        context,
        Routes.foodScan,
      );
      _bloc.add(const RefreshEvent());

      // FoodScanPage.navigate(context);
    }
    // Action for when the text matches the 'search' localization.
    else if (action == context.localization.textSearch) {
      FoodSearchPage.navigate(context, needsReturn: false);
    } else if (action == context.localization.voiceLogging) {
      VoiceLoggingPage.navigate(context);
    } else if (action == context.localization.takePhotos) {
      TakePhotoPage.navigate(context);
      _bloc.add(const RefreshEvent());
    } else if (action == context.localization.selectPhotos) {
      await SelectPhotoPage.navigate(context);
      _bloc.add(const RefreshEvent());
    } else if (action == context.localization.aiAdvisor) {
      await AdvisorPage.navigate(context);
      _bloc.add(const RefreshEvent());
    } else if (action == context.localization.myFoods) {
      await MyFoodsPage.navigate(context: context);
      _bloc.add(const RefreshEvent());
    }
    // Default action if none of the above conditions are met.
    else {}
  }

  void _checkTokenTrackingStatus({required BuildContext context}) {
    final isEnabled = PreferenceStore.instance.getValue(
        AppCommonConstants.tokenTracking,
        AppCommonConstants.defaultTokenTracking);
    if (isEnabled) {
      _overlayUtil.show(
        context: context,
        child: const TokenUsageWidget(),
      );
    } else {
      _overlayUtil.remove();
    }
  }
}
