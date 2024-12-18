import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_padding.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import '../../../common/widgets/loading/shimmer_loading.dart';
import '../../edit_food/ui/edit_food_page.dart';
import '../bloc/food_search_bloc.dart';
import '../models/navigation_data_provider.dart';

class MyFoodsSection extends StatelessWidget {
  const MyFoodsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final myFoods = context.watch<FoodSearchBloc>().myFoods;
    if (myFoods.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: AppPadding.ph16 + AppPadding.pt16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (myFoods.isNotEmpty)
            ShimmerLoading(
              isLoading: myFoods.first is! FoodRecord,
              child: Text(
                context.localization?.myFoods ?? '',
                style: AppTextStyle.textBase.addAll([AppTextStyle.semiBold]),
              ),
            ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: myFoods.length,
            padding: EdgeInsets.only(bottom: AppDimens.h24, top: AppDimens.h16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final data = myFoods.elementAt(index);
              if (data is FoodRecord) {
                final iconId = data.iconId;
                final title = data.name;
                final subtitle = data.additionalData;
                return FoodItemRowWidget(
                  data: FoodItemRowData(
                  index: index,
                  iconId: iconId,
                  title: title,
                  subtitle: subtitle,
                  onTap: () => _onSearchItemClick(context: context, data: data),
                  enableSlidable: false,
                  ),
                );
              }
              return FoodItemRowWidget(data: FoodItemRowData(isLoading: true));
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: AppDimens.h8);
            },
          ),
        ],
      ),
    );
  }

  void _onSearchItemClick({
    required BuildContext context,
    required FoodRecord data,
  }) {
    final navigationDataProvider = SearchNavigationDataProvider.of(context);
    if (navigationDataProvider.needsReturn) {
      Navigator.pop(context, data);
    } else {
      EditFoodPage.navigate(
        context: context,
        params: EditFoodPageParams(
          foodRecord: data,
          visibleFoodCreator: true,
          redirectToDiaryOnLog: true,
        ),
      );
    }
  }
}
