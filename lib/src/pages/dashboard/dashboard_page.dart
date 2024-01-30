import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/dimens.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/util/user_session.dart';
import '../edit_food/edit_food_page.dart';
import '../favorite/favorite_page.dart';
import '../food_search/food_search_page.dart';
import '../multi_food_scan/multi_food_scan_page.dart';
import '../profile/profile_page.dart';
import '../progress/progress_page.dart';
import '../quick_food_scan/quick_food_scan_page.dart';
import 'bloc/dashboard_bloc.dart';
import 'dialogs/add_item_dialog.dart';
import 'dialogs/more_actions_dialog.dart';
import 'widgets/add_item_button_widget.dart';
import 'widgets/calories_chart.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/macros_chart.dart';
import 'widgets/tab_all_day_widget.dart';
import 'widgets/tab_bar_widget.dart';
import 'widgets/tab_breakfast_widget.dart';
import 'widgets/tab_dinner_widget.dart';
import 'widgets/tab_lunch_widget.dart';
import 'widgets/tab_snack_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static void navigate(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const DashboardPage()));
  }

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  /// [_bloc] is use to call the events.
  final _bloc = DashboardBloc();

  DateTime _selectedDate = DateTime.now();

  late TabController _tabController;
  late PageController _pageController;

  /// [_tabs] contains the Meal Time data.
  List<String> get _tabs => [
        context.localization?.allDay ?? '',
        context.localization?.breakfast ?? '',
        context.localization?.lunch ?? '',
        context.localization?.dinner ?? '',
        context.localization?.snack ?? '',
      ];

  final List<FoodRecord?> _foodRecordsList = [];

  // [_userSession] keep the user information and profile.
  final _userSession = UserSession.instance;

  // [_totalCalories] contains the calories which foods are logged.
  int _totalCalories = 0;

  // [_caloriesTarget] contains the calories target from user profile.
  int get _caloriesTarget => _userSession.userProfile?.caloriesTarget ?? 0;

  ({
    int totalCarbs,
    int totalProtiens,
    int totalFats,
    String carbsValue,
    String proteinsValue,
    String fatsValue
  }) macroData = (
    totalCarbs: 0,
    totalProtiens: 0,
    totalFats: 0,
    carbsValue: '0%',
    proteinsValue: '0%',
    fatsValue: '0%'
  );

  bool isMacroGraphInPercentage = true;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.passioBackgroundWhite,
      resizeToAvoidBottomInset: false,
      appBar: DashboardAppBar(
        onDateChange: _onChangeDate,
        onTapMore: _showMoreActions,
        selectedDateTime: _selectedDate,
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is GetFoodRecordFailureState) {
            _handleFoodRecordFailureState(state: state);
          } else if (state is GetFoodRecordSuccessState) {
            _handleFoodRecordSuccessState(state: state);
          }

          /// States for DoFoodInsertEvent
          else if (state is FoodInsertSuccessState) {
            _handleFoodInsertSuccessState(state: state);
          } else if (state is FoodInsertFailureState) {
            _handleFoodInsertFailureState(state: state);
          }

          // States for [FavouriteSuccessState]
          else if (state is FavoriteFailureState) {
            _handleFavoriteFailureState(state: state);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: RefreshIndicator.adaptive(
                  notificationPredicate: (notification) => true,
                  onRefresh: () {
                    _doFetchRecords();
                    return Future.delayed(const Duration(seconds: 1));
                  },
                  child: NestedScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            SizedBox(
                              height: Dimens.h160,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _reloadGraph,
                                child: IgnorePointer(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CaloriesChart(
                                          key: UniqueKey(),
                                          caloriesTarget: _caloriesTarget,
                                          totalCalories: _totalCalories,
                                        ),
                                      ),
                                      Expanded(
                                        child: MacrosChart(
                                          key: UniqueKey(),
                                          data: macroData,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimens.h16),
                          ]),
                        ),
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: TabBarWidgetDelegate(
                                controller: _tabController, tabs: _tabs),
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: EdgeInsets.only(top: Dimens.h40),
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          TabAllDayWidget(
                            data: _foodRecordsList,
                            onDeleteItem: _onDeleteItem,
                            onEditItem: _onEditItem,
                          ),
                          TabBreakfastWidget(
                            data: _foodRecordsList,
                            onDeleteItem: _onDeleteItem,
                            onEditItem: _onEditItem,
                          ),
                          TabLunchWidget(
                            data: _foodRecordsList,
                            onDeleteItem: _onDeleteItem,
                            onEditItem: _onEditItem,
                          ),
                          TabDinnerWidget(
                            data: _foodRecordsList,
                            onDeleteItem: _onDeleteItem,
                            onEditItem: _onEditItem,
                          ),
                          TabSnackWidget(
                            data: _foodRecordsList,
                            onDeleteItem: _onDeleteItem,
                            onEditItem: _onEditItem,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                left: 0,
                right: 0,
                bottom: Dimens.h32,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AddItemButtonWidget(onTap: _showAddItemActions),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMoreActions() {
    MoreActionsDialog.show(
      context: context,
      onTapItem: (dialogContext, item) async {
        Navigator.pop(dialogContext);
        if (item == context.localization?.progress) {
          ProgressPage.navigate(context, _selectedDate);
        } else if (item == context.localization?.favorites) {
          _openFavouritePage();
        } else if (item == context.localization?.profile) {
          await ProfilePage.navigate(context);
          _doFetchRecords();
        }
      },
    );
  }

  void _showAddItemActions() {
    AddItemDialog.show(
      context: context,
      onTapItem: (dialogContext, item) async {
        Navigator.pop(dialogContext);

        if (item == context.localization?.quickFoodScan) {
          // var hasAdded = await Navigator.push(context, MaterialPageRoute(builder: (_) => QuickFoodScanPage(selectedDateTime: _selectedDate)));
          bool? hasAdded =
              await QuickFoodScanPage.navigate(context, _selectedDate);
          if (hasAdded is bool && hasAdded) {
            _doFetchRecords();
          }
        } else if (item == context.localization?.multiFoodScan) {
          bool? hasAdded =
              await MultiFoodScanPage.navigate(context, _selectedDate);

          if (hasAdded ?? false) {
            _doFetchRecords();
          }
        } else if (item == context.localization?.byTextSearch) {
          PassioIDAndName? data = await FoodSearchPage.navigate(context);
          if (data != null) {
            _bloc.add(DoFoodInsertEvent(data: data, dateTime: _selectedDate));
          }
        } else if (item == context.localization?.fromFavorites) {
          _openFavouritePage();
        }
      },
    );
  }

  void _doFetchRecords() {
    _bloc.add(GetFoodRecordsEvent(dateTime: _selectedDate));
  }

  void _onChangeDate(DateTime dateTime) {
    _selectedDate = dateTime;
    _doFetchRecords();
  }

  void _handleFoodRecordFailureState(
      {required GetFoodRecordFailureState state}) {
    context.showSnackbar(text: state.message);
  }

  void _handleFoodRecordSuccessState(
      {required GetFoodRecordSuccessState state}) {
    _foodRecordsList.clear();
    _foodRecordsList.addAll(state.data);
    _updateGraph();
  }

  void _initialize() {
    /// Initialize the tab related things.
    _tabController = TabController(length: 5, vsync: this);
    _pageController =
        PageController(initialPage: _tabController.index, keepPage: true);
    _tabController.addListener(() {
      _pageController.jumpToPage(_tabController.index);
    });

    /// Here, calling the Firebase API to get the food logs from firebase.
    _doFetchRecords();
  }

  void _updateGraph() {
    if (_foodRecordsList.isNotEmpty) {
      // Calculating the data for calories chart.
      _totalCalories = _foodRecordsList
              .map((e) => e?.totalCalories)
              .reduce((value, element) => (value ?? 0) + (element ?? 0))
              ?.roundToDouble()
              .toInt() ??
          0;

      // Calculating the data for macros chart.
      final carbs = _foodRecordsList
              .map((e) => e?.totalCarbs)
              .reduce((value, element) => (value ?? 0) + (element ?? 0)) ??
          0;
      final proteins = _foodRecordsList
              .map((e) => e?.totalProteins)
              .reduce((value, element) => (value ?? 0) + (element ?? 0)) ??
          0;
      final fats = _foodRecordsList
              .map((e) => e?.totalFat)
              .reduce((value, element) => (value ?? 0) + (element ?? 0)) ??
          0;
      final macro = calculatePercentageInPlace(carbs, proteins, fats);

      macroData = (
        totalCarbs: macro.$1,
        totalProtiens: macro.$2,
        totalFats: macro.$3,
        carbsValue:
            (isMacroGraphInPercentage) ? '${macro.$1}%' : '${carbs.round()}g',
        proteinsValue: (isMacroGraphInPercentage)
            ? '${macro.$2}%'
            : '${proteins.round()}g',
        fatsValue:
            (isMacroGraphInPercentage) ? '${macro.$3}%' : '${fats.round()}g',
      );
    } else {
      // Updating calories to 0.
      _totalCalories = 0;
      // Updating macroData to 0
      macroData = (
        totalCarbs: 0,
        totalProtiens: 0,
        totalFats: 0,
        carbsValue: (isMacroGraphInPercentage) ? '0%' : '0g',
        proteinsValue: (isMacroGraphInPercentage) ? '0%' : '0g',
        fatsValue: (isMacroGraphInPercentage) ? '0%' : '0g',
      );
    }
  }

  (int carbs, int proteins, int fats) calculatePercentageInPlace(
      double carbs, double proteins, double fats) {
    int rCarbs = 0;
    int rPro = 0;
    int rFat = 0;
    final sum = 4 * (carbs + proteins) + 9 * fats;
    if (sum > 0) {
      rCarbs = (4 * carbs / sum * 100).round();
      rPro = (4 * proteins / sum * 100).round();
      rFat = (9 * fats / sum * 100).round();
    }
    return (rCarbs, rPro, rFat);
  }

  void _onDeleteItem(int index, FoodRecord? data) {
    _bloc.add(DeleteFoodRecordEvent(data: data));
    _foodRecordsList.remove(data);
    _updateGraph();
    _bloc.add(RefreshFoodRecordEvent());
  }

  Future<void> _onEditItem(int index, FoodRecord? data) async {
    // Opening edit food page and awaiting for the result from edit page based on user action if action is save or favourite then perform action.
    bool? result = await EditFoodPage.navigate(context,
        index: index, foodRecord: data, dateTime: _selectedDate);
    if (result != null && result) {
      _doFetchRecords();
    }
  }

  void _reloadGraph() {
    isMacroGraphInPercentage = !isMacroGraphInPercentage;
    _updateGraph();
    _bloc.add(RefreshFoodRecordEvent());
  }

  void _handleFoodInsertSuccessState({required FoodInsertSuccessState state}) {
    _doFetchRecords();
  }

  void _handleFoodInsertFailureState({required FoodInsertFailureState state}) {
    context.showSnackbar(text: state.message);
  }

  void _handleFavoriteFailureState({required FavoriteFailureState state}) {
    context.showSnackbar(text: state.message);
  }

  /// Opens the favorite page and awaits changes, triggering a fetch of records if changes are detected.
  Future<void> _openFavouritePage() async {
    // Navigate to the favorite page and await changes.
    bool? hasChanges = await FavoritePage.navigate(context);

    // If there are changes, trigger fetching of records.
    if (hasChanges ?? false) {
      _doFetchRecords();
    }
  }
}
