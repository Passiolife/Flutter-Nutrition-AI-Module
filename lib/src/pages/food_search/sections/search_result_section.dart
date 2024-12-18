import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_padding.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import '../../../common/widgets/loading/shimmer_loading.dart';
import '../../edit_food/ui/edit_food_page.dart';
import '../bloc/food_search_bloc.dart';
import '../models/navigation_data_provider.dart';
import '../widgets/no_data_found_widget.dart';

class SearchResultSection extends StatelessWidget {
  const SearchResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    final searchResults = context.watch<FoodSearchBloc>().searchResults;
    return Padding(
      padding: AppPadding.ph16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchResults?.isNotEmpty ?? false)
            ShimmerLoading(
              isLoading: searchResults!.first is! PassioFoodDataInfo,
              child: Text(
                context.localization?.searchResults ?? '',
                style: AppTextStyle.textBase.addAll([AppTextStyle.semiBold]),
              ),
            ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: searchResults?.length ?? 0,
            padding: EdgeInsets.only(bottom: AppDimens.h24, top: AppDimens.h16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final data = searchResults!.elementAt(index);
              if (data is PassioFoodDataInfo) {
                final iconId = data.iconID;
                final title = data.foodName;
                final subtitle = data.brandName;
                final isRecipe = data.type.toLowerCase() ==
                    AppCommonConstants.recipe.toLowerCase();
                return FoodItemRowWidget(
                  data: FoodItemRowData(
                    index: index,
                    iconId: iconId,
                    title: title,
                    subtitle: subtitle,
                    isRecipe: isRecipe,
                    onTap: () => _onTap(context: context, data: data),
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
          if (searchResults?.isEmpty ?? false)
            NoDataFoundWidget(
              searchQuery: context.read<FoodSearchBloc>().searchTerm,
            ),
        ],
      ),
    );
  }

  void _onTap({
    required BuildContext context,
    required PassioFoodDataInfo data,
  }) {
    final navigationDataProvider = SearchNavigationDataProvider.of(context);
    if (navigationDataProvider.needsReturn) {
      Navigator.pop(context, data);
    } else {
      EditFoodPage.navigate(
        context: context,
        params: EditFoodPageParams(
          passioFoodDataInfo: data,
          visibleFoodCreator: true,
          redirectToDiaryOnLog: true,
        ),
      );
    }
  }
}
