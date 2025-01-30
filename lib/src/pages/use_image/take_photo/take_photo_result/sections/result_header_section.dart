import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/models/food_record/meal_label.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../widgets/date_widget.dart';
import '../widgets/meal_time_widget.dart';
import '../widgets/take_photo_app_bar.dart';

class ResultHeaderSection extends StatefulWidget {
  const ResultHeaderSection({super.key});

  @override
  State<ResultHeaderSection> createState() => _ResultHeaderSectionState();
}

class _ResultHeaderSectionState extends State<ResultHeaderSection> {
  MealLabel? _mealLabel;
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is UpdateHeaderState;
      },
      builder: (context, state) {
        if (state is UpdateHeaderState) {
          _mealLabel = state.viewModel.mealLabel;
          _dateTime = state.viewModel.dateTime;
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TakePhotoAppBar(),
            16.verticalSpace,
            Padding(
              padding: AppPadding.ph16,
              child: Row(
                spacing: 16.w,
                children: [
                  Expanded(
                    child: MealTime(
                      initialMealTime: _mealLabel,
                      onSelected: _onMealTimeSelected,
                    ),
                  ),
                  Expanded(
                    child: TimeStampWidget(
                      initialValue: _dateTime,
                      onSelected: _onTimeStampSelected,
                    ),
                  ),
                ],
              ),
            ),
            8.verticalSpace,
          ],
        );
      },
    );
  }

  void _onMealTimeSelected(MealLabel value) {
    context
        .read<TakePhotoResultBloc>()
        .add(UpdateMealLabelEvent(mealLabel: value));
  }

  void _onTimeStampSelected(DateTime? value) {
    context
        .read<TakePhotoResultBloc>()
        .add(UpdateTimeStampEvent(timeStamp: value));
  }
}
