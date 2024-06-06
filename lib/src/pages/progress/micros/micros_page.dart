import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/models/micro_nutrient/micro_nutrient.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/custom_calendar_app_bar_widget.dart';
import '../../../common/widgets/nutrition_information_widget.dart';
import '../../../common/widgets/nutrition_information_message_widget.dart';
import 'bloc/micros_bloc.dart';

class MicrosPage extends StatefulWidget {
  const MicrosPage({super.key});

  @override
  State<MicrosPage> createState() => _MicrosPageState();
}

class _MicrosPageState extends State<MicrosPage> {
  final _bloc = MicrosBloc();
  DateTime _selectedDate = DateTime.now();

  DayLog? _dayLog;

  @override
  void initState() {
    _fetchRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MicrosBloc, MicrosState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      buildWhen: (_, state) {
        return state is! MicrosListenerState;
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              24.verticalSpace,
              CustomCalendarAppBarWidget(
                selectedDate: _selectedDate,
                onDateTimeChanged: _handleOnDateTimeChanged,
              ),
              24.verticalSpace,
              const NutritionInformationMessageWidget(),
              24.verticalSpace,
              Expanded(
                child: Stack(
                  children: [
                    NutritionInformationWidget(
                      nutrientList: MicroNutrient.nutrientsFromFoodRecords(
                          _dayLog?.records ?? <FoodRecord>[]),
                    ),
                    Positioned(
                      bottom: context.bottomPadding,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: AppColors.gray50,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: AppButton(
                            buttonText: context.localization?.generateReport,
                            appButtonModel: AppButtonStyles.primary,
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
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
    required MicrosState state,
  }) {
    if (state is MicrosListenerState) {
      switch (state) {
        case FetchRecordsSuccessListenState():
          _dayLog = state.dayLog;
          break;
      }
    }
  }

  void _handleOnDateTimeChanged(DateTime dateTime) {
    _selectedDate = dateTime;
    _fetchRecords();
  }

  void _fetchRecords() {
    _bloc.add(DoFetchRecordsEvent(selectedDateTime: _selectedDate));
  }
}
