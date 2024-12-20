import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../nutrition_ai_module.dart';
import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/util/context_extension.dart';
import '../../../../../../common/widgets/floating_buttion_expanded_widget.dart';
import '../../../../../edit_food/ui/edit_food_page.dart';
import '../../../../../food_search/food_search_page.dart';
import '../../../../../food_search/models/food_selection_result.dart';
import '../../bloc/recipe_creator_bloc.dart';

class AddIngredientSpeedDialWidget extends StatelessWidget {
  const AddIngredientSpeedDialWidget({super.key});

  // List of floating action buttons with expanded widgets
  List<FloatingButtonExpandedWidget> _fabExpandedWidget(BuildContext context) =>
      [
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icSearch,
          text: context.localization?.textSearch,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RecipeCreatorBloc, RecipeCreatorState, bool>(
        selector: (state) =>
            state is ShowAddIngredientOptionsBuilderState && state.isVisible,
        builder: (context, isVisible) {
          return isVisible
              ? SpeedDial(
                  spacing: 32.h,
                  overlayColor: AppColors.black75Opacity,
                  isOpenOnStart: true,
                  onClose: () {
                    context.read<RecipeCreatorBloc>().add(
                        const DoUpdateVisibilityAddIngredientOptionsEvent(
                            isVisible: false));
                  },
                  dialRoot: (context, isOpen, toggleChildren) {
                    return SizedBox(
                      width: 52.r,
                      height: 52.r,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: AppColors.indigo600Main,
                          foregroundColor: AppColors.white,
                          shape: const CircleBorder(),
                          onPressed: toggleChildren,
                          child: SvgPicture.asset(
                            isOpen
                                ? AppImages.icCloseSolid
                                : AppImages.icPlusSolid,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                            width: 20.r,
                            height: 20.r,
                          ),
                        ),
                      ),
                    );
                  },
                  childrenButtonSize: Size(200.w, 78.h),
                  children: _fabExpandedWidget(context)
                      .map(
                        (e) => SpeedDialChild(
                          backgroundColor: AppColors.transparent,
                          child: e,
                          onTap: () => _handleSelection(
                            context: context,
                            action: e.text,
                          ),
                        ),
                      )
                      .toList(),
                )
              : const SizedBox.shrink();
        });
  }

  void _handleSelection({
    required BuildContext context,
    required String? action,
  }) async {
    if (action == context.localization?.textSearch) {
      final searchData = await FoodSearchPage.navigate(context);
      if (searchData != null &&
          searchData is FoodSelectionResult &&
          context.mounted) {
        if (searchData.fromAdd) {
          context.read<RecipeCreatorBloc>().add(DoConvertIngredientEvent(
              foodDataInfo: searchData.foodDataInfo,
              foodRecord: searchData.foodRecord));
          return;
        }
        final foodRecord = await EditFoodPage.navigate(
          context: context,
          params: EditFoodPageParams(
            passioFoodDataInfo: searchData.foodDataInfo,
            foodRecord: searchData.foodRecord,
            visibleMealTimeView: false,
            visibleDateView: false,
            visibleAddIngredient: false,
            needsReturn: true,
            title: context.localization?.editIngredient,
            positiveButtonText: context.localization?.addIngredient,
          ),
        );
        if (foodRecord != null && foodRecord is FoodRecord && context.mounted) {
          context
              .read<RecipeCreatorBloc>()
              .add(DoUpdateIngredients(foodRecord: foodRecord));
        }
      }
    }
  }
}
