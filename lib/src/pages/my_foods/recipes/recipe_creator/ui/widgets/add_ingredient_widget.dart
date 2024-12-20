import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../common/constant/app_border.dart';
import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/constant/app_padding.dart';
import '../../../../../../common/models/menu_model/menu_model.dart';
import '../../../../../../common/util/context_extension.dart';
import '../../bloc/recipe_creator_bloc.dart';

class AddIngredientWidget extends StatelessWidget {
  const AddIngredientWidget({super.key});

  List<MenuModel> getMenu(BuildContext context) => [
        MenuModel(
          icon: AppImages.icSearch,
          title: context.localization?.textSearch,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTapAddIngredient(context),
      splashColor: AppColors.blue50,
      highlightColor: AppColors.blue50,
      child: Padding(
        padding: AppPadding.pa16,
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.localization?.addIngredient ?? '',
                style: AppTextStyle.textBase.addAll([
                  AppTextStyle.textBase.leading6,
                  AppTextStyle.semiBold
                ]).copyWith(color: AppColors.gray900),
              ),
            ),
            SvgPicture.asset(
              AppImages.icPlusSolid,
              width: AppDimens.r24,
              height: AppDimens.r24,
              colorFilter: const ColorFilter.mode(
                AppColors.gray400,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapAddIngredient(BuildContext context) {
    context.read<RecipeCreatorBloc>().add(DoUpdateVisibilityAddIngredientOptionsEvent(isVisible: true));
  }

}
