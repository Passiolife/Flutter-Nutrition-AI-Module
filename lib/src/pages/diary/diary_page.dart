import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/day_log/day_log.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/models/user_profile/user_profile_model.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/util/user_session.dart';
import '../../common/widgets/bottom_nav_bar_space_widget.dart';
import '../edit_food/edit_food_page.dart';
import 'bloc/diary_bloc.dart';
import 'widgets/widgets.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage>
    implements DiaryListener, QuickSuggestionsListener {
  final _bloc = DiaryBloc();

  DateTime _selectedDate = DateTime.now();
  DayLog? _dayLog;

  UserProfileModel? userProfileModel = UserSession.instance.userProfile;

  // Members for quick suggestions
  final List<PassioFoodDataInfo> _suggestions = [];
  final ValueNotifier<double> _sheetSize = ValueNotifier(0);

  @override
  Future<void> onEditRecord(FoodRecord record) async {
    final foodRecord = FoodRecord.fromJson(record.toJson());
    final isUpdated = await EditFoodPage.navigate(
      foodRecord: foodRecord,
      context: context,
      isUpdate: true,
      visibleDelete: true,
    );
    if (isUpdated != null && isUpdated) {
      _bloc.add(FetchRecordsEvent(dateTime: _selectedDate));
    }
  }

  @override
  void onDeleteRecord(FoodRecord record) {
    _dayLog?.records.remove(record);
    _bloc.add(DoRecordDeleteEvent(foodRecord: record));
  }

  @override
  void initState() {
    _doFetchRecords();
    _doFetchSuggestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiaryBloc, DiaryState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStates(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          // Set background color
          backgroundColor: AppColors.gray50,
          // Prevent the screen from resizing when the keyboard is shown
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              DiaryAppBarWidget(
                selectedDate: _selectedDate,
                onDateTimeChanged: (newDate) {
                  _selectedDate = newDate;
                  _bloc.add(FetchRecordsEvent(dateTime: _selectedDate));
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: AppDimens.h16),
                            DailyNutritionWidget(
                              consumedCalories:
                                  _dayLog?.consumedCalories.round() ?? 0,
                              totalCalories:
                                  userProfileModel?.caloriesTarget.toDouble() ??
                                      0,
                              consumedCarbs:
                                  _dayLog?.consumedCarbs.round() ?? 0,
                              totalCarbs:
                                  userProfileModel?.carbsGram.toDouble() ?? 0,
                              consumedProteins:
                                  _dayLog?.consumedProteins.round() ?? 0,
                              totalProteins:
                                  userProfileModel?.proteinGram.toDouble() ?? 0,
                              consumedFat: _dayLog?.consumedFat.round() ?? 0,
                              totalFat:
                                  userProfileModel?.fatGram.toDouble() ?? 0,
                            ),
                            SizedBox(height: AppDimens.h16),
                            MealTileWidget(
                              dayLog: _dayLog,
                              listener: this,
                            ),
                            ValueListenableBuilder(
                              valueListenable: _sheetSize,
                              builder: (context, value, child) {
                                return SizedBox(height: value);
                              },
                            ),
                            SizedBox(height: AppDimens.h32),
                            const BottomNavBarSpaceWidget(),
                          ],
                        ),
                      ),
                    ),
                    /* AnimatedOpacity(
                      opacity: 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: QuickSuggestionsWidget(
                        data: _suggestions,
                        listener: this,
                      ),
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _doFetchRecords() {
    _bloc.add(FetchRecordsEvent(dateTime: _selectedDate));
  }

  void _doFetchSuggestions() {
    _bloc.add(const FetchSuggestionsEvent());
  }

  void _handleStates({
    required BuildContext context,
    required DiaryState state,
  }) {
    if (state is FetchRecordsSuccessState) {
      _dayLog = state.dayLog;
    } else if (state is FetchSuggestionsSuccessState) {
      _suggestions.clear();
      _suggestions.addAll(state.data);
    } else if (state is LogSuccessState) {
      _doFetchRecords();
      context.showSnackbar(text: context.localization?.logSuccessMessage);
    }
  }

  @override
  void onDrag(double draggedSize, double draggedPixels) {
    _sheetSize.value = draggedPixels;
  }

  @override
  void onTap(PassioFoodDataInfo data) {
    EditFoodPage.navigate(
      context: context,
      passioFoodDataInfo: data,
      visibleSwitch: true,
      message: context.localization?.itemAddedToDiary,
    );
  }

  @override
  void onTapAdd(PassioFoodDataInfo data) {
    _bloc.add(DoLogEvent(data: data));
  }
}
