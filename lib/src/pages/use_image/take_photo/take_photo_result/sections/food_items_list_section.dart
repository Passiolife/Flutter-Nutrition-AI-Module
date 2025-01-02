import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../models/take_photo_result_view_model.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../dialog/adjust_serving_size.dart';
import '../widgets/food_item_widget.dart';

class FoodItemsListSection extends StatelessWidget {
  const FoodItemsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is TakePhotoResultInitial || state is ResultsSuccessState;
      },
      builder: (context, state) {
        if (state is! ResultsSuccessState) return const SizedBox.shrink();
        final foodItems = state.foodRecordsViewModel;
        return Expanded(
          child: ListView.separated(
            itemCount: foodItems.length,
            padding: AppPadding.pv16,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final foodItemModel = foodItems.elementAt(index);
              return FoodItemWidget(
                viewModel: foodItemModel,
                index: index,
                initialSelection: foodItemModel.isSelected,
                onChangeSelection: (isSelected) => _onChangeSelection(
                  context: context,
                  index: index,
                  isSelected: isSelected,
                ),
                onTap: () => _onTap(
                  context: context,
                  viewModel: foodItemModel,
                  index: index,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return 8.verticalSpace;
            },
          ),
        );
      },
    );
  }

  Future<void> _onTap({
    required BuildContext context,
    required TakePhotoResultViewModel viewModel,
    required int index,
  }) async {
    FoodRecord? updatedFoodRecord = await AdjustServingSize.navigate(
      context: context,
      foodRecord: viewModel.foodRecord,
      index: index,
    );
    if (updatedFoodRecord != null && context.mounted) {
      context.read<TakePhotoResultBloc>().add(
          UpdateServingSizeEvent(index: index, foodRecord: updatedFoodRecord));
    }
  }

  void _onChangeSelection({
    required BuildContext context,
    required int index,
    required bool isSelected,
  }) {
    context.read<TakePhotoResultBloc>().add(
          SelectFoodItemEvent(
            index: index,
            isSelected: isSelected,
          ),
        );
  }
}
