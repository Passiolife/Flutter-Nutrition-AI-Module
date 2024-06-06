import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/food_record/meal_label.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/util/string_extensions.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../edit_food/edit_food_page.dart';
import 'bloc/meal_plan_bloc.dart';
import 'widgets/widgets.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage>
    implements HeaderListener, MealListener {
  final ScrollController _scrollController = ScrollController();

  final _bloc = MealPlanBloc();

  int _selectedDay = 1;
  PassioMealPlan? _selectedMealPlan;

  List<PassioMealPlan> _mealPlans = [];

  List<PassioMealPlanItem> _mealPlanItems = [];

  bool _isLoading = true;

  PassioMealTime? _selectedLogEntireMeal;

  @override
  void initState() {
    _bloc.add(const DoFetchMealPlansEvent());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealPlanBloc, MealPlanState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization?.mealPlan,
              ),
              16.verticalSpace,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      HeaderWidget(
                        mealPlans: _mealPlans,
                        selectedDay: _selectedDay,
                        selectedMealPlan: _selectedMealPlan,
                        listener: this,
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          controller: _scrollController,
                          children: [
                            MealWidget(
                              title: context.localization?.breakfast,
                              mealTime: PassioMealTime.breakfast,
                              listOfFoodData:
                                  _getListOfFoodData(PassioMealTime.breakfast),
                              listener: this,
                              isLoading: _isLoading,
                              isLogMealLoading: _selectedLogEntireMeal ==
                                  PassioMealTime.breakfast,
                            ),
                            16.verticalSpace,
                            MealWidget(
                              title: context.localization?.lunch,
                              mealTime: PassioMealTime.lunch,
                              listOfFoodData:
                                  _getListOfFoodData(PassioMealTime.lunch),
                              isLoading: _isLoading,
                              listener: this,
                              isLogMealLoading: _selectedLogEntireMeal ==
                                  PassioMealTime.lunch,
                            ),
                            16.verticalSpace,
                            MealWidget(
                              title: context.localization?.dinner,
                              mealTime: PassioMealTime.dinner,
                              listOfFoodData:
                                  _getListOfFoodData(PassioMealTime.dinner),
                              isLoading: _isLoading,
                              listener: this,
                              isLogMealLoading: _selectedLogEntireMeal ==
                                  PassioMealTime.dinner,
                            ),
                            16.verticalSpace,
                            MealWidget(
                              title: context.localization?.snack,
                              mealTime: PassioMealTime.snack,
                              listOfFoodData:
                                  _getListOfFoodData(PassioMealTime.snack),
                              isLoading: _isLoading,
                              listener: this,
                              isLogMealLoading: _selectedLogEntireMeal ==
                                  PassioMealTime.snack,
                            ),
                            24.verticalSpace,
                            context.bottomPadding.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleStateChanges({
    required BuildContext context,
    required MealPlanState state,
  }) {
    if (state is DayUpdateSuccessState) {
      _selectedDay = state.day;
      _fetchMealPlanForDay();
    } else if (state is FetchMealPlansSuccessState) {
      _mealPlans = state.data;
      _selectedMealPlan = _mealPlans.firstOrNull;
      _fetchMealPlanForDay();
    } else if (state is FetchMealPlanItemsLoadingState) {
      _isLoading = true;
    } else if (state is FetchMealPlanItemsSuccessState) {
      _isLoading = false;
      _mealPlanItems = state.data;
    } else if (state is LogMealSuccessState) {
      _selectedLogEntireMeal = null;
      context.showSnackbar(text: context.localization?.loggedEntireMealMessage);
    } else if (state is LogSuccessState) {
      context.showSnackbar(text: context.localization?.logSuccessMessage);
    }
  }

  @override
  void onDayChanged(int day) {
    _bloc.add(DoDayUpdateEvent(day: day));
  }

  @override
  void onMealPlanChanged(PassioMealPlan mealPlan) {
    if (mealPlan != _selectedMealPlan) {
      _selectedMealPlan = mealPlan;
      _fetchMealPlanForDay();
    }
  }

  List<PassioFoodDataInfo> _getListOfFoodData(PassioMealTime mealTime) {
    final mealTimeData =
        _mealPlanItems.where((element) => element.mealTime == mealTime);
    if (mealTimeData.isNotEmpty) {
      return mealTimeData.map((e) => e.meal).toList();
    }
    return [];
  }

  void _fetchMealPlanForDay() {
    if (_selectedMealPlan != null) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 250), curve: Curves.linear);
      _bloc.add(DoFetchMealPlanForDayEvent(
          day: _selectedDay, mealPlanLabel: _selectedMealPlan!.mealPlanLabel));
    }
  }

  @override
  void onTappedLogEntireMeal(List<PassioFoodDataInfo>? listOfPassioFoodData,
      PassioMealTime? mealTime) {
    _selectedLogEntireMeal = mealTime;
    _bloc.add(DoLogEntireMealEvent(
        data: listOfPassioFoodData, mealTime: _selectedLogEntireMeal));
  }

  @override
  void onTappedMealItem(
      PassioFoodDataInfo? passioFoodDataInfo, PassioMealTime? mealTime) {
    EditFoodPage.navigate(
      context: context,
      passioFoodDataInfo: passioFoodDataInfo,
      redirectToDiaryOnLog: true,
      mealLabel:
          MealLabel.stringToMealLabel(mealTime?.name.toUpperCaseWord ?? ''),
      shouldUpdateServingUnit: true,
    );
  }

  @override
  void onTappedAdd(
      PassioFoodDataInfo? passioFoodDataInfo, PassioMealTime? mealTime) {
    _bloc.add(DoLogEvent(data: passioFoodDataInfo, mealTime: mealTime));
  }
}
