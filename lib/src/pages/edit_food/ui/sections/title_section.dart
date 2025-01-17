import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/custom_app_bar_widget.dart';
import '../../../food_search/food_search_page.dart';
import '../../../food_search/models/food_selection_result.dart';
import '../../bloc/edit_food_bloc.dart';
import '../edit_food_page.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final title = NavigationDataProvider.of(context).params.title;
    bool visibleSwitch =
        NavigationDataProvider.of(context).params.visibleSwitch;
    bool visibleFoodCreator =
        NavigationDataProvider.of(context).params.visibleFoodCreator;

    return BlocBuilder<EditFoodBloc, EditFoodState>(
      buildWhen: (_, state) => state is ConversionSuccessState,
      builder: (context, state) {
        final isRecipe = state is ConversionSuccessState
            ? (state.foodRecord?.ingredients.length ?? 0) > 1
            : true;
        return CustomAppBarWidget(
          title: title ?? context.localization.foodDetails,
          isMenuVisible: false,
          suffix: Row(
            children: [
              if (visibleSwitch)
                IconButton(
                  onPressed: () => _onSwitchTapped,
                  icon: SvgPicture.asset(
                    AppImages.icSwitchHorizontal,
                    width: AppDimens.r24,
                    height: AppDimens.r24,
                  ),
                ),
              if (visibleFoodCreator && !isRecipe)
                IconButton(
                  onPressed: () => _onFoodCreatorTapped(context),
                  icon: SvgPicture.asset(
                    AppImages.icPencilAlt,
                    width: AppDimens.r24,
                    height: AppDimens.r24,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onSwitchTapped(BuildContext context) {
    FoodSearchPage.navigate(context).then((value) {
      if (value != null && value is FoodSelectionResult && context.mounted) {
        context
            .read<EditFoodBloc>()
            .add(DoConversionEvent(foodDataInfo: value.foodDataInfo));
      }
    });
  }

  void _onFoodCreatorTapped(BuildContext context) {
    context.read<EditFoodBloc>().add(DoUserFoodFlowEvent());
  }
}
