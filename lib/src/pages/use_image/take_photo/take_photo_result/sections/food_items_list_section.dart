import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../bloc/take_photo_result_bloc.dart';
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
        if(state is! ResultsSuccessState) return const SizedBox.shrink();
        final foodItems =  state.foodItems;
        return Expanded(
          child: ListView.separated(
            itemCount: foodItems.length,
            padding: AppPadding.pv16,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final foodItemModel = foodItems.elementAt(index);
              return FoodItemWidget(
                foodItemModel: foodItemModel,
                onTap: () {

                },
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
}
